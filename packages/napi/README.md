# napi

## Intent：最终目标

为编译后的 zxc 应用提供 Node-API 类型边界，不引入 ZX 解释器。

## Data：职责

api.zig 声明所需的稳定 C ABI；read.zig 和 write.zig 根据编译期类型形状转换 JS 与 Zig 值；value.zig 收口数值范围、字符串和 Node 状态处理。resources.zig 为 CLI 提供嵌入源码，独立发行的 zxc 不依赖开发仓库路径。

## Edges：边界

包不负责命令行、动态库链接或应用 Store 生命周期，后者由 CLI 宿主入口管理。字符串与字节列表由 genz 的形状区分。JS 输入复制到请求 arena；返回值成为 JS 自有数据。64 位整数使用 BigInt 且禁止有损转换。void 映射 undefined，可空值映射 null，枚举映射成员名称。

## Answer：入口

Zig 消费者通过模块 napi 使用 read、write、check、fail；CLI 使用 --host node 构建 addon.node，公开用法见 [N-API reference](../../docs/2026-10-05/NAPI参考.md)。正式 Node 插件最低声明 Node-API 6。
