# Store 回收证明验证记录

## Intent：最终目标

确认 Store 回收资格依据完整写入的递归独占性，且函数摘要、嵌套服务和库归档不能把持久借用伪装成独占。对应阶段 400，承接 399 的实际区域回收测试。

## Data：覆盖与证据

新增 `test-store-ownership-proof` 并接入总 test，源码在 `packages/test/tests/ownership/store_proof`。使用正式 RX XML 解析、项目推导、validateIr、frontend.storesOwnValues、库链接及 codec API。

Store 包含 count:u64、rows:u64[][]、labels:string[]，以真实声明与初值编译。16 种写入形状分别通过直接 writer、辅助函数 make、嵌套 RX service、service+make 四种调用图，共 64 项。每项在源码 IR 和携带 Store 初始化产物的库编解码后重新检查资格，并确认初始化产物未丢失。

16 种形状涵盖：全新字面量、只读旧标量、整个借用输入、只换标量的展开外壳、借用 rows、只复制 rows 外层、逐层 map 新建 rows、借用 labels、只复制 labels 外层、模板新建字符串、两类字段都新建、两支皆独占、分支含借用、把借用行放入新列表、读取标量元素后重建、展开后替换全部引用字段。

借用程序应合法通过分析，只是 storesOwnValues 为 false；浅对象或列表外壳不能抹去深层借用。逐层 map 数字列表、模板新建字符串与全引用字段替换则检查资格为 true。辅助函数和 RX 服务的额外边界不得改变结论。

4 项分配失败测试覆盖两类深层构造、浅层借用和条件借用，从 XML/ZX 分析、所有权证明到包含初值的库链接、编码、解码及二次验证完整清理。

### 伪造摘要门禁

8 项伪造测试将实际返回 borrowed 的 make 函数摘要改成 owned，覆盖完整输入、浅 rows、浅 labels、条件借用，分别在单层和嵌套服务中执行。函数体、输入输出类型及字段布局均保持不变，且断言恰好找到并修改一个目标函数。

变异必须被 validateIr、Zig 代码生成、library.link、codec.encode 拒绝。另手工序列化相同合法 schema 的归档内容，重新计算 SHA-256 并保留实际格式标记，使伪造归档具备正确校验和，再验证 codec.decode 返回 InvalidLibrary。相同构造器生成的未变异归档必须可解码且 IR 有效，排除因封装错误导致的假阳性。2 项 OOM 覆盖这些门禁与解码链路。

共 64 个语义测试 + 4 个正常链路 OOM + 8 个摘要伪造测试 + 2 个伪造链路 OOM = 78 项。两条验证路径在每个测试中执行，不再额外乘以二。

最终 Debug 与 ReleaseSafe 均 78/78 测试、4/4 构建步骤通过，退出 0；两个优化模式不重复计数。

## Edges：限制与自我批判

首轮直接及辅助函数 32 项通过，嵌套服务夹具使用无约束的 $in，因调用链不使用该输入而无法推导类型。给这一无需输入的服务调用提供明确的 u64 字面量后，服务矩阵通过；这只是夹具构造，不改变语言推导规则。

摘要变异初轮匹配包含斜线的 make 文件尾名，但实际 IR 文件名为相对路径，导致未修改任何函数，测试以 changed=1 断言失败。改用 basename 后正确命中；保留首次失败日志，未把无变异结果算作通过。

本轮未发现新的生产缺陷，未向实现会话发送修复消息。工作区另有 child_process 标准库实现进行中，结果 JSON 保存测试记录时的生产状态；不能据此宣称整个工作区干净。

这是资格推导和库门禁测试，未新增执行这些 16 种数据形状的运行宿主，也不宣称测试所有所有权摘要攻击。实际区域回收由上一阶段独立测试支持。未覆盖任意原生返回、全类型组合、跨请求 owned 输入转移、所有条件路径或深层分配归属。通用共享 Store 回收与完整 Test262 仍未完成。

## Answer：复现与交付

在 `packages/test` 执行：

```sh
zig build test-store-ownership-proof --summary all
zig build test-store-ownership-proof -Doptimize=ReleaseSafe --summary all
```

最终结果写入 [结果 JSON](Store回收证明验证/结果.json)，日志与草稿在 [配套目录](Store回收证明验证/)。[计划](Store回收证明验证计划.md)包含 IDEA、架构图和数据流图。完成后独立提交推送。
