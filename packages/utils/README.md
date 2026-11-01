# utils

常用静态工具，保留调用处的实际类型。包入口为 `src/index.zx`，支持命名导入、别名和
barrel 重导出。

在 workspace 中加入此包，并在消费包声明依赖后运行 `zxc pkg install`：

```yaml
dependencies:
    utils: workspace:*
```

```zx
import { pick, omit } from "utils"

export type Input = {
    id: u32,
    name: string,
    internal: bool
}

export type Output = {
    id: u32,
    name: string
}

export default function (in: Input): Output {
    return pick(in, ["id", "name"])
}
```

| 工具                                             | 参数与结果                                           |
| ------------------------------------------------ | ---------------------------------------------------- |
| `pick(object, keys)`                             | 保留指定字段，推导精确对象类型                       |
| `omit(object, keys)`                             | 排除指定字段，推导精确对象类型                       |
| `map(array, callback)`                           | 按元素生成新数组，回调可接收元素、索引、来源数组     |
| `reduce(array, callback[, initial])`             | 归约为累加值，回调可接收累加值、元素、索引、来源数组 |
| `identity(value)`                                | 返回原值，保留类型与求值语义                         |
| `isNil(value)` / `isNotNil(value)`               | 判断是否为 `null`，接受可空与非空值                  |
| `head(array)` / `last(array)`                    | 返回首尾元素；空数组返回 `null`                      |
| `take(array, count)` / `takeRight(array, count)` | 取前后至多 `count` 项                                |
| `drop(array, count)` / `dropRight(array, count)` | 去掉前后至多 `count` 项                              |
| `sum(array)`                                     | 同类型数值求和；空数组返回该数值类型的零             |
| `min(array)` / `max(array)`                      | 同类型数值极值；空数组返回 `null`                    |
| `clamp(value, lower, upper)`                     | `min(max(value, lower), upper)`，两端包含            |
| `inRange(value, start, end)`                     | 左闭右开；反向边界先交换，与 lodash 一致             |

`pick/omit` 支持任意完整的 ZX 对象类型，包括对象字面量、输入、局部值及函数结果。
字段类型原样保留，包括嵌套对象、集合、可空值和枚举。可空对象需先收窄。
键必须是字符串字面量数组，拒绝未知与重复字段；结果沿用来源字段顺序。
参数按从左到右顺序求值一次；空选择也保留来源的副作用和错误。

`map/reduce` 是 `loop` 的编译期语法糖，使用显式导入；语言不提供数组 `.map/.reduce` 方法。
回调必须是内联 lambda，可以只读引用外层数据，不是可传递的运行时函数。
无初值的 `reduce` 以首元素为累加器，空数组沿用既有边界错误；有初值时空数组返回初值。

数组工具保留元素类型，`count` 为 `u64`。截取只遍历结果区间，复杂度为结果长度的
O(k)；聚合为 O(n)，首尾读取为 O(1)。不修改来源、不深拷贝字段，结果数组按需要构造。
空数组字面量仍须有可确定的元素类型。数值使用 ZX 原有精度、溢出与比较语义，
不把整数统一转换为浮点数。

这些工具在编译期按实参类型展开为普通字段、条件和循环；不增加动态方法、反射或运行库。
源码包与 `--mode lib` 的语义产物保留静态操作身份。它们是编译期操作，不是具有固定
Input/Output ABI 的运行时函数；向 Zig 暴露具体调用接口时，导出具有明确接口的普通模块，
在其内部使用这些工具。

RX 属性保留 `object.pick(keys)` / `object.omit(keys)` 作为静态组装表达式。
其他工具在 ZX 中调用，RX 通过 Call 连接计算；属性不执行普通函数。

命名与用途参考 [es-toolkit](https://es-toolkit.dev/reference/object/pick.html) 和
[lodash](https://lodash.com/docs/4.17.15#inRange)。本包不承诺 JavaScript 的原型、动态路径、
隐式类型转换、默认参数或完整兼容层。当前未提供动态键分组与函数调度工具。
