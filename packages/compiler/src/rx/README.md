# RX

`.rx` 文件的 Zig 语法定义库，基于 `dsl`。支持 XML 文本解析和带源码位置的 AST 校验，输出为强类型数据或诊断；普通 Call.fn/Call.module/Return、Task 和 Switch 已支持生成独立应用；其余流程执行能力见本文边界。

## 构建与测试

```sh
cd packages/compiler
zig build test-rx
```

RX 与 ZX 同属 compiler 包；RX 模块通过 dsl 解析和校验，公开构建模块名为 rx。根目录 zig build test 覆盖 RX 回归。

RX 测试位于 compiler 包的 `tests/rx/`，实现文件不包含内嵌 test。

公共标签实现位于 `src/rx/labels/`，每个标签一个同名 `.zig` 文件，例如 `Call.zig`、`Module.zig`。Gateway 专用标签位于 `src/rx/features/gateway/labels/`，Store 专用标签位于 `src/rx/features/store/labels/`；每个文件同时承载该标签的 Schema 和专属校验。

`flow.zig` 和各 feature 的 `root.zig` 仅聚合导出，公共 API 保持不变。Gateway 的递归子元素适配器位于 `features/gateway/entries.zig`。Store 是专门声明运行时持续存在对象的特殊标签，其定义与引用统一归属 `features/store/labels/`：`Store.zig` 定义 Store 文件根标签，`StoreReference.zig` 定义模块内的 Store 引用。Store 定义支持字段类型、初值表达式与初始化 Program 分析；目标是按实际使用的 Object 生成应用级共享内存状态，无专用运行库；当前已撤除误加的磁盘代码，顺序调用共享 State；独立请求由生成的 Request 管理 arena，成功提交的请求内存由 State 接管，静态独占写入已支持借用结束后的过期区域释放；一般共享值回收与并发仍未实现，见 [Store 设计](../../../../docs/2026-10-05/Store设计.md)。

入口装载模式会读取 Store 引用文件：`from="state"` 相对当前模块目录解析到 `state.store.rx`，`from="state.store.rx"` 使用显式文件名。它验证定义存在、Schema 合法以及字段类型与初值兼容，不按 Store.name 搜索全局对象；`as` 和缺省别名保持既有约定。初值会编译为受检查的初始化 Program；读取定义不执行该程序，也不创建持久对象。

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

## 属性值

属性使用引号或花括号区分值的语义：`value="hello"` 是字符串，`value={expression}` 使用 ZX 表达式。`value="$in"` 返回字符串 `$in`；读取输入应写 `value={$in}`。对象表达式外面仍需属性花括号，例如 `in={{user: $in.user}}`。

RX 属性值只负责数据引用、组装和简单运算，不执行函数或方法调用，也不定义 lambda 或状态更新块；嵌套对象、模板插值和分支中的调用同样禁止。将 loop、集合处理和其他计算放在 ZX 模块中，用 `<Call fn="calculate" in={$in} />` 编排，再通过 `$ctx.calculate` 连接后续步骤。模块组合使用 Call.module。

花括号内部直接使用 ZX 源码，支持对象、列表、比较、逻辑运算、注释和模板，不进行 XML 实体解码或空白归一化；`<`、`&&` 无需写成 XML 实体。引号字符串仍使用标签转义，例如 `&amp;`、`&quot;`。

`Call.in`、`Return.value`、`Switch.on`、`Case.value`、`Emit.value` 和 Store `Field.value` 都使用这一规则。`setter` 写作 `{[store.alias.object]}`，仍只授权一个完整 Store Object。路径、`name` 及 `Field.type` 保持静态引号字符串，不接受动态表达式。Store.version 和 Gateway 字节上限是静态整数配置，使用 `{1}`、`{8192}` 等整数字面量，保留各自范围检查。

Call 使用 in 传参；读取输入写 `in={$in}`，字符串写 `in="$in"`；旧表达式中通过 XML 实体表示的符号需在花括号内恢复为 ZX 符号。无后缀调用保留：`fn="load"` 对应 `load.zx`，`module="orders"` 对应 `orders.rx`，不需要 `.zig`。

## 调用与组合

每个 Module 自身就是流程。可选的 in/out 用于命名推导后的类型契约，不是需要另行提供的类型文件；Schema 入口仅保留名称，`rx_analysis.module.infer` 从函数调用与返回表达式推导顺序模块的实际类型。

`checkout.rx` 可以通过调用多个子模块形成新的模块：

```xml
<Module in="CheckoutInput" out="CheckoutOutput">
  <Call module="users" in={$in.user} />
  <Call module="orders" in={{user:$ctx.users,items:$in.items}} />
  <Emit event="order.created" value={$ctx.orders} />
</Module>
```

父模块再用 `<Call module="checkout" in={$in} />` 调用整个组合模块。Call 的 fn 用于本地 ZX 函数，module 用于本地 RX 模块或依赖包的公开编译模块，两者必须且只能提供一个目标。

Call.fn 相对当前 RX 文件目录解析，省略后缀时补 `.zx`，目标是该文件的默认导出。例如 `fn="load_user"` 指向 `load_user.zx`，也可写相对目录和显式 `.zx` 后缀。入口检查会读取函数及其 ZX 导入闭包，执行现有命名、类型和依赖检查，并拒绝纯类型文件作为函数目标。可使用 `check-rx --entry <file.rx> --project <pkg.yaml>` 指定包与原生接口配置。

Call.module 先匹配当前 RX 文件所属包中已声明的公开模块引用；命中时解析统一库产物，否则按当前文件目录解析本地 RX（可省略 .rx）。本地引用与包引用同名时显式加 ./。`Call.module="package/public-module"` 通过依赖和公开导出解析，不读取库原始 ZX/RX 源码。例如：

```xml
<Module>
  <Call module="shared-counter/advance" in={$in} />
  <Call module="shared-counter/read" />
  <Return value={$ctx.read} />
</Module>
```

module 的 Input 为 void 时可省略 in；非 void 输入省略时在推导阶段拒绝。fn 必须提供 in；本地或编译 module 的输入为 void 时可省略 in。模块输入被推导为 void 时，显式 `$in` 表示编译期单位值，可用于 `in={$in}`，不占用运行时环境字段；void 调用不产生 $ctx 值。已编译 RX 模块保留模块内部声明的 Store 及逐次 Call 授权，与本地 module 调用相同；module 调用不能附加 setter，也不会给调用者提供库内部 Store 的读写句柄。带 Store 的裸事务函数不能作为 module 调用目标，普通 ZX 仍不能隐式调用 Store 函数。应用从库保存的初值生成共享内存状态，按包实例区分身份；再次发布继续保存初值和权限。

上述 check-rx 入口仅做结构与目标检查；`zxc build` 和下述项目推导入口会进一步验证顺序调用的参数、结果及类型兼容性。Store 支持显式授权的源码生成；原生 app 在应用启动时初始化共享内存，以普通 JSON 参数运行；不同进程重新使用初值。

`<Import from="users" />` 是可选的模块组合依赖声明，不接受 as；直接 Call 不必再重复写 Import。Import 本身不表示执行顺序或调用，执行关系由 Call 描述。依赖图同时包含 Import 和 Call.module，要求整个注册集合无环；即使 Import 暂未被调用，也不能形成循环依赖。

事件名不属于同步模块依赖图。Emit 只定义事件发送语法，当前没有实现订阅注册、事件调度或事件反馈环检测。

**无环是项目合法性的硬约束，不提供关闭选项。** 完整模块集合必须通过 `validateModules`，任何自引用、间接环、条件分支里的环或未使用 Import 形成的环都返回诊断，不返回部分合法模块作为成功结果。单文件语法通过不能替代这一项目检查。

遇到看似需要双向调用的业务，按 [AI 消除循环依赖指导](../../../skills/rx/消除循环依赖.md)选择父模块编排、提取共享能力或显式数据传递等方案；完整阅读入口见 [skills](../../../skills/README.md)。

该约束使模块依赖具备拓扑序，适合逐模块分析、测试和推导性质。它保证静态模块调用关系不递归，但不单独证明 ZX 函数终止、事件反馈终止或业务结果正确。测试额外穷举三个模块的全部 512 个有向图，并用独立的拓扑消除算法对照生产 DFS；有限穷举不等同于完整形式化证明。

## 支持的标签

属性默认必填，`?` 表示可以省略。

| 标签       | 属性                                                                   | 直属子标签                                                     |
| ---------- | ---------------------------------------------------------------------- | -------------------------------------------------------------- |
| Module     | `in?`、`out?`                                                          | Import、Store 引用、Task、Call、Parallel、Switch、Emit、Return |
| Import     | `from`                                                                 | 无                                                             |
| Call       | `fn?` / `module?` 二选一、`in?`、`setter?`                             | 无                                                             |
| Return     | `value`                                                                | 无                                                             |
| Task       | `name`、`out?`                                                         | Call、Parallel、Switch、Emit、Return                           |
| Parallel   | 无                                                                     | Task、Call                                                     |
| Switch     | `on`                                                                   | Case、Default                                                  |
| Case       | `value`                                                                | Task、Call、Parallel、Switch、Emit、Return                     |
| Default    | 无                                                                     | Task、Call、Parallel、Switch、Emit、Return                     |
| Emit       | `event`、`value`                                                       | 无                                                             |
| Store 引用 | `from`、`as?`                                                          | 无                                                             |
| Gateway    | `name`、`protocol?`、`listen?`、`max_header_bytes?`、`max_body_bytes?` | Group、Route                                                   |
| Group      | `prefix`                                                               | Group、Route                                                   |
| Route      | `path`、`service`、`method?`                                           | 无                                                             |
| Store 定义 | `name`、`version`                                                      | Object                                                         |
| Object     | `name`                                                                 | Field                                                          |
| Field      | `name`、`type`、`value`                                                | 无                                                             |

共 **16 个不同标签名**，Store 在两种文件上下文中具有不同 Schema。Store 引用中的 as 只沿用原设计的 Store 数据命名空间，不是模块别名；Gateway/Store 的 name 是领域配置名称，也不充当模块注册标识。

Task、Parallel、Switch、Case、Default、Group、Store 定义、Object 均至少有一个子元素。Module 和 Gateway 允许空内容。Task 不能直接嵌套 Task，其他递归嵌套遵循表格。Switch 的 Case 值不能重复，最多一个 Default，不强制 Default 位置。

setter 仅可用于 fn 调用；module 目标的 Store 写入能力由目标模块内部的 fn 调用声明。

protocol 的语法集合为 `http`、`grpc`、`websocket`、`tcp`、`mqtt`；method 为 `GET`、`HEAD`、`POST`、`PUT`、`DELETE`、`CONNECT`、`OPTIONS`、`TRACE`、`PATCH`。这不代表已经实现这些协议的 Runtime adapter。Route.service 也采用文件路径引用语法。

Store.version 为 u32。同一个 Object 的 Field 名不可重复；同名 Object 可声明不同字段，但同一文件的完整 Object.Field 路径不可重复。Field.value 可使用引号字符串或花括号 ZX 表达式；空字符串写作 `value=""`，也可写作 `value={""}`。Field.type 使用 ZX 类型表达式，字段初值通过相同类型与所有权检查，不自动提供动态 map 或未声明的类型别名。

## API 与校验层级

真实 XML 模块集合可使用 `parseModules(allocator, sources)`，其中每个 `TextSource` 包含 `path` 和 `source`。它先解析文本，再调用完整模块集合校验；返回值的 `value` 与 `validateModules` 相同，并通过 `deinit` 统一释放解析和校验结果。解析器复制源码，返回值不借用调用者的文本缓冲区。

`parseXml` 单独返回 `{ node | diagnostic }`；单文件 Gateway/Store 可先解析，再使用 `validate`。调用者应先释放校验结果，再释放 XML 解析结果。

XML 输入支持 UTF-8、XML 1.0 声明、注释、CDATA、单双引号属性、预定义实体和数值字符引用。标签与属性名称限制为 ASCII，不支持命名空间、DTD、自定义实体和通用处理指令；这些输入明确返回语法诊断。位置使用原始字节偏移及一基行、字节列，CRLF 计作一次换行。

`rx.attributeLocation(attribute, decoded_offset)` 可将属性表达式中解码后的字节位置映射回原 XML，涵盖实体引用及 CRLF、换行、制表符归一化。`rx.attributeEndLocation` 提供实体内部范围终点的右侧映射。它使用文本解析器保留的 raw_value；手工 AST 未提供该数据时返回 null。

官方 CLI 的 `zxc check-rx <module.rx> [module.rx ...]` 读取明确传入的完整普通模块集合，检查 XML、Schema 与模块依赖。`zxc check-rx --entry <module.rx>` 则从入口自动装载 Import、所有嵌套 Call.module 和 Store.from 的文件，以包配置所在目录为项目根，未配置包时使用当前工作目录。入口也可以是 `.gateway.rx`：先验证 Gateway Schema，再读取所有嵌套 Route.service 指向的普通模块和依赖；或 `.store.rx`：校验单个 Store 定义。入口模式不扫描无关文件，也不执行流程。显式集合模式仍只接受普通模块，不装载其 Store 定义。

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

跨模块校验包括：重复文件注册、引用越界、目标不存在、自调用、直接/间接循环，以及嵌套控制结构中的 module 调用。共享子模块、菱形依赖和重复调用都允许。诊断包含源文件索引、原始行列位置和具体属性。

单文件 validate 仅负责语法，不能代替完整模块集合的存在性和循环校验。两种入口均采用首错返回。

结果列表及规范化路径由 arena 持有，字符串借用 AST；输入 AST 必须活到结果使用结束。成功和失败都要 deinit，OutOfMemory 通过错误联合返回。

## 模块类型推导

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

当前 module.infer 接受 `Call.fn`、`Return`、Task 分组与 Switch 分支。`module.infer` 使用项目入口处理单个普通模块；有 module 依赖时应传入完整集合。`Call.in` 中的 `$in` 由目标函数的 Input 和字段用途共同约束；Call 返回值通过 `$ctx.<name>` 供后续步骤与 Return 使用。结果名直接取目标文件名（去掉源码后缀）；Call 不接受 name 属性。目标名必须是合法标识符，且不得为保留名 task。Task 返回值通过 $ctx.task.<name> 读取，可以与 Call 同名。绑定路径不能重叠，也不能覆盖 `$in`；Return 或必然返回的分支之后的步骤拒绝为不可达。输入既未被使用、也没有调用约束时推导为 void，无 Return 时输出为 void。使用输入却没有足够约束时报告无法推导，不默认为动态类型。

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

## Task 与 Switch 执行

普通顺序 Task 的 name 作为分组名称，不创建额外服务或并行调度。Task 内顺序执行；Task 和每个 Case/Default 内的 Call 的 $ctx 命名结果只在当前作用域及其子层可见。它们可读取外部绑定，不能覆盖外部路径；兄弟分支可声明相同结果名。没有隐式分支结果合并，需要返回时在各分支显式 Return。Return 结束所在执行边界：模块，或下文定义的直属 Parallel Task。

```xml
<Module>
  <Task name="choose">
    <Switch on={$in.enabled}>
      <Case value={true}>
        <Call fn="calculate" in={$in.value} />
        <Return value={$ctx.calculate} />
      </Case>
      <Default><Return value={$in.value} /></Default>
    </Switch>
  </Task>
</Module>
```

Switch.on 只计算一次，匹配一个 Case 或 Default，无 fallthrough。Default 可以出现在任意位置；没有 Default 且未匹配时继续 Switch 后的步骤。整数与 bool 标签使用花括号字面量；字符串标签写作 `value="ready"`，也可写作 `value={"ready"}`。标签必须是字面量，不能用运行中绑定或算术表达式替代常量；解码后相同的标签也拒绝重复。枚举成员名称尚受 RX 表达式类型命名环境限制，不能因底层 IR 支持枚举 switch 就认为已经提供 RX 枚举导入。

所有分支约束同一个模块 Output。非 void 模块必须在全部路径返回；含 true/false 两个标签的 bool Switch 无需额外 Default。Return 结束当前模块，即使位于 Task 或嵌套 Switch 内也不会仅退出分组。Call.module 的 Return 不结束其调用者。

完整流程仍执行路径敏感所有权及 IR 校验。未选分支不会执行，但其调用目标、类型和依赖仍在编译期检查。可运行材料见 [RX 控制流示例](../../../../docs/2026-10-04/RX控制流/示例/main.rx)。

## Parallel 调用执行

Parallel 的直接 Call.fn、Call.module 和编译模块 Call 可以并行执行。直属 Call 的输入和 Task 捕获参数在父线程按声明顺序计算；Task 内部调用参数随其步骤在工作线程求值。分支不能引用兄弟分支的输出；全部线程结束后，Call 的命名结果一起进入外层作用域，结果名称不得互相重叠。void 调用仍执行，其错误仍传播。直属 Task 分支支持独立多步骤纯计算，通过 $ctx.task.<Task.name> 在汇合后公开返回值；Task 内 Return 仅结束该并行分支，普通顺序 Task 未写 out 时仍作为所在执行边界内的分组。未写 out 和 Return 的分支输出为 void，不产生 $ctx 值；非 void 分支必须覆盖全部返回路径。见 [并行任务参考](../../../../docs/2026-10-05/RX并行任务参考.md)。

Task.out 为可选的花括号表达式，在任务内部步骤结束后求值；例如 `out={{user: $ctx.user, order: $ctx.order}}` 聚合内部调用结果。顺序 Task 在当前流程创建普通局部值，Parallel Task 将其作为分支返回值，均通过 `$ctx.task.<name>` 读取。内部调用仍保持局部作用域。out 必须用表达式语法，字符串输出写 `out={"hello"}`；旧字符串绑定路径不再接受。Task.out 与同一执行边界内的 Return 不能并用，嵌套 Parallel Task 的独立 Return 不受此限制。out 同样禁止内联函数调用、lambda 与状态更新。

分支函数及其可达调用必须不含 Store 能力或原生 external 调用。Call.in 可以在父线程读取显式授权的 Store 快照，再将不可变值传给纯计算分支；这不允许工作线程更新 Store。所有分支共享父请求分配区，通过生成的互斥 allocator 保护分配操作，输出在父 arena 结束前保持有效。普通参数统一不可变借用，纯函数的列表更新产生新结果；多个分支可以共享只读输入。Task 句柄仍只能等待或取消一次，Store 授权与来源生命周期检查仍保留。

全部线程 join 后按声明顺序报告首个分支错误；部分线程启动失败也会等待已经启动的线程。没有取消、串行降级或专用任务运行库。不支持线程的目标在原生构建时拒绝；证明与 FPGA 后端已支持纯 Parallel 的 bool、枚举、定宽整数及受支持的对象、元组，检查全部分支，包括 void 调用；不覆盖操作系统线程启动、锁实现或调度时序。带形式化契约的程序继续经过原有证明门禁，不通过关闭契约来放行。使用方式见 [并行调用参考](../../../../docs/2026-10-05/RX并行调用参考.md)。

## 项目服务联结

`rx_analysis.project.infer(allocator, options)` 返回与单模块相同的 `Result`，成功时提供入口模块的完整 `contract.program`。options 包含：

| 字段      | 含义                                                 |
| --------- | ---------------------------------------------------- |
| `entry`   | 集合中入口模块的项目相对路径                         |
| `modules` | 完整 `[]rx.ModuleSource`，每项包含真实路径和 XML AST |
| `sources` | 所有 Call.fn 所需的 ZX 源集合及其导入闭包            |
| `stores`  | 可选的独立 Store 定义集合，每项为路径与真实 XML AST  |
| `project` | 可选的既有 ZX 项目、包和原生接口配置                 |

入口先对整个集合执行 `validateModules`，包括未使用 Import、所有嵌套 module 引用及循环检查。之后为每个模块登记一个输入输出契约，共同收集 Call.fn、Call.module、Return、Task、Switch 与 Parallel Call/Task 的类型约束，稳定后才生成代码。Import 仅声明依赖，不触发运行。Store 引用独立分析并进入显式调用授权；事件仍明确拒绝。

子模块可以只有 `<Return value={$in} />`，由调用者或下游函数确定其类型。同一个文件在所有调用点共享一个契约，不按调用点生成不同类型的实例；不相容的调用会报错。未读取输入的子模块仍可接收调用者传来的有类型值；无使用、无调用约束的输入才默认为 void。完整集合仍无法确定的类型会报告推导失败。

生成保留顺序调用及跨步骤所有权检查，共享依赖和重复调用均允许。模块的 Return 只结束当前模块。错误位置保留实际来源文件；库不读取文件系统，也不启动生成的程序。使用结束后调用结果的 `deinit()`。

CLI 的 `zxc build workflow.rx --out build/workflow` 从入口递归装载 Import、module 与 ZX 函数依赖，执行项目推导、生成和应用构建，详见 [CLI 使用方式](../../../cli/README.md)。装载保留项目根及物理文件身份检查；`--watch` 同时登记递归依赖。`check-rx --entry` 仍属于结构及目标文件检查，不等同于上述表达式联结和执行验证。

## Store 定义与初始化接口

`rx_analysis.store.analyze(allocator, options)` 接收 `owner`（项目相对 .store.rx 路径）、真实 XML `node` 和可选共享 `types`、`nominal_types`。成功返回 `definition`，失败返回带路径、原始 XML 位置、错误码和消息的 `diagnostic`；结果独立拥有 arena，统一调用 `deinit()`。输入文本及 XML 解析结果可以先释放。

Definition 保存规范化 `source_path`、显示 `name`、`version`、共享类型表和 Object 列表。Object 的身份使用定义文件路径与 Object.name 的组合，不能只按显示 Store.name 合并。一个文件内同名 Object 的不同字段片段会合并；重复字段仍拒绝。

每个 Object 的 `initial` 是可交给 Zig 后端的完整 Program：Input 为 void，Output 为完整 Object。Field.type 按 ZX 类型表达式解析，Field.value 按无外部绑定的 ZX 表达式编译。类型属性不能夹带额外声明、导入或函数；value 不能读取 $in、$ctx 或其他 Store。类型错误、数值越界和未知名称映射回实际 XML 属性。

初始化沿字段声明顺序求值，类型表中的字段顺序不改变求值次序。程序通过所有权和 IR 校验；执行中仍可能返回运算或分配错误。生成后用 `execute(arena, {})` 获取初值，返回引用必须在 arena 存活期内使用。

CLI `check-rx --entry state.store.rx` 以及普通入口装载到的 Store 定义使用上述语义检查。纯 `rx.validate` 仍是 Schema 入口。定义分析本身不执行初始化或提交状态；完整项目推导另行处理 getter/setter，不能从单个定义检查成功推断完整调用已通过。接口和真实生成示例见 [Store 联结实施](../../../../docs/2026-10-04/RX状态联结实施计划.md)。

## Store 调用联结

项目推导的 `stores` 与普通 `modules` 分开传入，CLI 源码生成自动沿 Store.from 装载。定义先进入共享类型表，成功结果的 `contract.store_definitions` 保留各 Object 的初值 Program，供宿主初始化；它们不在每个 Call 中重新执行。

维护者使用分模块后端时，先通过 `compiler.zig.emitModules` 或对应缓存入口生成应用 Bundle，再调用 `compiler.zig.store_initializers.append(&bundle, options)`。options 中的 analysis 必须是生成该 Bundle 的同一份应用分析；initializers 每项提供 `identity`、`schema_version` 与 `program`，分别来自 `store.{source_path}:{Object.name}`、Definition.version 和 Object.initial。可选 cache 与应用使用同一个 GenerationCache。

该接口验证初值与应用的共享类型身份，为每个 Object 增加独立模块，并在 `bundle.store_initializers` 返回物理身份、schema 版本、模块名与 ABI 布局名。每个应用 Store 槽位必须找到同身份、同类型的初值；重复身份、缺失初值与不符合初始化约束的 Program 会被拒绝。Object 的运行值类型为该 ABI 布局的不可变指针。新增结果随 Bundle arena 一并释放。

初值模块名称保持稳定，初值正文进入独立缓存指纹；诊断源码位置不影响 Zig 生成缓存。schema 版本保存在 metadata 中，宿主及构建缓存必须消费该 metadata，不能仅依据初值源码是否变化判断恢复兼容性。本接口只组装生成模块，不执行初值或创建持久状态。`compiler.zig.state.append` 根据应用槽位与初值 metadata 生成具体 `zxc_state` 模块；CLI 原生构建只加入实际引用 Object 的初值模块。

`<Store from="state" as="jobs" />` 相对模块路径读取 state.store.rx，别名省略时取定义的 Store.name。命名空间与 Object 名需要是单个标识符；显示名称不适合作为标识符时使用 as。模块源码使用 `store.jobs.counter`，运行身份使用规范化定义路径与 Object 名。同一文件的不同别名共用一个对象，不同文件的同名 Store 不合并。

```xml
<Module>
  <Store from="state" as="jobs" />
  <Call fn="advance"
    in={{increment: $in, state: store.jobs.counter}}
    setter={[store.jobs.counter]} />
  <Return value={$ctx.advance} />
</Module>
```

getter 仅在 Call.in 可见，允许读取完整 Object 或字段。每次 Call 前读取新的不可变快照，作为普通输入值传递；Return、Switch 或回调不能直接捕获 Store getter。Call 结果固定位于 $ctx 命名空间。

setter 必须列出一个完整 Object；不能列出整个 Store、字段、未声明对象或多个对象。目标 ZX 必须声明 `export default function (in: Input, { store }): Output`，通过 `store.jobs.counter = next` 替换整个对象。该能力只写，不允许读取当前 Store；读取值从 in 获得。普通 ZX import 不继承能力，Call.module 的授权由被调模块自己声明。

成功调用独立提交；后续调用失败不回滚先前提交。编排函数自身不创建覆盖全流程的事务。`zxc module.rx --out flow.zig` 支持生成带显式宿主的源码；宿主提供稳定槽位指针与 commit(pending)，必须保证当前状态及旧快照的内存存活期；如提供 begin(comptime slots)，生成代码会在 Call 输入读取前调用它。Store 的正确生命周期是应用启动时初始化一次，跨调用和请求共享，应用结束后释放，重启使用初值。此前误加的 JSON 快照、文件锁、磁盘版本、恢复及目录同步已移除；Store 不要求可序列化，也不依赖状态目录。

真实 XML、ZX、初始化与宿主执行材料见 [Store 声明示例](../../../../docs/2026-10-04/RX状态联结/真实声明/main.rx)。

## 当前边界

未知/重复属性、必填项、非空白文本和非法嵌套均报错。值属性中的引号内容可为空字符串或空白字符串；路径、名称等静态配置仍执行各自非空限制，花括号表达式不得为空。

HTTP Gateway 已接通 `zxc build main.gateway.rx --out server`。编译时展开 Group、拒绝重叠路由，并将去重后的服务统一链接；每条路由使用自身的 Input/Output 类型，输入为 JSON 请求体，输出为 JSON。void 输入要求空请求体，void 输出为 null。多路由共享一个应用级 Store，每个请求独立管理输入输出内存。服务相对 Gateway 文件目录解析，Group.prefix 不影响文件路径。

省略 protocol 表示 HTTP，listen 默认 `127.0.0.1:8080`，只接受数字 IP 与端口。max_header_bytes 默认 8192、范围 1 至 16777216；max_body_bytes 默认 1048576。当前路由只匹配完整字面路径，query 不参与匹配，不解码百分号；省略 method 表示任意方法，GET 不隐含 HEAD。未匹配路径返回 404，方法不符返回带 Allow 的 405，JSON 错误返回 400，正文过大返回 413，压缩输入返回 415，未知 Expect 返回 417，业务错误返回 500。

当前 HTTP 宿主顺序处理，每个连接仅处理一个请求；不含超时、TLS 服务端、压缩、参数路由、多个 Gateway 合并及其他协议执行。非 HTTP 的 Schema 检查不代表可构建执行。所有写入有静态独占证明时，宿主在请求结束后释放已过期区域；存在持久借用的共享写入仍保留到应用结束，一般共享值的有界回收未完成。Gateway 目前只接受 app 构建，不接受源码输出、verify、fpga 或 `--result discard`。结构检查成功不代表业务执行已经验证。详见 [Gateway 执行参考](../../../../docs/2026-10-05/Gateway执行参考.md)。

结构级测试使用 AST 覆盖标签、路径身份、模块组合、递归结构、循环依赖与分配失败。独立文本及运行验证从真实 XML 开始，覆盖顺序模块的类型推导、原始诊断位置和部分生成代码执行；各组证据不替代尚未接入功能的验证。

## 独立证明与硬件生成

`zxc verify workflow.rx --solver /path/to/z3 --out workflow.smt2` 与 `zxc fpga workflow.rx --out workflow.v` 先完成同一 RX 项目推导，再调用统一后端。证明证据包含实际 RX 文本及 ZX 依赖。纯布尔与定宽整数流程可进入符号模型；Store、动态数据与不支持的调用仍由后端拒绝。`--clocked` 和 `--solver` 沿用硬件入口约定，证明失败不继续生成。详见 [使用参考](../../../../docs/2026-10-05/RX证明与硬件参考.md)。
