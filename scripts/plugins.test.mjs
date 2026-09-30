import assert from 'node:assert/strict';
import { test } from 'node:test';

import { fetchOrbitPlugins, frameworkEntry, loadCatalog, orbitEntry, orbitListingUrl } from '../src/data/plugins.mjs';
import { frameworkPlugins } from '../src/data/framework-plugins.mjs';

test('orbit listings keep their slug and point at Orbit', () => {
	const entry = orbitEntry({
		slug: 'orbit-workflows',
		name: 'Orbit Workflows',
		summary: 'Approvals',
		package: 'almasix-orbit-workflows',
		github_url: 'https://github.com/almasix-dev/almasix-orbit-workflows',
		official: true,
		stars: 1,
		price: 'free',
		categories: ['panel-kit'],
	});
	assert.equal(entry.slug, 'orbit-workflows');
	assert.equal(entry.source, 'orbit');
	assert.equal(entry.install, 'pip install almasix-orbit-workflows');
	assert.equal(entry.listingUrl, orbitListingUrl('orbit-workflows'));
	assert.equal(entry.stars, 1);
});

test('the catalog appends the Orbit feed after framework plugins', async () => {
	const feed = {
		plugins: [
			{ slug: 'orbit-permission', name: 'Orbit Permission', summary: 'Users and roles', package: 'almasix-orbit-permission' },
		],
	};
	const catalog = await loadCatalog({
		doFetch: async () => ({ ok: true, json: async () => feed }),
	});
	assert.deepEqual(
		catalog.all.map((item) => item.slug),
		[...frameworkPlugins.map((item) => item.slug), 'orbit-permission'],
	);
	assert.equal(catalog.framework[0].source, 'almasix');
	assert.equal(frameworkEntry(frameworkPlugins[0]).listingUrl, '/plugins/permission/');
});

test('a failed feed fails a strict build and is skipped otherwise', async () => {
	const broken = async () => {
		throw new Error('offline');
	};
	await assert.rejects(() => fetchOrbitPlugins(broken, ['https://example.test/feed.json']));
	const loose = await loadCatalog({ doFetch: broken, urls: ['https://example.test/feed.json'], strict: false });
	assert.equal(loose.orbit.length, 0);
	assert.equal(loose.all.length, frameworkPlugins.length);
});
