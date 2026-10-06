# WASM 参考

## Intent：用途

将 ZX/RX 编译为 WASI 命令模块，或无系统导入的 freestanding 可调用模块。app/lib 模式含义保持不变；库仍发布可由 Zig 消费的模块包，目标平台由最终应用选择。

## Data：构建与调用

```sh
zxc build main.zx --target wasm32-wasi --out main.wasm
zxc build main.zx --target wasm32-freestanding --out main.wasm
```

freestanding 用标准 `WebAssembly.compile` / `WebAssembly.instantiate` 加载。完整可执行宿主见 [宿主.mjs](WASM/宿主.mjs)，WASI 见 [WASI宿主.mjs](WASM/WASI宿主.mjs)。这两个示例使用 Node 文件加载；浏览器可将加载部分改为 fetch，无需 WASI 垫片即可实例化 freestanding 产物。

WASI 使用 preview1 命令入口，参数仍遵守原生应用契约：非 void Input 接收一个 JSON 参数，void Input 无参数，stdout 输出 JSON。宿主自行提供允许的 WASI 能力。参考 [Node WASI 文档](https://nodejs.org/api/wasi.html)。

## Edges：宿主边界

freestanding 不提供 OS I/O、进程或 Gateway。原生模块必须能编译到 WASM；动态库及线程等不兼容依赖不会自动转换为宿主服务。当前没有 WebAssembly Component Model、WIT、wasm64 或跨线程共享 Store 协议。

JSON 解码、输出编码及必要内存分配有成本，计算程序仍静态编译。标量接口可绕过 JSON。没有解释器或通用字节码执行循环。

所有指针均为同一实例 memory 的 u32 字节偏移。宿主应在每次调用后重新获取 memory.buffer，因为分配可能触发 memory.grow 并使旧视图失效。输入与输出只在下次 alloc/reset/deinit 前有效；读取后及时复制需要持久保存的内容。宿主不得修改分配区之外的模块内存，也不得在执行期间重入。

## Answer：导出协议

| 导出                          | 含义                                                     |
| ----------------------------- | -------------------------------------------------------- |
| memory                        | 实例线性内存                                             |
| zxc_alloc(length: u32) -> u32 | 释放上次请求并分配输入；返回地址，0 表示失败             |
| zxc_execute() -> u32          | 解析已写入的 JSON 并执行一次；0 成功、1 错误、2 正在执行 |
| zxc_result_ptr() -> u32       | 结果或 UTF-8 错误名称的地址                              |
| zxc_result_len() -> u32       | 结果或错误名称的字节长度                                 |
| zxc_reset()                   | 释放当前请求，保留实例 Store                             |
| zxc_deinit()                  | 释放当前请求及全部 Store；以后 alloc 会重新初始化        |

void Input 需调用 alloc(0) 后 execute；返回非零地址，无需写入字节。void Output 返回 JSON null。JSON 输出包含 NaN 或正负 Infinity（含嵌套字段）时，execute 返回 1，结果为 NonFiniteJsonNumber；WASI 同样在写出前失败。直接标量导出保留 IEEE 非有限数。`--result discard` 执行后返回空结果，错误仍提供错误名称。

每次 alloc 后只能 execute 一次，重复 execute 返回 InputNotPrepared，避免重复 Store 提交。Store 按既有事务边界提交；如果后续输出编码失败，不会撤销此前已提交的事务。deinit 后重新调用会从初始化状态开始。

### 直接标量调用

当 Input 和 Output 都是 void、bool、最多 64 位整数、f32 或 f64 时，额外导出 zxc_call。非 void 输入接收一个 WASM 数值参数，void 输入无参数，返回同样的状态码。非 void 输出可通过 zxc_scalar_result 读取。失败时应读取错误名称，不能把默认数值当成功结果。

bool 映射为 0/1，其他数值被拒绝。窄整数扩展到 i32，64 位整数使用 i64；JavaScript 的 i64 参数与结果使用 BigInt。f32/f64 保持 WASM 浮点类型。超出声明窄整数范围的输入被拒绝。调用会释放上次请求；Store 保留，其生命周期与 JSON 接口一致。

JSON 与直接标量导出属于同一应用，可交替使用。错误后可以再次分配或直接调用；发生 WASM trap 则宿主应放弃该实例，因为 trap 不保证执行中的状态已经清理。
