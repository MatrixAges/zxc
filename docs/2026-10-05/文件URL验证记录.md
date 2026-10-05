# 文件 URL 验证记录

## Intent：最终目标

验证显式 POSIX/Windows 文件路径转换契约，覆盖文本、任意字节、相对路径、UNC、扩展路径及资源释放。

## Data：证据与变更

1. [Node URL 文档](https://nodejs.org/api/url.html)定义文本与字节转换接口；[v26.10.0 官方测试](https://github.com/nodejs/node/blob/v26.10.0/test/parallel/test-url-pathtofileurl.js)包含扩展本地路径和无效 UNC 主机的明确期望。
2. 参考脚本使用本机 Node v25.8.1，对普通输入直接调用显式 windows 接口。相对路径先使用对应平台的 path.resolve 和显式 cwd 解析，避免宿主当前目录影响；UNC 保留原输入交给转换接口。
3. Node v25.8.1 对含空格 UNC 主机发生原生断言退出。该拒绝案例按 v26.10.0 官方测试的 ERR_INVALID_URL 固定，而非调用会崩溃的旧版本接口；记录在脚本末尾，不从 zxc 输出推导。
4. 首轮 1,397 条中 1,395 通过，两条失败：Windows 根相对路径的参考适配器漏应用 cwd 盘符，已经修正；扩展本地路径被生产实现当成 UNC，将 ? 作为主机并报 InvalidHost，属于生产缺陷。
5. 生产缺陷已发给指定实现会话，对方提交 7a8fbc77，按扩展前缀之后的绝对盘符结构分支，保留 UNC 路径分支。测试方未修改生产源码。
6. 补充全部 52 个大小写盘符的扩展路径和 UNC 归一化。生成器对所有输入身份做唯一性断言，去除 POSIX 空格示例与百分号矩阵重复的两条操作案例。

## Edges：边界与自审

- 独立参考不等于规范证明。Node v25.8.1 和 v26.10.0 已有差异，不能把旧参考崩溃当正确语义；参考错误由官方用例补证。
- 最终 1,449 条参考案例分为路径到 URL 347 条、URL 到文本 551 条、URL 到字节 551 条。包含 292 个预期拒绝；输入身份没有重复。
- 所有参考案例先验证正常执行，再逐个注入生产转换分配失败，检查 OutOfMemory 传播和泄漏。JSON 读取使用独立 std.testing.allocator，不把测试数据解析分配计入生产故障枚举。
- 2 项额外 Zig 原生测试覆盖 10 次非法 UTF-8 输入与 4 次缺失 host 的转换拒绝，避免 JSON 标量字符串限制掩盖字节输入边界。
- 文本拒绝编码路径分隔符及非法 UTF-8；字节接口按契约允许它们。两接口分别生成和断言，不相互代替。
- 本部分只验证转换内部 API，不声称 ZX 公共 ABI 或文件系统 I/O 已验收，也不覆盖 Windows 每盘符环境目录。
- 未运行浏览器，未变更测试范围以迎合实现；所有断言读取固定参考 JSON，不在正式测试时联网或调用 Node。

## Answer：交付与验收

正式测试位于 packages/test/tests/standard/resources/url/file，按操作和平台分组。test-url-file 已接入 test-standard-resources。具体架构和数据流见同日文件URL验证计划。

```sh
python3 docs/2026-10-05/文件URL验证/生成用例.py --check
zig build --build-file packages/test/build.zig test-url-file -j4 --summary all
zig build --build-file packages/test/build.zig test-url-file -Doptimize=ReleaseSafe -j4 --summary all
```

最终 Debug 与 ReleaseSafe 均为 18/18 构建步骤、1,451/1,451 测试通过。生成器 --check、输入唯一性检查及 Zig 格式检查通过。所有正常和拒绝路径均无 std.testing.allocator 泄漏报告。

初次失败日志保留以追溯缺陷与参考修正；日志中的初版 case 索引随后因加入案例和去重而变化。最终参考 JSON 与生成文件由 --check 一一核对。未重跑 test-standard-resources 全量，验收范围为独立 test-url-file。下一部分继续 ZX 公共 URL API 与原生库消费。
