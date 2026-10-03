# lint

ZX 的名称检查和 AST 空行格式化包，仅依赖 zx。

## Intent：最终目标

让官方编译入口强制执行同一套名称与空行规则，同时允许编辑器独立格式化尚未通过语义检查的源码。

## Data：实现依据

依据用户指定的 gpu-code-spacer/rules.md：比较同层相邻完整语句的写法；相似单行可以成组，多行完整表达式与相邻语句分隔。规则包含人工判断边界，本包不将模型预测等同于规范，也不依赖 Node、GPU 或 WASM。

本包以 AST 的声明和语句边界决定分组，利用原始源码和注释范围应用局部空白编辑，不通过文本关键字匹配识别语句。

## Edges：当前规则

- 类型声明之间、类型与默认函数之间保留一个空行。
- 完整语句或导入跨行时，与相邻项之间保留一个空行；不在表达式内部插行。
- 单行的标量声明、解构或 Store 写入分别比较完整结构；明显同形者保持紧凑，不以变量、类型或方法的名称作分组依据。
- 声明、解构、分支、Store 写入与 return 等不同语句形式之间保留一个空行。没有明确同形证据的同类单行组合保留原有间距，不用宽泛 AST 标签强行合并。
- 块的首尾不保留额外空行。
- 行尾注释跟随前一语句，独立行注释保留在后一组之前；不修改注释正文。
- 保留 LF/CRLF、缩进及所有非空行内容；同一物理行中的多个语句不拆行。当前不是完整的缩进/引号/行宽格式器。
- 普通值、回调参数和解构绑定使用 snake_case，类型使用 PascalCase，函数导入使用 camelCase；入口函数匿名。Call 注入的 $句柄不属于普通局部变量。
- 名称使用 ASCII 字母与数字；snake_case 禁止开头/结尾下划线及连续下划线。字段和外部协议名称不因内部绑定规则而重命名。

形状比较不使用语义职责、固定长度阈值或跨语言类型白名单。参数数目等局部差异可能使判断保持未定，未定不等于强制拆组。该策略落实规则明确覆盖的边界，不保证与 gcs 模型输出或任意人工审美逐字相同。

## Answer：接口与执行

- `checkNames(program)` 返回首条名称诊断或 null。
- `checkName(name, kind)` 检查单个名称。
- `source.check(allocator, input)` 依次检查名称和空行，返回首条诊断；input 包含 source、comments、program。
- `source.format(allocator, input)` 规划并应用空白编辑，内部释放 edits，返回调用方拥有的源码；不要求名称或语义先通过。
- `source.formatting_required` 是 CLI 格式检查失败的提示，和格式诊断内容统一由本包维护。
- `spacing.edits(allocator, source, comments, program)` 返回按源码位置排序、不重叠的空白编辑；输入必须是同一源码的 AST 和注释范围。
- `spacing.format(allocator, source, edits)` 应用编辑，返回调用方拥有的字符串。

调用方分别 free 编辑切片和格式化文本。编辑的 replacement 使用静态字符串，不需要逐条释放。直接执行：

```sh
zig-out/bin/zxc fmt packages/compiler/examples/quote.zx --check
zig-out/bin/zxc fmt application.zx --write
```

默认 fmt 输出到标准输出；`--write` 才写回文件。compile 与 fmt 使用相同的 edits 规划逻辑，避免检查和修复规则不一致。
