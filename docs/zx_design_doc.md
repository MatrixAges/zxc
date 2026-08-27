# ZX 最小语法设计文档

> 目标：把 `.zx` 限制为一门可快速生成、可完全静态验证、可机械转译为 Zig 的类 TypeScript 小语言。它用有限语法表达开放式业务计算，但不承担拓扑编排、不自行持有长期状态，也不具备未授权的任意系统副作用。

## 1. 语言定位

`.zx` 是 ZXC 的微观计算层。

它的基本模型是：

```text
Call Input + optional { store setter } → computation → Output
```

核心约束：

1. 一个可执行 `.zx` 文件只有一个函数；
2. 函数只有一个业务输入值和一个输出值；声明 Store setter 时可以接收固定的第二参数 `{ store }`；
3. 局部变量只能使用 `const`；
4. 函数不保存任何私有或隐式的跨调用状态；
5. 函数结束后，局部变量和调用帧全部销毁；
6. 业务失败作为普通输出值返回，不使用异常控制流；
7. Store 和 `ctx.*` 的读取由 `<Call in="...">` 精确传入，Store 更新使用 Runtime 注入的受限 `store` setter；
8. 数据库等其他 Runtime 能力也通过 `in` 精确传入，不使用特殊 import；
9. `.zx` 由 `zxc` 直接解析并 AOT 转译为 Zig，不依赖 TypeScript 编译器、Node.js 或 JavaScript Runtime。

`.zx` 是类 TypeScript 语法，不是 TypeScript 的完整实现。任何未列入本文白名单的语法默认不支持。

这里的“无状态”是指函数不能拥有自己的常驻变量、缓存或隐藏状态。Store 是由 Module 声明、Runtime 管理并可恢复的显式运行时状态，不属于函数自身。

---

## 2. 与其他文件的职责边界

| 文件 | 职责 |
|---|---|
| 普通 `*.rx` | Pipeline、Task、分支、并发和调用拓扑 |
| `*.gateway.rx` | API、RPC、Socket 等对外接口 |
| `*.store.rx` | 可恢复的常驻内存对象定义 |
| `*.zx` | 不可变计算、Module 授权的 Store 更新和显式 effect 描述 |
| `app.rx` | 程序总体配置，内部 schema 尚未确定 |

具体边界如下：

- 宏观分支和并发编排属于 `.rx`；
- 单个计算内部的 `if`、`switch` 和集合变换属于 `.zx`；
- Store 在 `.rx` 的 Module 中注册；Runtime 在 Module 初始化时一次性建立对应 getter/setter；
- `<Call in="...">` 读取 Store 快照，`<Call setter="[...]">` 选择允许注入 `.zx` 的 setter；
- 未在当前 Module 中声明的 Store 对 `.zx` 不可见，访问时必须编译失败；
- 领域实体和历史数据属于数据库，不属于 Store；
- 数据库命令在 `.zx` 中描述，连接、事务和实际 I/O 由 Runtime 管理。

---

## 3. 文件模型

`.zx` 只有两种文件角色：可执行文件和纯类型文件。

### 3.1 可执行文件

纯计算 `.zx` 必须遵循固定结构：

```ts
// 1. 可选导入
import type { Money } from "@/types/money";

// 2. 固定输入契约
export type Input = {
  price: Money;
  is_vip: bool;
};

// 3. 固定输出契约
export type Output = Money;

// 4. 唯一默认导出函数
export default function (in: Input): Output {
  const rate = in.is_vip ? 80 : 100;

  return {
    amount: (in.price.amount * rate) / 100,
    currency: in.price.currency,
  };
}
```

硬性规则：

- `Input` 和 `Output` 必须显式导出；
- `Input` 和 `Output` 都可以直接使用任意受支持类型，不强制包装为对象；
- 单个值优先直接使用标量、字符串、枚举、可选值或只读列表；需要组合多个字段时再使用对象；
- `Input` 还可以包含由 Call `in` 精确传入的内置 Runtime capability；`Output` 可以是 `void` 或内置 effect 类型；
- 默认导出必须是匿名函数，文件名承担函数语义；
- 参数名固定为 `in`；
- `<Call>` 未声明 setter 时，函数签名固定为 `(in: Input): Output`；
- `<Call>` 声明 setter 时，函数签名固定为 `(in: Input, { store }): Output`；
- 第二参数只包含受限 Store setter，由 Runtime 注入；不声明类型、不使用 import，也不允许改名、别名、默认值或剩余参数；
- 文件中不能出现第二个顶层或可复用函数；受限集合 lambda 是唯一例外；
- 不允许具名函数导出；
- 不允许在 `.rx` 中内联 `.zx` 代码。

标量可以直接作为完整契约：

```ts
export type Input = u64;
export type Output = bool;

export default function (in: Input): Output {
  return in > 0;
}
```

### 3.2 Call 输入与 Store setter 注入

`ctx.*`、Store getter 和普通业务数据都由 RX 的 `in` 映射精确选择，并组成 `.zx` 的第一个参数：

```xml
<Call
  fn="advance_dispatch_cursor"
  in="{batch_size:$in.batch_size,state:store.scheduler.dispatcher,trace_id:ctx.trace_id}"
  out="ctx.range"
  setter="[store.scheduler.dispatcher]"
/>
```

`setter` 中的路径引用 Module 初始化时已经建立的 setter。它不会在每次 Call 中重新创建 getter、setter 或权限表。

声明 setter 的 `.zx` 使用固定第二参数：

```ts
export default function (in: Input, { store }): Output {
  // store 只能用于 setter 左值
}
```

规则如下：

- 未声明 setter 的函数省略整个第二参数；
- 声明 setter 的函数固定使用 `{ store }`，不注入 `ctx`；
- `store` 只包含 `setter` 列出的、且已在当前 Module 注册的写入路径；
- `store` 是只写能力，读取旧状态必须通过 `in` 传入；
- `store` 的类型由 `zxc` 根据 Module Store 定义和 Call 的 `setter` 推导；
- 不允许给第二参数增加类型标注、改名、别名、默认值或剩余绑定；
- `store` 不能被读取、返回、保存或传递给普通项目函数；
- Runtime 能力不能通过任何 import 获得。

### 3.3 纯类型文件

纯类型文件用于复用结构类型和枚举，可以导出多个类型，但不能包含执行函数或运行时变量：

```ts
export type Money = {
  amount: u64;
  currency: string;
};

export enum Currency {
  CNY,
  USD,
  EUR,
}
```

纯类型文件是“一文件最多一个函数”规则中的零函数文件，不破坏可执行文件的一文件一函数原则。

### 3.4 词法与命名约定

- 代码块使用 `{}`；
- 语句使用 `;` 结束；
- 多行对象、列表和参数允许尾随逗号；
- 支持 `//` 单行注释和 `/* ... */` 块注释；
- 文件名、字段名和局部变量推荐 `snake_case`；
- 导入的可调用符号推荐 `camelCase`；
- 类型和枚举使用 `PascalCase`；
- 字符串使用双引号，动态字符串使用反引号模板；
- 导出的 `Input`、`Output` 以及函数参数 `in` 是固定名称，不能重命名。

---

## 4. 最小类型系统

`.zx` 类型必须能够确定性映射到 Zig 内存布局，不提供 TypeScript 的高级类型系统。

### 4.1 标量

| `.zx` 类型 | Zig 映射 | 说明 |
|---|---|---|
| `bool` | `bool` | `true` / `false` |
| `u8`、`u16`、`u32`、`u64` | 同名 Zig 类型 | 无符号整数 |
| `i32`、`i64` | 同名 Zig 类型 | 有符号整数 |
| `f32`、`f64` | 同名 Zig 类型 | 浮点数 |
| `string` | `[]const u8` | UTF-8 不可变字节切片 |
| `void` | `void` | 没有业务输出 |

不提供模糊的 `number` 类型。数值宽度和有无符号必须显式确定。

### 4.2 可选值

独立可选类型使用 `T?`：

```ts
export type Output = string?;
```

对象中的可选字段使用 TypeScript 风格的 `?`：

```ts
export type User = {
  id: u64;
  nickname?: string;
};
```

两者都映射到 Zig 的 `?T`。空值字面量为 `null`。

### 4.3 结构类型

结构类型使用对象类型字面量：

```ts
export type Address = {
  city: string;
  zip_code: string;
};

export type User = {
  id: u64;
  address: Address;
};
```

允许有限、明确的结构嵌套，但不允许继承、交叉合并或运行时追加字段。

### 4.4 枚举

有限状态使用扁平枚举：

```ts
export enum PaymentStatus {
  Success,
  Pending,
  Failed,
}
```

枚举成员在编译期固定，不允许动态枚举或字符串联合类型模拟枚举。

### 4.5 只读列表

列表使用 `T[]`，映射为 Zig 只读切片 `[]const T`：

```ts
export type Input = {
  item_ids: u64[];
};
```

列表本身不可变，不支持 `push`、`pop`、`splice`、原地 `sort` 或索引赋值。

### 4.6 内置 effect 类型

Runtime 可以提供编译器内置的 effect 类型，例如：

```ts
Db
DbEffect<Order?>
```

`Db` 是只能由 `<Call in="...">` 传入的受限 Runtime capability；`DbEffect<T>` 是它产生的命令描述。用户不能声明泛型。这些类型由编译器内置，不需要从任何模块导入，也不能被保存到 Store 或作为普通业务数据返回。

---

## 5. 导入与复用

### 5.1 导入协议

| 路径形式 | 含义 | 示例 |
|---|---|---|
| `./`、`../` | 相对路径项目 `.zx` | `import normalize from "./normalize"` |
| `@/` | 项目 `.zx` 绝对别名，实际根目录解析方式待工程配置确定 | `import type { Money } from "@/types/money"` |
| `lib:` | 已声明的第三方 Zig 库 | `import crypto from "lib:crypto"` |
| `zig:` | Zig 内置库的受限纯计算接口 | `import std from "zig:std"` |

项目 `.zx` 导入可以省略 `.zx` 后缀。`.zx` 不能导入任何 `.rx` 文件，包括普通 `*.rx`、`*.store.rx`、`*.gateway.rx` 和 `app.rx`。`zx:` 不是合法的导入协议。

### 5.2 允许的导入形式

类型导入：

```ts
import type { Money, User } from "@/types/models";
```

`import type` 只能读取纯类型 `.zx` 文件。Store layout 不会变成可导入的 `.zx` 类型；`.zx` 仍需显式声明自己的 `Input` 契约，`zxc` 再根据调用者 Module、Call `in` 和 `setter` 对两侧结构进行静态兼容性检查。

默认函数导入：

```ts
import normalizePrice from "./normalize_price";
```

枚举导入：

```ts
import { PaymentStatus } from "@/types/payment";
```

第三方纯计算模块导入：

```ts
import crypto from "lib:crypto";
```

### 5.3 复用边界

- 项目内函数复用仍遵循一文件一函数；
- 项目函数通过默认导入调用；
- 命名导出只用于类型和枚举，不用于定义多个 helper 函数；
- 普通函数只能调用纯函数；
- `lib:` 中会访问文件、网络、时钟、随机源或全局状态的 API 不能作为普通纯函数调用；
- Runtime 变量、Store getter 和外部能力通过 `<Call in="...">` 精确传入；只有 Store setter 使用第二参数 `{ store }`；
- 导入任何 `.rx` 配置文件都属于编译错误；
- 动态导入、运行时模块解析和循环依赖不进入最小语法。

---

## 6. 值、表达式与操作符

### 6.1 字面量

支持：

- 整数和浮点数字面量；
- `true`、`false`；
- 双引号字符串；
- 模板字符串；
- `null`；
- 对象字面量；
- 列表字面量。

```ts
const active = true;
const label = `ORDER-${in.order_id}`;
const result = { id: in.order_id, active: active };
const ids = [1, 2, 3];
```

### 6.2 访问表达式

```ts
in.user.id
in.items[0]
in.items.length
```

对象字段和列表元素都是只读值。由 Store getter 取得的快照作为 `in` 的普通字段传入后，同样不可修改。

### 6.3 操作符

| 类别 | 操作符 |
|---|---|
| 算术 | `+`、`-`、`*`、`/`、`%` |
| 比较 | `==`、`!=`、`<`、`<=`、`>`、`>=` |
| 逻辑 | `!`、`&&`、`||` |
| 条件 | `condition ? a : b` |
| 空值回退 | `value ?? fallback` |

字符串支持 `==` 和 `!=`，由 `zxc` 转译为 Zig 字节切片比较。

### 6.4 对象构造与更新

对象只能通过一次性构造产生。允许在对象字面量中展开旧值，生成一个新对象：

```ts
const next_state = {
  ...in.state,
  cursor: in.state.cursor + in.batch_size,
};
```

对象展开不会修改 `in.state`，而是创建一个新的不可变值。普通对象禁止属性赋值：

```ts
in.state.cursor = 10; // 非法
```

唯一允许的赋值语句是完整 Store Object 的 setter，见第 7.5 节和第 10 节。

### 6.5 函数调用

项目内默认函数始终接收一个对象参数：

```ts
import normalizePrice from "./normalize_price";

const normalized_price = normalizePrice({
  amount: in.amount,
  currency: in.currency,
});
```

项目函数不能自行定义多个位置参数、默认参数、剩余参数或重载。受限 Store setter 第二参数是语言规定的唯一额外参数；`zig:`、`lib:` 提供的编译器已知 API 可以拥有各自固定签名。

---

## 7. 语句与局部控制流

最小语句集合只有五类：

1. `const` 声明；
2. `if / else`；
3. `switch / case / default`；
4. `return`；
5. Store setter。

### 7.1 const

```ts
const base_price = in.raw_price;
const final_price = in.is_vip
  ? (base_price * 80) / 100
  : base_price;
```

变量声明后不能重新赋值。`let`、`var`、`++`、`--` 和复合赋值全部非法。

导出的契约必须显式标注类型；局部 `const` 可以由其初始化表达式进行简单、唯一的类型推导。如果推导存在歧义则编译失败，不进入复杂类型推导。

### 7.2 if / else

`if` 用于局部业务判断，可以直接返回，但不能依赖可变变量累积状态：

```ts
if (!in.enabled) {
  return { ok: false, error: ErrorCode.Disabled };
}

return { ok: true, value: in.value };
```

### 7.3 switch

`switch` 用于枚举或有限标量匹配：

```ts
switch (in.status) {
  case PaymentStatus.Success:
    return { label: "paid" };
  case PaymentStatus.Pending:
    return { label: "pending" };
  default:
    return { label: "failed" };
}
```

### 7.4 return

- 非 `void` Output 的每条可达路径都必须返回值；
- 返回值必须与 `Output` 完全匹配；
- `void` 函数可以使用 `return;`，也可以在函数末尾隐式结束；
- 不支持多个返回值；需要多个结果时返回一个对象。

### 7.5 Store setter

完整 Store Object 可以通过赋值语句更新：

```ts
store.scheduler.dispatcher = next_dispatcher;
```

这是语言内置的受控 setter，不是普通变量赋值。只有当调用者 `<Call>` 的 `setter` 列表包含该路径时，Runtime 才会注入对应写入能力。setter 左侧必须是静态可解析的完整路径 `store.<namespace>.<object>`；不能读取该路径，也不能写入某个嵌套字段、动态索引或计算出的路径：

```ts
store.scheduler.dispatcher.cursor = 10; // 非法
store[in.store_name].dispatcher = value; // 非法
```

右侧值必须与 `*.store.rx` 中该 Object 生成的类型完全一致。

---

## 8. 集合变换

最小集合操作只有：

| 操作 | 语义 |
|---|---|
| `map` | 把每个元素映射为新元素，返回等长新列表 |
| `filter` | 保留满足条件的元素，返回新列表 |
| `reduce` | 把列表归约为一个值 |

```ts
export type Input = {
  scores: u64[];
};

export type Output = u64[];

export default function (in: Input): Output {
  return in.scores
    .filter((score) => score >= 60)
    .map((score) => score + 10);
}
```

集合 lambda 是唯一允许的内联函数形式，并受到严格限制：

- 只能出现在 `map`、`filter`、`reduce` 参数位置；
- 只能读取参数、`in` 和外部不可变 `const`；
- 不能赋值、逃逸、保存或作为返回值；
- 不能执行 effect；
- 不能递归。

`forEach` 不进入最小集合，因为它依赖副作用才能产生价值。`zxc` 可以把连续的 `filter + map + reduce` 融合为一个 Zig 循环，并在满足类型条件时生成 SIMD，但这些属于编译优化，不改变源码语义。

生成的 Zig 可以在编译器控制的局部实现中使用循环和临时可变计数器；不可变约束作用于 `.zx` 源码和用户可观察语义，而不是限制编译器选择底层机器实现。

---

## 9. 错误作为值

业务错误不使用 `throw`、`try` 或 `catch`，而是定义为普通 Output：

```ts
export enum ErrorCode {
  InsufficientBalance,
  AccountLocked,
}

export type Input = {
  balance: u64;
  amount: u64;
};

export type Output = {
  ok: bool;
  remaining_balance?: u64;
  error?: ErrorCode;
};

export default function (in: Input): Output {
  if (in.amount > in.balance) {
    return {
      ok: false,
      error: ErrorCode.InsufficientBalance,
    };
  }

  return {
    ok: true,
    remaining_balance: in.balance - in.amount,
  };
}
```

这样 `.rx` 可以像判断普通字段一样，根据 `ctx.result.ok` 或 `ctx.result.error` 选择分支。

需要区分两类失败：

- **业务失败**：属于 `Output`，必须显式建模并正常返回；
- **Runtime 失败**：例如内存不足、数据库连接中断或执行被取消，由 Runtime 错误通道传播，不伪装成业务值。

---

## 10. Store getter 与 setter

Store 权限分为读取和写入两条路径：

- getter 由 `<Call in="...">` 读取，并作为普通 `Input` 字段传给 `.zx`；
- setter 由 `<Call setter="[...]">` 显式选择，并通过第二参数 `{ store }` 注入 `.zx`。

Module 声明决定两者共同的权限上界：

```xml
<Module name="scheduler">
  <Store from="scheduler" />

  <Pipeline name="next_batch" in="NextBatchInput" out="DispatchRange">
    <Call
      fn="advance_dispatch_cursor"
      in="{batch_size:$in.batch_size,state:store.scheduler.dispatcher}"
      out="ctx.range"
      setter="[store.scheduler.dispatcher]"
    />
  </Pipeline>
</Module>
```

Store namespace 的名称来自 Module 声明：

```xml
<Module name="worker">
  <Store from="scheduler" />
  <Store from="billing" as="payments" />
</Module>
```

对应的访问路径分别是 `store.scheduler.*` 和 `store.payments.*`。`as` 是可选的；不写别名时，`from` 的值就是 namespace。

Runtime 在 Module 初始化时一次性为已声明 Store 建立有类型的 getter/setter 表。这个开销是 Module 级固定成本。`in` 和 `setter` 在编译期解析为静态 slot；执行 Call 时不解析 Store 路径、不创建权限表，也不复制未引用的 `ctx` 或 Store 数据。

性能实现必须满足：

- 标量 getter 可以按值传递；字符串、列表和较大的 Store Object 使用带版本的只读 view，不做深拷贝；
- 每个 Call 的 setter view 在 Module 初始化时预绑定，执行时只传一个已有 view 的引用；
- 没有 `setter` 的 `.zx` 不接收第二参数；
- setter 暂存区按首次实际写入惰性创建，不因声明 `setter` 就复制整个 Object；
- Store 路径、类型和权限检查都在编译期或 Module 初始化期完成，不进入热路径。

对应 `.zx` 从 `in.state` 读取快照，通过第二参数中的只写 `store` 提交新状态。`.zx` 不导入 `*.store.rx`：

```ts
export type DispatcherSnapshot = {
  cursor: u64;
  in_flight: u32;
};

export type Input = {
  batch_size: u64;
  state: DispatcherSnapshot;
};

export type Output = {
  start: u64;
  end: u64;
};

export default function (in: Input, { store }): Output {
  const start = in.state.cursor;
  const end = start + in.batch_size;

  store.scheduler.dispatcher = {
    ...in.state,
    cursor: end,
  };

  return {
    start: start,
    end: end,
  };
}
```

`store.*` 的语义规则：

1. Store getter 只通过 `in` 映射提供不可变快照；
2. `store` 来自函数第二参数，是只写 setter namespace，不允许读取；
3. `.zx` 只能写入当前 Call 的 `setter` 列表明确声明的路径；
4. setter 只能整体替换一个 Object，不能原地修改其字段；
5. setter 写入先在当前调用中暂存；函数需要继续使用新状态时，应读取自己的局部 `const`，而不是回读 `store`；
6. `.zx` 正常返回后，Runtime 执行版本检查、原子替换和配置文件同步；
7. 函数失败或 Store 版本冲突时，本次暂存写入全部丢弃，并通过 Runtime 错误通道报告。

Store 权限按 RX Call 的调用位置检查。同一个 `.zx` 文件被多个 Module 复用时，每个调用者都必须在 Module 中注册对应 Store，并在 Call 的 `setter` 中列出函数实际写入的路径。输入快照和 setter Object 的结构必须兼容。

因此 `.zx` 仍然不能持有私有状态；它只是显式操作由 Module 授权、由 Runtime 持久化的 Store。Store Object 用于需要常驻内存并可停机恢复的运行时对象，不用于定义业务数据模型。

---

## 11. 数据库 effect

数据库操作属于 `.zx` 的受控能力，但函数不能持有连接或直接执行 I/O。RX 通过 `in` 只传入当前 Call 需要的 `ctx.db` capability；`.zx` 返回数据库 effect 描述，由 Runtime 解释执行。

### 11.1 查询示例

```xml
<Call
  fn="query_order"
  in="{order_id:$in.order_id,db:ctx.db}"
  out="ctx.order"
/>
```

```ts
import type { Order } from "@/types/order";

export type Input = {
  order_id: u64;
  db: Db;
};

export type Output = DbEffect<Order?>;

export default function (in: Input): Output {
  return in.db.queryOne<Order>(
    "SELECT order_id, amount, status FROM orders WHERE order_id = $1",
    [in.order_id],
  );
}
```

`in.db.queryOne<Order>` 是通过 `in` 精确传入的编译器内置 effect 构造器，不是用户自定义泛型。它只生成有类型的命令描述，不在函数内打开连接或执行 SQL。

### 11.2 最小数据库能力

| 能力 | 作用 |
|---|---|
| `Db.queryOne<T>` | 查询零或一条记录 |
| `Db.queryMany<T>` | 查询多条记录 |
| `Db.insert<T>` | 插入并返回结果 |
| `Db.update<T>` | 更新并返回结果 |
| `Db.delete<T>` | 删除并返回结果 |
| `Db.transaction<T>` | 把多个数据库命令组成一个事务 effect |

Runtime 负责：

- 连接池；
- 参数绑定和 SQL 注入防护；
- 事务开始、提交和回滚；
- 非阻塞执行和取消；
- 把 effect 的解析结果交给 `<Call>` 的 `out`；
- 释放所有数据库资源。

数据库 effect 与 Store setter 不得出现在同一个 `.zx` 调用中。需要“查数据库 → 计算 → 更新 Store”时，应拆成多个 RX Call，从而让数据库执行和 Store 提交保持可验证边界。

除通过 `in` 传入的 `Db` 外，网络、文件、时钟、随机数等 Runtime 能力只有在单独完成设计后才能加入；在 `.zx` 中书写未知的全局名称不能获得新权限。

---

## 12. 并发模型

当前最小集合不在 `.zx` 中提供：

- `async` / `await`；
- `Promise`；
- `parallel`；
- `parallelMap`；
- `race`；
- 线程、锁、Fiber 或调度器对象。

多个独立业务步骤的并发由普通 RX 的 `<Parallel>` 表达。`.zx` 集合操作保持确定性的顺序语义，`zxc` 可以在不改变结果的前提下自动进行循环融合、SIMD 或安全并行化。

数据库 effect 在源码中仍是普通返回值。Runtime 可以使用 Fiber、事件循环或线程池执行它，但这些实现细节不会进入 `.zx` 语法，也不会造成函数染色。

---

## 13. 内存与生命周期

开发者不能在 `.zx` 中创建或传递 allocator。

`zxc` 和 Runtime 负责：

- 标量和小结构的栈/寄存器布局；
- 字符串模板、列表变换和序列化所需的 Arena 分配；
- 把输出生命周期提升到当前 Call/Pipeline 所需范围；
- Pipeline 结束后统一释放 Arena；
- effect 资源的申请、取消和释放。

`.zx` 禁止返回：

- 原始指针；
- allocator；
- 文件句柄；
- Socket 或数据库连接；
- 线程、Fiber、锁；
- 指向局部调用帧的引用。

函数调用结束后不留下模块级变量、缓存、连接或后台任务。通过 `store.*` 成功提交的状态属于 Module 的 Runtime Store，不属于函数调用帧。

---

## 14. 明确禁止的语法

### 14.1 可变状态

- `let`、`var`；
- 重新赋值；
- 普通对象的属性或索引赋值；
- `++`、`--`、`+=` 等复合赋值；
- 可变全局变量、静态变量、单例和缓存。

唯一例外是完整 Store Object 的 `store.<namespace>.<object> = value` setter。

### 14.2 TypeScript 复杂类型

- `any`、`unknown`、`number`；
- 用户自定义泛型；
- 复杂联合类型；
- 交叉类型；
- `interface extends`、类继承；
- `keyof`、`typeof`、条件类型、映射类型；
- `Pick`、`Omit` 等类型运算；
- 函数重载和隐式公共契约推导。

### 14.3 对象与运行时模型

- `class`、`this`、`new`、原型链；
- getter/setter 对象成员；
- 装饰器；
- 反射、`eval`、动态属性；
- 动态 import 和 CommonJS 模块加载。

这里禁止的是用户定义对象成员中的 getter/setter，不影响 RX 的 Store getter 和语言内置的 `store.*` setter。

### 14.4 控制流与函数

- `throw`、`try`、`catch`、`finally`；
- `for`、`while`、`do while`；
- 递归；
- 一般闭包和可逃逸 lambda；
- 多个函数、嵌套函数和具名函数导出；
- `yield` 和 generator；
- `async`、`await`、`Promise`。

### 14.5 隐式能力

- 访问当前 Module 未声明的 Store；
- 写入当前 Call 的 `setter` 未列出的 Store；
- 从第二参数读取 `store.*`；Store getter 必须通过 `in` 传入；
- 动态计算 Store 路径或修改 Store Object 的嵌套字段；
- 直接读写数据库、文件或网络；
- 直接读取环境变量、系统时钟或随机源；
- 使用 `zx:` 或其他伪造协议导入 Runtime 能力；
- 启动线程、Fiber、定时器或后台任务；
- 调用未经允许的 Zig/第三方副作用 API。

---

## 15. 编译期检查

`zxc` 至少执行以下检查：

1. 文件角色只能是可执行文件或纯类型文件；
2. 可执行文件必须且只能导出一个 `Input`、一个 `Output` 和一个默认函数；
3. 默认函数签名必须为 `(in: Input): Output` 或 `(in: Input, { store }): Output`；
4. `Input` 和 `Output` 都是受支持的有效类型，不要求对象结构；
5. 所有非 `void` 路径都返回与 `Output` 匹配的值；
6. 只出现允许的类型、语句、表达式和操作符；
7. 所有局部绑定均为 `const`，不存在写后修改；
8. 项目函数导入不存在循环依赖；
9. 所有项目文件导入都指向 `.zx`，不存在任何指向 `.rx` 的依赖；
10. 枚举 `switch` 的覆盖情况可静态确定；
11. 集合 lambda 不逃逸且不产生 effect；
12. Runtime 数据和 capability 只来自 Call 的 `in` 映射，不存在 Runtime capability import；
13. `{ store }` 只在 Call 声明 `setter` 时出现，并且是只写能力；
14. 每个 `store.*` namespace 都来自当前调用者 Module 的 `<Store>` 声明；
15. 每条 Store 写入都出现在当前 Call 的 `setter` 列表中；
16. Store setter 指向完整 Object，且右侧值与编译器注入的 Object 类型完全匹配；
17. 同一个 `.zx` 调用不同时包含 Store setter 和数据库 effect；
18. effect 文件只使用 Call `in` 显式传入的 Runtime capability；
19. 数据库 effect 与声明的解析类型一致；
20. 输出不包含 Runtime 资源或非法生命周期引用。

编译错误应包含文件、行列、规则编号、实际语法和允许的修复方式，使 AI 能根据诊断直接重写失败文件。

---

## 16. 最小语法总览

下面是面向实现的简化语法轮廓，不替代正式 parser grammar：

```text
ExecutableFile := Import* TypeDecl* InputDecl OutputDecl DefaultFunction
TypeOnlyFile   := ImportType* ExportedType+

InputDecl      := "export type Input =" Type ";"
OutputDecl     := "export type Output =" Type ";"
DefaultFunction:= "export default function" FunctionParams ": Output" Block
FunctionParams := "(in: Input)"
                | "(in: Input, { store })"

Type           := Scalar
                | "string"
                | "void"
                | Type "?"
                | Type "[]"
                | ObjectType
                | EnumType
                | BuiltinCapabilityType
                | BuiltinEffectType

Statement      := ConstDecl
                | IfStatement
                | SwitchStatement
                | ReturnStatement
                | StoreSetStatement

StoreSetStatement := StoreObjectPath "=" Expression ";"
StoreObjectPath   := "store." Namespace "." ObjectName

Expression     := Literal
                | Identifier
                | FieldAccess
                | IndexAccess
                | ObjectLiteral
                | ListLiteral
                | TemplateString
                | UnaryExpression
                | BinaryExpression
                | TernaryExpression
                | NullishExpression
                | FunctionCall
                | CollectionTransform
                | EffectConstructor
```

绝对核心可以压缩为：

```text
Input / Output / export default function
optional Store setter parameter: { store }
const / if / switch / return / store.* setter
scalar / string / optional / object / enum / readonly list
operators / template string / map / filter / reduce
import / import type
```

按需能力只有：

```text
Store getter     = 通过 Call in 精确传入
Store setter     = Call setter + 第二参数 { store }
Database         = 通过 Call in 传入 Db，由 Runtime 执行 effect
```

这套最小集合的扩展方式不是增加语言特性，而是增加更多具体类型、更多单文件函数、更多 RX 组合，以及少量经过审查的 Runtime capability。
