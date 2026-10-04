# ZX 语言实现

## Intent：最终目标

在 compiler 包内完成 ZX 解析、类型与所有权分析、模块联结和 IR 校验。

## Data：实现组织

frontend 为词法与语法，analysis 为类型分析，ownership 为所有权检查，modules 为模块分析与缓存，ir 为 IR 校验。

## Edges：边界

共享数据结构位于 [core](../../../core/README.md)，IR 契约见 [IR契约](../../../core/IR契约.md)。本目录不负责 CLI 文件读取或产物发布。

## Answer：入口与成功标准

公开构建模块为 frontend。完整编译与风格门禁由 compiler 模块编排；只有通过 IR 校验的结果才能交给后端。既有语言测试位于 compiler/tests。
