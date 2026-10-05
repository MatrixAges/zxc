ZX では、リスト変換と所有権が明示されます。入力コレクションは借用データとして扱い、消費する操作に所有値が必要ならクローンします。

### 汎用ループなしで変換する

```typescript
export type Input = u64[][]
export type Output = u64[]

export default function (in: Input): Output {
  return in.map((row) => row.filter((item) => item > 2).reduce((sum, item) => sum + item, 0))
}
```

`map` と `filter` のコールバックは一引数です。`reduce` は二引数のコールバックと、明示的な累積値の初期値を受け取ります。本体は式でなければならず、外側の値や Store ハンドルをキャプチャできません。インポートした関数は呼び出せます。

### 状態に応じて繰り返す

`loop` は初期状態とインラインの規則を受け取り、同じ型の最終状態を返します。`while` が先に条件を確認し、真の場合に `next` が状態を更新します。

```typescript
const result = loop(initial, {
	while: state => state.remaining > 0,
	next: state => {
		state.remaining -= 1
		state.processed += 1
	}
})
```

`next` の代わりに `do` を使うと、最初に一度更新し、その後で更新済みの状態を判定します。両方を同時には指定できません。条件は `bool` を返し、ステップは更新ブロックで記述します。ブロックではローカルの `const`、`if`、`switch` を使えますが、`return` や Store への書き込みはできません。

コールバックは外側の変数をキャプチャできません。必要なデータは初期状態に含めてください。既存の初期状態の束縛は変更されず、呼び出し後も読み取れます。結果は外側の新しい `const` に束縛します。RX 内の ZX 式でも同じ操作を使えます。`forEach` は提供しません。

コンパイラは通常の Zig ループを生成します。記憶領域の再利用は所有権と別名の解析に依存し、すべての操作が割り当てなしになるわけではありません。詳しい構文と検証範囲は [loop リファレンス（中国語）](https://github.com/MatrixAges/zxc/blob/master/docs/2026-10-06/loop使用参考.md)を参照してください。

### 更新後のリストを引き継ぐ

消費する操作はタプルを返します。結果のリストを新しい名前に束縛し、不要な結果は `_` で捨てます。

```typescript
export type Input = u64[]
export type Output = u64[]

export default function (in: Input): Output {
  const items = clone(in)
  const [with_item, _] = items.push(7)
  const [rest, removed] = with_item.pop()
  const [ordered, _] = rest.sort()
  const [reversed, _] = ordered.reverse()

  return reversed
}
```

消費した後は、古いリストの束縛を再利用できません。別の分岐で元の値を残したい場合は、所有権が分かれる地点でクローンしてください。

### 操作の結果

| 操作                                 | 結果          | 制約                                                      |
| ------------------------------------ | ------------- | --------------------------------------------------------- |
| `push(item)`                         | `[T[], void]` | 元のリストを消費する                                      |
| `concat(items)`                      | `[T[], void]` | 更新後のリストを生成する                                  |
| `pop()`                              | `[T[], T?]`   | 取り除いた値は省略可能                                    |
| `sort()`                             | `[T[], void]` | 数値または文字列の要素のみ。比較関数は指定できない        |
| `reverse()`                          | `[T[], void]` | 並べ替えたリストを返す                                    |
| `splice(start, count, replacements)` | `[T[], T[]]`  | `start` と `count` は `u64`。二つ目の結果は取り除いた要素 |

リストの添字アクセスには境界検査があり、失敗することがあります。範囲外アクセスを、省略可能な値を返す検索として使わないでください。

割り当ての寿命はホストが管理します。リストを返しても、その arena がガベージコレクタへ渡されるわけではありません。[ホストとの統合](/docs/host-integration)へ進んでください。
