# cli

## Intent：最终目标

提供唯一的 zxc 可执行文件，集中处理命令与系统交互。

## Data：实现范围

命令分发、项目装载、包管理命令、缓存落盘、watch、外部工具调用及发行资源装配。既有运行回归在 tests/runtime，示例在 examples。

## Edges：职责边界

编译语义通过 compiler 包完成。标准库源码属于 compiler/standard；CLI 将其作为发行资源嵌入，不另存一份实现。compiler 不依赖 CLI。

## Answer：构建与验证

```sh
zig build
zig build test
```

仓库根目录使用 `zig build dist` 生成可分发程序与许可证。离线归档选项为 `-Dzig-archive=/absolute/path/to/archive`。成功标准包括既有运行回归，以及在空 PATH 下使用内嵌工具链完成真实构建。
