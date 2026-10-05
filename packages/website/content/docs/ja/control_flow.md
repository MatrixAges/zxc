RX は処理をまとめ、選択します。その中の型付き計算は ZX が担います。ここで示す RX はタグモデルが受け入れる構造の例です。スケジューリングと式の評価は実行ホストが提供する必要があります。

### 一連の処理をまとめる

```xml
<Module>
  <Task name="prepare">
    <Call service="users/load" in={$in.user_id} name="user" />
    <Call fn="quote" in={$in} name="quote" />
  </Task>

  <Return value={ctx.quote} />
</Module>
```

`Task.name` は空にできません。`Task` の直下に別の `Task` は置けません。一貫した責務を持つ処理をまとめ、再利用する境界になったらサービスとして取り出します。

### 独立した処理を記述する

```xml
<Parallel>
  <Call service="users/load" in={$in.user_id} name="user" />
  <Call service="catalog/load" in={$in.item_id} name="item" />
</Parallel>
```

`Parallel` は属性を持たず、子要素には `Task` または `Call` だけを受け入れます。少なくとも一つの子が必要です。並列分岐で、別の分岐の未完了の結果を使わないでください。構造の検証だけでは、実行時に競合しないことは分かりません。

### 分岐を選ぶ

```xml
<Switch on={$in.kind}>
  <Case value={priority}>
    <Call service="orders/priority" in={$in} name="order" />
  </Case>

  <Default>
    <Call service="orders/standard" in={$in} name="order" />
  </Default>
</Switch>
```

`Switch.on` と `Case.value` は必須です。Case の値は一意で、`Default` は最大一つです。`Case` と `Default` の本体は空にできません。読みやすさのため、デフォルト分岐は最後に置くとよいですが、バリデータはその順序を要求しません。

### 戻り値とイベントを明示する

`Return` には `value`、`Emit` には `event` と `value` が必要です。どちらも葉ノードです。イベントの宣言だけでは、購読者、配信保証、バックグラウンドワーカーは作られません。

計算内の分岐には ZX の `if`、早期 `return`、条件式を使います。[ZX リファレンス](/docs/zx-reference)を参照してください。
