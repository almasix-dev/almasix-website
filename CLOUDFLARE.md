# Cloudflare Workers (static assets) + Builds

This site is a **static Astro** app served as Worker static assets (not Pages Functions / SSR).

## Wrangler

`wrangler.jsonc` points assets at `./dist` (Astro’s build output). There is no Worker `main` script — assets only.

## Dashboard build settings (Workers Builds)

| Setting | Value |
|---------|--------|
| Build command | `npm ci && npm run build` |
| Deploy command | `npx wrangler deploy` (or Cloudflare’s default) |
| Root directory | `/` |
| Node version | `22` |

`public/_redirects` is copied into `dist/` at build time and is honored by static assets.

## Custom domains

`almasix.com` and `www.almasix.com` are Active. `www` → apex via `public/_redirects`.

Leave **`docs.almasix.com`** alone (GitHub Pages / Starlight).

## Local

```bash
npm ci
npm run build
npx wrangler deploy   # needs Cloudflare auth
```

## Why PRs showed “Workers Builds … failed in 0s”

Workers Builds was connected to the repo but there was no Wrangler config, so the check aborted before a real build. Adding `wrangler.jsonc` fixes that preflight.
