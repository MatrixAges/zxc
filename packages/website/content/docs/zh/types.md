ZX 在生成 Zig 之前确定具体类型，不采用 JavaScript 的单一数值类型或隐式转换规则。

### 熟悉的类型名

| 源码类型   | 默认 ZX 类型        |
| ---------- | ------------------- |
| `number`   | `f64`               |
| `boolean`  | `bool`              |
| `string`   | 不可变 UTF-8 字符串 |
| `void`     | 无输出值            |
| `Array<T>` | `T[]`               |

`number` 使用 IEEE 754 双精度浮点，安全整数范围为 ±(2^53 − 1)。更大的精确整数使用显式整数类型；金额适合使用最小货币单位的整数表示。这些名称复用已有类型，不自动初始化值。不支持 `bigint`、`symbol`、`any`、`unknown`、动态 `object`，以及独立的 `undefined`、`null` 或 `never` 类型。空值使用 `T?` 与 `null`。此映射不改变字面量推断，也不引入 JavaScript 隐式转换。

### 选择标量类型

| 类型                      | 表示的值             |
| ------------------------- | -------------------- |
| `bool`                    | `true` 或 `false`    |
| `u8`、`u16`、`u32`、`u64` | 对应位宽的无符号整数 |
| `i32`、`i64`              | 有符号整数           |
| `f32`、`f64`              | 浮点值               |
| `string`                  | 字符串数据           |
| `void`                    | 无值                 |

应有意识地选择边界上的位宽。已有整数变量不会隐式扩宽，也不会隐式转换为浮点数。字面量可以从上下文获得类型；缺少上下文类型时，正整数字面量默认为 `u64`，负整数字面量为 `i64`，小数或指数形式字面量为 `f64`。

### 定义结构化数据

```typescript
export type Input = {
  amount: u64
  label: string?
  adjustments: u64[]
}

export type Output = {
  amount: u64
  label: string
}

export default function (in: Input): Output {
  return { amount: in.amount, label: in.label ?? 'untitled' }
}
```

`T?` 表示可选值，对象属性也支持 `name?: T`。`T[]` 是列表，`[T, U]` 是元组。对象、命名类型与枚举让编译器能够在执行前检查边界的数据形状。

### 检查算术前提

整数除法向零截断，余数的符号跟随被除数。无效算术会导致运行时失败，不会像 JavaScript 那样进行隐式转换，也不会自动恢复成某个值。在可能失败的运算之前，先验证业务前置条件。

`&&`、`||`、`??` 和条件表达式采用短路求值。字符串相等按字节比较，不要假定列表或对象支持结构深度相等。

### 保持命名可预期

值使用 `snake_case`，导入函数使用 `camelCase`，类型使用 `PascalCase`。默认可执行函数是匿名函数，输入参数名为 `in`。

继续阅读[集合与所有权](/docs/collections-and-ownership)。
