### 为什么用类 TypeScript

原子逻辑需要表达计算、条件和数据变换。函数、对象、类型标注与表达式是 TypeScript 使用者熟悉的写法；沿用这套表层语法，旨在降低人和 AI 学习、阅读与生成 ZX 的成本，把注意力留给业务规则和输入输出契约。

ZX 同时收紧语法与语义：使用明确的数值宽度、可检查的所有权与受控能力边界，让编译器能够静态分析并生成 Zig。熟悉的写法与受约束的执行语义相配合，为原子单元的验证和优化提供基础。

类 TypeScript 不等于完整 TypeScript 兼容。ZX 不依赖 TypeScript 编译器或 JavaScript 运行时，也不能直接假定 npm 包与任意 TypeScript 代码可用。语言的性能空间来自静态语义和编译路径，而不是表面语法。

### 明确输入与输出

ZX 的语法类似 TypeScript，但它不是 JavaScript。声明输入输出类型，并默认导出一个函数。下面的最小计算原样返回输入金额：

```typescript
export type Input = {
  amount: u64
}

export type Output = {
  amount: u64
}

export default function (in: Input): Output {
  return { amount: in.amount }
}
```

### 限定计算范围

当前编译器支持标量、对象、枚举、可选值、列表、元组、局部绑定、分支和文件导入。集合操作包括支持词法捕获的 `map`、`filter` 和 `reduce`；条件迭代使用返回最终状态的 `loop`。

不要假定它支持任意闭包、通用循环、JavaScript 隐式转换或运行时能力导入。数值类型具有明确的语义，不能套用 JavaScript 的数字行为。

### 明确所有权

需要深拷贝时使用 `clone`。Store 访问通过已声明的句柄提供，读写权限彼此独立。生命周期、持久化与提交行为由宿主代码负责。

使用已安装工具链的格式化器和诊断信息。准确契约见[编译器参考](https://github.com/MatrixAges/zxc/blob/master/packages/compiler/README.md)。

### 将共享契约放进纯类型文件

两个可执行文件共享一种数据结构时，把它导出到单独的纯类型 `.zx` 文件。区分可执行函数导入和共享类型导入，避免某段计算的私有输入结构意外成为共享 API。

### 在所有必要路径上返回

非 `void` 输出要求每条可能的路径都提供返回值。可以先用守卫处理无效业务条件，再明确返回正常结果。编译器的 `return_path` 诊断表示声明的输出与控制流不一致。

### 继续阅读

- [类型与值](/docs/types-and-values)：标量位宽、可选值与结构化数据。
- [集合与所有权](/docs/collections-and-ownership)：转换操作与消耗式操作。
- [路径与导入](/docs/module-paths)：共享类型和可执行依赖。
- [ZX 参考](/docs/zx-reference)：支持的语法与不应假定的能力。

### 把逻辑写成可独立推理的单元

一个 ZX 原子围绕一项明确计算建立输入输出契约，例如价格计算、资格判断或数据变换。RX 负责组合这些单元。这里的原子性描述责任边界，不提供事务保证，也不要求把每个表达式拆成独立文件。

清晰的类型、所有权和副作用边界，为局部验证与算子式优化提供条件。当前路径是 ZX → 带类型 IR → Zig；内联、特化与抽象开销消除需要结合后端、生成代码和测量确认。形式化证明与 FPGA 等目标属于后续工具链方向，不能仅凭单元足够小就认定已具备这些能力。

### match 表达式

`match` 包含两种模式：`match { ... }` 用完整布尔条件选择结果，`match value { ... }` 按目标值选择结果。`=>` 右侧是结果，`_` 是默认分支。

```typescript
const shipping = match {
  discounted >= in.free_shipping_minimum => 0,
  _ => in.shipping_fee
}

const label = match status {
  "paid" => "ready",
  "pending" => "waiting",
  _ => "blocked"
}
```

条件按源码顺序检查，只计算命中分支的结果。值模式的目标只求值一次，必须为非 void 标量或枚举。必须有唯一的末尾 `_` 分支，允许尾逗号，结果类型必须一致。逻辑与使用 `&&`。不支持区间、结构解构和链式比较。
