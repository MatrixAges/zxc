Read the first diagnostic at its reported source location. Fixing the earliest invalid construct often removes later errors caused by the same assumption.

### Diagnostic format

```text
path:line:column:code:message
```

The code describes the failure category. Keep the message and source location when reporting a problem; a category alone is usually insufficient.

| Code                | Check first                                         |
| ------------------- | --------------------------------------------------- |
| `lexical`, `syntax` | Tokens, delimiters, and supported grammar           |
| `unsupported`       | Whether the construct exists in ZX                  |
| `contract`          | File role, Input/Output, and default function shape |
| `name`, `naming`    | Declarations, scope, and naming conventions         |
| `type_mismatch`     | Explicit scalar widths and structured data shape    |
| `return_path`       | Whether every required path returns a value         |
| `spacing`           | The compiler formatter's expected spacing           |
| `ownership`         | A borrowed or previously consumed value             |
| `module`            | Import paths, file roles, and dependency cycles     |
| `capability`        | Host registrations and access permissions           |

### An import cannot be resolved

Check the file exists, the `.zx` extension is explicit, and relative paths start at the importing file. For `@/`, check the compiler process's working directory. Ensure type imports point to type-only files and function imports point to executable files.

### A list cannot be used again

Find the first operation that consumed the binding. Continue with that operation's returned list, or clone before the point where two independent owners are needed. Renaming a consumed value does not restore its ownership.

### Formatting fails

Run `zxc fmt file.zx` to inspect formatted output, then use `--write` when you intend to replace the file. `--check` exits with status 1 when the file differs. The formatter is focused on ZX's supported spacing rules; it is not a general TypeScript formatter.

### XML validates but the application does not run

The current RX package validates a constructed AST and its module graph. It does not include an XML parser, expression evaluator, scheduler, or automatic ZX binding. Identify the host that supplies these missing layers before debugging the declaration as a running service.

### Report a reproducible issue

Include the source revision, Zig version, command and working directory, smallest relevant files, complete diagnostic, and expected behavior. For generated Zig failures, also include the generated source and the host integration boundary.
