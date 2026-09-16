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

## Docs sites (Cloudflare Worker assets)

All documentation hosts use the same pattern as this hub:

- GitHub Actions **builds** the Starlight site (no Cloudflare secrets in GitHub).
- Cloudflare **Workers Builds** deploys (`npm ci && npm run build` → `npx wrangler deploy`).

| Host | Repo | Worker / project | Root |
|------|------|------------------|------|
| `docs.almasix.com` | [`almasix-dev/almasix`](https://github.com/almasix-dev/almasix) | `almasix-docs` | `website/` |
| `conduit.almasix.com` | [`almasix-dev/conduit`](https://github.com/almasix-dev/almasix-conduit) | `almasix-conduit-docs` | `website/` |
| `inertia.almasix.com` | [`almasix-dev/inertia`](https://github.com/almasix-dev/almasix-inertia) | `almasix-inertia-docs` | `website/` |
| `permission.almasix.com` | [`almasix-dev/almasix-permission`](https://github.com/almasix-dev/almasix-permission) | `almasix-permission-docs` | `website/` |

Per docs site: connect Workers Builds → attach custom domain. **Prism** stays on `docs.almasix.com/prism/` (core).

### Cutover note for `docs.almasix.com`

Replace the grey-cloud `docs` CNAME → `almasix-dev.github.io` with the Proxied record for Worker `almasix-docs`. Disable GitHub Pages once Active. Details: [`almasix/website/CLOUDFLARE.md`](https://github.com/almasix-dev/almasix/blob/main/website/CLOUDFLARE.md).

### Optional: old Digging Deeper paths

Framework Digging Deeper pages `/conduit/` and `/inertia/` are stubs linking to the package hosts. Optional zone Redirect Rules can 301 those paths to `conduit.almasix.com` / `inertia.almasix.com`.

## Hub catalogue

**[almasix.com/packages](https://almasix.com/packages)** links to each package docs host once DNS is attached.
