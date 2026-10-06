# genz

Zig 代码生成包，包含独立的结构化生成原语与 ZX IR lowering。依赖 Zig 标准库和 zx 数据契约，不依赖 compiler、frontend 或 RX。

## Intent：最终目标

以结构化表达式、语句和声明组合 Zig 程序，通过统一打印器处理括号、转义和代码布局。

## Data：公开接口

- `node.Expression`：标识符、整数字面量、浮点位模式、字符串、布尔值、类型、指针、可选值、枚举、元组、数组、成员、索引、一元/二元运算、调用、错误传播、条件、对象与有标签表达式块；`container_type` 组合结构体字段与方法声明。
- `node.Statement`：常量、局部变量、赋值、循环、返回、分支、块结果、丢弃值及表达式语句。
- `node.Declaration`：常量和函数声明。
- `Builder`：在调用者提供的 allocator 中构造表达式，提供 identifier/integer/string 便捷函数；其他原语直接通过 `expression` 接收结构化联合值。
- `render(allocator, declarations)`：生成调用方拥有的 Zig 源码，使用同一 allocator.free 释放。
- `zx.emit(allocator, program)`：将已校验的 ZX IR 生成 Zig 源码。
- `zx.bundle(allocator, program)`：生成应用源码与共享类型源码，返回 `Bundle`，使用 `deinit(allocator)` 释放两者。
- `zx.modules.entry`、`zx.modules.function`、`zx.modules.types`：使用完整已校验 IR 和 `Names{ types, functions }` 生成独立入口、选定 FunctionId 的真实函数或共享 ABI；返回源码由调用方释放。名称数组分别对应完整类型表和函数表，函数名称作为 Zig import key。

```zig
const builder = genz.Builder{ .allocator = arena.allocator() };
const left = try builder.identifier("left");
const right = try builder.integer(2);

const sum = try builder.expression(.{
    .binary = .{ .operator = .add, .left = left, .right = right },
});
```

## Edges：边界与限制

Builder 借用传入名称、字段与参数切片；它们需要存活到 render 完成。建议调用方为一次生成创建 arena。

普通标识符直接打印，关键词或特殊名称使用 Zig quoted identifier；字符串按字节转义，二元和条件表达式显式加括号。浮点原语保留 f64 位模式，不因十进制打印损失负零或精度。

本包只覆盖当前实际需要的 Zig 子集，不是完整 Zig AST，也不验证语言类型。标识符转义保证语法打印，不负责目标作用域的命名冲突；调用方后端必须完成名称分配。

独立函数导出 `call(allocator, in)`，入口保持 `execute(arena, in)`；根据静态能力追加 Store、Io 与 process 参数。局部 Store 槽位通过调用点映射生成适配器，仅为可读槽位传递快照指针；事务函数创建 pending 并独立提交，编排函数只转交能力与读取当前状态。调用方必须为各文件注册其实际依赖和同一个 `zxc_abi` 实例。本包不推导名义身份或构造磁盘缓存。

`zx` 入口要求调用方事先完成 IR 结构、类型、所有权和形式化契约校验；它只负责 lowering，不替代编译器语义检查。一般应用通过 `compiler.zig.emit`、`compiler.zig.emitBundle` 或编译 CLI 使用，保留完整校验门禁。native 模块应使用 bundle 入口，单源码入口不构造共享 ABI 文件。

## Answer：交付与成功标准

通用 Builder/render 仍可独立构造并打印 Zig 代码。ZX 类型映射、运行时调用、临时变量和共享类型生成统一位于本包的 `src/zx`，目标代码最终由 Zig 编译器检查。compiler 负责校验和调用协调。

## SIMD 数组映射

map 按输入长度一次分配。对于同元素类型的 f32/f64 纯算术回调，zx/simd 生成按目标建议宽度划分的 Zig Vector 运算与标量尾部；其他回调保持普通索引循环。filter/reduce 不重排。类型约束、分配失败边界、构建命令与实际指令证据见 [SIMD reference](../../docs/2026-10-05/SIMD参考.md)。

## 内部状态值返回

符合静态条件的纯计算函数额外生成布局返回入口，供对象 reduce 的根调用使用。资格按完整调用图检查，排除原生、Store、Parallel；允许消费输入及含引用字段的返回对象。无环类型图与后代类型检查限制临时参数和局部根对象的逃逸，最终结果仍遵循指针 ABI；既有 call/execute 不变。compiler 将资格位纳入调用者生成指纹。详细使用和局限见 [内部状态值返回参考](../../docs/2026-10-05/内部状态值返回参考.md)。

## 跨函数列表容量

`zx/buffer_call` 对已验证 IR 分别进行确定来源与可能引用分析，为对象归约中的 owned 状态调用生成固定类型的缓冲上下文。归约持有容量与首次复制标记，内部 helper 只借用；未通过检查的字段使用普通列表生成。完整摘要进入调用者缓存指纹。公开切片 ABI 不变，详见 [跨函数列表追加参考](../../docs/2026-10-05/跨函数列表追加参考.md)。

原生调用不自动视为纯函数。若 ABI 输入只传递数值、枚举、错误集、宿主引用或这些类型的 optional，并且多参数 tuple 由包装函数逐字段展开，生成器可证明包装地址不会传给原生代码。输出另按表示检查，可返回借用字符串及受限的叶元素列表。该事实独立用于平面循环值状态和临时参数 tuple；深层布局和静态列表仍遵循原有纯度约束；循环缓冲另以列表版本与逃逸分析检查旧版本观察。集合结果的直接字段投影也可省去 tuple 包装，保持元素存储和求值顺序。边界及真实 AST 生成证据见 [原生调用临时值优化](../../docs/2026-10-06/原生调用临时值优化/实施计划.md)。

循环中通过版本分析的 push/concat/pop 与索引更新可共用标准库 ArrayList 容量。首次写入复制原始切片，后续按当前长度复用，结束时转移实际长度的存储；保留旧版本、传入原生聚合参数或存在未分析的嵌套捕获时不启用。该优化不改变普通列表语义，范围和证据见 [循环列表容量复用](../../docs/2026-10-06/循环列表容量复用/实施计划.md)。

循环将完整状态交给纯 owned helper、且返回相同对象类型时，也可沿已有逐字段摘要传递容量。返回标量的纯借用查询在字段转移前可参与证明；写入后的读取仍保守拒绝。该路径独立证明根状态头可按值传递，不要求全部嵌套状态都能栈化，也不让 owned 切片自动取得 realloc 权限。跨 helper 的 pop 可沿已证明的剩余列表路径继续传递容量，后续追加及最终交付同步逻辑长度；弹出元素的别名按类型单独检查。实际 XML、Parser 调用和资源证据见 [自举性能修复](../../docs/2026-10-06/自举性能修复/实施计划.md)。
