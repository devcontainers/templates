import * as fs from 'fs';
import * as path from 'path';

export const MCR_PREFIX = 'mcr.microsoft.com/devcontainers/';
export const IMAGE_REF_PATTERN = /mcr\.microsoft\.com\/devcontainers\/([^"]+)/g;
export const TEMPLATE_OPTION_PATTERN = /\$\{templateOption:([^}]+)\}/;

export interface TemplateJson {
	options?: Record<string, {
		default?: string;
		proposals?: string[];
	}>;
}

export function findFiles(dir: string, names: string[]): string[] {
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
