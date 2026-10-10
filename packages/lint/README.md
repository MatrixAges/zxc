# lint

ZX/RX 表达式风格、名称检查与四空格格式化包，依赖 core 的 ZX 类型及 dsl 的 XML AST。

## Intent：最终目标

让官方编译入口强制执行同一套名称、表达式风格与空行规则，同时允许编辑器独立格式化尚未通过语义检查的源码。

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
- 官方 fmt 默认使用四个空格缩进，保留 LF/CRLF；同一物理行中的多个语句不拆行，不调整引号与行宽。字符串、模板 token 内部和注释正文保持原文。
- 单层三元保留，条件、真分支或假分支的后代表达式不能再次包含三元。括号和普通表达式包装不解除限制；lambda 与状态块作为独立执行体重新检查。ZX 使用 match；RX value 使用 Switch 标签，或将判断提取到 ZX 后通过 Call.fn 取得结果。
- 普通值、回调参数和解构绑定使用 snake_case，类型使用 PascalCase，函数导入使用 camelCase；入口函数匿名。Call 注入的 $句柄不属于普通局部变量。
- 名称使用 ASCII 字母与数字；snake_case 禁止开头/结尾下划线及连续下划线。字段和外部协议名称不因内部绑定规则而重命名。

形状比较不使用语义职责、固定长度阈值或跨语言类型白名单。参数数目等局部差异可能使判断保持未定，未定不等于强制拆组。该策略落实规则明确覆盖的边界，不保证与 gcs 模型输出或任意人工审美逐字相同。

## Answer：接口与执行

- `length.check(source, maximum)` 统计 ZX 源码物理行数（含空行与注释），超过 `maximum` 时返回实际行数；`maximum` 为 0 时关闭。默认值 `length.default_maximum` 为 120。该规则只由 `zxc lint` 调用（`--max-lines <n>` 调整），`source.check` 与编译入口不包含行数检查。
- `checkNames(program)` 返回首条名称／表达式风格诊断或 null。
- `checkExpression(expression)` 与 `checkRxExpression(expression)` 共用语法树检查，分别给出 match 与 Switch／Call.fn 建议。
- `checkName(name, kind)` 检查单个名称。
- `source.check(allocator, input)` 依次检查名称、表达式风格和空行，返回首条诊断；input 包含 source、comments、program。
- `source.format(allocator, input)` 规划并应用空白编辑，内部释放 edits，返回调用方拥有的源码；不要求名称或语义先通过。
- `source.formatting_required` 是 CLI 格式检查失败的提示，和格式诊断内容统一由本包维护。
- `spacing.edits(allocator, source, comments, program)` 返回按源码位置排序、不重叠的空白编辑；输入必须是同一源码的 AST 和注释范围。
- `spacing.format(allocator, source, edits)` 应用编辑，返回调用方拥有的字符串。

调用方分别 free 编辑切片和格式化文本。编辑的 replacement 使用静态字符串，不需要逐条释放。直接执行：

```sh
zig-out/bin/zxc fmt packages/cli/examples/quote.zx --check
zig-out/bin/zxc fmt application.zx --write
```

默认 fmt 输出到标准输出；`--write` 才写回文件。compile 与 fmt 共用导入／空行 edits；官方 fmt 在应用这些编辑后，必要时重新解析位置，再按 token 规划四空格缩进。CLI lint 同时核对默认格式。表达式风格检查与格式化分离，fmt 可以整理尚未满足风格或语义规则的源码，不自动把判断转换成其它控制流。

仓库通用 GCS 格式化钩子跳过 ZX/RX 文件；两种源码使用 `zxc fmt`，避免模型格式化结果覆盖编译器的格式契约。

## RX 元素空行

`rx.format(allocator, source, node)` 接收同一份源码经 dsl.parseXml 成功解析的根节点，返回调用方拥有的文本。完整元素跨行，或相邻元素的标签、属性名列表、子元素结构不同，元素之间保留一个空行；同结构单行元素紧凑排列。元素内部首尾不保留多余空行。

只修改已有换行处的空白，不拆分同一行上的多个标签，不重排属性。元素、独立属性续行与结构注释按四空格层级缩进；保留 LF/CRLF、注释正文、属性值与实体写法。CDATA 和非空白文本不参与替换，含混合文本的父元素不调整自身间隔。格式化不要求 RX Schema、命名、依赖或类型检查通过，也不构成这些检查。此阶段未将 RX 空行规则加入构建门禁。

```sh
zxc fmt module.rx
zxc fmt state.store.rx --check
zxc fmt http.gateway.rx --write
```

统一入口 `compiler.format` 根据 .rx 后缀使用 XML 解析与上述格式规则，XML 语法错误返回带位置的诊断。实现与实际执行见 [RX 格式化参考](../../docs/2026-10-05/RX格式化参考.md)。

## 配置格式

`configuration.json.format(allocator, source)` 校验 JSON 语法并返回四空格缩进文本；保留数字词法值与数组顺序。`configuration.yaml.format(allocator, source, fields)` 接收同一 UTF-8 源码上已验证、按顺序且互不重叠的完整字段字节范围，只编辑字段间空行。Field.preserve_trailing 用于保护块标量的尾部内容。字段范围由使用既有 YAML parser 的调用方提供，不在 lint 中复制 YAML 或包清单 schema。

CLI 的 `zxc lint` 复用 ZX 名称／格式、RX 单文件 Schema／格式与各包配置 validator；`zxc fmt pkg.yaml` 和显式 `--kind index` 复用本包格式器。锁文件只读检查，由安装器维护。完整范围与命令见 [配置检查参考](../../docs/2026-10-05/配置检查参考.md)。

## RX 判断的组织方式

RX 的嵌套三元诊断建议使用 `Switch` 标签组织分支，或者用 `Call.fn` 将判断交给 ZX。以下写法将一个判断值合并后返回：

```xml
<Module>
    <Call fn="choose" in={$in} />

    <Return value={$ctx.choose} />
</Module>
```

对应的 `choose.zx` 使用 match：

```typescript
export type Input = { first: bool, second: bool }

export type Output = u8

export default function (in: Input): Output {
    return match {
        in.first => 1,
        in.second => 2,
        _ => 3
    }
}
```

实现与验证范围见 [表达式风格与四空格实施计划](../../docs/2026-10-06/表达式风格与四空格/实施计划.md)。

## 命名规则实现与引导

三类命名规则统一由 `src/naming/check.rx` 和 `check.zx` 实现。编译器类型表校验通过普通 ZX 模块引用复用同一规则，`checkName` 的 Zig API 静态调用生成代码；字符串借用及标量循环不需要临时堆分配。

构建编排由 compiler 提供生成文件，以 `generated_name` LazyPath 参数传给 lint；其他仓库调用者使用 compiler 导出的 lint 模块。lint 不依赖 compiler 包。只有最初的生成宿主显式设置 `seed = true`，使用 `bootstrap/naming.zig`；正式构建缺少生成输入时直接报错，不自动退回 seed。其余 lint 的 AST 遍历及格式处理仍待迁移，不能据此宣称整个 lint 已完成自举。
