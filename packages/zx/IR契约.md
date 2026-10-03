# ZX IR 契约（实验版 5）

## Intent：最终目标

向 Zig 或第三方后端提供有类型的程序、模块依赖、显式元组、无捕获集合回调和受授权 Store slot。IR 是语言语义契约，不依赖 genz；当前没有跨语言序列化协议或稳定二进制 ABI。

## Data：结构与语义

### 类型、模块与符号

- `Program.version` 必须是 5。`types` 起始项按 Scalar 枚举顺序排列，其后为 object、optional、list、tuple、enumeration。版本 5 删除 clone 节点，并增加函数返回所有权摘要；旧原始 IR 不复用新含义。
- 复合类型只能引用更早的 TypeId。对象字段按名称排序且唯一，字段不能是 void；元组可包含 void 丢弃槽；枚举非空且成员唯一。
- 普通函数的 `symbols[0]` 是 Input，Input 允许 void。纯类型文件设置 type_only，symbols/expressions/body 为空。
- 每个函数有独立 SymbolId 和 ExprId 空间，共享 Program.types。符号身份由编号决定，不依赖文本名称。
- `functions` 按依赖拓扑顺序排列，每个函数只能调用编号更小的函数；主程序可调用其中任意函数。此规则同时排除自递归与间接递归。
- `native_modules` 保存来源 specifier 与后端 import_name。同一对身份不能重复，specifier 必须属于原生或标准库协议。
- 原生 External 使用 NativeModuleId 引用模块，并保存非空成员路径数组，不再保存模块字符串或以点分隔的成员表达式。Input/Output 仍为共享类型表中的 TypeId。索引越界、空成员和非法 UTF-8 拒绝进入后端。
- 后端按 IR 模块表生成导入；不同来源别名可共享同一后端导入，函数只引用导入符号及成员路径。项目配置中的旧字符串形式在前端边界转换。
- 标准库与新的项目原生接口来自真实 .d.zx 声明源码。原生模块供应者仍负责审查纯度和 ABI，声明本身不证明外部实现纯度。
- 所有符号必须具有输入、const、解构或回调参数声明。子块和回调参数不能逃逸。

### 表达式与求值

源码使用 UTF-8，词法空白按 ASCII 识别。单行注释遇到 LF 或 CR 结束，CRLF 作为连续空白处理；模板插值中的注释遵守同一规则。NBSP、Unicode 行分隔符与段落分隔符不作为词法空白接受。

每个子 ExprId 必须早于引用它的节点。所有表达式均接受结构和类型校验；允许对象展开被覆盖后留下的纯投影孤立节点。后端不得执行未被语句引用的孤立节点。

object 包含 fields 和 evaluation。evaluation 记录源码操作数的求值顺序，包括被后续字段覆盖的操作数；fields 保存最后生效的字段值。后端先将 evaluation 操作数求值一次，再复用结果进行字段投影，不能重复执行消费操作。

逻辑非 `!` 及逻辑与或的操作数必须为 bool；数值、字符串、void 和可选值不会自动转换为布尔。

list、tuple、template 保留元素顺序。`&&`、`||`、`??` 和 conditional 保持短路。索引越界产生运行失败。none/some 显式表示可选值，unit 只表示 void。

字符串是不可变字节序列；相等比较按字节内容。可选标量可以相等比较，可选聚合只允许与 null 比较。对象和列表不提供隐式深相等。

match_expr 保存可选 subject、有序 arms 与必需 fallback。没有 subject 时条件必须为 bool；有 subject 时目标必须为非 void 标量或枚举，匹配项与其同型。所有结果与表达式同型。目标只求值一次，匹配项从前到后惰性求值，只有首个命中分支的结果或 fallback 会执行。所有权合流保留此前未命中条件的消费状态。

### 数值

源码 number、boolean 分别解析为现有 f64、bool；Array<T> 解析为 list，不增加 IR 类型种类。

支持 u8/u16/u32/u64、i32/i64、f32/f64，遵循用户最终选择的 Zig 原生数值语义。没有 Python 任意精度整数，也没有整数变量位宽、整数与浮点变量之间的隐式转换。

十进制数值中的 `_` 只允许出现在两个数字之间；e/E 后可以带正负号，但必须有指数数字。非法数值 token 在 parse 的词法阶段拒绝，错误类别不依赖目标类型；合法 token 的范围与精度检查属于类型分析。

整数字面量的前导零不改变十进制解释或分隔符规则，不采用 JavaScript 的旧式八进制规则。

字面量从上下文获得类型；缺省正整数为 u64、负整数为 i64、小数和指数形式为 f64。字面量范围在前端检查。整数除法为 @divTrunc，向零取整；余数为 @rem，符号随被除数。后端显式开启 runtime safety，非法整数运算不因 ReleaseFast 而成为未检查操作。

有符号余数使用加宽一位的中间值执行 @rem，再收束到目标类型，避免底层机器除法指令的商溢出影响本可表示的余数。最小有符号整数对 -1 求余为 0；对 -1 做整数除法仍溢出；零除数仍触发安全检查。

浮点使用 Zig 严格 f32/f64 语义；非有限字面量拒绝，运算产生的非有限值遵循 Zig。生成器通过位模式保留浮点字面量及负零。已知常量的非法计算仍可能由 Zig 在编译生成文件时报告；不把这些错误包装成业务 Output。

### 所有权与集合回调

所有者被 const 转移或消费之后，旧绑定失效。对象、元组、列表及其 optional 都参与所有权分析，聚合字段移动保守地消费整个根所有者。借用不能执行消费式操作；clone 已禁止，不通过复制恢复修改权限。发布给 Store 的值被冻结为借用，允许读取，禁止后续消费修改。

字符串虽不可变，仍可能是可变字节缓冲的只读视图，因此借用返回需要冻结可能的来源。reduce 的结果摘要同时合并初值与回调返回，不能忽略空列表路径。

Program/Function.output_ownership 描述 copy、owned 或 borrowed 返回。普通 ZX 函数按调用拓扑分析摘要；调用者可继续消费新拥有结果，借用聚合结果保守冻结实参。校验器重新分析并拒绝无法证明的 owned/copy 声明，borrowed 允许作为更保守的摘要。原生函数暂只接受 borrowed，不从 allocator 标记推导拥有权。

list_operation 统一产生 `[新列表, 业务值]`。push、sort、reverse、concat 的业务值为 void；pop 为 T?；splice 为被删除列表。destructure 必须覆盖全部槽，void 槽必须丢弃。

concat/splice 的结果缓冲区可以容纳标量或引用槽；聚合借用参数使结果保守地保持借用状态。所有参数始终执行移动/读取校验，不允许把已消费的目标再次作为参数使用。当前后端完整的聚合引用表示还在迁移，不能把已有值布局当作最终 ABI。

transform 参数只在自身回调体可见：map/filter 各一个元素参数，reduce 为累加值和元素两个参数。target 与 initial 在外层求值。回调体不能引用外层符号或 Store slot；验证不能因为 ExprId 已访问而跳过不同作用域的检查。

Symbol.ownership 是描述信息，不能用它绕过验证。官方校验器重新执行移动、借用、发布冻结和分支合流检查，不信任第三方给出的所有权声明。

### Store

stores 记录静态 handle、Object path、TypeId 和读写权限。store_get 只能读取已授权 slot；store_set 必须写入匹配的完整 Object。集合回调和纯模块 helper 不获得调用者的 Store 能力。

生成代码先暂存写入，getter 优先读取本次暂存值，成功返回前统一调用宿主 commit。版本检查、多 slot 原子发布与长期存储生命周期由宿主负责。失败路径不调用 commit。

### 函数契约

Program 和 Function 的 contracts 保存有序 requires/ensures。每个 Contract 拥有独立 symbols/expressions 图，复用所在 Program 的 types；predicate 必须指向 bool。requires 只有一个 in 符号，ensures 恰有 in/out 两个符号，类型对应函数输入输出。契约不能引用执行体的局部 SymbolId，也不能调用函数、访问 Store 或执行消费式集合操作。

IR 验证检查契约结构、表达式引用、类型、顺序与隔离，不等于证明谓词成立。纯类型模块和原生 External 不允许携带契约。当前 compiler.verification.generate 为支持的整数子集生成前提可满足性和路径敏感违例查询；不支持的能力返回 diagnostic。公开 zig.emit 拒绝任何包含契约的 Program 或子函数，返回 error.UnverifiedContracts。compileProjectVerified 将同一次求解通过的 IR 交给内部 renderer，并为 requires 生成顺序运行检查；它不读取既有结果文件作为授权。

## Edges：边界与限制

Span 是对应函数 file_name 源码的字节范围；IR 不保存完整源码，不能独立检查空行。项目诊断的 source_index 指向传入源文件集合。

数据库不在当前实现范围。前端不生成一般闭包、可变局部变量、一般循环、泛型用户函数、CFG 或 SSA；Zig 后端可以使用局部循环和可变暂存实现不可变源码语义。

Zig 后端将对象/元组表示为 `*const` 存储布局，list 的聚合元素保存引用。新构造值使用调用方 Arena，不能返回栈上局部布局的地址。执行入口的输入和 Arena 必须覆盖输出以及被宿主保留的 Store 引用的完整生命周期，仅覆盖 commit 调用期间是不够的。当前 Store 持久区域和原生共享 ABI 尚未完成迁移。第三方后端必须保留相同的数值、短路、移动和失败语义，不能直接用任意精度整数替换固定宽度计算。

## Answer：验证与后端入口

`compiler.validateIr(allocator, program)` 返回 null 或 Diagnostic。`compiler.zig.emit` 首先验证 IR，失败返回 error.InvalidIr。内存不足始终通过 error.OutOfMemory 返回，不转成普通语法错误。

验证覆盖版本、类型、索引、表达式顺序、字面量范围、完整字段、无捕获作用域、函数调用顺序、元组/列表操作、Store 权限、所有权及返回覆盖。真实生成代码的行为由 compiler/tests/runtime 验证，畸形外部 IR 由 compiler/tests/ir 验证。

### 原生公开名称与实现位置

External.export_name 保存可选的逻辑导出名；缺省时沿用 member 路径末段。公开名称用于共享类型命名空间，实现 member 仍用于调用定位，两者不得混用。同一 specifier 可以由多个实现模块提供不同导出；共享类型生成按逻辑 specifier 合并。重复公开名称的输入输出类型必须一致，类型导出与函数导出不能占用同一个名字。
