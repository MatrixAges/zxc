# 编译器 RX 目录职责调整

本轮用户后续决定合并 RX/ZX 到 compiler，并新建 cli 与共享数据 core 包。最终执行方案、IDEA 边界及验证记录统一见 [语言与命令行包边界调整计划](语言包与命令行职责拆分计划.md)。

application 的命名已移除；RX 编译语义位于 compiler/src/rx/analysis，CLI 装载位于 cli/src/cli/rx。
