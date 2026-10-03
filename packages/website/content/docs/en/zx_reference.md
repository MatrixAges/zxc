Use this page as a compact syntax and behavior reference. Start with [write logic](/docs/write-logic) for a complete function.

### File contract

| File kind  | Contents                                                           |
| ---------- | ------------------------------------------------------------------ |
| Executable | Imports, exported types/enums, then one anonymous default function |
| Type-only  | One or more exported types/enums, no executable default function   |

The executable entry uses `Input`, `Output`, and the parameter name `in`. Imported executable functions accept one input value. Function imports use `camelCase`; local values use `snake_case`; types use `PascalCase`.

### Values and expressions

| Construct  | Supported shape                                                  |
| ---------- | ---------------------------------------------------------------- |
| Scalar     | `void`, `bool`, integer widths, `f32`, `f64`, `string`           |
| Optional   | `T?`, optional object properties, `null`, `??`                   |
| Collection | `T[]`, tuple `[T, U]`                                            |
| Structured | Named types, objects, enums                                      |
| Branch     | `if`, early `return`, conditional expression                     |
| Binding    | `const`, tuple destructuring, `_` discard                        |
| Boolean    | Short-circuit `&&` and `                                         |     | `   |
| String     | Byte equality; template interpolation of supported scalar values |
| Copy       | `clone(value)`                                                   |
| Transform  | Non-capturing expression callbacks for `map`, `filter`, `reduce` |

### Unsupported assumptions

Do not write `let`, `var`, `for`, `while`, `throw`, general closures, or user-defined generics. ZX's familiar syntax is not a promise of TypeScript compatibility. There is no JavaScript runtime underneath the generated program.

### Capabilities

`zig:` and `lib:` imports require explicit external registration by the host compiler integration. They are not arbitrary module downloads or automatic access to native functions from the CLI. Store operations likewise depend on a compilation and execution context supplied by the host.

### Runtime semantics

Numeric widths remain explicit. Invalid arithmetic and invalid indexing can fail at runtime. List mutation operations consume their input binding and return the updated list. A successful type check does not prove business preconditions or host transaction behavior.

Read [types and values](/docs/types-and-values), [collections and ownership](/docs/collections-and-ownership), and the [current compiler contract](https://github.com/MatrixAges/zxc/blob/master/packages/compiler/README.md) for the detailed boundaries.
