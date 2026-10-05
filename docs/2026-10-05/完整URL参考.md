# URL 标准库参考

## Intent：最终目标

通过 `import url from "std:url"` 解析与序列化 URL，解析相对地址，读取来源并转换域名及文件路径。底层为静态 Zig 实现，不依赖 JavaScript 引擎。

## Data：接口与依据

接口定义位于 packages/compiler/standard/interfaces/url.d.zx。行为参考 [WHATWG URL](https://url.spec.whatwg.org/) 和 [Node.js URL](https://nodejs.org/api/url.html)，查询参数列表由独立的 [std:url/search_params](URL查询参数参考.md) 提供。

```typescript
import url from "std:url"

export type Input = { input: string, base: string? }

export type Output = string

export default function (in: Input): Output {
  return url.stringify(url.resolve(in))
}
```

## Edges：边界与限制

ZX 使用有效 UTF-8 字符串与不可变 Url 记录。公开 parse/resolve 返回完整、独立持有字段的记录；不暴露内部临时 arena。allocator 由编译器传入，普通 ZX 调用不手写 allocator。

Url 的 query/fragment 不包含问号或井号。null 表示缺失，空字符串表示存在但为空；stringify 保留这一区别。host 已规范化，IPv6 包含方括号，port 为数字或 null，默认端口被省略。path 是编码后的路径段；opaque_path 非 null 时使用不透明路径，path 不参与序列化。不要把未经组件编码和校验的普通字符串当成已解析记录来拼装。

域名遵循当前 WHATWG 规则：非 ASCII 输入经过 Unicode 18.0.0 IDNA 映射与校验；纯 ASCII 域名按兼容规则小写，某些无效 ACE 仍被保留。这可能与旧版本 Node 不同。domainToASCII/domainToUnicode 在主机输入无效时返回空字符串，分配失败仍抛错。

文件转换必须显式选择 Platform.Posix 或 Platform.Windows。pathToFileURL 还要求显式绝对 cwd；Windows 的 cwd 必须包含盘符或 UNC 设备，不隐式读取每盘符环境目录。文本反向转换严格解码，字节反向转换可返回非 UTF-8，并保留不完整百分号序列。

当前公开接口尚未提供 URL 字段编辑、可选格式化及 HTTP options 转换；浏览器 Blob 注册表和旧版 Node URL API 不由这里模拟。不可据此认为所有 Node URL 功能已完整交付。

## Answer：类型与操作

```typescript
export type Url = {
	scheme: string
	username: string
	password: string
	host: string?
	port: u16?
	path: string[]
	opaque_path: string?
	query: string?
	fragment: string?
}

export type Resolve = { input: string; base: string? }

export enum Platform {
	Posix,
	Windows
}

export type FilePath = { path: string; platform: Platform; cwd: string }
export type FileUrl = { url: Url; platform: Platform }
```

| 操作            | 输入     | 返回   | 语义                            |
| --------------- | -------- | ------ | ------------------------------- |
| parse           | string   | Url    | 解析绝对 URL，失败抛错          |
| resolve         | Resolve  | Url    | 使用可选基地址解析，失败抛错    |
| tryParse        | Resolve  | Url?   | 无效地址返回 null；不吞分配错误 |
| canParse        | Resolve  | bool   | 是否可以解析；不吞分配错误      |
| stringify       | Url      | string | 序列化全部组件                  |
| pathname        | Url      | string | 序列化路径                      |
| origin          | Url      | string | 来源字符串或 null 字面文本      |
| domainToASCII   | string   | string | 主机规范化为 ASCII              |
| domainToUnicode | string   | string | 规范化后显示 Unicode 域名       |
| pathToFileURL   | FilePath | string | 显式平台和 cwd 下构造 file URL  |
| fileURLToPath   | FileUrl  | string | 严格解码为平台文件路径          |
| fileURLToBytes  | FileUrl  | u8[]   | 解码为原始文件路径字节          |

导入公开类型使用 `import type { Url, Platform } from "std:url"`。枚举值写作 `Platform.Windows`，不使用 `url.Platform.Windows`。

应用示例见 [main.zx](完整URL/应用/main.zx)，输入见 [input.json](完整URL/应用/input.json)。示例调用全部 12 个入口。构建和发布：

```sh
zxc build docs/2026-10-05/完整URL/应用/main.zx --out /tmp/zxc_url_app

zxc build docs/2026-10-05/完整URL/应用/main.zx --mode lib \
  --out docs/2026-10-05/完整URL/ZX消费者/library

zxc build docs/2026-10-05/完整URL/ZX消费者/main.zx --out /tmp/zxc_url_consumer

zig build --build-file docs/2026-10-05/完整URL/Zig消费者/build.zig
```

三种入口都以单个 JSON 命令行参数接收示例输入。[应用输出](完整URL/应用/运行结果.json)、[ZX 消费输出](完整URL/ZX消费结果.json)和 [Zig 消费输出](完整URL/Zig消费结果.json)一致。发布库由上述命令生成，不将其标准库源码副本纳入版本管理。

## 自我复核

实际应用与两种库消费证明公开类型、原生签名及发布依赖可以联结；这不是全规范一致性证明。记录复制采用逐字段错误清理，避免返回已释放临时 arena 的切片。剩余 URL 能力与自举目标仍保留在实施计划中。
