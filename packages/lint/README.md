# lint

ZX 的名称检查和 AST 空行格式化包，仅依赖 zx。

## Intent：最终目标

让官方编译入口强制执行同一套名称与空行规则，同时允许编辑器独立格式化尚未通过语义检查的源码。

## Data：实现依据

参考仓库固定的 gpu-code-spacer 0.1.6 的逻辑分组效果。gcs 使用嵌入模型预测空行，并非一套确定性的 AST 规则；本包不复制模型结果，也不依赖 Node、GPU 或 WASM。

本包以 AST 的声明和语句边界决定分组，利用原始源码和注释范围应用局部空白编辑，不通过文本关键字匹配识别语句。

## Edges：当前规则

- 类型声明之间、类型与默认函数之间保留一个空行。
- 同一块内连续 const（包括元组解构）保持紧凑；其他相邻语句之间保留一个空行，包括 if 前后与后续 return。
- 块的首尾不保留额外空行。
- 行尾注释跟随前一语句，独立行注释保留在后一组之前；不修改注释正文。
- 保留 LF/CRLF、缩进及所有非空行内容；同一物理行中的多个语句不拆行。当前不是完整的缩进/引号/行宽格式器。
- 普通值、回调参数和解构绑定使用 snake_case，类型使用 PascalCase，函数导入使用 camelCase；入口函数匿名。Call 注入的 $句柄不属于普通局部变量。
- 名称使用 ASCII 字母与数字；snake_case 禁止开头/结尾下划线及连续下划线。字段和外部协议名称不因内部绑定规则而重命名。

这是一份明确的首版 AST 分组策略，不保证与 gcs 的模型输出逐字相同。

## Answer：接口与执行

- `checkNames(program)` 返回首条名称诊断或 null。
- `checkName(name, kind)` 检查单个名称。
- `spacing.edits(allocator, source, comments, program)` 返回按源码位置排序、不重叠的空白编辑；输入必须是同一源码的 AST 和注释范围。
- `spacing.format(allocator, source, edits)` 应用编辑，返回调用方拥有的字符串。

调用方分别 free 编辑切片和格式化文本。编辑的 replacement 使用静态字符串，不需要逐条释放。直接执行：

```sh
zig-out/bin/zxc fmt packages/compiler/examples/quote.zx --check
zig-out/bin/zxc fmt application.zx --write
```

默认 fmt 输出到标准输出；`--write` 才写回文件。compile 与 fmt 使用相同的 edits 规划逻辑，避免检查和修复规则不一致。
