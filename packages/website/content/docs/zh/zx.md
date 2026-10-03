### 显式输入输出

ZX 的语法类似 TypeScript，但不是 JavaScript。声明输入输出类型，并导出默认函数。下面的最小计算保持输入金额不变：

```typescript
export type Input = {
  amount: u64;
};

export type Output = {
  amount: u64;
};

export default function (in: Input): Output {
  return { amount: in.amount };
}
```

### 约束计算范围

当前编译器支持标量、对象、枚举、可选值、列表、元组、局部绑定、分支和文件导入。集合操作包括不捕获外部变量的 `map`、`filter` 和 `reduce`。

不要假定任意闭包、一般循环、JavaScript 隐式转换或运行时能力导入已经受支持。数值类型具有明确语义，不应依赖 JavaScript 的数值行为。

### 明确所有权

需要深复制时使用 `clone`。Store 访问通过声明的句柄提供，读写权限独立。宿主负责生命周期、持久化和提交行为。

使用已安装工具链的格式化器与诊断能力。具体契约请查阅[编译器参考](https://github.com/MatrixAges/zxc/blob/master/packages/compiler/README.md)。
