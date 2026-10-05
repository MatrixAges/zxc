# RX 属性值参考

## Intent：最终目标

用可见的语法区分字符串与 ZX 表达式，保持 RX 流程静态推导、依赖检查和原生编译。

## Data：当前规则

```xml
<Module>
  <Call fn="echo" in="hello" out="ctx.message" />
  <Call fn="calculate" in={{count: $in.count, limit: 5}} out="ctx.value" />
  <Return value={{message: ctx.message, value: ctx.value}} />
</Module>
```

| 写法                            | 含义                                           |
| ------------------------------- | ---------------------------------------------- |
| `value="hello"`                 | 字符串 hello                                   |
| `value="$in"`                   | 字符串 $in，不读取输入                         |
| `value={$in}`                   | ZX 输入表达式                                  |
| `value={{count: $in.count}}`    | ZX 对象表达式，外层花括号界定属性              |
| `value={[1, 2, 3]}`             | ZX 列表表达式                                  |
| `value={"hello"}`               | 返回字符串的 ZX 表达式，通常可直接写引号字符串 |
| `setter={[store.jobs.counter]}` | 静态授权一个完整 Store Object                  |

表达式内部使用原始 ZX 语法，例如 `<`、`&&`、注释与模板，无需 XML 实体转义。字符串使用 XML 标签转义：`in="A&amp;B"` 传入 A&B。

## Edges：静态边界与迁移

fn/service/module 路径、Import.from、Store.from、名称、out 绑定、Module 类型契约名称和 Field.type 都是静态字符串，必须用引号。花括号不会把依赖路径或绑定目标变成动态求值。Store.version 与 Gateway 字节上限保留静态整数字面量和范围检查，例如 `version={1}`。

Call.fn 已支持无后缀路径，`fn="load"` 定位同目录 load.zx；Call.service 的 `service="orders"` 定位 orders.rx。可以使用相对目录，仍检查项目根边界、物理模块身份及所有依赖边无环，不需要 .zig 后缀，也不会按多个后缀试探搜索。

旧 `in="$in"` 必须迁移成 `in={$in}`；旧对象表达式 `in="{count:$in.count}"` 变为 `in={{count:$in.count}}`。原表达式里的 `&lt;`、`&amp;&amp;` 等应还原为 ZX 符号。原来的双层字符串转义可简化为直接引号字符串。

值属性允许空字符串。空花括号不是有效 ZX 值表达式。Emit 的新语法不代表事件调度执行能力已经实现。

## Answer：应用、发布与验证

示例位于 [main.rx](RX属性值语法/应用/main.rx) 和 [worker.rx](RX属性值语法/应用/worker.rx)。无后缀 service 与 fn 都在真实装载链中执行。

```sh
zxc build docs/2026-10-05/RX属性值语法/应用/main.rx --out /tmp/rx_attributes
/tmp/rx_attributes '{"count":3}'

zxc build docs/2026-10-05/RX属性值语法/应用/main.rx --mode lib \
  --out docs/2026-10-05/RX属性值语法/发布库
zig build --build-file docs/2026-10-05/RX属性值语法/消费/build.zig
```

[表达式输出](RX属性值语法/应用/表达式输出.json)与[库消费输出](RX属性值语法/消费结果.json)一致。[字符串示例](RX属性值语法/应用/literal.rx)输出字面 `$in`；[迁移后的 Store 输出](RX属性值语法/应用/迁移Store输出.json)显示连续调用继续共享状态。

## 自我复核

本次只改变编译期属性解释和静态检查，不引入运行期表达式解释器。实际应用及库消费已执行，迁移后的 Zig 文件已做语法检查；未运行全量测试。迁移脚本针对旧语法快照一次性使用，不能对已经采用新字符串语义的代码再次机械加花括号。
