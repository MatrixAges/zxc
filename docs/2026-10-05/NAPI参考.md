# N-API 参考

## Intent：用途

将 ZX/RX 应用作为 Node 原生插件调用，接受与返回真实 JavaScript 值，复用编译后的函数与 Store 事务语义。

## Data：构建和加载

```sh
zxc build main.zx --host node --out addon.node
zxc build workflow.rx --host node --out workflow.node
```

```javascript
const addon = require('./addon.node')

const output = addon.execute(input)
```

--host 默认 process，node 仅用于 app 模式。lib 继续发布可复用源码/IR/原生模块包。--result 属于命令应用 JSON 输出选项，与 --host node 不同时使用；Node 调用始终返回声明的 Output。

插件声明 Node-API 6，使用稳定 C ABI，不绑定 V8 C++ API。实现参考 [Node-API 官方文档](https://nodejs.org/api/n-api.html) 与 [napi-rs 类型转换](https://napi.rs/docs/concepts/type-conversions)，实际行为以本页为准。

## Edges：能力和生命周期

构建会自动生成同名 `addon.cjs` 与 `addon.d.cts`。推荐通过普通模块入口获得类型检查：

```typescript
import type { Input, Output } from './addon.cjs'

import { execute, executeAsync } from './addon.cjs'

const output: Output = execute(input)
const async_output: Output = await executeAsync(input)
```

声明导出 Input、Output、execute 与返回 Promise<Output> 的 executeAsync，void 输入使用无参数签名。`.d.cts` 对应 CommonJS `.cjs`，由 TypeScript NodeNext 自动解析，见 [TypeScript 模块参考](https://www.typescriptlang.org/docs/handbook/modules/reference)。CommonJS 可使用 `require("./addon.cjs")`。

发布 npm 包时，将自己的 package.json 指向生成文件即可按包名导入：

```json
{
	"main": "./addon.cjs",
	"types": "./addon.d.cts",
	"exports": {
		"types": "./addon.d.cts",
		"default": "./addon.cjs"
	}
}
```

入口和声明带有生成标记。同名非生成文件会导致 NodeBindingWouldOverwriteFile，构建不会覆盖它；请选择其他输出基名。失败编译保留既有三份产物。Node 宿主的 --out 须以 `.node` 结尾。

execute 同步执行，占用调用线程。executeAsync 把原生计算交给 Node 工作池，返回 Promise<Output>；输入复制与输出转换仍在 JavaScript 线程执行。无 Store 的调用可以并行执行；同一插件实例的 Store 调用按提交顺序执行，队列未清空时 execute 抛出 PendingAsyncInvocation。

I/O/process 依赖和 Gateway 仍未接入 Node 宿主，构建会拒绝。executeAsync 是现有 Zig 应用的原生异步执行入口，并不表示完整 std.Io 异步宿主已经实现。Zig 0.17 Threaded 的进程信号所有权与 Evented 的网络缺口见 [异步实施计划](NAPI异步实施计划.md)。每个 Node Worker 拥有独立 Store，上下文不跨环境共享。

异步输入在提交时复制，提交后修改原对象不会改变已提交的调用。没有公开取消 API；Worker 退出会等待已经开始的原生工作结束，尚未开始的 Store 排队任务会清理。不要把 Worker.terminate 当作能抢占任意原生计算的取消操作。生成的 cjs 负责创建 Promise，原生 executeTask 是此入口的内部桥接接口。

每次调用的输入复制到原生请求 arena；返回值转换成 JS 自有数据后释放请求，Store 引用的数据沿现有事务内存机制保留。函数对象及活动异步任务共同持有持久上下文，最后一份引用释放时清理。单独保存 execute 或 executeAsync 引用仍会保持上下文存活。

读取 JS 对象字段可能调用 getter。已有 JavaScript 异常会原样传播；同步转换错误及应用错误抛出 Error，异步调用拒绝 Promise，message 为对应错误名称。禁止重入同一 execute，以免在一次状态操作未结束时再次修改共享状态。已提交的事务不会因后续返回值转换失败而回滚。Zig panic、运行安全检查失败（例如整数溢出）及原生崩溃不属于可返回的错误，不会转换为 Promise 拒绝，可能终止 Node 进程。

没有 ZX 解释器或 JSON 转换中转。Node-API 值转换和内存复制有实际成本，不能把跨 JS 边界称为零成本。

## Answer：类型映射

| ZX             | JavaScript 输入                                          | JavaScript 输出          |
| -------------- | -------------------------------------------------------- | ------------------------ |
| void           | execute() 无参数                                         | undefined                |
| bool           | boolean                                                  | boolean                  |
| u8/u16/u32/i32 | 范围内的整数 Number                                      | Number                   |
| u64/i64        | 范围内的 BigInt                                          | BigInt                   |
| f32/f64        | Number                                                   | Number                   |
| string         | string                                                   | string                   |
| u8[]           | Buffer、Uint8Array、Uint8ClampedArray 或字节 Number 数组 | Buffer                   |
| 其他 T[]       | Array                                                    | Array                    |
| T?             | T、null 或 undefined                                     | T 或 null                |
| 记录           | 对象；必需字段必须符合类型                               | 具有自有可枚举字段的对象 |
| 元组           | 长度精确匹配的 Array                                     | Array                    |
| 枚举           | 成员名称字符串                                           | 成员名称字符串           |

不将 Number 隐式转换成 i64/u64，避免精度损失。BigInt 必须无损落入范围；窄整数不能是小数、NaN 或 Infinity。f32 按浮点规则转换为单精度。字符串保留内嵌零字节；JavaScript UTF-16 到 UTF-8 的转换遵循 Node-API。

记录允许额外字段；可空字段缺省视为 null。对象字段写入使用定义自有属性的 API，避免 **proto** 等字段触发继承的 setter。数组与记录在转换期间遵循宿主正常的属性访问规则。

### 交叉构建和观察构建

```sh
zxc build main.zx --host node --target x86_64-linux-gnu --out addon.node
zxc build main.zx --host node --target x86_64-windows-msvc --node-lib /path/to/node.lib --out addon.node
zxc build main.zx --host node --watch --out addon.node
```

Windows 需要与目标架构匹配的 Node 导入库，通过 --node-lib 显式指定；插件不会下载或安装 Node。macOS/Linux 在 Node 加载时解析 Node-API 符号。--target/--cpu/--optimize 沿用现有选项。

--watch 重新构建并发布文件，不替换已加载到 Node 进程中的动态库实例。调用方需在新进程或新的 Worker 生命周期中加载新的产物；删除 require.cache 不代表操作系统卸载旧插件。
