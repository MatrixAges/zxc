### コンパイラを入手する

現在の手順はソースからのビルドを前提とします。このリビジョン用に Zig **0.16.0** をインストールし、次を実行してください。

```sh
git clone https://github.com/MatrixAges/zxc.git
cd zxc
zig build
zig build zx-example
```

`zx-example` はリポジトリ内の実際の ZX サンプルをコンパイルして実行します。これらはソースのチェックアウト内で使うコマンドです。アプリケーションのホストが別のビルド入口を提供する場合もあります。

### ZX ファイルをコンパイルする

ソースのチェックアウト内で実行します。

```sh
zig-out/bin/zxc packages/compiler/examples/quote.zx --out /tmp/quote.zig
zig-out/bin/zxc fmt packages/compiler/examples/quote.zx --check
```

コンパイル結果は Zig ソースです。完全な RX サービスの実行やランタイムの自動構築は行いません。生成したモジュールを Zig ホストに組み込むには、コンパイラの `zx_runtime` サポートモジュールが必要です。

### 境界を選ぶ

計算には ZX、合成の記述には RX を使います。動作するサービスを約束する前に、必要な RX の実行と状態管理を対象ホストが実装していることを確認してください。
