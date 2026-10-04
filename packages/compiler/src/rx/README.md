# RX

`.rx` 文件的 Zig 语法定义库，基于 `dsl`。支持 XML 文本解析和带源码位置的 AST 校验，输出为强类型数据或诊断；普通顺序 Call.fn/Call.service/Return 已支持生成独立应用；其余流程执行能力见本文边界。

## 构建与测试

```sh
cd packages/compiler
zig build test-rx
```

RX 与 ZX 同属 compiler 包；RX 模块通过 dsl 解析和校验，公开构建模块名为 rx。根目录 zig build test 覆盖 RX 回归。

RX 测试位于 compiler 包的 `tests/rx/`，实现文件不包含内嵌 test。

公共标签实现位于 `src/rx/labels/`，每个标签一个同名 `.zig` 文件，例如 `Call.zig`、`Module.zig`。Gateway 专用标签位于 `src/rx/features/gateway/labels/`，Store 专用标签位于 `src/rx/features/store/labels/`；每个文件同时承载该标签的 Schema 和专属校验。

`flow.zig` 和各 feature 的 `root.zig` 仅聚合导出，公共 API 保持不变。Gateway 的递归子元素适配器位于 `features/gateway/entries.zig`。Store 是专门声明运行时持续存在对象的特殊标签，其定义与引用统一归属 `features/store/labels/`：`Store.zig` 定义 Store 文件根标签，`StoreReference.zig` 定义模块内的 Store 引用。当前仅实现语法校验，尚未实现对象的运行时生命周期。

入口装载模式会读取 Store 引用文件：`from="state"` 相对当前模块目录解析到 `state.store.rx`，`from="state.store.rx"` 使用显式文件名。它验证定义存在且 Schema 合法，不按 Store.name 搜索全局对象；`as` 和缺省别名保持既有约定。读取定义不代表初始值已解码或持久对象已创建。

## 文件类型与模块身份

| 文件           | 根标签                           |
| -------------- | -------------------------------- |
| 普通 `*.rx`    | Module                           |
| `*.gateway.rx` | Gateway                          |
| `*.store.rx`   | Store 定义                       |
| `app.rx`       | 保留；内部语法尚未确定，明确报错 |

模块唯一标识是项目内的**完整文件路径**，包括文件名称。Module 没有 name 属性，不存在 Pipeline 层，也不提供模块别名。`users/get.rx` 和 `orders/get.rx` 是不同模块。

注册时传入项目相对路径，采用 `/` 分隔、区分大小写；规范化 `.`、`..` 和重复分隔符后检测重复注册。库不访问文件系统，不解析符号链接；文件加载器必须保证同一物理文件没有通过符号链接注册成多个逻辑文件。

模块引用相对于当前文件所在目录，自动补齐 `.rx`：

| 当前文件        | 引用       | 目标标识        |
| --------------- | ---------- | --------------- |
| `area/index.rx` | `users`    | `area/users.rx` |
| `area/index.rx` | `./users`  | `area/users.rx` |
| `area/index.rx` | `../users` | `users.rx`      |
| `area/index.rx` | `users.rx` | `area/users.rx` |

不进行按名称搜索、目录 index 猜测或扩展名候选搜索。绝对路径、越出项目根的路径和特殊 RX 文件不能作为普通模块依赖。

## 调用与组合

每个 Module 自身就是流程。可选的 in/out 用于命名推导后的类型契约，不是需要另行提供的类型文件；Schema 入口仅保留名称，`rx_analysis.module.infer` 从函数调用与返回表达式推导顺序模块的实际类型。

`checkout.rx` 可以通过调用多个子模块形成新的模块：

```xml
<Module in="CheckoutInput" out="CheckoutOutput">
  <Call service="users" in="$in.user" out="ctx.user" />
  <Call service="orders" in="{user:ctx.user,items:$in.items}" out="ctx.order" />
  <Emit event="order.created" value="ctx.order" />
</Module>
```

父模块再用 `<Call service="checkout" in="$in" out="ctx.result" />` 调用整个组合模块。Call 的 fn 用于 ZX 函数，service 用于 RX 模块，必须且只能提供一个目标。

Call.fn 相对当前 RX 文件目录解析，省略后缀时补 `.zx`，目标是该文件的默认导出。例如 `fn="load_user"` 指向 `load_user.zx`，也可写相对目录和显式 `.zx` 后缀。入口检查会读取函数及其 ZX 导入闭包，执行现有命名、类型和依赖检查，并拒绝纯类型文件作为函数目标。可使用 `check-rx --entry <file.rx> --project <pkg.yaml>` 指定包与原生接口配置。

上述 check-rx 入口仅做结构与目标检查；`zxc build` 和下述项目推导入口会进一步验证顺序调用的参数、结果及类型兼容性。RX 尚未生成 Store 句柄上下文，需要这些上下文的函数仍待完整联结。

`<Import from="users" />` 是可选的模块组合依赖声明，不接受 as；直接 Call 不必再重复写 Import。Import 本身不表示执行顺序或调用，执行关系由 Call 描述。依赖图同时包含 Import 和 Call service，要求整个注册集合无环；即使 Import 暂未被调用，也不能形成循环依赖。

事件名不属于同步模块依赖图。Emit 只定义事件发送语法，当前没有实现订阅注册、事件调度或事件反馈环检测。

**无环是项目合法性的硬约束，不提供关闭选项。** 完整模块集合必须通过 `validateModules`，任何自引用、间接环、条件分支里的环或未使用 Import 形成的环都返回诊断，不返回部分合法模块作为成功结果。单文件语法通过不能替代这一项目检查。

遇到看似需要双向调用的业务，按 [AI 消除循环依赖指导](../../../skills/rx/消除循环依赖.md)选择父模块编排、提取共享能力或显式数据传递等方案；完整阅读入口见 [skills](../../../skills/README.md)。

该约束使模块依赖具备拓扑序，适合逐模块分析、测试和推导性质。它保证静态模块调用关系不递归，但不单独证明 ZX 函数终止、事件反馈终止或业务结果正确。测试额外穷举三个模块的全部 512 个有向图，并用独立的拓扑消除算法对照生产 DFS；有限穷举不等同于完整形式化证明。

## 支持的标签

属性默认必填，`?` 表示可以省略。

| 标签       | 属性                                               | 直属子标签                                                     |
| ---------- | -------------------------------------------------- | -------------------------------------------------------------- |
| Module     | `in?`、`out?`                                      | Import、Store 引用、Task、Call、Parallel、Switch、Emit、Return |
| Import     | `from`                                             | 无                                                             |
| Call       | `fn?` / `service?` 二选一、`in`、`out?`、`setter?` | 无                                                             |
| Return     | `value`                                            | 无                                                             |
| Task       | `name`                                             | Call、Parallel、Switch、Emit、Return                           |
| Parallel   | 无                                                 | Task、Call                                                     |
| Switch     | `on`                                               | Case、Default                                                  |
| Case       | `value`                                            | Task、Call、Parallel、Switch、Emit、Return                     |
| Default    | 无                                                 | Task、Call、Parallel、Switch、Emit、Return                     |
| Emit       | `event`、`value`                                   | 无                                                             |
| Store 引用 | `from`、`as?`                                      | 无                                                             |
| Gateway    | `name`、`protocol?`、`listen?`                     | Group、Route                                                   |
| Group      | `prefix`                                           | Group、Route                                                   |
| Route      | `path`、`service`、`method?`                       | 无                                                             |
| Store 定义 | `name`、`version`                                  | Object                                                         |
| Object     | `name`                                             | Field                                                          |
| Field      | `name`、`type`、`value`                            | 无                                                             |

共 **16 个不同标签名**，Store 在两种文件上下文中具有不同 Schema。Store 引用中的 as 只沿用原设计的 Store 数据命名空间，不是模块别名；Gateway/Store 的 name 是领域配置名称，也不充当模块注册标识。

Task、Parallel、Switch、Case、Default、Group、Store 定义、Object 均至少有一个子元素。Module 和 Gateway 允许空内容。Task 不能直接嵌套 Task，其他递归嵌套遵循表格。Switch 的 Case 值不能重复，最多一个 Default，不强制 Default 位置。

setter 仅可用于 fn 调用；service 目标的 Store 写入能力由目标模块内部的 fn 调用声明。

protocol 的语法集合为 `http`、`grpc`、`websocket`、`tcp`、`mqtt`；method 为 `GET`、`HEAD`、`POST`、`PUT`、`DELETE`、`CONNECT`、`OPTIONS`、`TRACE`、`PATCH`。这不代表已经实现这些协议的 Runtime adapter。Route.service 也采用文件路径引用语法。

Store.version 为 u32。同一个 Object 的 Field 名不可重复；同名 Object 可声明不同字段，但同一文件的完整 Object.Field 路径不可重复。Field.value 允许空字符串，type/value 尚未接入完整 Store 值类型系统。

## API 与校验层级

真实 XML 模块集合可使用 `parseModules(allocator, sources)`，其中每个 `TextSource` 包含 `path` 和 `source`。它先解析文本，再调用完整模块集合校验；返回值的 `value` 与 `validateModules` 相同，并通过 `deinit` 统一释放解析和校验结果。解析器复制源码，返回值不借用调用者的文本缓冲区。

`parseXml` 单独返回 `{ node | diagnostic }`；单文件 Gateway/Store 可先解析，再使用 `validate`。调用者应先释放校验结果，再释放 XML 解析结果。

XML 输入支持 UTF-8、XML 1.0 声明、注释、CDATA、单双引号属性、预定义实体和数值字符引用。标签与属性名称限制为 ASCII，不支持命名空间、DTD、自定义实体和通用处理指令；这些输入明确返回语法诊断。位置使用原始字节偏移及一基行、字节列，CRLF 计作一次换行。

`rx.attributeLocation(attribute, decoded_offset)` 可将属性表达式中解码后的字节位置映射回原 XML，涵盖实体引用及 CRLF、换行、制表符归一化。`rx.attributeEndLocation` 提供实体内部范围终点的右侧映射。它使用文本解析器保留的 raw_value；手工 AST 未提供该数据时返回 null。

官方 CLI 的 `zxc check-rx <module.rx> [module.rx ...]` 读取明确传入的完整普通模块集合，检查 XML、Schema 与模块依赖。`zxc check-rx --entry <module.rx>` 则从入口自动装载 Import、所有嵌套 Call.service 和 Store.from 的文件，以当前工作目录为项目根。入口也可以是 `.gateway.rx`：先验证 Gateway Schema，再读取所有嵌套 Route.service 指向的普通模块和依赖；或 `.store.rx`：校验单个 Store 定义。入口模式不扫描无关文件，也不执行流程。显式集合模式仍只接受普通模块，不装载其 Store 定义。

入口装载会检查真实文件路径：拒绝符号链接越出项目根，以及同一物理文件通过多个逻辑路径重复注册。语法库本身仍不访问文件系统；显式集合模式的调用者仍需保证物理身份一致性。

单文件语法检查：

```zig
var result = try rx.validate(allocator, "orders.rx", xml_ast);

defer result.deinit();

switch (result.value) {
    .data => |document| consume(document),
    .diagnostic => |issue| report(issue),
}
```

模块注册及跨模块校验必须使用完整模块集合：

```zig
const sources = [_]rx.ModuleSource{
    .{ .path = "users.rx", .node = users_ast },
    .{ .path = "orders.rx", .node = orders_ast },
    .{ .path = "checkout.rx", .node = checkout_ast },
};

var result = try rx.validateModules(allocator, &sources);

defer result.deinit();

switch (result.value) {
    .data => |modules| consumeModules(modules),
    .diagnostic => |diagnostic| reportAtFile(
        sources[diagnostic.source_index].path,
        diagnostic.issue,
    ),
}
```

validateModules 输出按输入顺序排列的 `{ path, data }`，path 是规范化后的注册标识，data 为 Module.Data。该接口只接受普通 Module AST；Gateway 和 Store 文件通过单文件入口校验。

成功结果另提供 `dependency_order`，内容是原输入数组的索引，依赖模块排在引用它的模块之前，每个模块仅出现一次。`value.data` 仍保持输入顺序。`validateModules` 与真实文本入口 `parseModules` 使用同一顺序；失败结果的顺序为空，不暴露部分完成的计划。该结构入口仅检查依赖图；`rx_analysis.project.infer` 进一步共享推导全部模块契约，并按该顺序联结可执行 Program。

跨模块校验包括：重复文件注册、引用越界、目标不存在、自调用、直接/间接循环，以及嵌套控制结构中的 service 调用。共享子模块、菱形依赖和重复调用都允许。诊断包含源文件索引、原始行列位置和具体属性。

单文件 validate 仅负责语法，不能代替完整模块集合的存在性和循环校验。两种入口均采用首错返回。

结果列表及规范化路径由 arena 持有，字符串借用 AST；输入 AST 必须活到结果使用结束。成功和失败都要 deinit，OutOfMemory 通过错误联合返回。

## 顺序模块类型推导

Zig 构建模块 `rx_analysis` 提供两个独立拥有 arena 的接口；结果使用后调用 `deinit()`。

| 入口                               | 输入                                                                        | 成功结果                                                                                       |
| ---------------------------------- | --------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------- |
| `call.link(allocator, options)`    | `target`（RX 路径、真实 Call 节点、ZX 源集合、项目选项）以及显式 `bindings` | `invocation`：函数与参数 Program，共享类型表和名义类型来源                                     |
| `module.infer(allocator, options)` | `owner`、真实 `module` 节点、ZX `sources`、可选 `project` 选项              | `contract`：可执行 program、类型表、input_type、output_type、顺序 calls、可选 result、原生接口 |

两个入口失败时返回带原始路径、位置、错误码和消息的 `diagnostic`；分配失败通过错误联合返回。它们使用真实 ZX 项目分析、风格检查及类型检查，不接受类型表之外的绑定。

```zig
var parsed = try rx.parseXml(allocator, source);

defer parsed.deinit();

if (parsed.value == .diagnostic) return error.InvalidXml;

var inferred = try rx_analysis.module.infer(allocator, .{
    .owner = "calculate.rx",
    .module = parsed.value.node,
    .sources = zx_sources,
});

defer inferred.deinit();

switch (inferred.value) {
    .contract => |contract| consume(contract),
    .diagnostic => |issue| report(issue),
}
```

当前 module.infer 接受顺序 `Call.fn` 与最后的 `Return`。`module.infer` 使用项目入口处理单个普通模块；有 service 依赖时应传入完整集合。`Call.in` 中的 `$in` 由目标函数的 Input 和字段用途共同约束；`Call.out` 绑定可供后续步骤与 Return 使用。绑定路径不能重叠，也不能覆盖 `$in`；Return 后的步骤拒绝为不可达。输入既未被使用、也没有调用约束时推导为 void，无 Return 时输出为 void。使用输入却没有足够约束时报告无法推导，不默认为动态类型。

数组字面量保留各元素的类型约束，等待目标上下文决定 list 或 tuple；目标仍不明确时才采用同质列表。嵌套数组先默认外层，再将得到的元素类型传回内层，避免把可接受 tuple 上下文的字面量提前固定为 list。空列表没有足够元素类型信息时仍拒绝推导。

对象字段与展开保留覆盖顺序，等待后续调用约束稳定后收束；多个未知展开源可能提供同一必需字段时报告歧义。缺失必需字段、完整对象多余字段和冲突类型拒绝；源值向可选字段赋值沿用 ZX 的包装规则。仅凭 length 不能区分字符串、列表和同名对象字段时也拒绝推导。

`calls[].argument` 与 `result` 是带类型的联结中间片段；其中的合成环境不表达前序调用的真实所有权，不能据此独立执行。`compileForLinking` 将这部分判断延后到流程绑定映射之后；独立 `expression.compile` 仍检查借用环境。完整 `contract.program` 才是经过跨步骤所有权检查的执行入口，owned 结果允许合法消费，借用值和重复消费仍拒绝。

`contract.program` 是可交给现有 Zig 后端的完整 ZX IR Program。生成器按顺序计算参数并执行函数调用，即使未绑定输出也保留调用；Return 使用前面可见的结果。属性表达式通过符号映射内联，保留函数契约、原生引用和源码位置，不深拷贝业务聚合值。完成联结后再次检查整个流程的所有权与 IR。

```zig
const generated = try compiler.zig.emit(allocator, contract.program);

defer allocator.free(generated);

try output.writeAll(generated);
```

包含原生模块时使用 `compiler.zig.emitBundle` 的共享 ABI 输出。包含形式化契约时仍须先完成既有证明流程，生成门禁不会因来自 RX 而放宽。生成的 Zig 模块提供 `Input`、`Output` 与 `execute(arena, input)`，arena 必须覆盖返回聚合值的使用生命周期。

## 项目服务联结

`rx_analysis.project.infer(allocator, options)` 返回与单模块相同的 `Result`，成功时提供入口模块的完整 `contract.program`。options 包含：

| 字段      | 含义                                                 |
| --------- | ---------------------------------------------------- |
| `entry`   | 集合中入口模块的项目相对路径                         |
| `modules` | 完整 `[]rx.ModuleSource`，每项包含真实路径和 XML AST |
| `sources` | 所有 Call.fn 所需的 ZX 源集合及其导入闭包            |
| `project` | 可选的既有 ZX 项目、包和原生接口配置                 |

入口先对整个集合执行 `validateModules`，包括未使用 Import、所有嵌套 service 引用及循环检查。之后为每个模块登记一个输入输出契约，共同收集顺序 Call.fn、Call.service 和 Return 的类型约束，稳定后才生成代码。Import 仅声明依赖，不触发运行。Store、分支、事件及其他流程节点仍明确拒绝。

子模块可以只有 `<Return value="$in" />`，由调用者或下游函数确定其类型。同一个文件在所有调用点共享一个契约，不按调用点生成不同类型的实例；不相容的调用会报错。未读取输入的子模块仍可接收调用者传来的有类型值；无使用、无调用约束的输入才默认为 void。完整集合仍无法确定的类型会报告推导失败。

生成保留顺序调用及跨步骤所有权检查，共享依赖和重复调用均允许。模块的 Return 只结束当前模块。错误位置保留实际来源文件；库不读取文件系统，也不启动生成的程序。使用结束后调用结果的 `deinit()`。

CLI 的 `zxc build workflow.rx --out build/workflow` 从入口递归装载 Import、service 与 ZX 函数依赖，执行项目推导、生成和应用构建，详见 [CLI 使用方式](../../../cli/README.md)。装载保留项目根及物理文件身份检查；`--watch` 同时登记递归依赖。`check-rx --entry` 仍属于结构及目标文件检查，不等同于上述表达式联结和执行验证。

## 当前边界

未知/重复属性、必填项、非空白文本和非法嵌套均报错。除 Field.value 外，显式属性不能是空白字符串。

Gateway 入口已验证 Route 目标文件及其普通模块依赖图，模块 Store 引用已读取并校验定义文件；这些专用流程尚未实现多个 Gateway 的合并、Store 值与 setter 的类型联结、Group 展开冲突、路由输入输出兼容、Store 初值解码或实际执行。普通顺序模块的表达式、函数类型联结与 Return 推导见上节。路由 service 相对 Gateway 文件目录解析，Group.prefix 不影响文件路径。结构检查成功不代表业务执行已经验证。

结构级测试使用 AST 覆盖标签、路径身份、模块组合、递归结构、循环依赖与分配失败。独立文本及运行验证从真实 XML 开始，覆盖顺序模块的类型推导、原始诊断位置和部分生成代码执行；各组证据不替代尚未接入功能的验证。
