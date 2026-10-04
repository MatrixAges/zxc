# 配置 BOM 偏移修复

## Intent：最终目标

带 UTF-8 BOM 的 YAML 与无 BOM 文件使用相同空行规则，格式化保留 BOM，check 和 lint 不漏报多余空行。

## Data：可用证据

测试会话提供 LF 和 CRLF 最小复现及既有配置格式化专项。当前 layout.byteOffsets 把初始 BOM 当成一个 Unicode 字符；仓库绑定的 libyaml reader.c 在编码检测时先跳过 UTF-8 BOM 的三个字节，而 scanner 的字符 mark.index 从正文开始计数。两个坐标系起点不同，导致字段末尾定位到内容内部，间隔检查读到非空白字符后跳过格式化。

## Edges：边界与限制

只修正字符索引到原文偏移的起点，不改变 YAML 语义校验、空行策略、块标量保留或换行编码。仅跳过输入开头的编码 BOM；正文中的 Unicode 字符仍正常计数。原文和输出均保留 BOM。不改测试预期、不增加测试用例、不执行全量测试。

## Answer：交付与成功标准

偏移表从 libyaml 实际扫描的 UTF-8 正文建立，同时保存原文三字节起点。复用反馈中的三份文件检查 fmt、check、lint，运行已有配置格式化专项，并提交推送独立修复。

```mermaid
flowchart LR
 Source[UTF8 原文] --> BOM[识别开头编码 BOM]
 BOM --> Characters[正文字符序号]
 Characters --> Offsets[带原文起点的字节偏移表]
 Offsets --> Layout[字段范围]
 Layout --> Format[既有空行格式化]
```

```mermaid
flowchart LR
 Reader[libyaml reader 跳过 BOM] --> Index[scanner mark.index 从正文计数]
 Index --> Map[偏移表 index 0 对应原文正文起点]
 Map --> Edit[仅编辑字段间空白]
 Edit --> Output[保留 BOM 和换行风格]
```

## 自我复核

缺陷属于解析器坐标系适配错误，不能在 lint 检查结果或具体字段文本上补特例。修复应统一作用于任意 UTF-8 清单，而非只处理 sample/name/version。现有不带 BOM 的输入继续从零字节建立映射。

## 验证结果

根构建 14/14 步通过。现有配置格式化专项 14/14 步通过：manifest 118 项、index 15 项、真实安装锁文件 4 项，以及 JSON 分配失败 2 项均通过；专项包含 BOM 与 Unicode、锚点、块标量、LF/CRLF 的组合。测试文件由独立测试会话维护，本修复没有修改测试。

复用反馈的无 BOM、含 BOM、含 BOM CRLF 三份文件，实际运行 fmt、fmt --check 和 lint 共九次：fmt 均移除多余空行，含 BOM 输出保持 BOM；check 与 lint 均退出 1；原输入字节均未修改。去掉编码前缀并统一换行后，三份 fmt 输出一致。见 [执行结果](配置BOM偏移修复/执行结果.json)。
