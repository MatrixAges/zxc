# URL 公开接口验证记录

## Intent：最终目标

验证 std:url 的 12 个公开接口在 ZX 源码、已发布库及独立 Zig 消费中保持类型、返回值和错误契约，补齐内部 URL 算法测试未覆盖的接口与资源边界。

## Data：可用证据

| 接口            | 固定案例数 |
| --------------- | ---------: |
| canParse        |        896 |
| tryParse        |        896 |
| parse           |        628 |
| resolve         |        628 |
| stringify       |        627 |
| pathname        |        627 |
| origin          |        414 |
| domainToASCII   |         14 |
| domainToUnicode |         14 |
| pathToFileURL   |        347 |
| fileURLToPath   |        551 |
| fileURLToBytes  |        551 |
| 合计            |      6,193 |

WPT 固定版本沿用 c48d58747e1f211527fb695fd60548a997fae617，生成时校验原始文件 SHA256。canParse 和 tryParse 消费全部成功与失败案例；resolve 对成功案例使用原始 input/base，parse 对成功案例使用无 base 的规范 href。两者另有明确抛错用例。stringify/pathname/origin 的期望由 WPT 给出；公开记录的字段来自 WPT 的 protocol、hostname、port、pathname、href 分隔符等独立数据，不从生产 parse 导出。origin 只采用上游给出的 414 个期望。

文件转换复用上一轮完整 1,449 条 Node 参考案例，映射为公开 FilePath/FileUrl 类型。显式平台由 ZX bool 输入转换为 Platform 枚举。原生错误枚举由文件转换契约分支映射，不按生产实际错误回填。域名案例包括 IDNA、全角映射、IPv4、IPv6、无效主机和当前 ASCII ACE 兼容规则。

### 三条执行链

1. 源码链：真实 CLI 读取 .zx，产生程序与 ABI；标准库使用该 ABI 构建，collections 支持层深复制输入、运行 execute 并检查输入未变化与返回值。
2. ZX 发布消费链：每个操作由 CLI 发布到独立临时目录，确认携带 zxc_standard 原生依赖；消费者从 library 导入函数及 Input/Output 类型，构建为程序并逐例执行。
3. 原生发布消费链：每个操作同样真实发布；临时 Zig 项目通过 b.dependency("library") 使用发布包自己的 build.zig 和原生依赖；执行与源码链相同的 Zig 断言，直接比较原生值。

三条链都消费完整 6,193 条目录案例；重复执行不累加为独立案例。临时构建目录结束后清理。

### 资源检查

另有 5 项 Zig 测试，使用正式 standard ABI 检查公开层：

- 层级与不透明 URL 的 parse/stringify 分配失败清理。
- resolve 对 base 字段复制后的生命周期。
- tryParse、canParse 在成功与语义拒绝路径均传播 OutOfMemory。
- 域名成功和空字符串拒绝结果的独立所有权。
- 修改原输入缓冲区后公开 Url 记录仍可正确序列化。

返回记录逐字段释放；这里使用 std.testing.allocator 故障枚举，不用应用 arena 最终释放代替复制路径的资源证明。

## Edges：边界与自审

1. 已修正测试驱动的两处接线错误：外部进程 cwd 改为临时目录前应将 CLI/语料路径绝对化；--mode lib 不接受 --optimize，优化模式施加在消费端。
2. u8[] 的应用 JSON 约定是有效 UTF-8 输出字符串、其余输出字节数组。消费者断言按输出类型与 isUtf8 转换期望；原生链仍逐字节比较，未把二进制强制转为文本。
3. 最初消费者写成 `export type Result = Output` 后让入口返回 Result，产生 syntax: Output，曾误判并反馈为库别名问题。实现会话检查发现入口签名固定为 Input/Output；保留 Result 别名而返回 Output 即可构建和再次发布。没有生产缺陷，不修改编译器，不把该反馈列为待修复。详见同日《编译库类型别名反馈核对》。原始不符合契约的复现保留在功能目录，仅作为分析证据，不纳入正向测试。
4. 包级 TypeScript 检查仍有两处既有错误：tests/runtime/http/server.ts:72 的 Buffer 泛型，tests/runtime/process_entry/run_test.ts:50 的 delete 可选性。两文件本轮没有修改。本轮生成器、共享 helper 与两种消费 runner 单独严格类型检查通过。
5. 公开字段编辑、可选格式化、HTTP options 和旧版 Node URL 对象均未由本轮实现或声称完成；WPT 核心和文件平台测试仍由前两轮单独维护。
6. 本轮没有新增或调整 Test262 原始案例适配记录；URL 属于额外标准库能力验证。三条路径通过不能推导整个 zxc 或全部 Test262 已达到生产级。

## Answer：交付与复现

```sh
node packages/test/src/generate_url_api.ts --check
zig build --build-file packages/test/build.zig test-url-api -j2 --summary all
zig build --build-file packages/test/build.zig test-url-api-library -j2 --summary all
zig build --build-file packages/test/build.zig test-url-api-resources -j2 --summary all
```

每条 Zig 命令增加 -Doptimize=ReleaseSafe 即验证对应优化模式。test-url-api-library 已包含 test-url-api-native；也可分别运行以定位路径问题。构建总入口包含生成一致性检查，追踪生成器 helper 和固定参考文件。架构与数据流图见《URL公开接口验证计划》。

原始签名复现重建顺序：先把功能目录的 类型别名库.zx 发布到 类型别名复现/library，再构建 main.zx 观察拒绝；alias_observation.zx 为实现会话保存的符合契约示例。生成库不纳入版本控制。

最终结果：

| 路径                | Debug                        | ReleaseSafe                  |
| ------------------- | ---------------------------- | ---------------------------- |
| 源码与共享 ABI      | 57/57 步骤，6,193/6,193      | 57/57 步骤，6,193/6,193      |
| 发布库 ZX 消费      | 10/10 步骤，6,193 条执行通过 | 10/10 步骤，6,193 条执行通过 |
| 发布库独立 Zig 消费 | 10/10 步骤，6,193/6,193      | 10/10 步骤，6,193/6,193      |
| 公开接口资源检查    | 6/6 步骤，5/5                | 6/6 步骤，5/5                |

日志逐项保存于同名功能目录。本轮严格类型检查、生成器 --check、Zig 格式检查和 diff 空白检查通过。包级 TypeScript 错误如上保留，不宣称全仓检查通过。未执行整个 test 或 test-standard-resources。

自我复核结论：12 个当前公开接口都有实际运行证据，发布路径使用包内标准库依赖；未发现 URL 实现的新问题。别名反馈属于测试入口误用，已明确纠正。后续继续新 RX 语法迁移等特性回归，整体目标保持未完成。
