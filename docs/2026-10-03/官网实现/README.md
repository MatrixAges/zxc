# website

## Intent

Agent-first zxc website and documentation, built with Vinext App Router, React, and TypeScript.

## Data

`content/docs/*.md` is the single source for HTML documentation, `/llms-full.txt`, and `/docs/raw/[slug]`. `content/docs.ts` controls the grouped navigation and `/llms.txt` index. Visual references: code.storage home and trees.software documentation navigation.

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
