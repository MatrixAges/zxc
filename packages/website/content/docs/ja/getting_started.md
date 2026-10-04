### コンパイラを用意する

現在の導入手順はソースからのビルドです。このリビジョンでは Zig **0.16.0** をインストールし、次を実行します。

```sh
git clone https://github.com/MatrixAges/zxc.git
cd zxc
zig build
zig build zx-example
```

`zx-example` はリポジトリ内の実際の ZX サンプルをコンパイルして実行します。これらはソースを取得した作業ツリーで使うコマンドです。アプリケーションのホストには、別のビルド入口が用意されている場合があります。

### ZX ファイルをコンパイルする

ソースの作業ツリーから実行します。

```sh
zig-out/bin/zxc packages/cli/examples/quote.zx --out /tmp/quote.zig
zig-out/bin/zxc fmt packages/cli/examples/quote.zx --check
```

コンパイルが出力するのは Zig ソースです。完全な RX サービスを実行したり、ランタイムを自動的に用意したりはしません。生成モジュールを Zig ホストに組み込むには、コンパイラのサポートモジュール `zx_runtime` が必要です。

### 境界を選ぶ

計算には ZX、合成の記述には RX を使います。動くサービスを約束する前に、必要な RX 実行と状態管理の振る舞いが対象ホストに実装されているか確認してください。

### 完全な計算を読む

リポジトリの `quote.zx` サンプルは、金額、割引、有効フラグ、浮動小数点係数を明示します。

```typescript
export type Input = {
  amount: u64;
  discount: u64;
  enabled: bool;
  factor: f32;
};

export type Output = {
  amount: u64;
  factor: f32;
};

export default function (in: Input): Output {
  const adjusted_factor = in.factor * 0.5;

  if (!in.enabled || in.discount > in.amount) {
    return { amount: in.amount, factor: adjusted_factor };
  }

  return { amount: in.amount - in.discount, factor: adjusted_factor };
}
```

ガード条件は、割引が金額を超える場合の符号なし減算を防ぎます。係数はどちらの分岐でも半分になります。有効フラグが真で、金額が `100`、割引が `15`、係数が `2.0` なら、期待される結果は金額 `85`、係数 `1.0` です。

これはソースから導いた期待値です。自分の環境での実行を確認するには、リポジトリの実行サンプルを使うか、生成モジュールをホストに接続して上記の入力を渡してください。

### 最初の到達点を確認する

ここまでで、コンパイラのバイナリ、生成された Zig ソース、動作するリポジトリのサンプルが得られます。整形はソースの表記を、コンパイルはプログラムを検査し、ホストでの実行が生成結果を動かします。この三つを分けて確認してください。

次は[ロジックの記述](/docs/write-logic)、続いて [Zig ホストとの統合](/docs/host-integration)へ進みます。
