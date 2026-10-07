# IR 与所有权 RX/ZX 全面审查

审查基线：`d3667ffe`。工作目录：`/Users/xiewendao/.codex/worktrees/semantic-type-table/zxc`。

本次只读源码与构建注册；仅按主审要求保存本文，不修改源码、不新增或运行测试。NativeType 后续实施继续暂停。

## IDEA

- **Intent（最终目标）**：确认现有 IR 与所有权实现是否真正由 RX 表达阶段编排、ZX 表达内聚算法与数据，并找出专用原生语义和状态残留。
- **Data（可用证据）**：`packages/compiler/src/zx/ir` 的 18 个 RX、108 个 ZX，`packages/compiler/src/zx/ownership` 的 4 个 RX、31 个 ZX；相关 Zig 入口、生成注册、类型查询、模块分类与命名检查的传递依赖。
- **Edges（边界与限制）**：静态架构审查，不等于行为回归通过。不能凭单 Call、文件短或 import 多判定违规；不能凭 RX/ZX 后缀宣称完整自举。本文不展开 NativeType 实施。
- **Answer（交付与成功标准）**：完整列出 22 个 RX 入口；逐级区分可上提阶段、必须保留的 ZX 算法、原生状态和宿主适配残留；提供整改依赖顺序。

## 判定原则

1. 已有独立输入、结果与短路边界的阶段组合由 RX 表达，即使各阶段都服务于同一个校验目标。
2. ZX 的集合遍历、递归替代状态机、动态规划与同一算法内的分支保留完整；不把每次循环迭代变成 RX 节点。
3. 整改必须下钻传递调用，不能只把顶层 validate 改成 RX，下一层仍保留同样的跨职责总控。
4. 同一个表的逐列长度、范围、引用检查可以在一个 ZX 规则内统一处理；不为每列建立独立文件或 RX Call。
5. 短 helper 有复用或共同表示不变量时保留，不以行数作为机械合并依据。
6. 自有规则和状态必须最终来自 RX/ZX；专用 Writer/Workspace 桥只能作为明确记录的过渡依赖。

主审确认：`body/references` 的表达式引用与控制引用检查无共享状态，应上提 RX；`native/exports` 的导出合法性、跨模块类型名冲突、历史函数兼容是三个独立遍历和短路阶段，也应上提 RX。算法内部循环仍保留 ZX。

## 全部 RX 入口覆盖

以下路径均以 `packages/compiler/src/zx/` 为前缀。ZX 目标指其 `export default function`。

| RX 入口                                     | 实际调用及传递依赖                                                                                                                                                                                       | 结论                                                                        |
| ------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------- |
| `ir/canonical/body_check.rx`                | `body/validate → stores/validate、body/symbols、expressions/validation/validate、control/validate、body/tree`；通过后 `body/references → references/expressions、references/control → optional/required` | 有真实门禁，但两层 ZX 总控需要继续上提，见下表                              |
| `ir/canonical/contract_tables_check.rx`     | `contracts/tables → offsets → 逐条 symbols、expressions/validation/validate`                                                                                                                             | 表头、契约位置、逐条内容三个阶段应显露；逐条算法保留 ZX，继续检查其叶子边界 |
| `ir/canonical/contracts_check.rx`           | `contracts/validate → tables → 带 has_ensures 状态的 predicate 循环 → allowed、expressions/rules/validate`                                                                                               | 结构门禁与语义遍历分到 RX；契约顺序状态和 predicate 扫描留 ZX               |
| `ir/canonical/expressions_check.rx`         | `expressions/rules/validate → access/atoms/calls/control/iteration/objects/operation/operators/parallel/scope/sequences/tasks/transform`；复用 typed/numeric/comparable/types.kind/stores.call           | 单个表达式规则分派合理，不应因单 Call 判为假编排                            |
| `ir/canonical/functions_check.rx`           | `functions/analyze → functions/calls`，按索引累计 allowed                                                                                                                                                | 拓扑函数图动态规划，单 Call 合理                                            |
| `ir/canonical/program_pure_check.rx`        | `functions/program → analyze(false) → calls(entry)`                                                                                                                                                      | Store 限制、函数事实分析、入口判定应由 RX 编排                              |
| `ir/canonical/task_call_check.rx`           | `functions/analyze(true) → functions/selected`                                                                                                                                                           | 已在 RX 表达分析与选取，合理                                                |
| `ir/canonical/tasks_check.rx`               | `tasks/validate → 输入输出 Task 限制 → references → consumption`                                                                                                                                         | 三个独立策略阶段应提升到 RX                                                 |
| `ir/canonical/scopes_check.rx`              | `scopes/prepare → terminates、analyze(false/true)`；`scopes/run → take、dispatch → block/branch/callback/declare/destructure/expression/selection/refinement.assume`                                     | prepare 是隐藏总控；run 是可保留的内聚事件遍历，但依赖专用原生状态          |
| `ir/canonical/refinement_assume.rx`         | `refinement/assume → compare → flow_state`                                                                                                                                                               | 内聚事实推导遍历合理，状态仍为专用原生                                      |
| `ir/canonical/refinement_bind.rx`           | `refinement/bind → flow_state.appendCapture`                                                                                                                                                             | 单一 capture 绑定规则合理，状态未迁移                                       |
| `ir/canonical/refinement_type_of.rx`        | `refinement/type_of → types.kind、flow_state.contains`                                                                                                                                                   | 单一细化类型查询合理，状态未迁移                                            |
| `ir/canonical/stores_check.rx`              | `stores/declarations → path、querying/execute → contains/row/types.row`                                                                                                                                  | Store 声明逐行约束内聚，循环保留 ZX                                         |
| `ir/canonical/store_call_check.rx`          | `stores/call → stores/validate → 槽位映射、去重、类型与权限检查`                                                                                                                                         | 同一次调用能力匹配；输入列安全检查与匹配循环内聚，无需为每个条件拆 RX       |
| `ir/canonical/native_modules_check.rx`      | `native/structure → declarations_check → bindings_check → owners → owner/key`                                                                                                                            | 合理 RX 编排样例，结构、声明、绑定、归属门禁可直接看见                      |
| `ir/canonical/native/declarations_check.rx` | `declarations/declarations → namespaces → imports_unique`；传递 specifier.check/text/key                                                                                                                 | 合理真实阶段编排                                                            |
| `ir/canonical/native/bindings_check.rx`     | `binding_values → bindings_unique → bindings_consistent`；传递 text/key                                                                                                                                  | 合理真实阶段编排                                                            |
| `ir/canonical/native_export_check.rx`       | `native/exports → export_name/key/text/errors/compatible`；errors → lint/naming/check                                                                                                                    | 按主审结论拆为导出合法性、类型名冲突、历史函数兼容三个 RX 阶段              |
| `ownership/check.rx`                        | `initialize.rx → runtime/execute`                                                                                                                                                                        | 准备与检查阶段显式，执行器内部需按 ZX 规则族整理                            |
| `ownership/initialize.rx`                   | `ir/prepare.rx → runtime/initialize`                                                                                                                                                                     | 派生事实和布局后初始化内存，合理                                            |
| `ownership/ir/prepare.rx`                   | `references → control/terminates → layout/roots → layout/project`                                                                                                                                        | 合理 RX 编排样例，事实和布局依赖明确                                        |
| `ownership/places/apply.rx`                 | `places/execute → combine`                                                                                                                                                                               | 同一次 place 状态传播的遍历与祖先合并，单 Call 合理                         |

## 二级调用与整改边界

### Body 与表结构

| 当前 ZX 位置                                                          | 源码证据                                                                  | 应显露的阶段                                            | 留在 ZX 的算法                                                |
| --------------------------------------------------------------------- | ------------------------------------------------------------------------- | ------------------------------------------------------- | ------------------------------------------------------------- |
| `ir/canonical/body/validate.zx:13–30`                                 | 顺序调用 stores、symbols、expressions、control，最后 tree，各自 bool 短路 | RX 依次表达这些结构门禁，必要时使用所属 RX 子模块       | 每一种结构的列校验和树算法                                    |
| `ir/canonical/body/references.zx:10–11`                               | 仅 `expressions(in) && control(in)`，两次调用无共享状态                   | 表达式引用检查 → 控制引用检查                           | 各自内部对所属引用列的统一检查                                |
| `ir/canonical/body/references/expressions.zx:10`                      | 对 some、captures、awaits、sequence 等列调用 required/optional            | 不为每个引用列生成 RX 步骤                              | 一个表达式表引用规则，保留逐列聚合                            |
| `ir/canonical/body/references/control.zx:10`                          | 对 evaluation、constant、branch、case、symbol 等列检查范围                | 不为每个控制列生成 RX 步骤                              | 一个控制表引用规则                                            |
| `ir/canonical/body/references/required.zx:7`、`optional.zx:7`         | 全列索引范围循环；optional 处理 null                                      | 无需提升                                                | 可复用范围算法                                                |
| `ir/canonical/body/symbols.zx:9–16`                                   | 列宽一致后调用 offsets                                                    | 可在 symbols 所属结构阶段中显露形状与位置门禁；不拆每列 | names/types/ownership/span 列宽作为统一规则，offsets 扫描保留 |
| `ir/canonical/expressions/validation/validate.zx:12–21`               | widths → ranges/payloads → offsets                                        | RX 子模块按安全依赖短路                                 | 每一规则中的列比较/扫描                                       |
| `ir/canonical/expressions/validation/widths.zx:7`                     | 比较 expression 及各 payload 列组长度                                     | 无需拆列                                                | 统一列形状规则                                                |
| `ir/canonical/expressions/validation/ranges.zx:9`                     | 同一 segments 算法检查所有 segment 列组                                   | 无需拆列                                                | 全表分段规则                                                  |
| `ir/canonical/expressions/validation/payloads.zx:11`                  | 单次逐行扫描，共享各 kind 计数器并检查终值                                | 不拆成每种表达式一个阶段                                | 同一 payload 完整性算法                                       |
| `ir/canonical/control/validate.zx:12–41`                              | widths → segments → payloads → 逐 blockValid 循环                         | RX 子模块表达形状、分段、payload、后序块关系            | 四个 segments 调用可归入统一 control 分段规则；逐块算法留 ZX  |
| `ir/canonical/control/widths.zx:7`、`segments.zx:7`、`payloads.zx:11` | 分别为统一列宽、连续范围覆盖、共享 kind 计数扫描                          | 不拆每列或每 kind                                       | 各自内聚规则                                                  |
| `ir/canonical/control/block_valid.zx:11`                              | 所属块内逐语句检查 branch/switch 子块早于父块                             | 外层遍历可形成一个 block-order ZX owner                 | 内层规则留 ZX                                                 |
| `ir/canonical/body/tree.zx:11–75`                                     | 初始化 owned/depths，再逐块传播深度和唯一归属，末尾 all-owned             | 不将初始化、边访问和末尾断言拆成 RX 算法步骤            | 单一树合法性算法                                              |

必须保留结构前置条件：宽度检查先于成对索引，分段与 payload 检查先于对应内容访问，block order 先于 tree 深度传播。不能为了把 Call 排进 RX 而改变失败短路顺序。

### Contracts

- `contracts/validate.zx:12–24` 先调用 tables，再执行 has_ensures 与 predicate 循环。结构表检查和语义遍历应成为 RX 两个阶段。
- `contracts/tables.zx:15–27` 还包含第二层总控：表头列形状、契约 span 范围、逐条 predicate 数据的 symbols 与 expressions 结构。不能只移动外层 tables 调用便算完成。
- 建议将表头形状、契约位置、所有 predicate 符号结构、所有 predicate 表达式结构作为 RX 门禁；后两项各自用 ZX 遍历集合，或复用能够表达集合调度的普通能力。不要让 RX 属性出现循环或函数调用。
- `contracts/predicate.zx:23–46` 的参数约定、结果 bool 类型、允许表达式种类和逐表达式类型规则属于同一 predicate 语义。循环中 allowed 与 expression 共同定义一行是否成立，可留 ZX。
- `contracts/allowed.zx` 是可理解的表达式种类白名单，不需要将每个被拒绝种类拆文件。

### Functions、Tasks 与 Scopes

- `functions/program.zx:13–19` 的入口 Store 限制、`analyze(false)`、`calls(entry)` 应上提 RX。
- `functions/analyze.zx:12–23` 每轮使用已经求出的 allowed 前缀，`calls.zx:12–30` 检查函数体调用与副作用，构成拓扑动态规划，保持 ZX。
- `tasks/validate.zx:14–19` 的接口限制、references、consumption 应上提 RX。
- `tasks/references.zx:15–43` 逐 task/capture 检查 native reference；`consumption.zx:16–79` 累计 task 使用并检查恰好一次。两个算法各留 ZX。
- `scopes/prepare.zx:10–15` 求 terminates、条件求 pure 和 concurrent 后仅组装 Prepared。三个独立结果应在 RX 显式计算；条件也放 RX。
- `scopes/run.zx:31–38` 取事件并 dispatch，末尾检查声明与返回性质。该遍历与其完成条件构成一个 scope 分析过程，不改成 RX 事件解释器。
- `scopes/dispatch.zx` 根据 Phase 调用 block/branch/callback/declare/destructure/expression/selection，并处理恢复和 assume。它是单步状态转移分派，不是多个编译阶段总控。
- `scopes/expression.zx` 处理访问与调用上下文，调度 iteration/transform，并按表达式种类转至 children/choice/match/scope/task_body。各 handler 服务同一遍历，保留 ZX。
- block/statement/branch、callback、task_body、selection/switch_valid/same、choice、match、scope、children/sequence、declare/destructure、returns/clear 已按语义分组；首要问题是原生状态桥及裸 a/b/c/flags 协议，而不是文件数量。

### Native export

主审按严格模块职责确认以下三个阶段应由 RX 表达：

1. `native/exports.zx:16–31`：取得 module/owner/export name 并检查 text、fallible/errors。
2. `native/exports.zx:33–58`：遍历同 owner 模块的 type_names，检查导出与类型名冲突。
3. `native/exports.zx:60–77`：遍历历史函数，对同 owner/name 的声明调用 compatible。

同一导出项是这三个阶段的共同上下文，不是必须藏在一个 ZX 函数中的理由。冲突扫描与兼容扫描各自循环仍保留 ZX；key/export_name/text/errors/compatible 保持清晰的规则职责。

### Ownership

`ownership/check.rx → initialize.rx → ir/prepare.rx` 已真实表达引用事实、终止事实、根布局、投影布局、内存初始化和检查之间的依赖。

`runtime/execute.zx` 742 行是目前最明显的职责膨胀点。其单一工作栈循环共享 memory/snapshots/work/value/values，处理语句、分支、Iteration/Transform、Switch/Match、调用逃逸、对象缓存、Scope、Task capture、Value 分派。这是内聚所有权分析机，不能仅因长而要求 RX 接管循环。

应按语义规则族拆 ZX handler，保留小的 worklist/dispatch owner：语句、分支、集合与回调、对象、任务、调用。不得按每个 WorkAction 拆一个文件。具体规则族先在设计中确定输入输出与共同状态，避免生成大量传参包装。

- `layout/roots.zx` 的 Heads/Symbols/Expressions/Evaluation 是同一根布局构造；`layout/project.zx` 的路径、Ensure、Grow/Clear/Rehash 服务同一投影索引构造，可以留 ZX。
- `places/execute.zx` 的 Enter/Leave/Parents/Advance 是一次状态传播的遍历；`places/find.zx` 的上溯与下降是一次投影定位，可以留 ZX。
- `runtime/borrowing/execute.zx` 的查询、投影下降、表达式边展开、place 状态传播围绕一次 borrowing 闭包计算。可复核与 places/find/execute 的重复规则，但不因阶段枚举便拆 RX。
- `runtime/initialize.zx` 分配 states/memo 并给输入 place 初值，是一个状态初始化职责。
- `runtime/snapshots` 的 save/apply/update/drop 各自维护快照表示不变量；`runtime/work` 的 push/pop/top 共同维护四列栈，不是无意义短转发。

## 专用原生依赖与正式入口残留

RX/ZX 直接及已检查传递闭包中的原生能力为 `zig:integers`、`zig:floats`、`zig:flow_state`。

### FlowState 尚未自举

调用链：

`scopes/refinement ZX → analysis/semantic/native/flow_state.zig → analysis/semantic/flow/workspace.zig → packages/core/src/refinement.zig`。

- `flow_state.zig:1–7` 使用 `Writer=*const anyopaque`，强制转换回专用 Workspace。
- `workspace.zig:7–14` 持有 facts、active、declared、owners、history、events 和 current。
- `workspace.zig:39` 的 setActive 记录历史；restoreActive 用 Zig 循环回退历史。它们是编译器自有状态算法。
- `flow_state.zig` 的 restoreFacts/contains 调用 core Refinement 的 restore/contains；后者仍以 Zig 操作 nonnull/captures。
- `scopes/schedule.zx:13–32` 与 `take.zx:13–34` 重复维护 Phase 到数字 0..15 的编码。这是桥造成的双份协议，应随类型化 ZX Frame/栈迁移一起撤除。

因此 scopes/refinement 只能标记为“规则逻辑已迁移，状态与部分操作仍有过渡依赖”，不能标记完整自举。迁移目标是 ZX 状态与纯显式转换；先复用普通语言集合能力，不新增同职责专用 native 接口作为最终解法。

### 通用能力与宿主适配要分别记录

- `analysis/semantic/native/integers.zig` 仅 widen/narrow；`floats.zig` 仅 widen/narrow/isFinite。属于通用数值转换能力，不与 flow_state 专用状态等同；其标准库契约仍需正式记录。
- ownership RX/ZX 闭包没有专用原生状态回调，但 `ownership/input.zig:12` 仍做 IR 借用适配，`ownership/generated.zig:11` 仍处理错误、诊断及结果映射，完整职责边界尚未全部迁移。
- `ir/validate.zig:5` 仍是正式 IR 总门禁，负责结构、native、逐函数及表达式检查、scopes/tasks/ownership 和 error contracts 的编排。18 个 IR RX 是局部模块，不能代表总门禁已经 RX 化。
- `ir/native_modules.zig` 仍将 validateType 指向手写 `native_type.zig`。本轮仅登记，遵守暂停 NativeType 实施要求。
- 原有 seed 分支只可作为引导；不能将正式路径里专用 Zig 规则因名为 seed 或 adapter 而忽略。
- native/errors 的 lint 依赖经 `build/generate_parser.zig` 收集到虚拟 `lint/naming/` 路径，实际源码为 `packages/lint/src/naming/check.zx`，不能误判为缺失源码或 native fallback。

## 合理模块与机械碎片判断

无需为形式重写的内聚算法包括：`body/tree`、`control/terminates`、`functions/analyze`、`tasks/consumption`、`expressions/rules/validate` 的语义分派、ownership 布局/定位/传播/borrowing，以及 scopes 事件遍历。

短文件有明确边界和复用的包括 typed/numeric/comparable、segments/offsets、required/optional、key/export_name、hash/lookup/projection、places/combine、work push/pop/top。保留它们比复制规则到调用方更清晰。

低优先级可整理项是 `ownership/ir/widen_optional.zx` 的通用转换落点和 `layout/empty_slot.zx` 的短局部 helper；不足以单独发起重构。scopes schedule/take 则不是普通文件洁癖问题，而是专用原生协议应被撤除。

## 整改依赖顺序

1. 固定本报告的职责与前置条件，列出每个 RX 阶段输入、输出、失败短路；先更新方案，不直接改正式源码。
2. 清理不涉及状态表示的编排：scopes prepare、functions program、tasks、contracts、native exports；递归清理 body 与表结构二级总控，避免改一层留一层。
3. 设计 ZX FlowState/Frame/facts/capture/history，确认普通语言表达与集合能力，复用 ownership 显式状态方式。
4. 按状态操作和调用者闭包迁移 scopes/refinement，撤除 flow_state/Workspace/Core Refinement 的正式传递依赖及数字编码桥。
5. 整理 ownership runtime 的 ZX 规则族，保持 worklist 算法在 ZX；不要与 scopes 状态迁移并成一次大范围改动。
6. 迁移正式 IR 总编排、输入桥和诊断映射边界；在用户对齐方案后再恢复后续 NativeType 工作。
7. 在获授权实施后进行相应验证；最终验收同时检查依赖闭包和 stage 1→2→3，不以共同调用同一 Zig 核心的产物一致代替自举。

## 自我批判与复核限制

初审曾将 body/references 和 native/exports 视为同一目标的内聚检查；主审进一步依据独立输入遍历与短路边界确认其应上提 RX，本文已采纳这一更严格判断。判据必须贯彻到 contracts/tables 等二级总控，不能只重命名入口。

相反，表列规则、循环共享状态和语义分派也不能机械拆散。本文保留这些边界，不以单 Call 判假编排、不以行数判文件违规。

本次未执行测试，未证明行为等价、性能或所有 malformed IR 的安全性。后续实施必须保持 widths/ranges 等先决检查、短路次序和状态语义，并实际验证；这些内容不能由本次静态审查替代。

## 补充：所有权执行器的 300 行约束实施方案

用户新增硬要求：每个 ZX 的实际总行数（含空行）最多 300，且文件与函数仍需单一职责。以下行号以尚未拆分的 742 行 `ownership/runtime/execute.zx` 为基准。本节仅为实施方案，没有修改正式源码或运行测试。

### 最小语义分组

保持 `runtime/execute.zx` 为工作栈算法 owner，在同名 `runtime/execute/` 目录存放模型和 handler。不要增加原生桥，不创建动态 handler 表。分派使用静态 enum match。

| 建议 ZX                  | 原始行范围                | WorkAction 归属                                                                                                                            | 预计含导入与空行 |
| ------------------------ | ------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ | ---------------- |
| `execute.zx`             | 33–51、733–742            | 初始化、工作栈空判断、top/pop、调用静态分派、产出 Outcome                                                                                  | 约 60–100        |
| `execute/step.zx`        | 原各分支入口              | 只把 WorkAction 静态分派到所属 handler；未知动作保留 complete=false                                                                        | 约 110–160       |
| `execute/model.zx`       | 原第 42 行状态结构        | Machine 与 Step 类型；复用既有 Program/Built/Memory/Stack/Work/Frame/State                                                                 | 约 35–60         |
| `execute/statements.zx`  | 52–129                    | Block、Release、Statement、Constant、Result、Store、Destructure                                                                            | 约 110–150       |
| `execute/values.zx`      | 157–198                   | Finish、Copy、Borrowed、Borrow、Aggregate、Sequence、SequenceResult、IndexTarget、IndexResult                                              | 约 70–110        |
| `execute/callbacks.zx`   | 199–315                   | IterationInitial/Condition/Body/Finish、TransformTarget/Initial/Parameter/Body/Finish                                                      | 约 150–190       |
| `execute/branches.zx`    | 130–156、316–383、577–615 | BranchCondition/Yes/No、SwitchSubject/Case/Result、MatchSubject/Arm/Condition/Result/Finish、BinaryLeft/Right、ConditionalCondition/Yes/No | 约 175–220       |
| `execute/calls.zx`       | 384–401、554–576          | Invocation、InvocationResult、CallResult                                                                                                   | 约 75–110        |
| `execute/collections.zx` | 402–442、542–553          | CollectionTarget/Argument/Result/Freeze、UpdateResult                                                                                      | 约 90–125        |
| `execute/objects.zx`     | 443–477                   | ObjectEvaluation/Cached/Field/FieldResult/Finish                                                                                           | 约 65–100        |
| `execute/scope.zx`       | 478–506                   | ScopeBinding、ScopeResult、ScopeFinish                                                                                                     | 约 60–90         |
| `execute/tasks.zx`       | 507–541                   | TaskCapture、TaskFinish、ParallelBranch                                                                                                    | 约 65–100        |
| `execute/expression.zx`  | 616–732                   | Value：定位 place、访问规则、按表达式类型安排 continuation                                                                                 | 约 155–200       |

分组理由：callbacks 共享输入状态保存、回调参数、结果借用与恢复语义；branches 共享分支快照和路径合并语义；其余按语言实体及状态转移规则收口。不是机械按相邻行分段。每个文件有明显余量，不应靠去空行满足上限。预测行数不是实际验收，实施后须统计。

### Machine 与已有契约

建议第一步保持原循环状态字段平铺，不为此次拆分再重构上下文表示，以降低 state-value 布局变化风险：

```typescript
export type Machine = {
    program: Program
    references: bool[]
    returns: bool[]
    layout: Built

    memory: Memory
    snapshots: Stack
    work: Work

    value: State
    values: State[]
    returned: State
    stores_owned: bool

    failed: bool
    complete: bool
    expression: u64
    active: bool
}

export type Step = { machine: Machine; frame: Frame }
```

`Program` 来自 `ownership/ir/input_model.zx`；`Built` 来自 `layout/model.zx`；`Memory` 来自 `runtime/model.zx`；`Stack` 来自 `runtime/snapshots/model.zx`；`Work/Frame` 来自 `runtime/work/model.zx`；`State` 来自 `places/model.zx`。

只读字段为 program/references/returns/layout。所有 handler 返回更新后的 Machine；不能修改不可变 in。ZX 的可变更新保留在合法 loop 状态块内，或用纯值表达式构造返回。若用一次迭代 loop 保留现有更新语法，必须使用独立单步哨兵，不能借用 Machine.active 作为哨兵而破坏外层循环状态；该包装必须经过生成代码分配检查。

### handler 状态访问清单

所有 handler 读取 frame.action；subject 是表达式、payload 或 place 索引，必须保持原动作下的意义，不能统一当表达式 ID。frame.index 常为循环位置或 snapshot frame，不能重新编号。

| handler     | 写入 Machine 字段                                                    | 额外读取                          | frame 字段                   |
| ----------- | -------------------------------------------------------------------- | --------------------------------- | ---------------------------- |
| statements  | work、memory、returned、stores_owned、complete                       | program、layout、snapshots、value | subject/index；不需要 moving |
| values      | memory、work、value、values                                          | program、references、layout       | subject/index/moving         |
| callbacks   | memory、snapshots、work、value、values                               | program、references、layout       | subject/index/moving         |
| branches    | memory、snapshots、work、value、values                               | program、returns                  | subject/index/moving         |
| calls       | memory、snapshots、work、value                                       | program、references、layout       | subject/index；不需要 moving |
| collections | memory、work、value、values                                          | program、references、layout       | subject/index；不需要 moving |
| objects     | memory、snapshots、work、value、values                               | program、layout                   | subject/index/moving         |
| scope       | memory、snapshots、work、value                                       | program、references、layout       | subject/index/moving         |
| tasks       | memory、snapshots、work、value、failed、expression                   | program、layout                   | subject/index；不需要 moving |
| expression  | memory、snapshots、work、value、values、failed、expression、complete | program、references、layout       | subject/moving；不需要 index |

只有外层 owner 写 active，并在读取 top 后立刻 pop。step 的未知动作写 complete=false。上述写集合按赋值语义复核；例如 statements 的 Result 只读取 value、写 returned，不应因比较运算被当作写 value。

### 零复制与分配边界

1. Machine 是静态类型的数据契约，不是新建的堆对象身份；保持数组/IR 表的现有描述符引用，不复制数组内容，不以 map/concat 构造 handler 参数。
2. 每个 WorkAction 只进入一个 handler，返回后直接替换当前状态；不同时保留旧 Machine 与新 Machine，不为了“不可变”保存整个工作栈历史。
3. 原算法已有的 push/pop、save/apply/drop、借用传播与必要快照保留原顺序；新增分配不得以这些既有操作为掩护。
4. `packages/genz/src/zx/value_call/root.zig:55–80` 存在 state/legacy 调用模式及转换。仅看到 ZX 返回 Machine 不能证明不会堆物化聚合。必须检查生成 Zig 的 handler 参数、返回值和每步调用走静态 value/state 表示，没有新增 aggregate arena allocation、数组 dupe 或整表 clone。
5. 若拆分触发 state 类型不闭合而退回 pointer/legacy 路径，应先调整普通状态值调用能力或表达形状；不得新增专用 native Machine 桥。不能承诺 LLVM 一定消除分配。
6. 本次只读分析没有生成编译产物，因此零新增堆分配是实施验收条件，不是已经验证的结论。

### 最小执行顺序

先定义平铺 Machine/Step；按表提取 handler 并保持原分支正文和 push 顺序；将外层 loop 缩为 pop→step→接回状态；检查所有 WorkAction 恰好覆盖一次、default complete=false 保留；统计所有 ZX 实际行数；最后对照生成 Zig 的聚合和数组传递方式。检查过程中不要新增测试用例，测试执行遵循用户授权。
