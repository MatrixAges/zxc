# website

## Intent

Agent-first zxc website and documentation, built with Vinext App Router, React, and TypeScript.

## Data

`content/docs/{en,zh,ja,ko}/*.md` is the single source for HTML documentation, `/llms-full.txt`, and `/docs/raw/[slug]`. `content/docs.ts` controls the grouped navigation and `/llms.txt` index. `/docs` redirects to `/docs/overview`; each `/docs/[slug]` renders only its own chapter, with an active navigation item and individual page title. Visual references: code.storage home and trees.software documentation navigation.

## Edges

Node 22.18+ is required by the typed Cloudflare configuration. Cloudflare uses `cf` and the Vite plugin 2.0 beta, with `cloudflare.config.ts`; no Wrangler dependency or configuration is used. No account or domain is hardcoded. Documentation distinguishes compiler capabilities from the unimplemented production RX runtime. Repository tooling owns formatting and ignores.

## Answer

From the repository root:

```sh
pnpm dev:website
pnpm build:website
pnpm start:website
pnpm deploy:website
pnpm --filter @zxc/website typecheck
```

Development and production preview use http://127.0.0.1:4320. The existing zray services are independent.

`dev` and `build` run through `cf`. Production preview uses the Cloudflare Vite plugin. Deployment uses the official `vinext-cloudflare deploy` adapter, which delegates publishing to `cf` for the typed configuration. Authenticate with `pnpm --filter @zxc/website login` before explicitly deploying. Deployment creates or updates the configured `zxc-website` Worker.

The `cf` CLI and Cloudflare Vite plugin 2.0 are beta releases. This workspace pins their exact versions. `cf` currently warns about the workspace lockfile location but successfully delegates development and builds to Vite.

## Languages

The site uses next-intl with request-scoped configuration, without a language switcher or locale-prefixed routes. English, Japanese, and Korean follow `Accept-Language`; unsupported preferences fall back to English. Chinese is Simplified Chinese and is only enabled explicitly:

```sh
ZXC_WEBSITE_LOCALE=zh pnpm dev:website
```

Alternatively, open `/?__lang=zh` or `/docs/overview?__lang=zh`. Internal links retain this parameter; no locale cookie is stored. Plain-text documentation follows the same language rules.

For a production build with Chinese as the default, run `ZXC_WEBSITE_LOCALE=zh pnpm build:website`. Preview uses the binding saved in that build; changing the preview process environment alone does not replace it. The query parameter works without rebuilding.

UI messages live in `locales/*.json`; chapter translations live in `content/docs/<locale>/`. Keep executable examples identical across languages. The request proxy sets `Content-Language`, `Vary: Accept-Language`, and a private no-store cache policy.
