### モジュールはファイルである

通常の RX ファイルのルートには `Module` を使います。モジュールに `name` を追加したり、`Pipeline` で囲んだりしないでください。業務上の責務に応じてファイルを命名し、分類します。

```text
checkout.rx
users/load.rx
orders/create.rx
```

### 入出力をつなぐ

`checkout.rx` の例です。

```xml
<Module>
  <Call service="users/load" in="$in.user_id" out="ctx.user" />

  <Call
    service="orders/create"
    in="{user:ctx.user,items:$in.items}"
    out="ctx.order"
  />

  <Return value="ctx.order" />
</Module>
```

呼び出し先のファイルはアプリケーション内に実在する必要があります。`service` は呼び出し元のファイルを基準に解決され、通常は `.rx` を省略します。`$in` は現在のモジュールの入力です。`out` は後続の処理で使う結果に名前を付けます。

### 計算を呼び出す

アプリケーションが提供する関数には `Call.fn` を使います。`fn` と `service` は同時に指定できません。直接の `Call` に重複する `Import` は不要です。

並列の処理は、互いの未完了の結果に依存してはいけません。子モジュールがデータ取得のために親を呼び出すのではなく、親が入力として渡します。

これらの例は RX の合成契約を示しています。実行には適切なホストが必要です。
