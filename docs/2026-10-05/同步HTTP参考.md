# 同步 HTTP 参考

## Intent：最终目标

`std:http.request` 提供 HTTP/HTTPS 的同步单次请求，供 ZX/RX 应用和发布库使用。功能参考 [Node.js HTTP](https://nodejs.org/api/http.html)，不依赖 Node.js 运行环境。

## Data：接口

```zx
import type { Options, Response } from "std:http"
import http from "std:http"

export type Input = Options

export type Output = Response

export default function (in: Input): Output {
  return http.request(in)
}
```

Options 字段：url:string、method:Method、headers:Header[]、body:u8[]?、max_body_bytes:u64、max_header_bytes:u64。Method 包含 Get、Head、Post、Put、Patch、Delete、Options。Header 是 name:string 与 value:u8[]；值采用字节以保留 HTTP 非 UTF-8 内容，重复项保持独立。

Response 字段：status:u16、headers:Header[]、body:u8[]。4xx/5xx 仍是正常响应，网络、协议、上限与输入错误会抛出。结果独立分配在调用者 allocator；退出请求后不会借用连接缓冲。

## Edges：边界与限制

- 请求头必须为合法 token 名称与合法 HTTP 值字节。Host、Content-Length、Transfer-Encoding、Connection、Expect、Upgrade 由实现管理，不能通过额外头设置。
- Post/Put/Patch 可提供正文；body=null 时发送空正文。其他列出的方法不支持请求体，这是当前 Zig 发送路径限制，并非声明 HTTP 协议普遍禁止 DELETE body。
- max_header_bytes 支持 1..16MiB，累计临时与最终响应头的原始字节，max_body_bytes 限制实际正文；超限报错，不截断。
- HEAD、204、304 返回空正文；100/103 等临时响应继续接收最终响应。101 升级不支持。
- 不自动跟随重定向或解压 Content-Encoding；传输编码由 Zig HTTP reader 处理。正文是内容编码后的原始字节，头值不做 UTF-8 转码。Zig 不支持的编码与协议会返回错误。
- HTTPS 使用系统证书验证，不提供关闭校验选项。URL 禁止内嵌用户密码，认证通过显式请求头提供。
- 不共享连接池，不自动重试，没有代理配置或内置时间上限。大小上限不等于超时；同步等待仍受宿主 Io 控制。
- 这不是事件流、Server、WebSocket、HTTP/2 或完整 Node HTTP API。

## Answer：交付与验收

实现职责与验证记录见[实施计划](同步HTTP实施计划.md)。当前平台已通过本地协议请求、正文与头上限、重复头与字节保留、错误清理、ZX/Zig 发布库消费及受信任 HTTPS 请求。Windows x86_64 交叉构建通过，但未在 Windows 执行。
