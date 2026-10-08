#!/bin/sh

pnpm_config_verify_deps_before_run=false exec /usr/local/bin/node /usr/local/lib/node_modules/corepack/dist/corepack.js pnpm@11.13.0 --pm-on-fail=warn "$@"
