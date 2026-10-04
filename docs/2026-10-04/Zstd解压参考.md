# Zstd 解压参考

## Intent：用途

在 ZX 中解压内存中的 Zstandard 数据。接口为纯计算，不读取文件或网络，不依赖系统 Zstd 动态库。返回新分配的 u8[]。

## Data：接口与示例

```zx
import compression from "std:zlib";
import type { ZstdDecompressOptions } from "std:zlib";

export type Input = ZstdDecompressOptions;

export type Output = u8[];

export default function (in: Input): Output {
  return compression.zstdDecompress(in);
}
```

ZstdDecompressOptions 的字段均必填：

| 字段              | 类型 | 含义                                                        |
| ----------------- | ---- | ----------------------------------------------------------- |
| data              | u8[] | 一个或多个连续 Zstd 帧，可包含 skippable 元数据帧           |
| max_output_length | u32  | 所有帧合计输出的字节上限                                    |
| max_window_length | u32  | 每个压缩帧允许声明的最大窗口字节数，例如 8388608 表示 8 MiB |

最大输出长度可以为零，此时只允许不产生输出的数据。窗口上限独立于输出上限；未知输出长度的帧同样受两个上限约束。窗口缓冲还需要 128 KiB 的解码工作空间，输出列表也有分配器容量开销，因此这两个字段不是进程内存总量承诺。

通过 `zxc build main.zx --out application` 构建后，按普通 CLI 的 JSON Input 协议传入字段。库模式同样支持，生成库可由 ZX 或 Zig module("library") 消费。

## Edges：协议与资源边界

- 支持已知或未知内容长度、连续帧及可跳过帧；仅含可跳过帧时返回空列表。
- 带校验和的帧逐个验证 XXH64 低 32 位；已声明内容长度由解码器核对。
- 空输入、截断、非法块、尾随垃圾、错误校验和或长度不匹配返回错误。
- 超出总输出预算返回 OutputTooLarge；超出窗口预算或底层可表示的窗口范围返回 WindowOversize。
- 当前不支持预设字典；底层也不接受显式字典 ID 字段值为零的帧，返回 DictionaryIdFlagUnsupported。
- 此接口仅解压，不提供 Zstd 压缩、字典训练、流式或 Node.js Streams 兼容接口。既有 gzip/DEFLATE 接口保持不变。

协议依据为 [RFC 8878](https://www.rfc-editor.org/rfc/rfc8878.html)；功能参考 [Node.js zlib](https://nodejs.org/download/release/v26.8.2/docs/api/zlib.html)，并非其 API 的逐项兼容实现。

## Answer：已验证结果

Node 独立生成的空帧、文本、二进制和多块数据经真实 ZX 应用解压后逐字节一致，包含未知长度帧及约 852 KB 输出。连续帧中穿插元数据帧仍正确；坏校验和、截断、尾随垃圾、输出超限、窗口超限被拒绝。发布为 library 后，由 ZX 和独立 Zig 项目再次消费，输出一致。

当前运行证据来自 macOS。结果与实施复核见 [Zstd 解压实施计划](Zstd解压实施计划.md)。
