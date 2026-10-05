# RX 新属性验证记录

## Intent：最终目标

验证新 RX 属性语法区分字符串与 ZX 表达式，确认旧源码迁移后的诊断位置和运行含义仍正确。

## Data：实测与实现

新增 test-rx-attributes，包含 70 条解析、78 条属性契约测试，并依赖 test-rx-attribute-runtime 的 26 个真实应用、55 次执行，另有 6 条真实 CLI 编译拒绝。正式文件位于 packages/test/tests/rx/attributes，运行样例按字符串、表达式、流程、函数和服务分组。

解析案例检查 .kind、解码后的 value、原始 raw_value、起止字节位置及相邻属性未被吞入。覆盖花括号对象、嵌套模板、模板内对象字符串、单双 XML 引号、字符串中的闭合符、块与行注释、CRLF、原始关系/逻辑运算符、实体单次解码和畸形边界。解析后覆盖原输入缓冲区再检查结果，验证所有权。

属性案例使用真实 Module、Gateway、Store 文本并调用正式 schema：23 个必须使用引号的静态属性、4 个必须花括号的属性均验证两种写法；Call.in、Return.value、Switch.on、Case.value、Emit.value、Field.value 各验证非空字符串、空字符串、输入表达式、对象表达式。错误路径核对 invalid_attribute、属性名称和源字节位置。

全部 148 条原生案例均执行 checkAllAllocationFailures，覆盖解析和 schema 的成功与拒绝路径。正式样例不由手写 AST 代替。

编译拒绝案例检查空/空白花括号、空 Call.in、引号数字/输入不能隐式转为数值、表达式中的 XML 实体不解码，并确认失败不产生可执行文件。

运行案例验证：

- 引号中的 $in、对象外形、模板外形只作为字符串；空字符串、XML 实体和空白规范化实际返回正确值。
- 原始表达式中的 &amp; 不做 XML 解码；<、&&、注释和嵌套模板正确编译执行。
- 动态输入驱动列表、对象和数值/字符串 Switch；引号 Case 与表达式字符串 Case 保持相同字符串值语义。
- 无后缀与显式后缀的 service、Import 路径执行一致；子服务通过相对目录调用无后缀 ZX 函数。
- Store 初值同时使用字面 $in、空字符串、解码实体、原始表达式字符串与数值；经 Call 输入授权读取后核对全部字段。

### 迁移回归修正

首次 test-rx-text/test-rx-inference 得到 251/258 通过、7 个测试崩溃。均是既有位置用例已改为花括号源码，却保留旧实体或引号 marker；辅助函数对不存在的 marker 强制解包，导致测试进程 ABRT，并非生产解析器崩溃。

修正两个位置测试文件，使 marker 与新语法一致；缺失 marker 现在报告 MissingDiagnosticMarker。原实体测试改为真实引号字符串传入数值函数的 type_mismatch 位置检查，另覆盖原始 CRLF、注释前缀和闭合花括号位置，没有降低为只检查“产生错误”。修正后既有文本/推导 258/258 全部通过。

## Edges：边界与自审

1. 初始 CLI 测试把项目源码置于临时 cwd 之外，触发 RxEntryOutsideProject；已按成熟运行 fixture 做法复制完整项目并在该项目目录构建。没有放宽根边界。
2. 初版 Store 观察用例直接从 Return 读取 Store，违反已有 Call 显式读取授权。已改成 Call.in 读取并返回 ctx 结果；不是生产问题，没有要求实现会话扩大权限。
3. 多文件分组前尝试 Grit HTML 规则，工具对新 RX 花括号语法报告解析错误且零匹配，未执行不可靠批量改写。随后用明确文件映射移动样例、同步相对引用与清单，并重新构建执行。尝试规则保留为功能目录路径分组.grit，仅用于记录。
4. 新增 209 条验证由 148 个原生测试、55 次应用断言与 6 条编译拒绝构成；故障注入重试、两个优化模式及既有回归均不累加为新增语义案例。
5. Emit 只验证属性与 schema，不声称事件运行时存在。schema 成功和实际执行分别提供证据；不以 Probe 解析测试替代完整 Module 校验。
6. 拒绝诊断按实际处理契约核对：空表达式在 schema 阶段报告 context，表达式内 XML 实体残留报告 syntax，字符串传入数值函数报告 type_mismatch；没有把诊断类别统一放宽为任意失败。
7. 本轮没有修改生产代码，没有发现需提交实现会话修复的问题。原有 XML 实体与位置能力保留，表达式内部采用新的原始 ZX 语义。

## Answer：交付与复现

```sh
python3 docs/2026-10-05/RX新属性验证/生成用例.py --check
zig build --build-file packages/test/build.zig test-rx-attributes -j2 --summary all
zig build --build-file packages/test/build.zig test-rx-text test-rx-inference -j2 --summary all
zig build --build-file packages/test/build.zig test-rx-runtime -j2 --summary all
```

各 Zig 命令加 -Doptimize=ReleaseSafe 可运行对应模式。新 runtime 可独立使用 test-rx-attribute-runtime。生成器核对解析与属性目录，运行样例及 cases.json 为固定审阅输入。

架构与数据流图见同日《RX新属性验证计划》。初次失败与最终结果日志保存在同名功能目录，既有回归最终结果：

| 范围          | Debug                 | ReleaseSafe           |
| ------------- | --------------------- | --------------------- |
| RX 文本与推导 | 258/258               | 258/258               |
| RX 既有执行   | 933/933 步骤，875/875 | 933/933 步骤，875/875 |

新套件最终组合入口在 Debug、ReleaseSafe 下均为 18/18 构建步骤通过，包含生成检查、148/148 个 Zig 测试、55 次应用执行和 6 条编译拒绝。两种模式均未报告分配泄漏。

生成器 --check、Zig 格式检查、diff 空白检查，以及两份新 TypeScript runner 的严格独立类型检查通过。本轮未执行全仓 test，不能由这些局部结果宣称整体 Test262 对齐完成。初始 ReleaseSafe 合并运行曾使用修正前的 Store 观察样例，日志明确命名为 Store观察修正前ReleaseSafe，不当作最终成功证据。
