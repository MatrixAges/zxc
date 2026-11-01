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
