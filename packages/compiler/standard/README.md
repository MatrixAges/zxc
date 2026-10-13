# 数值与字符串标准模块

数值转换与解析可通过 `std:integer` 和 `std:float` 使用。这些函数无分配、无外部状态，支持并发调用。

## 整数宽度转换

```zx
import integer from "std:integer"
```

| 函数        | 输入 → 输出   | 语义                                     |
| ----------- | ------------- | ---------------------------------------- |
| `widen`     | `u32` → `u64` | 精确拓宽                                 |
| `widenByte` | `u8` → `u64`  | 精确拓宽                                 |
| `narrow`    | `u64` → `u32` | 大于 4294967295 时返回 `IntegerOverflow` |

`narrow` 是检查范围的转换，不会截断或环绕。调用者需要处理或传播 `IntegerOverflow`。

## 浮点转换与解析

```zx
import float from "std:float"
```

| 函数       | 输入 → 输出     | 语义                                                     |
| ---------- | --------------- | -------------------------------------------------------- |
| `narrow`   | `f64` → `f32`   | 按目标浮点精度舍入，遵循 Zig `@floatCast` 的数值转换语义 |
| `widen`    | `f32` → `f64`   | 有限值精确拓宽，保留正负零                               |
| `isFinite` | `f64` → `bool`  | NaN 和正负无穷返回 `false`                               |
| `parse32`  | `u8[]` → `f32?` | 直接按 f32 解析，非法文本返回 `null`                     |
| `parse64`  | `u8[]` → `f64?` | 直接按 f64 解析，非法文本返回 `null`                     |

解析接受当前 Zig `std.fmt.parseFloat` 支持的完整浮点文本。它不采用只读取文本前缀的 JavaScript `parseFloat` 规则，也不自动排除非有限结果；需要有限数值的应用应继续调用 `isFinite` 检查。`parse32` 不经过 f64 中间结果，避免额外一次舍入。

浮点转换是数值转换，不是位重解释。不要依赖 NaN payload 在不同目标平台间保持一致。

## 字符串列表连接

`std:string.join(separator, values)` 按原顺序连接字符串列表，仅在相邻元素之间插入分隔符。空列表返回空字符串；空元素保留，不做路径归一化、转义或编码转换。

```zx
import strings from "std:string"

export type Input = string[]

export type Output = string

export default function (in: Input): Output {
    return strings.join(", ", in)
}
```

连接使用线性文本构造并分配结果字符串，分配失败传播 `OutOfMemory`。函数没有外部状态，支持并发调用。

## 字节切片计数

```zx
import bytes from "std:bytes"
```

| 函数    | 输入 → 输出          | 语义                                     |
| ------- | -------------------- | ---------------------------------------- |
| `count` | `(u8[], u8)` → `u64` | 统计借用字节切片中等于目标字节的元素个数 |

`bytes.count` 直接扫描借用切片，不分配内存、不做字符编码校验，支持并发调用。
