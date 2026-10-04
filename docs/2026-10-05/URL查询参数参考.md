# URL 查询参数参考

## Intent：最终目标

使用 std:url/search_params 处理 URL 查询部分，保留重复键和插入顺序，以纯函数形式提供 URLSearchParams 的列表操作。实现为静态 Zig 模块，不依赖 JavaScript 引擎或 zxc 专用运行库。

## Data：接口与依据

接口位于 packages/compiler/standard/interfaces/url_search_params.d.zx；算法依据 [WHATWG form 编解码](https://url.spec.whatwg.org/#application/x-www-form-urlencoded)及 [Node.js URLSearchParams](https://nodejs.org/api/url.html#class-urlsearchparams)。ZX 使用 UTF-8 字符串和不可变列表，不进行 JavaScript 值到字符串的隐式转换。

```typescript
import params from "std:url/search_params"

export type Input = string

export type Output = string

export default function (in: Input): Output {
  return params.stringify(params.sort(params.parse(in)))
}
```

## Edges：语义与限制

- parse 接受查询部分，可有一个前导 ?，不会提取完整 URL 的查询部分。
- 空分段被忽略；只用首个 = 分隔键和值。重复键、空键和空值均保留。
-   - 解码为空格；合法百分号字节按 UTF-8 解码，非法 UTF-8 使用替换字符，未完成的百分号序列保留原字符。
- stringify 不添加 ?。空格编码为 +，ASCII 字母数字及 *-._ 不编码，其他字节使用大写百分号编码。
- append、set、remove、sort 返回新列表或结果，不修改输入项；已有只读字符串和条目按引用共享，不深拷贝。
- Zig 直接消费方须让原条目和字符串覆盖结果使用期；不能释放输入后继续访问共享结果。
- sort 按 UTF-16 单元稳定排序，相同键保持原有顺序。与 UTF-8 字节排序不同。
- stringify 和 sort 对来自原生调用方的非法 UTF-8 返回错误；普通 ZX 字符串应保持有效 UTF-8。
- 本模块不提供绑定到可变 URL 实例的实时视图。完整 URL 解析、相对地址、域名/IDNA、origin 和文件 URL 尚未由本模块实现。

## Answer：类型、操作和使用方式

类型字段保持以下形状：

```typescript
export type Entry = { key: string; value: string }
export type Lookup = { entries: Entry[]; key: string }
export type Match = { entries: Entry[]; key: string; value: string? }
export type Update = { entries: Entry[]; key: string; value: string }
```

| 操作      | 输入    | 返回     | 行为                                             |
| --------- | ------- | -------- | ------------------------------------------------ |
| parse     | string  | Entry[]  | 解析查询部分，没有默认 1000 项截断               |
| stringify | Entry[] | string   | 按原顺序进行 form 编码                           |
| get       | Lookup  | string?  | 首个同名值；不存在返回 null                      |
| getAll    | Lookup  | string[] | 全部同名值，保留顺序                             |
| has       | Match   | bool     | value 为 null 时仅按键匹配，否则同时匹配键和值   |
| append    | Update  | Entry[]  | 在末尾添加一个条目                               |
| set       | Update  | Entry[]  | 替换首个同名项、删除后续同名项；没有同名项则追加 |
| remove    | Match   | Entry[]  | 删除全部匹配项，value 为 null 时删除全部同名项   |
| sort      | Entry[] | Entry[]  | 按键稳定排序                                     |
| keys      | Entry[] | string[] | 全部键，包括重复键                               |
| values    | Entry[] | string[] | 全部值，保持条目顺序                             |
| size      | Entry[] | u64      | 条目数量，包括重复键                             |

Match.value 是必填字段；使用 null 表示不限制值，空字符串表示只匹配空值。remove 对应 JavaScript URLSearchParams.delete 的功能；ZX 中使用显式结果赋值保存编辑后的列表。

构建与运行使用普通 app 入口：

```sh
zxc build main.zx --out build/query
./build/query '"b=two+words&a=1&a=2"'
```

上面的最小示例输出 JSON 字符串 `"a=1&a=2&b=two+words"`。声明文件中的 allocator 参数由编译器传入，ZX 调用不显式传递分配器。

完整操作示例位于 [示例 main.zx](URL标准库/示例/main.zx)，输入位于 [input.json](URL标准库/示例/input.json)。[Node 参考程序](URL标准库/示例/reference.mjs)采用同一输入，通过各自独立列表执行编辑。实际运行结果见 [ZX 输出](URL标准库/生成/示例运行.json)与 [Node 输出](URL标准库/生成/Node参考结果.json)。

在 URL标准库 目录内可重新生成示例发布库，并分别通过 ZX 工作区和 Zig 模块消费：

```sh
zxc build 示例/main.zx --mode lib --out ZX消费者/library
zxc build ZX消费者/main.zx --out 生成/zx_consumer
cd 库消费者
zig build
```

发布目录由第一条命令生成，不保存重复的标准库源码或构建缓存。两种消费者均接收同一 JSON 输入；结果分别保存在 [ZX 消费记录](URL标准库/生成/ZX消费结果.json)和 [Zig 消费记录](URL标准库/生成/Zig消费结果.json)。

## 自我复核

该交付覆盖查询参数的静态列表接口，不能据此声称完整 WHATWG URL 状态机已经实现。复用了既有百分号解码与 UTF-8 替换逻辑，但没有复用 querystring 的默认上限或编码字符集。没有引入可变对象包装、动态分派或运行库。
