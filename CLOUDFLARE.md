# Cloudflare Pages

## Build settings

| Setting | Value |
|---------|--------|
| Build command | `npm ci && npm run build` |
| Build output directory | `dist` |
| Node version | `22` |
| Root directory | `/` (repo root) |

## Phase 5 — custom domains

Do this in the Cloudflare dashboard after the first Pages deploy succeeds.

### 1. Attach domains to the Pages project

1. **Workers & Pages** → your `almasix-website` project → **Custom domains**
2. **Set up a custom domain** → `almasix.com` → continue
3. Repeat for `www.almasix.com`

If `almasix.com` is already in this Cloudflare account, Pages will create/adjust DNS automatically (proxied / orange cloud).

### 2. Confirm DNS (DNS → Records for `almasix.com`)

Expect something like:

| Type | Name | Content | Proxy |
|------|------|---------|-------|
| `CNAME` | `@` | `<project>.pages.dev` | Proxied |
| `CNAME` | `www` | `<project>.pages.dev` (or `almasix.com`) | Proxied |

Exact targets are whatever Cloudflare shows in the Custom domains UI — prefer those over inventing records.

Leave **`docs`** alone (it should still CNAME to `almasix-dev.github.io`, DNS only / grey cloud).

### 3. SSL/TLS

For the zone `almasix.com`:

- Encryption mode: **Full (strict)**
- **Always Use HTTPS**: On

Wait until both custom domains show **Active** and a valid certificate in the Pages UI.

### 4. www → apex

This repo ships `public/_redirects` so Pages redirects:

`https://www.almasix.com/*` → `https://almasix.com/:splat` (301)

After the next deploy, verify:

```bash
curl -I https://www.almasix.com/
# expect 301 Location: https://almasix.com/
curl -I https://almasix.com/
# expect 200
```

### 5. Smoke check

- [ ] `https://almasix.com/` loads the marketing site
- [ ] Logo/CSS load (no broken assets)
- [ ] `https://www.almasix.com/` redirects to apex
- [ ] `https://docs.almasix.com/` still serves Starlight docs
- [ ] `*.pages.dev` preview URL still works (optional keep)

## Later (not Phase 5)

- Package subdomains (`courier.almasix.com`, …) when those sites exist
- Redirect old `almasix-dev.github.io/almasix` bookmarks if still needed
