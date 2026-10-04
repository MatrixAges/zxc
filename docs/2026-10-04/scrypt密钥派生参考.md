# scrypt 密钥派生参考

## Intent：用途

使用 std:crypto.scrypt 从密码字节和盐派生指定长度的密钥，算法由 Zig 标准库实现。它是纯计算接口，不生成盐、不访问系统随机源，也不负责密码记录格式或密钥持久化。

## Data：接口

```zx
import crypto from "std:crypto";
import type { ScryptOptions } from "std:crypto";

export type Input = ScryptOptions;

export type Output = u8[];

export default function (in: Input): Output {
  return crypto.scrypt(in);
}
```

所有字段必须显式提供：

| 字段        | 类型 | 含义                                                     |
| ----------- | ---- | -------------------------------------------------------- |
| password    | u8[] | 密码原始字节，不做字符串编码或 Unicode 归一化            |
| salt        | u8[] | 盐的原始字节                                             |
| cost        | u32  | RFC 的 N，必须大于一且为二的幂                           |
| block_size  | u32  | RFC 的 r，正整数                                         |
| parallelism | u32  | RFC 的 p，正整数；这是算法参数，不代表创建同等数量的线程 |
| length      | u32  | 正数，派生密钥字节数                                     |
| max_memory  | u64  | 本次工作缓冲与输出的请求字节预算                         |

构建命令为 `zxc build main.zx --out application`。返回值是新分配的 u8[]，普通 CLI 按现有字节 JSON 协议输出。库模式提供相同算法，Zig 可通过生成的 module("library") 调用。

## Edges：参数、预算与错误

参数还必须满足 `block_size * parallelism < 2^30` 及 `log2(cost) < 16 * block_size`，并受目标平台和 Zig 实现可表示范围约束。参数及整数溢出检查发生在派生前。

当前实现的预算计算为：

```text
requested = 128 * block_size * (cost + parallelism + 2) + length
```

它包含 Zig 算法的三块工作缓冲和返回密钥，不包含借用的输入、栈、分配器元数据等，因此不是进程总内存上限。预算不足或计算溢出返回 MemoryLimitExceeded；实际内存不足仍会返回 OutOfMemory。

cost 非法返回 InvalidCost，r/p 关系非法返回 InvalidParameters，零密钥长度返回 InvalidKeyLength；底层还可能对不可表示的参数返回 WeakParameters。失败时本层擦除并释放已分配的输出；成功结果由调用者持有。底层工作缓冲遵守 Zig 的释放行为，不承诺所有临时密码数据都被擦除。

接口没有隐式默认值。RFC 互操作向量中的低成本参数仅用于验证算法，不能据此推导应用应采用相同成本。协议参见 [RFC 7914](https://www.rfc-editor.org/rfc/rfc7914.html)，功能参考 [Node.js scryptSync](https://nodejs.org/download/release/v24.21.0/docs/api/crypto.html#cryptoscryptsyncpassword-salt-keylen-options)。

## Answer：已验证范围

前三组 RFC 7914 向量和 Node 独立结果一致；二进制输入及 1、31、33、129 字节输出也一致。预算精确达到请求量时成功，少一个字节时拒绝；无效参数及请求量溢出均返回错误。发布后 ZX 与 Zig 消费的输出一致。

macOS 已实际运行；x86 Linux 的 32 位静态可执行文件已交叉编译，但未在 Linux 运行。实施与核验见 [实施计划](scrypt密钥派生实施计划.md)。
