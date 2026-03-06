/**
 * Compares the concrete image tags that each template would produce (for every
 * proposed option value) against the set of tags the images repo would publish
 * (based on each manifest's version, variants, tags and variantTags).
 *
 * Usage: npx tsx build/check-image-tags.ts <path-to-images-repo>
 * Example: npx tsx build/check-image-tags.ts ../images
 */

import * as fs from 'fs';
import * as path from 'path';

const RED = '\x1b[0;31m';
const GREEN = '\x1b[0;32m';
const YELLOW = '\x1b[0;33m';
const NC = '\x1b[0m';

const MCR_PREFIX = 'mcr.microsoft.com/devcontainers/';
const IMAGE_REF_PATTERN = /mcr\.microsoft\.com\/devcontainers\/([^"]+)/g;
const TEMPLATE_OPTION_PATTERN = /\$\{templateOption:([^}]+)\}/;

interface ImageManifest {
	version: string;
	variants?: string[];
	build: {
		tags?: string[];
		variantTags?: Record<string, string[]>;
	};
}

interface TemplateJson {
	options?: Record<string, {
		default?: string;
		proposals?: string[];
	}>;
}

interface TemplateTag {
	templateName: string;
	relFile: string;
	tag: string;
}

// --- Step 1: Compute all tags that images would publish ---

function computeImageTags(imagesRepo: string): Set<string> {
	const tags = new Set<string>();
	const srcDir = path.join(imagesRepo, 'src');

	for (const imageDir of fs.readdirSync(srcDir)) {
		const manifestPath = path.join(srcDir, imageDir, 'manifest.json');
		if (!fs.existsSync(manifestPath)) continue;

		const manifest: ImageManifest = JSON.parse(fs.readFileSync(manifestPath, 'utf-8'));
		const major = manifest.version.split('.')[0];
		const variants = manifest.variants ?? [];
		const buildTags = manifest.build.tags ?? [];
		const variantTags = manifest.build.variantTags ?? {};
		const versionedTagsOnly = (manifest as any).build?.versionedTagsOnly;

		// The build system generates tags for each version granularity
		// (e.g. 2.1.6 -> ['2.1.6', '2.1', '2', '']). We only need major
		// and floating (empty) for comparison purposes.
		const versions = [major];
		if (!versionedTagsOnly) {
			versions.push('');
		}

		// Apply a version+variant to a tag pattern, mimicking the build
		// system's replacement logic.
		function expandTag(pattern: string, version: string, variant?: string): string | null {
			let tag = pattern
				.replace(/\$\{VERSION\}/g, version)
				.replace(':-', ':')
				.replace(/\$\{?VARIANT\}?/g, variant ?? 'NOVARIANT')
				.replace('-NOVARIANT', '');
			if (tag.endsWith(':')) return null;
			return tag;
		}

		for (const version of versions) {
			if (variants.length > 0) {
				// Expand tags × variants
				for (const variant of variants) {
					for (const tagPattern of buildTags) {
						const tag = expandTag(tagPattern, version, variant);
						if (tag) tags.add(tag);
					}
				}
			} else {
				// No variants — expand tags directly (e.g. anaconda, universal)
				for (const tagPattern of buildTags) {
					const tag = expandTag(tagPattern, version);
					if (tag) tags.add(tag);
				}
			}

			// Expand variantTags (these don't use ${VARIANT})
			for (const extraTags of Object.values(variantTags)) {
				for (const tagPattern of extraTags) {
					const tag = expandTag(tagPattern, version);
					if (tag) tags.add(tag);
				}
			}
		}
	}

	return tags;
}

// --- Step 2: Compute all tags that templates would produce ---

function findFiles(dir: string, names: string[]): string[] {
	const results: string[] = [];
	function walk(d: string) {
		for (const entry of fs.readdirSync(d, { withFileTypes: true })) {
			const full = path.join(d, entry.name);
			if (entry.isDirectory()) {
				walk(full);
			} else if (names.includes(entry.name) || names.some(n => n.startsWith('*.') && entry.name.endsWith(n.slice(1)))) {
				results.push(full);
			}
		}
	}
	walk(dir);
	return results;
}

function computeTemplateTags(templatesDir: string): TemplateTag[] {
	const results: TemplateTag[] = [];

	for (const templateName of fs.readdirSync(templatesDir)) {
		const templateDir = path.join(templatesDir, templateName);
		if (!fs.statSync(templateDir).isDirectory()) continue;

		const templateJsonPath = path.join(templateDir, 'devcontainer-template.json');
		if (!fs.existsSync(templateJsonPath)) continue;

		const templateJson: TemplateJson = JSON.parse(fs.readFileSync(templateJsonPath, 'utf-8'));
		const files = findFiles(templateDir, ['devcontainer.json', 'Dockerfile', '*.yml', '*.yaml']);

		for (const file of files) {
			const content = fs.readFileSync(file, 'utf-8');
			const relFile = path.relative(templatesDir, file);
			const isDockerfile = path.basename(file) === 'Dockerfile';

			for (const line of content.split('\n')) {
				// Skip comment lines
				if (isDockerfile && /^\s*#/.test(line)) continue;
				if (/^\s*\/\//.test(line)) continue;

				for (const match of line.matchAll(IMAGE_REF_PATTERN)) {
					const pattern = match[1]; // e.g. "typescript-node:1-${templateOption:imageVariant}"
					const optionMatch = pattern.match(TEMPLATE_OPTION_PATTERN);

					if (optionMatch) {
						const optionName = optionMatch[1];
						const option = templateJson.options?.[optionName];

						if (option) {
							const values = [...new Set([...(option.proposals ?? []), ...(option.default != null ? [option.default] : [])])];
							for (const value of values) {
								const tag = pattern.replace(`\${templateOption:${optionName}}`, value);
								results.push({ templateName, relFile, tag });
							}
						} else {
							// Option not found in template.json — output raw
							results.push({ templateName, relFile, tag: pattern });
						}
					} else {
						// Static tag
						results.push({ templateName, relFile, tag: pattern });
					}
				}
			}
		}
	}

	// Deduplicate by templateName + tag, keeping first relFile
	const seen = new Map<string, TemplateTag>();
	for (const entry of results) {
		const key = `${entry.templateName}\t${entry.tag}`;
		if (!seen.has(key)) {
			seen.set(key, entry);
		}
	}

	return [...seen.values()].sort((a, b) =>
		a.templateName.localeCompare(b.templateName) || a.tag.localeCompare(b.tag)
	);
}

// --- Step 3: Compare ---

function main() {
	const imagesRepo = process.argv[2];
	if (!imagesRepo) {
		console.error('Usage: npx tsx build/check-image-tags.ts <path-to-images-repo>');
		process.exit(1);
	}

	const templatesDir = path.resolve(__dirname, '..', 'src');

	const imageTags = computeImageTags(imagesRepo);
	console.log('=== Published image tags (from manifests) ===');
	console.log(`${imageTags.size} unique tags\n`);

	const templateTags = computeTemplateTags(templatesDir);
	console.log('=== Template tags ===');
	console.log(`${templateTags.length} unique template/tag combinations\n`);

	console.log('=== Comparison ===\n');

	let errors = 0;
	let prevTemplate = '';

	for (const { templateName, relFile, tag } of templateTags) {
		if (templateName !== prevTemplate) {
			if (prevTemplate) console.log('');
			console.log(`${templateName.padEnd(30)} (${relFile})`);
			prevTemplate = templateName;
		}

		if (imageTags.has(tag)) {
			console.log(`  ${GREEN}OK${NC}        ${tag}`);
		} else {
			console.log(`  ${RED}MISSING${NC}   ${tag}`);
			errors++;
		}
	}

	// Collect the set of all tags referenced by templates
	const templateTagSet = new Set(templateTags.map(t => t.tag));

	// Find image tags not referenced by any template
	const unreferencedImageTags = [...imageTags].filter(t => !templateTagSet.has(t)).sort();

	if (unreferencedImageTags.length > 0) {
		console.log('\n=== Image tags not in any template ===\n');
		for (const tag of unreferencedImageTags) {
			console.log(`  ${YELLOW}UNUSED${NC}    ${tag}`);
		}
	}

	console.log('\n');
	if (errors > 0) {
		console.log(`${RED}Found ${errors} template tag(s) not in image manifests.${NC}`);
		if (unreferencedImageTags.length > 0) {
			console.log(`${YELLOW}Found ${unreferencedImageTags.length} image tag(s) not referenced by any template.${NC}`);
		}
		process.exit(1);
	} else {
		console.log(`${GREEN}All template tags match published image tags.${NC}`);
		if (unreferencedImageTags.length > 0) {
			console.log(`${YELLOW}Found ${unreferencedImageTags.length} image tag(s) not referenced by any template.${NC}`);
		}
	}
}

main();
