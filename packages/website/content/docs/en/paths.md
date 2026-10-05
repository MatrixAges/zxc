Paths identify modules. Keep file placement aligned with business responsibilities so imports remain understandable without a registry of aliases.

### RX service paths

`Call.service` and `Import.from` resolve against the importing module. The normalizer adds the `.rx` suffix when omitted: `./load` and `load.rx` identify the same sibling module.

| Form                                                   | RX behavior                                        |
| ------------------------------------------------------ | -------------------------------------------------- |
| `users/load`                                           | A module below the caller's directory              |
| `../shared/load`                                       | A module in a parent directory, within the project |
| `/users/load`                                          | Rejected: absolute path                            |
| A path escaping the project root                       | Rejected                                           |
| Backslashes, colons, or a trailing slash               | Rejected                                           |
| `app.rx`, a Gateway file, or a Store file as a service | Rejected                                           |

`app.rx` is a reserved basename. Do not use it for an ordinary module, including inside a nested directory. Path normalization is lexical; it does not resolve filesystem symlinks.

### Declaring a dependency

```xml
<Module>
  <Import from="shared/validate" />

  <Call service="orders/create" in={$in} out="ctx.order" />

  <Return value={ctx.order} />
</Module>
```

An `Import` declares a graph edge; it does not execute the imported module and has no `as` alias. A service call already declares its own edge, so do not add a duplicate import just to enable it.

### ZX imports

ZX file imports may omit the `.zx` extension and start with `./`, `../`, or `@/`. `./calculate_quote` and `./calculate_quote.zx` identify the same module. Relative paths start at the importing file. `@/` starts at the owning package or project root, or the CLI working directory when no project configuration is present.

```typescript
import calculateQuote from './calculate_quote'
import type { Money } from './types'
```

Default function imports come from executable ZX files. Shared type and enum imports come from type-only files. A type-only file exports at least one type or enum and has no default function. Do not use an executable module's `Input` export as a substitute for a shared type module.

An extensionless file reference only gains `.zx`; it does not search directory entry points or other language extensions. Package names and `std:`, `zig:`, and `c:` imports retain their own module resolution rules.

### Keep both graphs acyclic

The compiler checks dependencies, including unused imports. A branch that never executes cannot make a cyclic dependency acceptable. Move shared work into a lower-level module and pass parent-owned values as input.

Continue with [dependency design](/docs/keep-dependencies-acyclic).
