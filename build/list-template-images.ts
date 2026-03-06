/**
 * Lists the fully qualified image references (mcr.microsoft.com/devcontainers/...)
 * that each template would produce, expanding all proposed option values.
 *
 * Usage: npx tsx build/list-template-images.ts
 */

import * as fs from 'fs';
import * as path from 'path';

const MCR_PREFIX = 'mcr.microsoft.com/devcontainers/';
const IMAGE_REF_PATTERN = /mcr\.microsoft\.com\/devcontainers\/([^"]+)/g;
const TEMPLATE_OPTION_PATTERN = /\$\{templateOption:([^}]+)\}/;

interface TemplateJson {
	options?: Record<string, {
		default?: string;
		proposals?: string[];
	}>;
}

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

function main() {
	const templatesDir = path.resolve(__dirname, '..', 'src');

	for (const templateName of fs.readdirSync(templatesDir).sort()) {
		const templateDir = path.join(templatesDir, templateName);
		if (!fs.statSync(templateDir).isDirectory()) continue;

		const templateJsonPath = path.join(templateDir, 'devcontainer-template.json');
		if (!fs.existsSync(templateJsonPath)) continue;

		const templateJson: TemplateJson = JSON.parse(fs.readFileSync(templateJsonPath, 'utf-8'));
		const files = findFiles(templateDir, ['devcontainer.json', 'Dockerfile', '*.yml', '*.yaml']);
		const images: string[] = [];

		for (const file of files) {
			const content = fs.readFileSync(file, 'utf-8');
			const isDockerfile = path.basename(file) === 'Dockerfile';

			for (const line of content.split('\n')) {
				if (isDockerfile && /^\s*#/.test(line)) continue;
				if (/^\s*\/\//.test(line)) continue;

				for (const match of line.matchAll(IMAGE_REF_PATTERN)) {
					const pattern = match[1];
					const optionMatch = pattern.match(TEMPLATE_OPTION_PATTERN);

					if (optionMatch) {
						const optionName = optionMatch[1];
						const option = templateJson.options?.[optionName];
						if (option) {
							const values = [...new Set([...(option.proposals ?? []), ...(option.default != null ? [option.default] : [])])];
							for (const value of values) {
								images.push(MCR_PREFIX + pattern.replace(`\${templateOption:${optionName}}`, value));
							}
						}
					} else {
						images.push(MCR_PREFIX + pattern);
					}
				}
			}
		}

		if (images.length > 0) {
			console.log(`# ${templateName}`);
			for (const img of images.sort()) {
				console.log(img);
			}
			console.log('');
		}
	}
}

main();
