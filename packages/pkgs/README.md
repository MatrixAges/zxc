# pkgs

## Intent：最终目标

维护 ZX 包的多版本索引，为 zxc 包管理器提供确定的版本选择和归档完整性信息。

## Data：数据与接口

`index.json` 是仓库维护的索引。顶层包含 `format_version: 1` 和 packages 数组；每个包包含 name、versions，每个版本包含 version、archive、sha256。archive 指定归档来源，sha256 是归档原始字节的 64 位十六进制摘要。初始索引为空，尚无公开发布包。

Zig 模块 `pkgs` 导出 `Index.parse`、`Index.select`、`version.matches` 和 `validName`。parse 结果持有内存，使用后调用 deinit；select 返回的版本借用解析结果中的字符串。

## Edges：约束

拒绝未知字段、重复包名、版本优先级冲突、不合法版本和摘要。选择结果不依赖索引顺序。版本范围支持精确与部分版本、通配、比较符交集、^、~、|| 和连字符区间；预发布版本按比较集合约束。使用严格数字形式，不接受宽松 v 前缀。

索引不执行网络请求或安装。归档内容、清单身份及依赖闭包由包管理器进一步校验。workspace: 保留本地成员语义，不自动回退到索引。

## Answer：构建与使用

在本目录执行 `zig build` 构建独立库，其他 Zig 包通过依赖的 `module("pkgs")` 使用。索引与清单采用不同职责：pkg.yaml 描述一个包，index.json 描述可获取的多个包及多个版本。

安装后的 CLI 使用 `zxc pkg index [index.json]` 查看和校验索引，使用 `zxc pkg resolve <name> <range> [index.json]` 查询最高匹配版本。省略路径时读取 share/zxc/pkgs/index.json。查询命令不下载归档；安装闭环仍在实现。

版本范围参考 [node-semver 的范围定义](https://github.com/npm/node-semver#ranges)，本地协议参考 [pnpm workspace](https://pnpm.io/workspaces)。本包只处理版本与索引事实，不把 JavaScript 包运行模型带入 ZX。
