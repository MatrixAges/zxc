# ZX 语言实现

## Intent：最终目标

在 compiler 包内完成 ZX 解析、类型与所有权分析、模块联结和 IR 校验。

## Data：实现组织

frontend 为词法与语法，analysis 为类型分析，ownership 为所有权检查，modules 为模块分析与缓存，ir 为 IR 校验。

## Edges：边界

共享数据结构位于 [core](../../../core/README.md)，IR 契约见 [IR契约](../../../core/IR契约.md)。本目录不负责 CLI 文件读取或产物发布。

## Answer：入口与成功标准

公开构建模块为 frontend。完整编译与风格门禁由 compiler 模块编排；只有通过 IR 校验的结果才能交给后端。既有语言测试位于 compiler/tests。

## 静态模板资源

ZX 的 `templateFile("./statement.tpl")` 在编译期包含独立模板正文。路径必须是静态的 `.tpl` 文件路径，支持 `./`、`../` 和 `@/`，遵守所在包的文件边界。正文沿用模板字面量的插值与转义规则，`${in.field}` 在引用处的 ZX 作用域内接受类型和所有权检查。模板是叶子资源，不递归包含其他模板。

库 API 的每个 `project.Source` 可通过 `templates` 提供 `{ path, source }` 资源集合；库不执行文件 IO。CLI 与自举构建负责读取、依赖跟踪和共享源码准备。准备后的文本进入既有解析及语义缓存，来源映射用于把错误定位回模板；fmt 始终处理原始 ZX。生成产物无需读取模板，不增加运行时解释器。此能力不用于模板生成 Zig，目标代码仍由结构化 genz 管线产生。

## 管道表达式

`value -> function(_) -> other(argument, _)` 保留独立 Pipeline AST，原生和索引解析路径均支持。
分析器将每级输入绑定一次，使用独立阶段上下文解析占位符，再降低为既有 Scope、Reference 与 Call。
不增加 IR opcode、专用运行库或新的持久化格式。阶段栈保存在遍历上下文，避免扩大普通表达式高频重建的 Frames。

阶段必须是使用 `_` 的调用；占位符不进入回调、迭代、异步体或嵌套管道，局部作用域可以建立自己的管道。
函数 Input 为 tuple 且实参多于一个时，复用普通调用的逐项检查与 tuple 构造，保持单 Input ABI。
单实参仍代表完整 Input。错误、权限、共享与所有权分析共用现有规则；RX 属性不执行管道。

管道左结合，低于普通二元运算、高于条件表达式；formatter 按阶段换行。
阶段、占位符和参数顺序的使用指导见 [编码约定](../../../skills/rx/编码约定.md#zx-管道表达式)。
