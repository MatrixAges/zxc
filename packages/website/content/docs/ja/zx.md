### 明示的な入出力

ZX は TypeScript に似ていますが、JavaScript ではありません。入力と出力の型を宣言し、デフォルト関数をエクスポートします。次の最小例は入力金額をそのまま返します。

```typescript
export type Input = {
  amount: u64;
};

export type Output = {
  amount: u64;
};

export default function (in: Input): Output {
  return { amount: in.amount };
}
```

### 計算の範囲を制約する

現在のコンパイラは、スカラー、オブジェクト、列挙型、オプショナル値、リスト、タプル、ローカル束縛、分岐、ファイルのインポートをサポートします。コレクション操作には、外部変数をキャプチャしない `map`、`filter`、`reduce` があります。

任意のクロージャ、一般的なループ、JavaScript の暗黙変換、実行時の機能インポートが使えると仮定しないでください。数値型には明示的な意味があり、JavaScript の数値動作には依存できません。

### 所有権を明示する

深いコピーが必要なら `clone` を使います。Store へのアクセスには宣言済みのハンドルを使い、読み取りと書き込みの権限は独立しています。ライフタイム、永続化、コミットの動作はホストが管理します。

インストール済みツールチェーンのフォーマッタと診断を使ってください。正確な契約は[コンパイラリファレンス](https://github.com/MatrixAges/zxc/blob/master/packages/compiler/README.md)で確認できます。
