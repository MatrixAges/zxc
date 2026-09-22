# ZX IR 契约（实验版 2）

## Intent：最终目标

向 Zig 或第三方后端提供有类型的程序、模块依赖、显式元组、无捕获集合回调和受授权 Store slot。IR 是语言语义契约，不依赖 genz；当前没有跨语言序列化协议或稳定二进制 ABI。

## Data：结构与语义

### 类型、模块与符号

- `Program.version` 必须是 2。`types` 起始项按 Scalar 枚举顺序排列，其后为 object、optional、list、tuple、enumeration。
- 复合类型只能引用更早的 TypeId。对象字段按名称排序且唯一，字段不能是 void；元组可包含 void 丢弃槽；枚举非空且成员唯一。
- 普通函数的 `symbols[0]` 是 Input，Input 允许 void。纯类型文件设置 type_only，symbols/expressions/body 为空。
- 每个函数有独立 SymbolId 和 ExprId 空间，共享 Program.types。符号身份由编号决定，不依赖文本名称。
- `functions` 按依赖拓扑顺序排列，每个函数只能调用编号更小的函数；主程序可调用其中任意函数。此规则同时排除自递归与间接递归。
- 原生外部函数使用显式 External 描述。注册方负责审查其纯度和 ABI；未注册 zig:/lib: 导入在源码阶段拒绝。
- 所有符号必须具有输入、const、解构或回调参数声明。子块和回调参数不能逃逸。

### 表达式与求值

每个子 ExprId 必须早于引用它的节点。所有表达式均接受结构和类型校验；允许对象展开被覆盖后留下的纯投影孤立节点。后端不得执行未被语句引用的孤立节点。

object 包含 fields 和 evaluation。evaluation 记录源码操作数的求值顺序，包括被后续字段覆盖的操作数；fields 保存最后生效的字段值。后端先将 evaluation 操作数求值一次，再复用结果进行字段投影，不能重复执行消费操作。

list、tuple、template 保留元素顺序。`&&`、`||`、`??` 和 conditional 保持短路。索引越界产生运行失败。none/some 显式表示可选值，unit 只表示 void。

字符串是不可变字节序列；相等比较按字节内容。可选标量可以相等比较，可选聚合只允许与 null 比较。对象和列表不提供隐式深相等。

### 数值

支持 u8/u16/u32/u64、i32/i64、f32/f64，遵循用户最终选择的 Zig 原生数值语义。没有 Python 任意精度整数，也没有整数变量位宽、整数与浮点变量之间的隐式转换。

字面量从上下文获得类型；缺省正整数为 u64、负整数为 i64、小数和指数形式为 f64。字面量范围在前端检查。整数除法为 @divTrunc，向零取整；余数为 @rem，符号随被除数。后端显式开启 runtime safety，非法整数运算不因 ReleaseFast 而成为未检查操作。

浮点使用 Zig 严格 f32/f64 语义；非有限字面量拒绝，运算产生的非有限值遵循 Zig。生成器通过位模式保留浮点字面量及负零。已知常量的非法计算仍可能由 Zig 在编译生成文件时报告；不把这些错误包装成业务 Output。

### 所有权与集合回调

所有者被 const 转移或消费之后，旧绑定失效。包含列表的嵌套字段移动保守地消费整个根所有者。借用不能执行消费式操作，需要显式 clone。发布给 Store 的值被冻结为借用，允许读取，禁止后续消费修改。

list_operation 统一产生 `[新列表, 业务值]`。push、sort、reverse、concat 的业务值为 void；pop 为 T?；splice 为被删除列表。destructure 必须覆盖全部槽，void 槽必须丢弃。

transform 参数只在自身回调体可见：map/filter 各一个元素参数，reduce 为累加值和元素两个参数。target 与 initial 在外层求值。回调体不能引用外层符号或 Store slot；验证不能因为 ExprId 已访问而跳过不同作用域的检查。

Symbol.ownership 是描述信息，不能用它绕过验证。官方校验器重新执行移动、借用、发布冻结和分支合流检查，不信任第三方给出的所有权声明。

### Store

stores 记录静态 handle、Object path、TypeId 和读写权限。store_get 只能读取已授权 slot；store_set 必须写入匹配的完整 Object。集合回调和纯模块 helper 不获得调用者的 Store 能力。

生成代码先暂存写入，getter 优先读取本次暂存值，成功返回前统一调用宿主 commit。版本检查、多 slot 原子发布与长期存储生命周期由宿主负责。失败路径不调用 commit。

## Edges：边界与限制

Span 是对应函数 file_name 源码的字节范围；IR 不保存完整源码，不能独立检查空行。项目诊断的 source_index 指向传入源文件集合。

数据库不在当前实现范围。前端不生成一般闭包、可变局部变量、一般循环、泛型用户函数、CFG 或 SSA；Zig 后端可以使用局部循环和可变暂存实现不可变源码语义。

执行入口接收调用级 Arena；输入和 Arena 的生命周期必须覆盖输出与 Store 提交过程。第三方后端必须保留相同的数值、短路、移动和失败语义，不能直接用任意精度整数替换固定宽度计算。

## Answer：验证与后端入口

`compiler.validateIr(allocator, program)` 返回 null 或 Diagnostic。`compiler.zig.emit` 首先验证 IR，失败返回 error.InvalidIr。内存不足始终通过 error.OutOfMemory 返回，不转成普通语法错误。

验证覆盖版本、类型、索引、表达式顺序、字面量范围、完整字段、无捕获作用域、函数调用顺序、元组/列表操作、Store 权限、所有权及返回覆盖。真实生成代码的行为由 compiler/tests/runtime 验证，畸形外部 IR 由 compiler/tests/ir 验证。
