# core

## Intent：最终目标

共享 AST、IR、源码位置和诊断数据，让 compiler、lint、genz 使用同一模型，避免相互依赖。

## Data：公开内容

source、syntax、ast、ir、Diagnostic、Reporter 与语言/IR 版本。IR 契约见 [IR契约](IR契约.md)。

## Edges：边界

不包含解析、类型检查、格式化、代码生成、文件系统或运行调度。语言实现位于 compiler/src/zx 与 compiler/src/rx；数据切片的生命周期由调用方管理。

## Answer：使用与成功标准

使用 `dependency.module("core")`。同一编译图共享该模块实例，语言前端和后端以同一类型契约传递数据。
