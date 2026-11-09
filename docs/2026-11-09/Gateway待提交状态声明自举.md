# Gateway 待提交状态声明自举

## Intent：最终目标

把 Gateway storage.render 的初始模块导入及 zx_pending 类型构造完整迁入 RX/ZX，
保持 Store 顺序、可空字段、null 默认值、导出性和结构化 AST 输出。

## Data：可用证据

起点 a064427b，工作区干净。上游已有 initial_imports 数组，直接借用，不从
Object[] 再复制名称列。复用 Context、Fields、Constant、optional_type 和 header。

```mermaid
flowchart LR
    Init[初始化AST] --> Items[按Store顺序构造导入及可空字段]
    Items --> Structure[构造zx_pending类型]
    Structure --> Publish[发布AST及常量行]
```

```mermaid
flowchart LR
    Backend[已有initial_imports] --> Borrow[借用模块名数组]
    Borrow --> Source[RX及ZX]
    Source --> AST[共用结构化AST]
    AST --> Native[通用借用发布]
    Native --> Printer[统一printer]
```

## Edges：边界与限制

原生仅保留arena、参数借用、通用AST发布和printer；初始seed保留原逻辑。
不改变Store存储生命周期，不新增运行库，不生成Zig源码片段。名称来自所属
const或现有命名原子，不重复声明语义常量。

## Answer：交付与成功标准

正式storage路径消费Source。既有Gateway/Store行为、空及多Store生成物、seed、
阶段自编译和受影响成本均需验收。复用已有证据，不为格式调整重复计时。
历史固定P2冷构建基线不变；验收后收口全部文件提交推送。

## 当前实现与验收

Source入口storage/build.rx顺序初始化、按模块构造imports/字段、构造zx_pending。
Native storage.render保留arena、借用参数、通用AST导入和printer。backend只传
既有initial_imports，seed同步改为模块名切片，无额外名称列投影。

首版正式冷构建43/43步通过：time墙钟129.61s、CPU194.42s、单体峰2145189888 B，
0.2s树峰2162049024 B。阶段前129.01s、193.89s、2127560704/2143256576 B。
历史固定P2基线仍129.74s、216.03s、2075033600/2247294976 B，不重设。
首版host三对中位CPU34.33/34.37s、墙钟32.37/32.46s、RSS2408038400/
2416361472 B；逐对CPU0/+0.04/+0.01s、墙钟+0.12/+0.09/−0.01s。
成本差异保留，尚不声称整体无退化。

首版及当前字段行版均通过Gateway86项和JSON Gateway52项。空Store和多Store
的gateway_storage_contract分别保持字节SHA：

- 90e9bde8209bc200dac4fb8eabb6cb8c62667ddf66c333f0e30a71570bf1f69e
- a6d2b950bd9bcce826c5612242fdcfd5c6fcd8141f0676f7a3bd1c10c0396c6d

字段行候选正式P2构建43/43步、两代工具21/21步通过且SHA相同：
dc34b5db61cecba8d6a3c4040f5e2ff037679b38e86b7460d9f65c913d7520d0。
seed Gateway及storage独立编译/运行通过。Source格式/lint通过，未新增仓库用例。
字段行候选单次host为CPU33.92s、墙钟32.02s、RSS2428518400 B；这是探针，
不能据它声称内存改善或代替最终完整构建。

证据根目录为.zig-cache/cold-build-analysis/ownership-research/gateway-storage。
output-comparison保留前后既有fixture生成，host-pairs保存冻结控制和配对rsp。
全部测试及测量均已终止，无须重启原句柄；当时工作区未提交；最终方案与收口见文末。

## 已定位的表示约束

首版Fields四列的push均使用zxReserve(raw_slice,...,true)，该增长器通过自有
ZxHeader.capacity/committed续长；它并不是managed storage被重置成plain的路径。
Constants及optional_type的items/storage跨循环保留。不得把renewal=true单独
说成零分配或每次原地增长。

为对齐原生Field[]，已增加共用ast/fields/model.Field，并用members:Field[]
累计；Native import_fields新增通用按行借用接口，旧列入口保持原校验。
新行版语义、range、借用均通过，但实际生成揭示members为指针数组，每Field
有create，而非flat行；指针数组增长及storage续用保留。相比首版的Fields
描述符装箱，这是表示变化，不是已经证明“取消装箱”。

根因有可复核的完整路径：新Field与既有types/definitions/model.Field结构
相同，复用结构化TypeId，records eligibility本身为true；正式入口
state_conversion_emit的walk→borrowed→record调用中，record.zx执行
in.fields.concat(fields)[0]。state/shared.zx对record Object的非Push集合
操作加入共享roots，roots/closure将这个TypeId全局boxed。其他Field concat
也存在，因此不能只改一处消费者便宣称根因已解决。Constant的fresh push
不触发同一根，这解释两者不同，不需要改字段名或业务特判。

这是全局、按类型的共享身份表示约束。该候选没有逐值来源/使用边界的布局
证据，不能直接删除共享根、破坏对象身份、借用或Native ABI。comparisons、
captures、public/native boundaries的独立根也必须保留，不把boxed当语法错误。

## 下一步与自我复核

当时功能完整，但成本及表示验收尚未收口，未提前提交。
下一步先核对共享身份规则与布局能力的边界：应优先复用现有能力；若必须补
通用能力，应保留最小可复核需求，独立验收再消费，不靠改字段名、换等价
结构绕开全局分类。保留迁移，不能因成本问题撤回Source实现。

自我复核：首版源码容易让人误以为Fields丢失增长信息，实际生成已反证；
Field[]也不能套用Constant[]的flat结论。当前报告只确认可运行行为、续用及
全局boxing原因，不把布局简洁、编译通过或单次CPU下降当作零成本证明。
不要重复相同完整冷构建，继续使用已有控制和实际生成体确定下一处改动。

## 最终方案：直接列状态

继续核对后，当前职责不需要放宽全局共享规则，也不需要新增语言特性。
Source内部直接保存field_names/field_values/field_defaults/field_comptime四个
managed列，item逐列追加；只在structure发布时构造一次共用Fields视图。
共享/身份规则保持不变；未采用的Field行类型和Native按行字段导入已移除，
对应两个公共文件恢复HEAD，不留未消费API。Source storage迁移完整保留。

实际生成体：item的四个reserve均renewal=true，items写回各列items/storage；
没有逐Field或逐Fields create。仍存在Expressions和Context描述符装箱，不能
宣称零分配。optional_type、Constant续用不变；field range/default/comptime和
空输入语义均经审查保持。使用既有AST列格式并不复制模块名字节。

最终columns/bin/zxc通过Gateway86项及JSON Gateway52项；同一既有空/多Store
fixture再次无缓存生成，两个契约SHA均与阶段前相同。Source格式和lint通过。
columns-tool和columns-confirm均21/21步通过且SHA一致：
fcdb42b277ccb6fca2bbe17759e96f769e548391d5b508fdfabb5586c74e5a53。

单次columns-host-probe为CPU33.97s、墙钟32.05s、RSS2398339072 B，相对三对
阶段前host控制中位34.33/32.37s/2408038400 B均略降。该单次探针不能替代
正式成本验收，也不把字段数量减少或取消一类装箱直接当峰值收益。

最终完整冷构建cold-gateway-storage-columns已启动；这是实际状态表示变化后
的收口检查，不重复首版同源码计时。配置、固定历史基线、缓存边界保持不变，
运行期间不改被编译源码、不并行其他构建。最终结果及收口判断如下。

自我复核：曾把源码Field[]误认为与Constant[]同样flat，实际生成已否定；
没有通过改字段名、加特殊type绕开。最终使用现有能力的更小改动避免不必要
对象构造，不能据此宣称全局按类型共享表示已经优化；该通用问题仍可独立研究。

## 最终成本与收口判断

最终columns版本完整P2冷构建43/43步通过：time墙钟130.19s、累计CPU196.10s、
单体峰2138439680 B；0.2s树峰2157314048 B。采样器墙钟130.389s、单体采样峰
2137063424 B，不能混同time数据。

相对阶段前单轮129.01/193.89s：墙钟+1.18s、CPU+2.21s，单体+10878976 B、
树峰+14057472 B；这些总量差异保留，不用局部探针抹去。相对历史固定基线
129.74/216.03s：墙钟+0.45s、CPU−19.93s、单体+63406080 B、树峰−89980928 B，
历史单体差额仍需跟踪，不能说全局内存优化完成。

直接四列版本的三次独立host探针，均新local/global缓存：

- CPU33.97/33.76/33.98s，中位33.97s。
- 墙钟32.05/31.92/32.05s，中位32.05s。
- RSS2398339072/2409594880/2417065984 B，中位2409594880 B。

阶段前反序配对控制中位34.33/32.37s/2408038400 B；最终CPU−0.36s、墙钟
−0.32s、RSS+1556480 B（约0.065%）。不是同一时间交替的最终三对实验，
不把这些中位数冒充严格逐对收益；但全部候选CPU/耗时低于已有控制范围上界，
局部峰值增量处于同一控制已经观察到的波动量级，未重现首版的耗时增幅。

结合真实表示取消不必要Field/Fields装箱、增长资格保留、字节一致和86+52项
回归、两代SHA一致，本阶段完整功能可以收口。结论限定为受影响路径未观察到
稳定退化；不能据此宣称完整冷构建总量已经证明零差异。后续继续使用固定基线
监控累计增长，不重新领取0.1s容差，不删除CPU和历史单体剩余差额。

最终只保留模块名借用、通用AST列/Constant行发布和独立seed，没有新增共享
身份例外或专用运行库。文档按IDEA保留目标、证据、边界和成功标准；英文提交
收口全部工作区改动并推送。完整Gateway装配及其他原生自有职责仍待迁移，
不把本阶段当作完整自举完成。
