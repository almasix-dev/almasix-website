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
| Node version | `24` (Workers Builds default; 22 also fine) |

## Custom domains

`almasix.com` and `www.almasix.com` are Active on the Worker.

Leave **`docs.almasix.com`** alone (GitHub Pages / Starlight).

### www → apex (Redirect Rule — not `_redirects`)

Workers static-asset `_redirects` only allows **relative** URLs and does **not** support domain-level redirects. Absolute `https://www…` rules fail deploy with `Invalid _redirects configuration` / code `100324`.

Create a **Single Redirect** in the Cloudflare dashboard for zone `almasix.com`:

1. **Rules** → **Redirect Rules** → **Create rule**
2. When incoming requests match → **Wildcard pattern**
   - Request URL: `https://www.almasix.com/*`
3. Then
   - Target URL: `https://almasix.com/${1}`
   - Status code: **301**
   - Preserve query string: **On**
4. Optional second rule for `http://www.almasix.com/*` → same target (or rely on Always Use HTTPS first)

Verify:

```bash
curl -I https://www.almasix.com/
# expect 301 Location: https://almasix.com/
curl -I https://almasix.com/
# expect 200
```

## Local

```bash
npm ci
npm run build
npx wrangler deploy   # needs Cloudflare auth
```

## Why PRs showed “Workers Builds … failed in 0s”

Workers Builds was connected to the repo but there was no Wrangler config, so the check aborted before a real build. `wrangler.jsonc` fixes that preflight.
