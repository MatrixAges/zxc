# genz

独立的 Zig 代码生成原语。依赖仅为 Zig 标准库，不认识 ZX、RX 或其 Runtime。

## Intent：最终目标

以结构化表达式、语句和声明组合 Zig 程序，通过统一打印器处理括号、转义和代码布局。

## Data：公开接口

- `node.Expression`：标识符、整数字面量、浮点位模式、字符串、布尔值、类型、指针、可选值、枚举、元组、数组、成员、索引、一元/二元运算、调用、错误传播、条件、对象与有标签表达式块。
- `node.Statement`：常量、局部变量、赋值、循环、返回、分支、块结果、丢弃值及表达式语句。
- `node.Declaration`：常量和函数声明。
- `Builder`：在调用者提供的 allocator 中构造表达式，提供 identifier/integer/string 便捷函数；其他原语直接通过 `expression` 接收结构化联合值。
- `render(allocator, declarations)`：生成调用方拥有的 Zig 源码，使用同一 allocator.free 释放。

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

## Answer：交付与成功标准

genz 可脱离 ZX 单独构造并打印 Zig 代码。目标代码最终由 Zig 编译器检查；ZX 类型映射、运行时调用与临时变量策略属于 compiler 后端。
