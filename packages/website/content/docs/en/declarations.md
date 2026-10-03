Gateway and Store files describe application boundaries. Their structural validation does not start a server, connect a database, or link them to an RX runtime.

### Describe an entry point

```xml
<Gateway name="api" protocol="http" listen=":8080">
  <Group prefix="/orders">
    <Route path="/create" method="POST" service="orders/create" />
  </Group>
</Gateway>
```

Store this declaration in a `*.gateway.rx` file. It has a `Gateway` root, not `Module`.

| Construct | Required          | Optional / accepted values         |
| --------- | ----------------- | ---------------------------------- |
| `Gateway` | `name`            | `protocol`, `listen`               |
| `Group`   | `prefix`          | Nested `Group` or `Route` children |
| `Route`   | `path`, `service` | `method`                           |

Protocols are `http`, `grpc`, `websocket`, `tcp`, and `mqtt`. HTTP methods are `GET`, `HEAD`, `POST`, `PUT`, `DELETE`, `CONNECT`, `OPTIONS`, `TRACE`, and `PATCH`. These accepted tokens describe the declaration contract; they do not demonstrate implemented transports.

### Describe shared data

```xml
<Store name="inventory" version="1">
  <Object name="Stock">
    <Field name="available" type="u64" value="0" />
  </Object>
</Store>
```

Store this in a `*.store.rx` file. `Store.name` and its unsigned 32-bit `version` are required. Each `Object` needs a name. Each `Field` needs `name`, `type`, and `value`; an empty value string is permitted by structural validation.

Field names must be unique within an object, and repeated object declarations cannot introduce the same `Object.Field` identity twice. The validator checks structure; it does not parse field values into runtime objects.

### Reference a Store namespace

An ordinary module can declare a Store with `from` and an optional `as` namespace. That namespace identifies data access, not a service alias. Store path linking is not implemented by the current structural validator; a nonempty `from` is not proof that the file exists or can execute.

Continue with [state and host responsibilities](/docs/state-and-host).
