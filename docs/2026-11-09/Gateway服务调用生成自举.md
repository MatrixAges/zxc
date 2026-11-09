# Gateway 服务调用生成自举

## Intent：最终目标

将 gateway/invoke.lower 的完整请求读取、输入解析、上下文连接、服务调用、错误响应、
JSON输出校验及序列化职责迁入RX/ZX。RX显示真实阶段依赖，ZX只承担原子构造。
本阶段不是整个Gateway或编译器自举完成。

## Data：可用证据

原实现为 packages/genz/src/gateway/invoke.zig。正式上阶段为07a85292，生成器稳定
工具为ownership-research/gateway-adapter/ordered-confirm/bin/zxc-bootstrap。
现有ast/context、statements/builder及host/json_output/check可直接复用。

成本模型：输入只借用TypeTable和基址，另传服务编号、slot数量及io/process布尔标记；
不需要复制Service、Slot数组或Route记录。输出由同一Builder allocator生成并借用发布。
生成物是普通Zig函数，不新增运行库、解释层或原生语义回调。

## Edges：边界与限制

- 参数严格为scope/io/process/request；execute参数顺序为arena指针、input、可选context、
  可选io和process。不用的参数保留discard。
- body缺失时直接return；void Input检查非空body，其他类型解析JSON并只向上传播OOM。
- execute向上传播OOM/Canceled，其余错误记录日志并返回500；有限性校验先于序列化。
- response调用自身不加try，保留直接return错误联合；readBody和Stringify显式try。
- JSON检查共用Context、StatementsBuilder及for列，保留空Scope、失败子块、sequence顺序。
  不调用会重新初始化基址的JSON prepare/publish。
- 使用已close的绝对first/count构造block，不混用context/block的独立statement表。
- parameters/response仍被未迁移的entry.dispatch使用，作为明确过渡职责保留；正式invoke
  不回调它们。旧lower仅作为seed路径保留。
- 不新增测试。验收既有Gateway/JSON Gateway、模块生成及相关求值/分配行为。先贯通，
  再集中验收；性能按受影响路径及固定累计基线，不重做无关或已有效的检查。

## Answer：交付与成功标准

```mermaid
flowchart LR
    Input[借用类型表与服务标记] --> Symbols[符号与类型准备]
    Symbols --> Read[读取与解析输入]
    Read --> Context[上下文和调用参数]
    Context --> Execute[调用服务及错误处理]
    Execute --> Json[复用JSON有限性检查]
    Json --> Encode[序列化与响应]
    Encode --> Publish[函数声明及AST发布]
```

```mermaid
flowchart LR
    Native[Native基址及只读类型视图] --> RX[RX阶段编排]
    RX --> ZX[原子AST构造]
    ZX --> Shared[共用Context及statement表]
    Shared --> Rows[完整声明与语句列]
    Rows --> Import[通用借用发布]
    Import --> Printer[统一Zig printer]
```

成功要求正式lower完整消费Source产物，既有行为、语义顺序、产物与memo符合预期；
阶段自编译稳定，相关执行成本及冷编译累计门禁通过。完成后核对所有未提交内容，
统一英文提交推送并确认干净。Source文件建议180行、硬上限240行，按语义职责拆分。

## 执行记录

完整Source调用链已实现，首代引导21/21步通过。源文件按input、execution、response
职责分组，根目录保留模型、共用AST原子操作及最终发布；26个RX/ZX文件均格式和
lint通过，另有通用StatementsBuilder的break_value原语。

输出复用已有printer/model/statements.Statements完整类型，避免重复声明statement
字段；import_module在没有独立variables字段时直接发布完整列，既有分离列契约不变。
该扩展是通用AST发布能力，没有新增Gateway语义桥。Source只共用一个Context和
StatementsBuilder；JSON直接复用check，failure与validation均保留原Scope边界。

Native正式lower只提供只读类型视图、基址及标量标记，调用Source并通用发布根声明。
独立源码复核未发现body早退、raw response/catch、scope索引或输出栈借用阻断；
实际ABI、全部生成物、行为与成本仍需验证。首代引导不证明完整阶段已通过。

首次端到端检查定位到ABI接入缺口：完整Statements以view_value按值返回，旧发布器
对statements直接取Child，编译失败。沿用上一阶段已存在的Descriptor投影，允许
同一声明布局的指针或按值视图，仍由columns.view验证并借用列；不复制payload，
不改拥有模式。失败轮日志保留regressions.log，修正版使用regressions-view.log。
Source及生成流程没有因该接入问题回退。

ABI修正版相关回归62/62步、71/71项受管检查通过，JSON Gateway52项观察通过。
现有Gateway宿主覆盖与模块缓存/所有权检查均保留，没有新增测试。修正版后续
bootstrap-stage21/21步通过，工具SHA与上一代相同：
f628be093937d57d8b0ed92a036fb206128f424ea30ec972d0d42c4c6ad4ee02。
引导工具中不可达的Native Gateway发布代码不因该SHA相等便视为已验证；实际
Gateway执行及正在编译的生成物对照独立覆盖正式lower路径。

现已冻结只将invoke.lower切向seed的忽略副本，其他生成逻辑使用当前实现；
准备沿用已有8种JSON fixture与3种slot组合，并覆盖io/process四种标记组合。
该探针只用于96份完整生成物比较及重复render计量，不生成新应用用例，也不
以压力循环冒充普通端到端编译时间。正式源码未加入该控制开关。

96份完整Gateway源码逐字节一致。独立压力循环六轮交替、排除首轮，每轮100次
重复×96种组合，共9600次完整render：控制CPU/墙钟中位数1.09/1.10 s，Source
1.23/1.24 s，差值0.14/0.14 s，平均每次约15微秒。RSS为6471680→6733824 B。
压力循环不是普通编译门禁，也不因每次很小便忽略累计增长。

第一对普通冷CLI使用相同当前响应文件、工具链及ReleaseSmall，每侧新local/global
缓存，保留OS缓存，无其他构建、无IR导出或采样。Native控制仅切换invoke到seed。
控制CPU/墙钟/RSS为83.53 s/81.74 s/4117757952 B，Source为
84.51 s/82.71 s/4145594368 B；+0.98/+0.97 s及+27836416 B未通过。
该单CLI场景不与历史根构建峰值相减。当前不提交，不回退迁移；正在同输入下
导出完整IR以定位新增成本，不重复该失败版本普通计时。所有探针及日志位于
ownership-research/gateway-invoke忽略目录，生产源码没有控制开关。

### 重复持有状态的迁移错误

完整IR控制/Source函数体合计188483262→189407006 B，定义34004→34375；
memcpy静态数量247611→248711，至少512 B的19552→19996。新增invoke Source
约603 KB，import_rows.appendRows仅增加约65 KB；不能再只猜通用导入包装。

复核到Validation同时持有state、scope.state和visit.state中的同一StatementsBuilder
与Context。现有state/traverse对输出中重复Object/Tuple进行boxed判定，来源明确；
生成execute中result/branch的raw State返回后又allocator.create装入父对象。此处
是新迁移的交接数据表示冗余，不等于应放松通用别名规则。

已改为Validation仅持有一份State及恢复作用域所需parent_tags/parent_offsets。
JSON Visit由RX按当前单一State引用组装，validated恢复parent索引并接入checker结果，
不再把Scope的完整State或Visit一同长期返回。算法、分支、错误与AST顺序不变；
未改编译器duplicates guard或active借用路由。正在引导compact版本，尚无新成本结论。

另纠正IR解释：root20处1264 B复制来自最终1256 B Output错误联合的try失败出口，
不是正常中间State；实际中间State复制为592 B。静态错误传播形态不能归因为运行
时底层数组复制，也不据此重复此前否定的宽错误返回实验。

compact引导21/21及相关62/62步、71/71项检查通过，但实际execute生成仍为
20284 B、5处allocator.create，和压缩前相同；整个main改变54文件，源码净增
3577 B。它减少本地交接冗余，尚未消除全局boxing，不据此追加相同普通计时。

继续发现独立正式根：store/regions/model.Release同时包含state.statements与
scope.state；release/guard的输出会单独触发同一类型boxed。该路径在store_regions
正式入口中，不能仅优化invoke就推断类型可改为值表示。已在5个相关Source文件
将Release改为一份当前State及parent_tags/parent_offsets，guard把open后的child
放入State，keep/unlink更新该child，finish以保存的parent索引封装while。
无视图提前释放、输出字段克隆或借用规则放宽，释放算法及生成顺序不变。
该处由实际boxing依赖定位纳入同一成本修复，不做无关Store重构。正在引导
single-state，后续必须验证真实生成形态、Store行为及成本；不能声称已解决全局
所有重复类型根。

### 单状态版本的新证据与基线纠偏

single-state引导21/21步通过，扩展回归419/419步、978/978项受管检查通过，
覆盖Store事务、Task、集合、原生值边界、Gateway及模块生成。实际execute代码
20284→14984 B，5处State allocator.create全部消失；这证明对应装箱已消除，
尚不单凭静态形态宣称全部成本收益。

相同当前manifest，阶段前工具与single-state的main/collections/growth/ordered
分别3672/65/361/24文件，全代码相同，各仅.zxc-inputs指纹不同。隔离八轮交替、
排除首轮的冻结输入：固定基线/上阶段/本阶段CPU为5.37/5.20/5.16 s，
墙钟1.17/1.12/1.10 s；RSS中位数494862336/489193472/494714880 B，
未证明生成器内存改善。2268文件仅工具指纹不同。

一次同当前生成库、只切换invoke实现的冷CLI对照：控制CPU/墙钟/RSS为
87.22 s/85.44 s/4145659904 B，Source为87.23 s/85.51 s/4173824000 B。
CPU+0.01 s、墙钟+0.07 s进入容差，但RSS单样本+28164096 B未形成趋势证据。
更关键的是，该比较两侧均消费single-state生成库，只隔离invoke实现，不能覆盖
Region表示变化的整阶段成本。因此没有以此收口或把当前库重设为累计基线。

当前追加cold-frozen三对交替：控制使用最初冻结的native-cli-response.json，候选
使用single-state-cli-response.json；冻结控制Native副本不刷新，两侧各新编译缓存。
该比较包含全阶段生成形态变化。原始脚本compare_frozen_cold.py与cold-frozen.log
保留忽略目录，session仍运行；测量完成前不提交，不将局部容差冒充全阶段通过。

冻结阶段前生成库的首对普通冷结果：控制84.33 s CPU/82.67 s墙钟/
4135387136 B RSS，single-state为86.63 s/84.86 s/4194107392 B，
+2.30/+2.19 s和+58720256 B明确未通过。由此证实“同当前生成库”的局部比较
不足以验收整阶段；没有接受其结果或重设基线。首对结果已改变下一步决策，
停止剩余重复计时（总控与子进程均确认终止，保留完整首对），不等待同一失败
版本重复三遍。现在复用原ir-before控制，单独导出ir-single用于查清全局表示
变化的实际代价；保留迁移，不将消除5次装箱等同于整体性能改善。

### 去箱候选的停止决定

IR-single证实全局表示代价：StatementBuilder从8 B指针变为616 B managed值，
Invoke.State从592→1344 B，JSON State从80→832 B；对应错误联合临时也变宽。
root函数体25362→55230 B、JSON check58723→86725 B，execute虽然减少5次装箱，
却不足以抵销调用方增长；另有20991 B的权限weaken helper。这里是描述符布局与
静态IR增长，不是payload深复制。

因此撤回仅本阶段引入的5文件Region DTO去箱优化，保留原已迁入Source的释放
实现，未撤回invoke RX/ZX迁移；invoke本地Validation去重继续保留。遵守先实现
再优化，不能将有实测负效应的优化当作必须保留的功能。尚未引入任何新的借用
放宽。下一个通用候选需要先证明active plain-ABI调用的临时flat结果借用不会逃逸，
并保持原求值和转换表示；不能直接删除active guard或恢复已否定的inline实验。

### 论文依据与下一项有界候选

本轮再次核对 [ThinLTO，CGO 2017](https://ieeexplore.ieee.org/document/7863733/)、
[Compile-Time Analysis，CGO 2024](https://2024.cgo.org/details/cgo-2024-main-conference/9/Compile-Time-Analysis-of-Compiler-Frameworks-for-Query-Compilation)、
[MEMOIR，CGO 2024](https://mcmichen.cc/memoir/) 与
[LLVM New Pass Manager](https://llvm.org/docs/NewPassManager.html)。
前两篇支持分别计量完整IR驻留和各编译阶段成本，MEMOIR支持把逻辑数据与物理
布局分开考虑；LLVM文档明确分析复用、失效及按IR单元集中处理的局部性取舍。
这些是方法依据，不是zxc所有权导致后端数GB峰值的证明，也不构成直接套用
ThinLTO、替换后端或全面去箱的理由。既有13篇所有权论文见11月7日文档。

新的可证伪假设：active调用普通ABI值函数时，部分临时对象可以直接在调用方
作用域组装并借用，不必先构造managed对象再转换回来。这是生成质量优化，
不放宽用户所有权规则。只允许输出根Object且所有字段经任意Optional/List后
均为Scalar/Enumeration/ErrorSet；拒绝嵌套Object、Tuple、Task和NativeReference。
保留can_stack、参数缓存及pointer与shares的既有限制，确认valueFunction且callee
不使用state表示。只有已提供ABI BorrowObject时跳过一次重复transition.borrow；
结果转换和clip不变。白名单沿类型结构判定，不按文件名、类型名或用例硬编码。

只读复核确认fresh调用结果先绑定到调用方body后取地址；ABI结果按值返回，允许
列表的payload来自已有列表存储，不借用临时record内部字段。该证明只覆盖白名单，
不能推及任意对象。先验收生成物与现有行为，再看固定冷基线和生成器成本；命中
减少装箱也不能直接等价为峰值降低。若候选无收益或带来CPU/RSS退化，撤回候选，
保留本阶段invoke迁移。

active-borrow首代引导21/21步通过；现有函数分析、值返回、函数更新、Task、原生
值边界、Gateway、JSON Gateway、模块生成与Store回归419/419步、978/978项通过。
只读二次复核未发现白名单安全条件漏接。相对compact生成main仍3670个Zig文件，
80个改变、源码净减24942 B，但`.create(`调用数仍3100，不能称已消除堆分配。
下一步仅验收阶段不动点和受影响生成器/冷CLI成本，不重复无关完整回归。

active-stable引导21/21步通过，工具SHA由915c8627…变为b414dc75…，说明尚需
下一代引导确认不动点，不能把一次成功当作稳定。隔离八轮交替、排除首轮：
固定累计基线/上阶段/候选的CPU中位5.33/5.19/5.19 s，墙钟1.16/1.11/1.11 s，
RSS 493584384/495566848/492371968 B。前端未出现时间退化；约3 MB的RSS差异
不据此宣称稳定收益。冻结输入输出各2268文件、31处预期变化（包括工具指纹、
清单和优化影响的Zig模块）；现有行为由419步回归覆盖。

已启动完整冻结控制的三对普通冷CLI交替，控制继续使用最初native-cli-response，
候选使用active-cli-response；不使用两侧均含新生成库的局部控制。脚本与原始
日志保留忽略目录cold-active，测量期间不并行启动其他构建或性能任务。

### 借用候选收口与未通过项

cold-active三对全部成功完成，控制/候选中位CPU 85.64/86.10 s、墙钟83.85/84.29 s、
峰值4140728320/4162109440 B。配对CPU差为-0.22、+0.47、+0.03 s，RSS差为
+21381120、+4227072、+47988736 B。耗时波动不支持稳定收益，三对峰值均更高。
因此整阶段仍未满足成本门禁；没有把“正确性通过”或“前端不退化”当作完成。

这是冻结阶段前生成库相对整阶段候选的比较，不能仅凭它断言active借用优化单独
造成了全部回退。该候选虽通过行为回归并简化少量转换，但未减少静态create数量，
也未证明整体成本收益，不保留未经收益证实的策略复杂度。恢复本轮5个call策略
文件并移除2个新增谓词；invoke迁移、本地Validation去重及通用AST发布继续保留。
未执行下一次不动点引导或同样回归，因为候选已因整体成本未通过而停止。

#### 自我复核与下一步边界

- 论文提供可证伪的设计依据，不能替代zxc本身的成本归因；没有证明LLVM峰值由死
  视图引起，不重写完整所有权分析来赌收益。
- 整体去箱使描述符变宽，局部借用只减约25 KB源码且没有少分配；两者不能作为
  内存优化交付。上阶段约111 MB收益仅覆盖其普通冷CLI路径，不能外推整个冷构建。
- 当前保留实现的实际缺口仍是invoke生成阶段的成本：原生与Source语义已等价，
  需要继续定位Source调用边界、宽结果错误传播及生成IR的新增成本。不在这轮重新
  尝试已否定的全面inline、宽错误out参数或Region去箱。
- 迁移尚未通过完整成本门禁，不创建“完成”提交、不推送半验收结果；阶段完成后
  按仓库要求统一验收全部未提交文件并提交推送。完整自举和冷构建内存目标均未完成。

### 按来源视图重复实例化的真实热点

新筛选复用已有完整IR，无需再导出相同版本。copy-families按结构身份归一化泛型
编号后，import_rows.validateColumn有7049个实例、3947821 B IR；commit有6771个、
4073121 B。仅新增两种Source视图就各增加166个helper实例，合计260809 B IR。
这些叶helper的运行时逻辑只需要一项长度或目标列及一个slice，却携带整份来源
视图类型和字段前缀，因而在反射展开后保留了不必要的运行时实例身份。

有界候选只将validateColumn/commit的反射投影层在编译期展开；前者调用共享
validateCount(actual,expected)，后者先按既有规则验证/转换为目标列元素类型，
再调用仅依赖目标列类型的commitValues；void列使用独立commitVoid。不是把
Source业务函数或大型算法全面inline。验证次序、缺失/未知列检查、计数、reserve、
拥有型复制与错误清理以及最终提交次序均保留，不新增缓存或所有权放宽。

预期是减少本来应在编译期消失的跨SourceView叶helper实例，而非少验证数据。
先通过引导和受影响发布路径的现有行为，随后导出候选IR，核对helper与调用方合计；
只有整形态有明显缩减才进入普通冷CLI和生成器成本验收。该存储适配器仍属既有
原生过渡实现，本改动不冒充其RX/ZX迁移。

首版projection既有回归62/62步、71/71项通过。整IR相对冻结Native阶段前从
196424217→193924123 B，函数体合计188483262→186668895 B，函数34004→20571；
validateColumn/commit运行时实例归零，改为1个validateCount、1个commitVoid和
14个commitValues。但check由2350089→5236917 B，appendRows由8012453→10530036 B，
抵销大部分删除收益，不能仅报告少了一万多个实例。

在普通计时前按此新证据继续收口同一热点：validateColumn改为编译期结构投影的
布尔谓词；check按同一字段顺序以AND短路累积，最后只返回一次InvalidAst。
所有尺寸失败本来就是同一个无副作用错误；不再为每列try生成完整Counts的失败
返回。Source视图不变，遇到首个无效列后仍不读取后续列，已存在列的兼容性检查
仍始终在编译期执行；先前tag/offset/OOM检查和最后发布均不改变。

projection-short整IR相对冻结Native控制196424217→192316760 B（-4107457 B，
约-2.09%），函数体合计188483262→185061576 B，函数34004→20570。
check本体仍由2350089→3629804 B，但其memcpy站点3422→616；commit原6605个
实例归零，实际提交只剩14个目标列类型的commitValues和1个commitVoid。
完整模块memcpy 247611→245860，>=512 B站点19552→19998（新增迁移仍有宽结果），
不把静态站点减少等同于运行时payload少复制。完整合计已包含所有调用方增长
及新增Source invoke，达到进入普通成本对照的筛选条件；尚不声称RSS或CPU收益。

projection-short最终发布路径回归62/62步、71/71项通过，首代引导21/21通过，
工具SHA 13242ab6b871a1c7b15d1b016224586252b3c118cadfbca3b1093eacdd7f361c。
只读复核确认布尔累积保留首次错误后的不读取行为、void/缺列/空列及未知列规则，
所有检查仍先于reserve/copy/commit，叶提交无新增分配。下一代引导及扩展419步
既有职责回归正在运行；普通计时等它们完成后隔离执行。

projection-short-confirm引导21/21步通过，SHA与前代完全一致13242ab6…，阶段
自编译稳定。新旧工具生成当前main/collections/growth/ordered四组输出分别
3672/65/361/24文件，所有代码字节相同，各仅.zxc-inputs工具指纹不同。
扩展职责回归仍在原句柄运行，未另起相同任务；普通计时等待它终止后隔离执行。

## 阶段最终验收

本阶段完成gateway/invoke.lower的真实RX编排与ZX原子AST构造，同时收口其
通用AST发布器的列投影重复实例化。未撤回迁移，未保留无收益的Region去箱或
active借用候选。invoke.parameters/response仍供下一项entry.dispatch使用，
独立seed仍是过渡；没有将这些剩余Native职责计为完整Gateway或全编译器自举。

### 正确性与生成物

- projection-short-final-regressions：419/419步骤、978/978受管检查通过；覆盖
  函数分析、值返回、函数更新、Task、原生值边界、Gateway、JSON、模块生成与Store。
- 阶段引导及下一代引导各21/21通过，两代工具SHA相同：
  13242ab6b871a1c7b15d1b016224586252b3c118cadfbca3b1093eacdd7f361c。
- 当前四组main/collections/growth/ordered共3672/65/361/24文件代码全部字节相同，
  各仅工具指纹不同。冻结前端输入2268文件也只有工具指纹不同。
- Source调用输出由既有结构化AST及统一printer输出，无模板、RawCode或专用运行库。
  发布借用的payload由Builder allocator持有，不缩短既有生命周期；描述符仍由目标持有。

### 性能与内存平衡

普通冷CLI三对交替全部成功，同一Zig、ReleaseSmall、入口与参数，各自空本地及
全局缓存，测量期间没有其他构建。控制冻结于本阶段最初Native实现及生成库，
候选包含完整Source invoke、Validation去重、通用发布及最终列投影优化。

| 指标            | 阶段前控制中位数 | 最终候选中位数 |                    差值 |
| --------------- | ---------------: | -------------: | ----------------------: |
| CPU（user+sys） |          85.55 s |        84.82 s |                 -0.73 s |
| 墙钟            |          83.74 s |        83.00 s |                 -0.74 s |
| 最大单进程RSS   |     4133814272 B |   4084121600 B | -49692672 B（约-1.20%） |

逐对候选减控制：CPU -0.87/-0.78/-0.71 s，墙钟-0.76/-0.74/-0.74 s，
RSS -14008320/-56262656/-56721408 B。三对方向一致；控制RSS范围
4098129920～4144644096 B，候选4077092864～4088381440 B，范围不重叠。
这是本阶段普通冷CLI单进程证据，不是整个冷构建进程树的峰值，也不是所有权
生命周期问题已彻底解决的证明。不把不同历史输入的RSS收益机械相加。

隔离八轮生成器交替、排除首轮：固定累计基线/上阶段/最终候选CPU中位
5.35/5.20/5.20 s，墙钟1.17/1.11/1.11 s；RSS
495747072/496025600/492044288 B。当前阶段时间不退化，固定累计基线未重设，
已有增长趋势门禁保留；约4 MB前端RSS差异不单独作为稳定收益声明。

IR筛选与普通测量共同支持保留最终列投影优化，不能只凭函数数量减少判断成功。
已有前两项负实验继续保留以避免重试同一失败路径。数据、命令、版本、完整IR
与每轮日志在忽略目录ownership-research/gateway-invoke，不提交构建产物。

### 自我批判与剩余工作

1. 本次收益来自消除按完整SourceView重复实例化的投影helper及重复错误出口；
   没有证据把数GB后端峰值归因于死视图，也没有重写所有权系统冒充内存修复。
2. check/appendRows调用方增长已经包含在完整IR和冷编译测量中；局部变短或减少
   堆分配没有作为交付证据。兼容性、校验顺序、OOM清理和payload拥有规则保持。
3. 高内存主峰仍约4 GB，当前只是有重复证据的小幅改善。下一项自举职责是
   Gateway entry.dispatch，再到entry.render等整体编排；原生状态适配及其他自有
   算法仍需按完整自举标准继续迁移。
4. 按全部未提交文件统一验收、英文提交并推送，完成后确认工作区及上游均干净。
