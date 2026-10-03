CLI は ZX から Zig へのコンパイルと、ZX ソースの整形を行います。リポジトリからビルドすると `zig-out/bin/zxc` が得られます。バイナリを `PATH` に追加した場合は `zxc` として実行できます。

### コンパイル

```sh
zig-out/bin/zxc packages/compiler/examples/quote.zx --out /tmp/quote.zig
```

| 引数           | 意味                        |
| -------------- | --------------------------- |
| 入力パス       | 入口となる `.zx` ファイル   |
| `--out <path>` | 生成する Zig ソースの保存先 |
| `--help`       | CLI の使い方を表示          |

コンパイルにはインポート解析と意味検査が含まれます。出力は Zig ソースであり、実行ファイル、Web サーバー、デプロイ用パッケージではありません。ホストに組み込む際は、生成コードの `zx_runtime` インポートを解決してください。

### 整形

```sh
zig-out/bin/zxc fmt packages/compiler/examples/quote.zx
zig-out/bin/zxc fmt packages/compiler/examples/quote.zx --check
zig-out/bin/zxc fmt packages/compiler/examples/quote.zx --write
```

| モード     | 効果                                                |
| ---------- | --------------------------------------------------- |
| フラグなし | 整形したソースを標準出力へ表示                      |
| `--check`  | 元のソースと整形結果を比較。ステータス 1 は差分あり |
| `--write`  | 元のファイルを整形結果で置き換える                  |

既存の検証フローにはチェックモードを使い、ソースを書き換える意図があるときだけ書き込みモードを使います。

### パスと環境

相対インポートはインポート元ファイルから、`@/` は CLI の作業ディレクトリから解決します。ローカルと自動化で同じ意味になるよう、意図したプロジェクトルートから実行してください。

### 存在しないコマンド

この CLI に汎用の `zxc run`、`zxc check`、`zxc watch`、`zxc server` はなく、RX XML の実行コマンドもありません。`zig build zx-example` はリポジトリのビルドステップであり、zxc のサブコマンドではありません。

続いて[診断](/docs/troubleshooting)または [Zig ホストとの統合](/docs/host-integration)を読んでください。
