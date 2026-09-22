# RX

`.rx` 文件的 Zig 语法定义库，基于 `dsl`。输入为带源码位置的 XML AST，输出为强类型数据或诊断；XML 解析和 Runtime 执行由上游、下游分别负责。

## 构建与测试

```sh
cd packages/rx
zig build
zig build test
```

根目录 `zig build` 编译正式包，`zig build test` 运行 RX 测试。两个包均有自己的 `build.zig` 和 `build.zig.zon`；根通过 `b.dependency` 接入，rx 通过 `../dsl` 依赖 dsl。

所有测试位于与 `src` 同级的 `tests/`，实现文件不包含内嵌 test。

公共标签实现位于 `src/labels/`，每个标签一个同名 `.zig` 文件，例如 `Call.zig`、`Module.zig`。Gateway 专用标签位于 `src/features/gateway/label/`，Store 专用标签位于 `src/features/store/label/`；每个文件同时承载该标签的 Schema 和专属校验。

`flow.zig` 和各 feature 的 `root.zig` 仅聚合导出，公共 API 保持不变。Gateway 的递归子元素适配器位于 `features/gateway/entries.zig`。`labels/Store.zig` 定义 Store 引用，`features/store/label/Store.zig` 定义 Store 文件根标签，两者通过目录区分。

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

每个 Module 自身就是流程。可选的 in/out 声明其类型契约，当前保留为字符串，不做 ZX 类型联结。

`checkout.rx` 可以通过调用多个子模块形成新的模块：

```xml
<Module in="CheckoutInput" out="CheckoutOutput">
  <Call service="users" in="$in.user" out="ctx.user" />
  <Call service="orders" in="{user:ctx.user,items:$in.items}" out="ctx.order" />
  <Emit event="order.created" value="ctx.order" />
</Module>
```

父模块再用 `<Call service="checkout" in="$in" out="ctx.result" />` 调用整个组合模块。Call 的 fn 用于 ZX 函数，service 用于 RX 模块，必须且只能提供一个目标。

`<Import from="users" />` 是可选的模块组合依赖声明，不接受 as；直接 Call 不必再重复写 Import。Import 本身不表示执行顺序或调用，执行关系由 Call 描述。依赖图同时包含 Import 和 Call service，要求整个注册集合无环；即使 Import 暂未被调用，也不能形成循环依赖。

事件名不属于同步模块依赖图。Emit 只定义事件发送语法，当前没有实现订阅注册、事件调度或事件反馈环检测。

**无环是项目合法性的硬约束，不提供关闭选项。** 完整模块集合必须通过 `validateModules`，任何自引用、间接环、条件分支里的环或未使用 Import 形成的环都返回诊断，不返回部分合法模块作为成功结果。单文件语法通过不能替代这一项目检查。

遇到看似需要双向调用的业务，按 [AI 消除循环依赖指导](../skills/rx/消除循环依赖.md)选择父模块编排、提取共享能力或显式数据传递等方案；完整阅读入口见 [skills](../skills/README.md)。

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

跨模块校验包括：重复文件注册、引用越界、目标不存在、自调用、直接/间接循环，以及嵌套控制结构中的 service 调用。共享子模块、菱形依赖和重复调用都允许。诊断包含源文件索引、原始行列位置和具体属性。

单文件 validate 仅负责语法，不能代替完整模块集合的存在性和循环校验。两种入口均采用首错返回。

结果列表及规范化路径由 arena 持有，字符串借用 AST；输入 AST 必须活到结果使用结束。成功和失败都要 deinit，OutOfMemory 通过错误联合返回。

## 当前边界

未知/重复属性、必填项、非空白文本和非法嵌套均报错。除 Field.value 外，显式属性不能是空白字符串。

未实现 XML 解析、Gateway/Store 跨文件合并、Route 目标注册联结、Group 展开冲突、ZX 输入输出兼容、表达式解析、Store 初值解码、自动返回分析或实际执行。本文的语法检查成功不代表业务执行已经验证。

测试使用合成 AST，覆盖全部标签、路径身份、模块组合、递归结构、错误定位、循环依赖及内存分配失败；不覆盖 XML 文本到 AST 的解析链。
