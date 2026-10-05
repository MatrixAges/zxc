Gateway と Store ファイルは、アプリケーションの境界を記述します。構造検証によってサーバーが起動したり、データベースへ接続したり、RX ランタイムへ結合されたりすることはありません。

### 入口を記述する

```xml
<Gateway name="api" protocol="http" listen=":8080">
  <Group prefix="/orders">
    <Route path="/create" method="POST" service="orders/create" />
  </Group>
</Gateway>
```

この宣言は `*.gateway.rx` ファイルに保存します。ルートは `Module` ではなく `Gateway` です。

| 構造      | 必須              | 任意 / 受け入れる値             |
| --------- | ----------------- | ------------------------------- |
| `Gateway` | `name`            | `protocol`、`listen`            |
| `Group`   | `prefix`          | 入れ子の `Group` または `Route` |
| `Route`   | `path`、`service` | `method`                        |

プロトコルは `http`、`grpc`、`websocket`、`tcp`、`mqtt` です。HTTP メソッドは `GET`、`HEAD`、`POST`、`PUT`、`DELETE`、`CONNECT`、`OPTIONS`、`TRACE`、`PATCH` です。これらは宣言の契約として受け入れる語であり、通信実装が完成している証拠ではありません。

### 共有データを記述する

```xml
<Store name="inventory" version={1}>
  <Object name="Stock">
    <Field name="available" type="u64" value={0} />
  </Object>
</Store>
```

`*.store.rx` ファイルに保存します。`Store.name` と符号なし 32 ビットの `version` は必須です。各 `Object` は名前を持ち、各 `Field` には `name`、`type`、`value` が必要です。構造検証では空の値文字列も許可されます。

フィールド名はオブジェクト内で一意でなければなりません。同じオブジェクトを再度宣言しても、同一の `Object.Field` を重複して導入できません。検査するのは構造であり、フィールド値を実行時オブジェクトに解析するわけではありません。

### Store の名前空間を参照する

通常のモジュールでは、`from` と任意の `as` 名前空間で Store を宣言できます。その名前空間はデータアクセスを識別し、サービスの別名ではありません。現在の構造バリデータは Store のパス結合を実装していないため、`from` が空でないことは、ファイルの存在や実行可能性を証明しません。

続いて[状態とホストの責務](/docs/state-and-host)を読んでください。
