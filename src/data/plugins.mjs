/**
 * Almasix plugin catalog.
 *
 * Framework plugins live in this repo. Every published Orbit listing is read
 * from the Orbit feed, so a plugin submitted there appears here on the next
 * site build without a second submission.
 */

import { frameworkPlugins } from './framework-plugins.mjs';

export const ORBIT_FEED_URLS = [
	'https://orbit.almasix.com/main/plugins/feed.json',
	'https://orbit.almasix.com/0.x/plugins/feed.json',
];

const ORBIT_SITE = 'https://orbit.almasix.com';

export function orbitListingUrl(slug) {
	return `${ORBIT_SITE}/main/plugins/${slug}/`;
}

export function frameworkEntry(plugin) {
	return {
		slug: plugin.slug,
		name: plugin.name,
		summary: plugin.summary,
		source: 'almasix',
		install: plugin.install,
		docs: plugin.docs,
		github: plugin.github,
		pypi: plugin.pypi ?? null,
		listingUrl: `/plugins/${plugin.slug}/`,
		stars: null,
		official: Boolean(plugin.official),
		price: 'free',
		categories: [],
	};
}

export function orbitEntry(item) {
	const slug = String(item?.slug ?? '').trim();
	const pkg = item?.package ? String(item.package) : '';
	return {
		slug,
		name: String(item?.name ?? slug),
		summary: String(item?.summary ?? ''),
		source: 'orbit',
		install: pkg ? `pip install ${pkg}` : null,
		docs: item?.docs_url ? String(item.docs_url) : orbitListingUrl(slug),
		github: item?.github_url || item?.repository || null,
		pypi: item?.pypi_url || (pkg ? `https://pypi.org/project/${pkg}/` : null),
		listingUrl: orbitListingUrl(slug),
		stars: typeof item?.stars === 'number' ? item.stars : null,
		official: Boolean(item?.official),
		price: item?.price ? String(item.price) : 'free',
		categories: Array.isArray(item?.categories) ? item.categories.map(String) : [],
	};
}

export async function fetchOrbitPlugins(doFetch = fetch, urls = ORBIT_FEED_URLS) {
	let lastError = null;
	for (const url of urls) {
		try {
			const response = await doFetch(url, { headers: { Accept: 'application/json' } });
			if (!response.ok) {
				lastError = new Error(`${url} returned ${response.status}`);
				continue;
			}
			const body = await response.json();
			const plugins = Array.isArray(body?.plugins) ? body.plugins : [];
			return plugins.filter((item) => item && item.slug).map(orbitEntry);
		} catch (error) {
			lastError = error;
		}
	}
	throw lastError ?? new Error('Orbit plugin feed was empty');
}

export async function loadCatalog({
	doFetch = fetch,
	urls = ORBIT_FEED_URLS,
	strict = true,
} = {}) {
	const framework = frameworkPlugins.map(frameworkEntry);
	try {
		const orbit = await fetchOrbitPlugins(doFetch, urls);
		return { framework, orbit, all: [...framework, ...orbit] };
	} catch (error) {
		if (strict) throw error;
		console.warn(`Orbit plugin feed skipped: ${error.message}`);
		return { framework, orbit: [], all: framework };
	}
}
