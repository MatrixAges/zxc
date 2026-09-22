# RX 配置驱动设计文档

> 模块语法更新（2026-09-22）：普通 RX 现以完整文件路径作为唯一模块标识，取消 `Module.name`、`Pipeline` 和模块别名。流程直接放在 `Module` 下，使用 `Call service="users"` 调用同目录的 `users.rx`；跨目录引用按当前文件目录解析。模块组合与直接调用必须无环。下文保留早期设计背景，当前已实现语法及准确边界以 [RX 包文档](../packages/rx/README.md) 为准。

> 目标：用一组有限、稳定、可静态验证的能力，让 AI 通过组合配置、实现领域函数和扩展数据内容，完成开放式需求，而不是不断发明新标签或绕过运行时边界。

## 1. 核心定位

RX 是配置驱动的应用描述语言。

它不负责承载任意业务代码，而是负责描述：

- 模块和 Pipeline；
- 程序级总体配置；
- Gateway 对外接口；
- Pipeline 中的数据流与控制流；
- `.zx` 函数的调用关系；
- 运行时持续对象的结构；
- 运行时允许执行的显式能力。

整个系统分为六层：

| 层                  | 职责                                              | 是否持有状态                   |
| ------------------- | ------------------------------------------------- | ------------------------------ |
| `app.rx`            | 定义程序总体配置，具体字段待定                    | 否                             |
| 特殊 `*.gateway.rx` | 定义 API、RPC、Socket 等对外接口及其 Service 映射 | 否                             |
| 普通 `*.rx`         | Pipeline 编排、分支、并行、事件                   | 否                             |
| 特殊 `*.store.rx`   | 定义可恢复的运行时持续对象                        | 定义状态，实际状态由运行时持有 |
| `*.zx`              | 单次计算、数据转换、数据库 effect 描述            | 否                             |
| Runtime             | 调度、执行 effect、提交 Store、同步快照、恢复     | 是                             |

最重要的边界是：

1. 普通函数无内部状态、无隐藏副作用；每次调用结束后，其局部数据全部销毁。
2. 唯一允许跨调用常驻内存的应用状态是 Store object。
3. Store 由 `*.store.rx` 定义并自动合并，由 Runtime 持有、提交并同步到配置快照，以便停机后恢复内存状态。
4. Store 不是业务数据模型、数据库 schema、实体、DTO 或表映射。
5. 所有 API、RPC、Socket、WebSocket 等对外接口统一由 `*.gateway.rx` 定义并自动合并。
6. `app.rx` 是程序唯一的总体配置入口。
7. 数据库能力在 `.zx` 中使用，不为数据库操作增加 `.rx` 标签。
8. 所有外部副作用都必须是 Runtime 可识别、可限制、可观测的显式 effect。

因此，“函数无副作用”的准确含义是：函数不能自行修改全局状态、文件、Store 或数据库；它只能返回新数据或声明一个受控 effect，真正的状态提交与 I/O 由 Runtime 完成。

---

## 2. 配置驱动与有限能力

RX 的能力集合应当小而稳定。系统的扩展性不来自增加更多语法，而来自三个维度：

- **组合扩展**：用有限语法构造更多 Pipeline、Gateway 接口和并行拓扑；
- **内容扩展**：由 `.zx` 实现新的领域计算，并保持统一的输入输出约束；
- **运行时状态扩展**：通过多个 `*.store.rx` 横向增加必须常驻内存的 Store object，而不改变运行时语义。

AI 可以在这些边界内生成大量业务内容，但不能自行创造新的权限、生命周期或副作用类型。

这使编译器和 Runtime 可以稳定地检查：

- 标签、属性和嵌套是否合法；
- 数据引用是否存在；
- Pipeline 的每条路径是否有有效输出；
- Gateway 自动合并后的监听与路由是否冲突；
- `.zx` 输入输出类型是否匹配；
- Store object 是否冲突；
- effect 是否属于项目允许的能力；
- 数据库和 Store 提交是否可追踪。

原则上，新增业务需求应优先通过“已有 Pipeline 语法的组合 + 新的 `*.gateway.rx` + 新的 `.zx` 内容 + 新的 `*.store.rx`”完成。只有出现无法由现有语义表达的新执行模型时，才考虑扩展语言本身。

---

## 3. 普通 RX 的最小标签集

### 3.1 绝对核心标签

| 标签         | 作用                                          | 必要性 |
| ------------ | --------------------------------------------- | ------ |
| `<Module>`   | 文件级边界，声明模块身份                      | 必需   |
| `<Pipeline>` | 定义一个可执行流程                            | 必需   |
| `<Call>`     | 调用 `.zx` 函数，是业务能力的唯一基础执行节点 | 必需   |

最小合法 Pipeline：

```xml
<Module name="user">
  <Pipeline name="get_user" in="GetUserInput" out="User">
    <Call
      fn="query_user"
      in="{id:$in.id}"
      out="ctx.user"
    />
  </Pipeline>
</Module>
```

这里没有显式返回节点。`ctx.user` 是该执行路径最后一个产生值的节点，因此自动成为 Pipeline 输出。

### 3.2 按场景启用的标签

| 标签         | 作用                         | 使用条件                             |
| ------------ | ---------------------------- | ------------------------------------ |
| `<Return>`   | 显式选择返回值或提前终止     | 自动返回无法准确表达意图时           |
| `<Task>`     | 给一组步骤命名，形成局部边界 | 一个 Pipeline 内存在多个可理解阶段时 |
| `<Parallel>` | 并发执行互不依赖的步骤       | 确实存在可并行节点时                 |
| `<Switch>`   | 按值选择分支                 | 需要条件分流时                       |
| `<Case>`     | 定义一个匹配分支             | 只能出现在 `<Switch>` 内             |
| `<Default>`  | 定义兜底分支                 | 只能出现在 `<Switch>` 内             |
| `<Emit>`     | 发出业务事件                 | 外部订阅者需要接收事件时             |

### 3.3 Module 级 Store 注册

需要访问 Store 的 Module，在根节点内统一注册所需 object：

```xml
<Module name="scheduler">
  <Store from="scheduler" />

  <Pipeline name="next_batch" in="NextBatchInput" out="DispatchRange">
    <!-- Pipeline 中 Call 调用的 .zx 可使用 store.scheduler.dispatcher -->
  </Pipeline>
</Module>
```

这里的 `<Store>` 是 Module 级引用声明，不是执行节点：

- `from` 只填写逻辑 Store 的 `name`，不包含任何前缀或 object 路径；
- 引入后的变量名默认就是 Store 名，例如 `scheduler`；
- `as` 是可选别名；省略时 `from="scheduler"` 通过 `store.scheduler.*` 访问；
- 显式写 `as="jobs"` 时，通过 `store.jobs.*` 访问；
- 一个 Module 可以注册多个逻辑 Store；
- 注册结果对该 Module 内的所有 Pipeline 和 Task 可见；
- 未注册的 Store object 不能通过路径绕过 Module 边界访问；
- 两个被引入 object 的最终变量名相同时产生编译错误，可以通过 `as` 消解冲突。

Runtime 在 Module 初始化时为这些 Store 一次性建立有类型的 getter/setter 表，并为各 Call 预先绑定 `setter` 视图。它们与 Module 同生命周期，属于固定开销；执行 Call 时只传递已有视图的引用，不创建权限表，也不解析字符串路径。

```xml
<Module name="scheduler">
  <Store from="scheduler" />
  <Store from="backup" as="backup_state" />
</Module>
```

### 3.4 对外入口不属于普通 RX

普通 RX 不声明端口、协议、路由或 Socket 事件，也不包含入口根标签。所有对外接口统一放入特殊定义文件 `*.gateway.rx`，由 Gateway 专用语法映射到 Service。

---

## 4. Return 是可选标签

### 4.1 默认返回规则

当一条正常完成的执行路径没有 `<Return>` 时，编译器自动返回该路径最后一个产生值的节点。

产生值的节点包括：

- 带 `out` 的 `<Call>`；
- 有有效结果的 `<Task>`；
- 已完成聚合的 `<Parallel>`；
- 各分支输出类型一致的 `<Switch>`。

`<Emit>` 只产生事件，不替换隐式返回候选值。

如果 Pipeline 声明了非空 `out`，但某条路径没有产生值，则编译失败。编译器不能用 `null`、空对象或其他猜测补齐结果。

### 4.2 必须显式使用 Return 的场景

以下情况应使用 `<Return>`：

1. 返回的不是最后一个计算结果；
2. 需要提前结束当前 Task 或 Pipeline；
3. 需要把多个并行结果显式组装为一个输出；
4. 需要返回输入透传值、常量或错误对象；
5. 多个候选值会导致返回含义不明确。

```xml
<Switch on="ctx.user.status">
  <Case value="banned">
    <Return value="{ok:false, reason:'user_banned'}" />
  </Case>
  <Default>
    <Call fn="build_profile" in="ctx.user" out="ctx.profile" />
  </Default>
</Switch>
```

`banned` 分支显式提前返回；默认分支自动返回 `ctx.profile`。

---

## 5. 数据引用规则

普通 RX 只使用少量固定引用域：

| 引用      | 含义                                                                                 |
| --------- | ------------------------------------------------------------------------------------ |
| `$in`     | 当前 Pipeline 或 Task 的输入                                                         |
| `ctx.*`   | 当前执行上下文中已经产生的数据                                                       |
| `store.*` | 当前 Module 已注册 Store 的 getter；只能在 `in` 中读取，或在 `setter` 中声明写入路径 |
| `$item`   | 并行映射或集合处理中的当前元素                                                       |
| `$error`  | 当前错误处理边界捕获到的错误                                                         |

Store object 只在 Module 根节点注册，不在 `<Call>` 上重复声明。声明会向该 Module 调用的 `.zx` 授予 Store capability：

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

Store 的 getter/setter 具有两种固定入口：

- **getter**：在 `<Call in="...">` 中读取 Object 的不可变快照，并作为普通 Input 字段传入 `.zx`；
- **setter**：在 `<Call setter="[...]">` 中列出可写路径，Runtime 仅把这些路径的只写能力注入 `.zx` 第二参数 `{ store }`。

`setter` 不是 Store 注册；它只引用 Module 初始化时已经建立的 setter。`.zx` 不能导入任何 `.rx` 文件；Store namespace 和 Object 类型由 `zxc` 根据 Module 声明、Call `in` 和 `setter` 联合校验。

Runtime 的执行顺序是：

1. 根据 Module 注册表解析 `store.scheduler.dispatcher`；
2. 按 `in` 映射取得 Object 的不可变快照和版本；
3. 把 Module 初始化时已生成的只写 `store` 视图引用传给 `.zx`；
4. 执行 `.zx`，把新 Object 暂存到对应 setter；
5. 接收 `.zx` 的普通返回值并写入 `ctx.range`；
6. 对 setter 目标执行版本校验、原子替换和快照同步；
7. 任一步骤失败时丢弃本次调用尚未提交的 Store 写入。

`in` 可以读取整个 Object，也可以读取字段，例如 `store.scheduler.dispatcher.cursor`。`.zx` 中的 setter 只能整体替换 Object，不能读取 Store 或直接修改嵌套字段。

一个 `<Call>` 可以读取多个已注册 Store Object，但最多设置一个 Object。需要共同原子更新的字段必须位于同一个 Object；跨 Object 事务不进入基础语义。

---

## 6. `app.rx`：程序总体配置

`app.rx` 是项目唯一的程序级总体配置入口。目前只确定它的文件职责，不定义任何元素、字段、属性或默认值。

在 App schema 正式确定前，本文不假设以下内容：

- 程序身份或版本字段；
- 源码目录和文件发现字段；
- Runtime 参数；
- capability 或权限结构；
- 环境、构建、部署和插件配置；
- 与 `app.gateway.rx`、`app.store.rx` 的显式引用方式。

已确定的边界只有：`app.rx` 不承载 Pipeline、Gateway Route、Store 运行值或业务逻辑，Runtime 也不得把运行数据写回 `app.rx`。其余语法等待后续设计决定。

---

## 7. `*.gateway.rx`：统一对外接口定义

### 7.1 文件定位

`*.gateway.rx` 是 RX 家族中的特殊 XML 定义文件，专门描述进程如何对外提供或接收接口；对外接口统一使用 Gateway 这一概念。

它负责：

- 声明监听地址和协议；
- 定义 HTTP API、RPC、WebSocket、TCP Socket、MQTT 等接口；
- 把请求、消息或连接事件映射到 Service；
- 通过多个文件的自动合并组织大规模接口。

它不负责：

- 编写业务逻辑；
- 直接调用 `.zx`；
- 读取或提交 Store；
- 编写 SQL 或数据库事务；
- 保存 Socket 连接等进程资源。

Gateway 只能把外部输入映射为 Service 的输入，再把 Service 输出编码为协议响应。`service` 属性指向现有的 `<Module>.<Pipeline>`，这里只统一字段名称，不把普通 RX 中的 `<Pipeline>` 标签改名。

### 7.2 文件与自动合并约定

- 默认基础文件名为 `app.gateway.rx`，所在目录的发现规则等待 `app.rx` schema 确定；
- 其他文件名必须匹配 `*.gateway.rx`，例如 `users.gateway.rx`、`orders.gateway.rx`；
- 每个文件定义一个 Gateway fragment；
- `zxc` 自动发现并合并所有 fragment，不需要显式挂载或中央路由表；
- 具有相同 `name` 的 `<Gateway>` 合并为同一个逻辑 Gateway；
- `protocol`、`listen` 等单值属性可以只声明一次；多文件重复声明时必须完全一致；
- 一个逻辑 Gateway 对应一个协议监听接口；
- Gateway 名、监听地址和合并后的最终 Route 在编译期必须无冲突。

推荐目录：

```text
src/
  app.gateway.rx
  app.store.rx
  gateways/
    order_socket.gateway.rx
  users/
    users.gateway.rx
  orders/
    orders.gateway.rx
```

### 7.3 HTTP API 示例

默认基础定义 `app.gateway.rx`：

```xml
<Gateway
  name="public_api"
  protocol="http"
  listen="0.0.0.0:8080"
>
  <Group prefix="/api/v1">
    <Route
      method="POST"
      path="/orders"
      service="order.create_order"
    />
  </Group>
</Gateway>
```

用户领域 fragment `src/users/users.gateway.rx`：

```xml
<Gateway name="public_api">
  <Group prefix="/api/v1/users">
    <Route method="POST" path="/login" service="user.login" />
    <Route method="GET" path="/:id" service="user.get_user" />
  </Group>
</Gateway>
```

`zxc` 按 Gateway `name="public_api"` 自动合并这两个文件。编译后的最终路径包括 `/api/v1/orders`、`/api/v1/users/login` 和 `/api/v1/users/:id`。

### 7.4 Socket 与流式接口示例

`src/gateways/order_socket.gateway.rx`：

```xml
<Gateway
  name="order_socket"
  protocol="websocket"
  listen="0.0.0.0:8081"
>
  <Route path="/orders/connect" service="realtime.connect" />
  <Route path="/orders/message" service="realtime.handle_message" />
  <Route path="/orders/close" service="realtime.disconnect" />
</Gateway>
```

Gateway 的所有请求、连接和消息入口都统一使用 `<Route>`，并通过 `path` 表达协议内的逻辑路径：

- `/orders/connect`：连接元数据和认证信息；
- `/orders/message`：连接标识、消息元数据和 payload；
- `/orders/close`：连接标识和关闭原因。

`path` 是统一寻址字段，由协议 adapter 解释。HTTP 中它是 URL path；WebSocket/TCP 中它是生命周期或消息分发路径；gRPC 中它可以规范化为 `/package.Service/Method`；MQTT 中它是 topic path。

连接、监听器、缓冲区和文件描述符都是 Runtime 拥有的临时资源，不是 Store object，也不会在停机后恢复。只有确实需要跨请求常驻内存并在重启后重建的运行时状态才进入 Store；持久业务数据仍进入数据库。

### 7.5 最小 Gateway 语法

| 概念        | 作用                                     |
| ----------- | ---------------------------------------- |
| `<Gateway>` | 声明一个可自动合并的接口 fragment        |
| `<Route>`   | 用统一 `path` 把外部接口映射到 `service` |
| `<Group>`   | 为一组接口增加公共路径或协议前缀         |

协议由有限的 Runtime adapter 集合提供，例如 `http`、`grpc`、`websocket`、`tcp`、`mqtt`。AI 可以生成任意数量的接口配置，但不能通过填写一个未知协议名获得新的网络能力。

所有协议都使用 `path + service` 作为基础映射。HTTP 可以额外使用 `method`；其他协议的额外约束由对应 adapter 固定定义。未知属性和不完整 Route 在编译期报错。

### 7.6 编译约束

编译器必须完成以下检查：

1. 每个 `<Route>` 的 `service` 指向一个存在的 `<Module>.<Pipeline>`；
2. 协议解码结果与目标 Service 的 `in` 类型兼容；
3. Service 的 `out` 可被协议 adapter 编码；
4. 同名 Gateway fragment 的 `protocol`、`listen` 等单值属性一致；
5. 自动合并和 Group 展开后的最终 `path` 不冲突；
6. 同一 HTTP `path` 可以通过不同 `method` 区分，其他协议遵循对应 adapter 的唯一性规则；
7. Gateway 不能直接引用 `.zx` 函数；
8. Socket 生命周期结束后，Runtime 必须释放全部连接级资源。

---

## 8. `*.store.rx`：运行时持续对象配置

### 8.1 语义边界

Store 专门用于定义这样的对象：

1. 对象必须在进程运行期间常驻内存；
2. 对象需要被多次函数调用连续使用和更新；
3. 对象在停机或崩溃后还需要从配置快照恢复；
4. 对象的生命周期由 Runtime 管理，而不是由某个函数或数据库连接管理。

Store 定义的是“可恢复的内存对象布局和初始值”，不是通用数据模型。不能用 `*.store.rx` 定义：

- 用户、订单、商品等领域实体；
- 数据库表、列、索引和外键；
- API 请求或响应 DTO；
- 只在单次请求中存在的临时数据；
- 仅用于静态启动配置的常量；
- 大规模、需要查询和事务处理的持久业务数据。

数据归属使用以下判定：

| 数据类型                                         | 应放置的位置                        |
| ------------------------------------------------ | ----------------------------------- |
| 单次 Pipeline 执行中的临时数据                   | `$in` 或 `ctx.*`                    |
| 程序级不可变配置                                 | `app.rx`                            |
| 必须常驻内存、跨调用更新、重启后恢复的运行时对象 | `app.store.rx` 或 `*.store.rx`      |
| 领域实体、历史记录、可查询业务数据               | 数据库，由 `.zx` 数据库 effect 操作 |

适合 Store 的典型对象包括调度游标、运行时计数器、限流桶、可恢复任务进度和进程级协调状态。即使某类数据需要持久化，只要它不需要常驻内存并由 Runtime 连续管理，就不应放入 Store。

### 8.2 文件与自动合并约定

`*.store.rx` 是 RX 家族中的特殊 XML 配置文件，但不使用普通 Pipeline 标签语法。

约定如下：

- 默认基础文件名为 `app.store.rx`，所在目录的发现规则等待 `app.rx` schema 确定；
- 其他文件名必须匹配 `*.store.rx`，例如 `scheduler.store.rx`、`rate_limit.store.rx`；
- 一个目录可以包含多个 `*.store.rx`；
- 每个文件定义一个独立的 Store fragment；
- `zxc` 直接按 `Store name` 自动合并所有 fragment；
- 不需要 import、extend 或中央 Store 总表；
- 自动合并后发生完整字段路径冲突时编译失败。

示例目录：

```text
src/
  app.gateway.rx
  app.store.rx
  runtime/
    scheduler.store.rx
    rate_limit.store.rx
    advance_dispatch_cursor.zx
```

### 8.3 XML 定义语法

默认基础定义 `app.store.rx` 可以声明应用级运行时 object，并建立默认 Store 名称与版本：

```xml
<Store name="app" version="1">
  <Object name="lifecycle">
    <Field name="restart_count" type="u64" value="0" />
  </Object>
</Store>
```

调度器状态 `src/runtime/scheduler.store.rx`：

```xml
<Store name="scheduler" version="1">
  <Object name="dispatcher">
    <Field name="cursor" type="u64" value="0" />
    <Field name="in_flight" type="u32" value="0" />
  </Object>
</Store>
```

限流器状态 `src/runtime/rate_limit.store.rx`：

```xml
<Store name="gateway" version="1">
  <Object name="rate_limit">
    <Field name="window_started_at" type="i64" value="0" />
    <Field name="buckets" type="map" value="{}" />
  </Object>
</Store>
```

组合后的逻辑 Store tree：

```text
app
└── lifecycle

scheduler
└── dispatcher

gateway
└── rate_limit
```

最小 XML 语法只有三个元素：

| 概念       | 作用                                                          |
| ---------- | ------------------------------------------------------------- |
| `<Store>`  | 通过 `name`、`version` 声明导入名、自动合并目标与内存布局版本 |
| `<Object>` | 通过 `name` 定义最小读取与原子提交单元                        |
| `<Field>`  | 通过 `name`、`type`、`value` 定义内存状态字段及初始值         |

初始版本只支持可确定序列化的值类型：标量、枚举、列表、定长结构和字符串键 Map。不允许函数、连接、文件句柄、线程、闭包或任意进程资源进入 Store。

### 8.4 横向组合规则

横向扩展遵循以下固定规则：

1. 同名 `<Store>` 的 fragment 合并到同一逻辑 Store；
2. object 的完整路径为 `<store>.<object>`；
3. 每个 object 是独立的版本与提交单元；
4. 同名 object 可以跨文件合并字段，但完整 field 路径不能重复；
5. 新运行时组件通过增加 `*.store.rx` 扩展，不修改中央总表；
6. 删除或修改已有字段属于 Store 内存布局变更，必须提升 `version` 并执行显式迁移；
7. 需要跨状态原子性的字段必须定义在同一个 object 内。

这些规则让多个团队或 AI 可以并行增加状态片段，同时把冲突限定在可静态检查的完整路径上。

### 8.5 持久化与停机恢复

源码中的 `*.store.rx` 定义内存对象布局和初始值。Runtime 为每个 object 维护一份同为 XML 的运行时配置快照。以下只表示建议的内部目录结构，实际根目录如何配置等待 `app.rx` schema 确定：

```text
.zxc/runtime/<store>/<object>.store.rx
```

Runtime 在成功提交 Store object 后：

1. 生成包含最新值、object 版本和 Store 布局版本的新快照；
2. 写入同目录临时文件；
3. 刷新文件内容；
4. 原子替换正式快照；
5. 成功后再确认本次提交完成。

Runtime 启动时：

1. 发现并自动合并源码中的所有 `*.store.rx`；
2. 读取对应运行时配置快照；
3. 校验 store name、Store layout version、object version 和完整性；
4. 使用最近一次完整快照恢复；
5. 没有快照时使用源码定义的初始值；
6. 快照损坏或版本不兼容时拒绝静默启动，并给出明确诊断。

源码配置不在运行时被覆盖。这样既保留配置驱动开发，也避免运行数据污染 Git 工作区；用于恢复的快照仍然是可读、可验证的 `*.store.rx` XML 配置文件。

### 8.6 并发提交

Store object 使用版本化提交：

- `<Call in="...">` 使用 Store getter 取得 Object 的不可变快照及版本；
- `.zx` 通过 Call 授权的完整 Object setter 暂存新状态；
- Runtime 只在版本未变化时提交；
- 版本冲突时，Runtime 可以安全地用新快照重新执行不含其他 effect 的函数；
- 重试超过运行时上限后返回明确冲突错误。

Store 写入在函数成功返回前只是暂存，因此冲突重试不会重复提交状态。数据库 effect 不得与 Store setter 位于同一个 `.zx` 调用中。

---

## 9. `.zx` 函数模型

### 9.1 普通函数

每个 `.zx` 函数遵循统一约束：

- 只有一个业务输入值和一个输出值，二者都不强制为对象；Call 声明 `setter` 时使用固定第二参数 `{ store }`；
- 不允许模块级可变变量、静态缓存或单例状态；
- 不保存连接、会话、文件句柄或后台任务；
- 不直接修改传入数据；
- 调用结束后局部状态全部销毁；
- 没有 Store 或其他 effect 时，相同输入必须得到相同输出。

需要更新 Store 的 `.zx` 从 `in` 读取快照，并使用 Call 授权的只写 `store.*` setter：

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

`.zx` 对 `.rx` 保持零导入依赖。`ctx.*` 和 Store getter 通过 Call `in` 精确传入；只有 `setter` 列出的 Store 写入能力通过第二参数注入。Runtime 负责原子提交和持久化，函数不能直接写入快照文件。

### 9.2 数据库操作

数据库相关语义属于 `.zx`，普通 RX 不感知表、SQL、连接或事务。

数据库连接池和事务由 Runtime 持有。Call 通过 `in` 只传入当前函数需要的 `ctx.db` capability，不使用 `zx:` import：

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

这里的函数返回一份有类型的数据库命令描述，本身不持有连接，也不直接执行 I/O。Runtime 校验 capability 后执行命令，并把结果作为该 `<Call>` 的输出。

数据库能力的基础集合应保持有限，例如：

- `queryOne`；
- `queryMany`；
- `insert`；
- `update`；
- `delete`；
- `transaction`。

更复杂的查询通过这些能力的参数和 `.zx` 组合表达，不为每种数据库需求增加 RX 标签。

数据库是真实的外部持久化系统，不属于 Store。领域实体、交易记录、关系、索引和需要查询的业务数据都由数据库保存，并由 `.zx` 数据库 effect 操作。Store 只保存必须常驻内存、跨调用持续更新，并能通过配置快照恢复的 Runtime object。

---

## 10. 完整示例

```xml
<Module name="order">
  <Pipeline name="create_order" in="CreateOrderInput" out="CreateOrderResult">
    <Task name="validate">
      <Call fn="validate_order" in="$in" out="ctx.validated" />
    </Task>

    <Parallel>
      <Call fn="query_user" in="{id:$in.user_id}" out="ctx.user" />
      <Call fn="query_inventory" in="$in.items" out="ctx.inventory" />
    </Parallel>

    <Call
      fn="create_order_record"
      in="{order:ctx.validated,user:ctx.user,inventory:ctx.inventory}"
      out="ctx.order"
    />

    <Emit event="order.created" value="ctx.order" />
  </Pipeline>
</Module>
```

这个 Pipeline 的行为是：

1. 纯函数校验输入；
2. 并行执行两个由 `.zx` 描述的数据库查询；
3. 由 `.zx` 返回数据库写入 effect，Runtime 创建并返回订单记录；
4. 发出事件；
5. `<Emit>` 不覆盖返回候选，因此 Pipeline 自动返回 `ctx.order`。

订单是需要查询、关联和事务处理的领域实体，因此由数据库保存，而不是定义为 Store object。

---

## 11. 嵌套约束

| 父级                   | 允许的直接子级                                                     |
| ---------------------- | ------------------------------------------------------------------ |
| `<Module>`             | `<Store>`、`<Pipeline>`                                            |
| `<Pipeline>`           | `<Task>`、`<Call>`、`<Parallel>`、`<Switch>`、`<Emit>`、`<Return>` |
| `<Task>`               | `<Call>`、`<Parallel>`、`<Switch>`、`<Emit>`、`<Return>`           |
| `<Parallel>`           | `<Task>`、`<Call>`                                                 |
| `<Switch>`             | `<Case>`、`<Default>`                                              |
| `<Case>` / `<Default>` | `<Task>`、`<Call>`、`<Parallel>`、`<Switch>`、`<Emit>`、`<Return>` |

Module 内的 `<Store from="..." as="..." />` 是可选引用声明；`*.store.rx` 中的 `<Store>` 是 object 定义根节点。两者由所在文件和父级上下文区分。

`*.gateway.rx` 和 `*.store.rx` 使用各自的专用 XML 定义语法，不参与其他普通 RX 嵌套规则。`app.rx` 的定义语法尚未确定。

---

## 12. 明确排除的设计

基础版本不引入以下能力：

- 手动状态读取或写入标签；
- 在 RX 中直接编写 SQL 或数据库事务；
- 在普通 RX 中声明监听端口、API 路由或 Socket 事件；
- 函数级全局变量、单例、静态缓存和隐式会话；
- 在 `<Call>` 上声明 Store object；
- 未经 Module 注册直接访问 `store.*`；
- `.zx` 导入普通 `*.rx`、`*.store.rx`、`*.gateway.rx` 或 `app.rx`；
- 函数自行写入 Store 快照文件；
- 使用 Store 定义领域实体、数据库 schema、DTO 或通用数据模型；
- Runtime 无法识别的任意文件或网络副作用；
- 跨多个 Store object 的基础事务；
- 为每个业务动作创造新的 RX 标签；
- 通过隐式规则猜测缺失的 Pipeline 输出。

历史设计中的业务语义应统一收束到：

- 可计算内容 → `.zx` 普通函数；
- 领域实体、持久记录和数据库操作 → 数据库 + `.zx` 数据库 effect；
- 程序总体配置 → `app.rx`；
- 可恢复的常驻内存对象 → `app.store.rx` + `*.store.rx` + Runtime；
- 执行关系 → 普通 RX；
- API、RPC、Socket 等对外接口 → `app.gateway.rx` + `*.gateway.rx` + Runtime adapter。

---

## 13. 最终核心集合

绝对核心只有 3 个普通 RX 标签：

```text
Module / Pipeline / Call
```

按需控制能力为：

```text
Return / Task / Parallel / Switch / Case / Default / Emit
```

需要 Store 的 Module 使用一个可选的引用声明和固定命名空间：

```text
<Store from="store_name" as="optional_name" />
Call in → Store getter
Call setter + .zx { store } → Store setter
```

对外接口不增加普通 RX 标签，而由另一种特殊定义文件承载：

```text
app.gateway.rx + *.gateway.rx → Gateway / Route / Group
```

需要跨调用并跨重启持续存在的内存对象不增加普通 RX 执行标签，而由特殊 Store 配置文件承载：

```text
app.store.rx + *.store.rx → Store / Object / Field
```

程序总体配置只有一个固定文件名，但内部 schema 尚未定义：

```text
app.rx → program configuration (schema TBD)
```

这套设计把语言表面积限制在稳定范围内，同时为 AI 留出四种开放扩展空间：组合更多 Pipeline、自动合并更多 Gateway 接口、实现更多 `.zx` 内容、自动合并更多互不冲突的 Store fragment。
