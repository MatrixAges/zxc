Gateway 和 Store 文件描述应用边界。结构校验不会启动服务器、连接数据库，也不会把它们链接到 RX 运行时。

### 描述入口

```xml
<Gateway name="api" protocol="http" listen=":8080">
  <Group prefix="/orders">
    <Route path="/create" method="POST" service="orders/create" />
  </Group>
</Gateway>
```

将此声明放在 `*.gateway.rx` 文件中，根节点是 `Gateway`，不是 `Module`。

| 结构      | 必填              | 可选 / 接受的值                  |
| --------- | ----------------- | -------------------------------- |
| `Gateway` | `name`            | `protocol`、`listen`             |
| `Group`   | `prefix`          | 嵌套的 `Group` 或 `Route` 子节点 |
| `Route`   | `path`、`service` | `method`                         |

协议包括 `http`、`grpc`、`websocket`、`tcp` 和 `mqtt`。HTTP 方法包括 `GET`、`HEAD`、`POST`、`PUT`、`DELETE`、`CONNECT`、`OPTIONS`、`TRACE` 和 `PATCH`。这些被接受的标记描述的是声明契约，并不能证明对应传输已实现。

### 描述共享数据

```xml
<Store name="inventory" version={1}>
  <Object name="Stock">
    <Field name="available" type="u64" value={0} />
  </Object>
</Store>
```

将此声明放在 `*.store.rx` 文件中。`Store.name` 和无符号 32 位的 `version` 必填。每个 `Object` 需要名称，每个 `Field` 需要 `name`、`type` 和 `value`；结构校验允许 `value` 是空字符串。

同一对象内字段名必须唯一，重复的对象声明也不能再次引入同一个 `Object.Field` 身份。校验器检查的是结构，不会把字段值解析为运行时对象。

### 引用 Store 命名空间

普通模块可以用 `from` 与可选的 `as` 命名空间声明 Store。该命名空间标识数据访问，不是服务别名。当前结构校验器没有实现 Store 路径链接；`from` 非空，不代表文件存在或可以执行。

继续阅读[状态与宿主职责](/docs/state-and-host)。
