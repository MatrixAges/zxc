# test

> Context 注入功能已移除，相关专项不再注册；混合 Store 产物测试使用显式 Input。历史阶段记录不代表当前能力。

## Intent：最终目标

保留 ZX/RX 的设计，逐项审查固定版本的 Test262 行为，以独立预期和完整编译执行验证 zxc。目标超过 30,000 个有效案例；当前进度见执行记录，不将目标数写成已完成数。

## Data：结构与证据

- `upstream/lock.json`：固定上游提交、下载地址和归档 SHA-256。
- `upstream/index/`：按上游顶层分类的完整路径与内容哈希，只是索引，不是测试。
- `upstream/metadata/`：53,597 个文件的上游 frontmatter 事实，可按特性和负例阶段筛选；不表示适用性或执行结果。
- `upstream/reviews/`：多层目录中的逐项决定、理由、契约和本地案例 ID。不存在审查记录即 unreviewed。
- `suites.json`：构建与审计共用的案例目录登记表；漏登记、多重登记或指向缺失文件都会失败。
- `tests/language/expressions/division/`：f32/f64 ZX 源码及具名输入/预期目录；每条数据独立生成为 Zig `test`，执行真实生成模块。
- `tests/language/expressions/logical_not/`：布尔取反、绑定、字段、连续取反和逻辑优先级；非布尔类型另有静态拒绝案例。
- `tests/language/expressions/unary_minus/`：取负、绑定、双重取负及字段读取的位模式断言，严格区分有符号零。
- `tests/language/expressions/comparison/`：f32/f64 NaN、零、无穷和相邻值的六种比较；每组输入计一个案例。
- `tests/language/expressions/{logical_and,logical_or,conditional,coalesce}/`：短路正反分支、嵌套优先级及精确索引错误。
- `tests/language/expressions/static_names/`：全部分支的名称正负例，精确检查分析诊断位置，并区分静态检查与运行短路。
- `tests/language/lexical/numeric/`：词法阶段、位置、合法数值与上游字面量实际执行。
- `tests/language/lexical/comments/block/`：非嵌套结构、字符串标记和两项完整 BMP 遍历；范围内循环不另计案例。
- `tests/language/lexical/comments/`：ASCII/Unicode 空白区别、CR/LF 注释边界、模板插值和实际执行值。
- `tests/language/lexical/{string,utf8}/`：转义、控制字符、未终止字符串和原始 UTF-8 源码字节；负例检查具体阶段与 span。
- `tests/language/types/operators/`：12 种类型 × 12 种类型 × 13 种操作符，区分分析通过与 type_mismatch；分析前必须解析成功。
- `tests/runtime/safety/integer/`：整数正常结果、溢出、除零、有符号余数与单次/双重取负边界；每个案例单独运行进程。
- `tests/ownership/{propagation,consumption}/`：标量与嵌套容器的借用传播、旧 owner、自引用参数；已用本地构造替换旧 clone 前置条件。`tests/ownership/deep_copy/` 已验证 clone 禁止。
- `tests/built_ins/list/`：集合值模型、严格区间、嵌套别名与回调错误；执行前后深比较输入。
- `tests/built_ins/string/`：字节长度、内容比较、optional、模板、排序与字符串累积。
- `tests/rx/modules/graphs/`：合成 AST 的模块图校验；三节点含自环与四节点无自环图，覆盖直接调用、Import、Case 和 Parallel/Task。
- `tests/rx/modules/resources/`：4、16、64 节点的逐分配点故障注入，以及 256/1,024 节点链与环在固定线程栈上的回归。
- `tests/rx/modules/paths/`：规范化身份、重复注册、缺失依赖、越界引用及属性空白的完整诊断。
- `tests/support/`：断言支持。浮点非 NaN 结果按位比较，区分正负零；NaN 不约束 payload。
- `src/models/ieee.ts`：独立参考模型，用精确有理数进行 IEEE 最近偶数舍入，不调用 zxc/Zig 生产实现。
- `src/generate_division.ts`：生成有语义边界的参数矩阵；稳定 ID 包含类型与两个操作数的类别。
- `src/emit_floating_tests.ts`：将目录数据展开为具名测试，生成代码只放 Zig cache。

## Edges：边界与限制

这不是原样执行 JavaScript 的 Test262 runner，不宣称 ECMAScript 兼容。equivalent/adapted/excluded 是语义审查结论，执行通过必须另有实际运行证据。上游未审查条目不会自动归为不适用。

f32 是 ZX 自有扩展；上游 Number 对应 f64。每个输入组合是单独具名案例，但仍属于少量行为族；数量不能代表覆盖面。多种优化模式重复运行同一 ID 不增加案例数。脚本由 Node.js 24.2+ 原生执行 TypeScript，不需要编译脚本或 Python；Zig 版本要求 0.16.0。

目前共 52,519 个登记案例：2,944 个前端案例、38,429 个普通执行案例、464 个隔离执行案例、10,446 个 RX 模块场景、236 个 Store 暂存与失败案例。另有 9 个真实 RX 文本入口 Zig 测试、15 个标准库资源 Zig 测试、1 个操作数调用轨迹 Zig 测试、6 个契约 Zig 测试、3 个验证器资源 Zig 测试、5 个硬件图与资源 Zig 测试、10 个原生声明 Zig 测试、11 个 RX CLI 场景和 20 个真实求解器 CLI 场景，不计入 JSONL 目录数。RX 模块测试通过公开 validateModules 校验合成 AST，不覆盖 XML 解析或 Runtime，不增加 Test262 上游审查数。完整模块交互、RX 标签、宿主、其他资源失败及生产运行保障仍需扩展。归档文件保存在外部缓存，不复制 53,597 份 JS 到测试目录凑数。

隔离执行器只接受明确结果或指定 panic 文本和专用退出码；超时、其他崩溃、参数解析失败均为失败。测试宿主安装 Zig panic hook 记录安全检查，不修改被测程序的运算。Zig 自带测试汇总不包含这 464 个子进程案例，不能只看该汇总推断全包数量。

## Answer：重现和验收

先在仓库根目录执行 `pnpm install` 安装工具依赖，然后在本包执行：

```sh
pnpm typecheck
zig build test --summary all
zig build test -Doptimize=ReleaseSafe --summary all
zig build test-frontend --summary all
zig build test-runtime --summary all
zig build test-module-graphs --summary all
zig build test-rx-text --summary all
zig build test-rx-cli --summary all
zig build test-stores --summary all
zig build test-standard-resources --summary all
zig build test-evaluation-order --summary all
zig build test-contracts --summary all
zig build test-verification --summary all
zig build test-verification-resources --summary all
zig build test-build-modes --summary all
zig build test-safety -Doptimize=ReleaseFast --summary all
node src/generate_division.ts --check
node src/audit_matrix.ts
```

根 `zig build test --summary all` 同时执行原有回归与本包。首次构建会将每个 `.zx` 交给实际 zxc 编译，再编译生成的 Zig，最后运行具名断言。

包内运行后，隔离执行报告位于 `zig-out/conformance/<优化模式>/<类型>.jsonl`；根调用时，报告位于 Zig 给依赖包分配的 `.zig-cache/i/<hash>/conformance/` 安装目录。报告包含逐案例 ID、通过状态、实际退出码及标准错误。普通前端案例统一编译为一个测试程序，保留全部具名测试，避免每个数据目录重复优化整个编译器。

从 `upstream/lock.json` 的 `archive_url` 下载文件后：

```sh
node src/index_upstream.ts /path/to/upstream.tar.gz --check
```

省略 `--check` 可重建索引。索引器核验归档 SHA-256，并排除文件名包含 `_FIXTURE` 的辅助文件。矩阵审计检查上游内容哈希、案例 ID 唯一性与关联是否存在；不替代人工语义审查或执行结果。

全量元数据事实可用于选择尚未审查的文件：

```sh
node src/query_upstream.ts --feature numeric-separator-literal --phase parse --prefix test/language/literals/numeric/ --limit 10
node src/query_upstream.ts --prefix test/language/expressions/ --limit 20
```

多个 `--feature` 要求同时包含这些标签。输出同时报告匹配总数和显示数，不自动作出适用性决定。查询与日常审计只需 Node.js 内置模块，并检查事实索引与完整源码索引一致。

归档索引和元数据重建使用系统 `tar`；仅元数据重建需要 `package.json` 固定的 `yaml` 2.9.1（由 pnpm 安装）：

```sh
node src/inventory_upstream.ts /path/to/upstream.tar.gz --check
```

省略 `--check` 重建；安全解析器拒绝重复键和错误字段形状，不执行 JavaScript。归档和每个文件均校验哈希，元数据缺失或异常不会静默丢弃文件。

规划与中断恢复见 [执行计划](../../docs/2026-10-03/Test262对齐执行计划.md)、[执行记录](../../docs/2026-10-03/Test262对齐执行记录.md)、[词法与短路阶段记录](../../docs/2026-10-03/Test262词法与短路对齐.md) 和 [集合与所有权阶段记录](../../docs/2026-10-03/Test262集合与所有权对齐.md)。

工具迁移的精度、数据一致性和回归记录见 [TypeScript 迁移](../../docs/2026-10-03/Test262脚本迁移TypeScript.md)。

## 形式验证求解器

完整测试现包含真实 `zxc verify` 场景，需要 Z3。默认从 PATH 查找 `z3`，也可通过 `ZXC_TEST_SOLVER=/absolute/path/to/z3` 指定。缺失求解器会失败，不会静默略过。本轮已校验并使用官方 Z3 5.1.0；工具版本、SHA-256 与验证范围见《形式验证求解器回归记录》。

`test-build-modes` 使用 compiler 包的正式安装步骤，在临时目录验证 app 执行与搬迁后的纯 ZX 库双端消费。该集成链路不计入 JSONL 数量，外部 native 依赖的搬迁能力另行验证。

历史动态插件测试保存在 `tests/plugins/`。当前静态链接改造已移除默认插件步骤及 `test-plugins` 入口；旧执行记录仅代表改造前结果，不计作当前支持能力。

硬件图与分配失败专项入口：`zig build test-hardware-resources`。该步骤不替代 RTL 仿真、综合或器件时序验证。

独立 RTL 行为入口：设置 `ZXC_TEST_YOSYS` 后运行 `zig build test-hardware-evaluation`；该外部工具专项不在默认根测试内，不会静默跳过。当前检查 144 个真实生成 RTL 的输入/输出与 fault 组合，以及 14 个时刻的时钟握手序列，不计入 JSONL 数量。

`test-build-modes` 同时验证原生 Zig 依赖和嵌入资源搬迁、删除原项目后的双语言执行、普通 b.dependency 的优化选项传递，以及资源越界拒绝。

原生声明回归纳入 `test-build-modes`：72 组对象数组、借用基准列表与可选枚举引用、原生错误无输出，以及生成库两组分配失败遍历；不计入 JSONL 数量。

原生声明分析专项：`zig build test-native-declarations`，十组 Zig 测试覆盖十二种声明拒绝、零/双参数和命名空间属性、接口配置冲突、非法名称、缺失成员及纯类型接口校验，以及成功/失败的分析分配清理；纳入默认 test，不计入 JSONL 数量。

静态库消费不再注入 `zx_runtime`，并检查无旧 runtime 目录。`test-build-modes` 另有 25 组真实零/多参数、allocator 和 nested.api 命名空间调用。

`zig build test-owned-collections` 验证按初始长度分组的 10,855 个数值集合案例及 428 个字符串消费案例。数值列表由输入标量构造，字符串列表由输入值编码的静态字面量构造。`zig build test-frontend -Dfrontend-filter=ownership/deep_copy` 单独验证 8 个 clone 拒绝案例；省略 filter 仍执行完整前端目录。当前根级回归 868/868 步骤、52,493/52,493 条 Zig 测试通过；该数与登记目录、独立进程及外部场景分别计数。

`zig build test-ownership-contracts` 检查函数返回拥有权、借用视图与伪造 IR 拒绝，三组 Zig 测试纳入默认 test；不计入 JSONL 数量。完整前端目前 2,944 条通过，完整运行目录目前 38,429 条通过，根级集成入口也已重新通过。

`zig build test-floating test-standard-runtime` 分别覆盖 19,534 个精确位模式案例与 3,714 个标准库调用案例。原生调用 suite 显式声明 `shared_abi`，生成程序与标准库共同导入 CLI 输出的类型模块；仍包含在默认 `test-runtime` 中，不重复计数。

Store 引用回归保留 236 条目录案例，宿主使用独立基准检查快照不变，并核对未更新列表继续共享存储；四个分配失败场景继续执行。完整运行目录 38,429 条已通过；根级回归也已通过，证据见执行记录阶段 60。

`zig build test-strings` 验证全部 1,712 条字符串案例。消费案例的 `input` 保存字面量下标，`value_input` 保存原始字符串值，原 ID 和预期保持；不将输入构造误计为新增案例。

整数隔离驱动已适配引用 Input：`zig build test-safety` 与 `zig build test-safety -Doptimize=ReleaseSafe` 各有 464/464 条逐案例报告通过，两种模式不重复计入语义案例总数。

`zig build test-querystring` 执行六个接口的 540 条具名案例；`test-standard-resources` 包含新增九个 querystring 逐分配失败与错误清理测试。原始 Unicode 与非法百分号混合时，ZX 保留原始 UTF-8 字符，具体 Node 差异见《查询字符串独立测试与资源验证》。
