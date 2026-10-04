# pkgs

## Intent：最终目标

维护 ZX 包的多版本索引与锁定依赖图，为 zxc 包管理器提供确定的版本选择、归档完整性信息和依赖拥有者边界。

## Data：数据与接口

`index.json` 是仓库维护的索引。顶层包含 `format_version: 1` 和 packages 数组；每个包包含 name、versions，每个版本包含 version、archive、sha256。archive 指定归档来源，sha256 是归档原始字节的 64 位十六进制摘要。初始索引为空，尚无公开发布包。

Zig 模块 `pkgs` 导出 `Index.parse`、`Index.select`、`Lock.parse`、`Lock.validate`、`Lock.workspaceTarget`、`version.matches` 和 `validName`。parse 结果持有内存，使用后调用 deinit；select 返回的版本借用解析结果中的字符串。

`pkg.lock.json` 保存完整锁定图，格式版本为 1。packages 中每个节点包含 name、version、source、dependencies；source 是 workspace 相对目录或 archive 来源及 sha256。每条依赖包含 name、requirement、development、target，target 指向拥有者选定的节点下标。同名不同版本分别拥有节点和源码作用域；工作区根节点位于下标 0。

## Edges：约束

拒绝未知字段、重复包名、版本优先级冲突、不合法版本和摘要。选择结果不依赖索引顺序。版本范围支持精确与部分版本、通配、比较符交集、^、~、|| 和连字符区间；预发布版本按比较集合约束。使用严格数字形式，不接受宽松 v 前缀。

本 Zig 模块不执行网络请求或安装。锁定图拒绝未知字段、重复节点及依赖、非法目标、版本不匹配、循环、超过 256 层的依赖和不可达外部节点。上限为 65536 个包及 262144 条依赖。归档内容、清单身份及当前工作区请求由 CLI 进一步校验。workspace: 保留本地成员语义，不自动回退到索引。

## Answer：构建与使用

在本目录执行 `zig build` 构建独立库，其他 Zig 包通过依赖的 `module("pkgs")` 使用。索引与清单采用不同职责：pkg.yaml 描述一个包，index.json 描述可获取的多个包及多个版本。

CLI 使用 `zxc pkg index [index.json]` 查看和校验索引，使用 `zxc pkg resolve <name> <range> [index.json]` 查询最高匹配版本。省略路径时读取编译进 zxc 的索引，不依赖旁置文件。查询命令不下载归档。

在项目的 pkg.yaml 中声明依赖后执行：

```sh
zxc pkg install --index /path/to/index.json
zxc build src/main.zx --out app
```

完整语法为 `zxc pkg install [pkg.yaml] [--index index.json] [--offline] [--frozen-lockfile]`。命令生成 pkg.lock.json，并在 .zxc/packages 下保存对应锁文件摘要的本机安装映射。应提交锁文件；.zxc 中的绝对缓存路径不适合提交。构建读取已有安装，不自动联网。

当清单请求与已有锁定图一致时，install 重放原版本和摘要，不重新查找最高版本；即使索引已经更新也保留原选择。`--frozen-lockfile` 要求现有锁文件与工作区匹配，并保留其字节和修改时间。`--offline` 只使用已校验的共享缓存，也可从缓存归档恢复解包内容；缓存缺失或损坏会报错。ZXC_CACHE_DIR 可指定绝对缓存目录。

索引的 archive 可为 HTTP(S) 地址或相对于索引文件的本地 tar.gz 路径。包归档根目录需包含 pkg.yaml，名称及版本与索引一致。安装包含本地成员的开发依赖；外部包只安装其运行依赖。包脚本不会执行，应用不能直接导入未声明的传递依赖。

外部包的 ZX 及 zig:/c: 原生声明按包拥有者解析。同名原生接口来自不同包实例时，其声明身份、实现模块和 ABI 视图分别隔离；消费者只能使用自己声明的接口。发布为 library 时，清单保留原生实现所需的 ABI 名称映射，重新打包安装后仍可使用。构建出的 library 也可通过其生成的 build.zig 作为 Zig 模块消费。

原生模块可配置自己的 include_paths，省略时继承包级路径。发布物中的 abi_aliases 保存原生源码使用的名称与包内声明的对应关系，通常由库构建器生成。系统库、外部头文件和不兼容 C ABI 仍属于原生构建环境要求；模块隔离不会消除底层链接冲突。接口格式及示例见 [原生包接口参考](../../docs/2026-10-04/原生包接口参考.md)。

版本范围参考 [node-semver 的范围定义](https://github.com/npm/node-semver#ranges)，本地协议参考 [pnpm workspace](https://pnpm.io/workspaces)。本包只处理版本、索引和锁定图，不把 JavaScript 包运行模型带入 ZX。
