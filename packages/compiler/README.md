# compiler

ZX 源码 → Token → AST → 类型与所有权检查 → IR → genz → Zig。

## Intent：最终目标

提供可独立调用的声明式前端、开放 IR 和 Zig 后端，同时执行命名与 AST 空行门禁。第三方后端只需依赖 frontend 与 zx。

## Data：实现范围

- 纯类型与可执行文件，类型/枚举/默认函数导入，./、../、@/ 路径及导入无环检查。
- number→f64、boolean→bool、Array<T>→T[]；标量、对象、枚举、optional、list、tuple；const、解构、if、switch、match 表达式、return。
- 列表和对象字面量、展开、索引、length、模板、字符串比较、三元与空值回退。
- 无捕获 map/filter/reduce，统一元组返回的消费式列表更新；禁止 clone 深拷贝。
- Call 注入的 `$name.value` Store getter/setter、类型与独立读写权限、暂存与宿主统一提交。
- 显式注册并审查的 zig:/c: 接口与模块成员，保留旧 lib: 兼容；无前缀 ZX 包入口映射；普通项目函数的 Input/Output 类型连接。
- 内建 std:encoding、std:crypto、std:path、std:querystring 与 std:zlib 系列纯计算接口；它们不是完整 Node.js 标准库兼容实现。
- 原生 build、C 头文件桥接、目标与 CPU 配置，以及真实汇编输出。
- 原生模块采用静态编译链接；动态插件与懒加载已按用户决定取消。
- app/lib 构建模式；lib 交付独立 Zig 模块、实际静态源码依赖、ZX 源码与项目配置，不携带 zxc runtime。
- requires/ensures 契约、独立契约 IR 与有限整数子集的 SMT 验证。
- 第三方 IR 的结构、作用域、调用图顺序、所有权与权限检查。

语法通过 Token 组合子声明；表达式优先级集中在 zx 操作符规则表。类型分析和所有权使用独立算法，不把所有阶段伪装成语法配置。

## Edges：边界

数据库按用户要求不实现。没有 JavaScript 隐式转换、Python 大整数、一般闭包、任意循环或运行时 capability import。IR 是实验版 5 的内存 API，没有稳定序列化 ABI。

Store 的实际版本检查、锁、持久化和跨对象原子发布由宿主 commit 实现。编译器不包含完整 RX XML 加载器或生产 Runtime 调度器，不能把生成端的提交接口视为生产持久化已经实现。

ZX 不提供指针类型、取地址或解引用语法。参数、返回值和局部绑定始终使用普通 ZX 类型；聚合值的引用传递及具体存储表示由编译器处理。clone 已删除。

以下为 Zig 宿主集成细节：生成入口使用调用方 Arena，聚合列表元素保存引用槽。新构造数据在 Arena 中分配，所有权移动不递归复制数据。push/concat/splice 为自身操作分配结果列表，pop/reverse/sort 可复用独占存储。新建聚合返回值的所有权摘要已进入 IR，输入借用不能直接消费。原生共享 ABI 和 Store 生命周期还在迁移；调用方必须使输入和 Arena 覆盖所有输出及被保留的 Store 引用。

std:encoding 的 encodeUtf8/decodeUtf8 验证后返回输入的只读视图，不复制内容。Zig 直接消费方不传 allocator，也不释放这两个借用结果；输入存活期须覆盖视图使用期。

std:querystring 使用有序 Entry 列表保留重复键。parse/stringify 使用默认分隔符，parseWith/stringifyWith 接收显式配置；escape/unescape 提供百分号编解码。该模块不提供 JavaScript 对象隐式转换或完整 URL 解析。

std:zlib 提供 gzip/deflate/deflateRaw，输入 u8[]；gzipWith/deflateWith/deflateRawWith 接收 `{ data: u8[]; level: i32; }`，级别为 -1（默认）、0（不压缩）、1–9。gunzip/inflate/inflateRaw 接收 `{ data: u8[]; max_output_length: u32; }`。结果均为新分配字节数组。解压验证容器校验和、gzip 长度及总输出上限，支持连续 gzip 成员，拒绝尾随垃圾。当前不提供流、预设字典、其他压缩参数、Brotli 或 Zstd。

## Answer：使用与验证

仓库根目录：

```sh
zig build
zig build test
zig build zx-example

zig-out/bin/zxc packages/compiler/examples/quote.zx --out /tmp/quote.zig
zig-out/bin/zxc fmt packages/compiler/examples/quote.zx --check

zig-out/bin/zxc build packages/compiler/examples/quote.zx --out .zxc/quote --asm .zxc/quote.s
```

包内 `zig build test` 包含前端、第三方 IR、完整编译分配失败、实际生成 Zig 执行及 Store 宿主契约测试。`zig build test-frontend` 只运行前端测试。

公开模块：

- `dependency.module("frontend")`：parse、analyze、analyzeWithContext、project.analyze、validateIr；只依赖 zx。
- `dependency.module("compiler")`：上述入口加 compile、compileWithContext、compileProject、compileProjectVerified、format、zig.emit。
- `dependency.module("standard")`：普通 Zig 标准算法模块；实际使用 std: 接口的生成模块将它绑定为 `zxc_standard`。普通语言操作直接生成 Zig，不依赖专用运行库。

parse 返回拥有源码副本的 ParseResult，analyze/project.analyze 返回拥有 IR 的 AnalysisResult，分别 deinit。源码可先于 IR 释放。compile/format 返回 source 或 diagnostic，调用 result.deinit(allocator)。

单文件有 import 时必须使用 project 入口；CLI 会加载实际依赖文件。`@/` 相对 project.Options.root_dir；CLI 无配置时使用工作目录，存在 zxc.json 或指定 --project 时使用配置目录。配置的 packages 声明无前缀包的 specifier 与 .zx entry。项目集合的每个 Source 提供 path 与 source，entry 指定入口。函数导入和未使用的类型导入都参与环检测。

Store 使用 compileWithContext 或 project.Options.context.stores，每项声明 handle、path、type_name、readable、writable。生成入口为 execute(arena, input, context)，context 提供对应 slot 的快照指针和 commit(pending)。参考 tests/runtime/store_test.zig。

IR 实验版本 5 将原生模块保存为 `Program.native_modules`，函数通过 `NativeModuleId` 和成员路径数组引用模块，并携带返回所有权摘要。后端按模块表生成并复用导入；旧原始 IR 不再接受。标准库签名来自 standard/interfaces 中的真实 .d.zx 源码，原成员注册表已删除。

原生接口通过 project.Options.native_interfaces 提供声明源码与模块绑定。声明支持类型、枚举及 `export declare function`；allocator 首参数标记和 throws 返回标记显式描述 ABI。CLI 的 native_interfaces 使用 specifier/path/module/namespace，其中 path 指向 .d.zx。旧 externals 仅作为兼容输入保留。CLI 不自动放行任意原生导入。

`compiler.zig.emitBundle(allocator, program)` 提供共享类型生成入口，返回 `source` 与 `types` 两份源码，使用后调用 `bundle.deinit(allocator)`。将 types 注册为同一个 `zxc_abi` Zig 模块，供生成程序与原生模块共同导入。原生模块通过 `@import("zxc_abi").native.@"zig:模块名".类型名` 或 `.函数名.Input/Output` 使用声明类型。原生实现需要显式创建声明中的记录时，通过 `@import("zxc_abi").layouts.@"zig:模块名".类型名` 获取存储布局；函数匿名参数和结果的布局也可从 `InputValue/OutputValue` 获取。此模式直接传递对象/元组引用和数组切片，不执行原生字段转换；CLI app/lib 已接入该入口，生成并链接同一个 ABI 模块；标准库复合参数与结果已使用共享声明类型。原生字段转换路径已删除。CLI 的 --out 在导出原生程序时同时写出 <输出文件>.abi.zig；Zig 消费方须将其注册为共享的 zxc_abi 模块。纯 ZX 导出仍是单文件。只返回单份源码的 emit/compile 接口拒绝原生模块，使用 analyzeProject 与 emitBundle，或向 compileProjectVerified 提供 type_output。可运行示例见 [共享原生类型示例](../../docs/2026-10-03/共享原生类型示例/)。

接口提供 export_name 时，同一 specifier 可声明多个成员，通过默认导入的命名空间调用。CLI 的 zxc.json 可声明 externals 和 native_modules；后者以 path 指定 Zig 文件，或以 header 指定 C 头文件并通过 c 命名空间导出。build 模式会完成对应链接，支持 libraries/include_paths/library_paths。生成的可执行文件接收一个 JSON Input 参数并输出 JSON Output；void Input 不接收参数。

应用 CLI 当前采用 Zig 的默认 JSON 输出约定：`u8[]` 字节构成合法 UTF-8 时输出 JSON 字符串，否则输出整数数组；空字节列表输出 `""`。例如 `[65, 66]` 输出 `"AB"`，`[255]` 输出 `[255]`，嵌套对象中的字节列表也遵循这一规则。消费端应按已知 ZX 输出类型恢复字节：字符串做 UTF-8 编码，数组逐项校验为 0–255 的整数后转换。字符串不是 Base64，不应按 UTF-16 字符码恢复。这只影响 CLI 的 JSON 表示，std:zlib 等接口的 ZX 返回类型和内容仍为字节列表。

`std:path` 按编译目标 OS 选择路径风格，`std:path/posix` 与 `std:path/win32` 固定风格。提供 isAbsolute、basename、dirname、extname、parse、format、normalize、join、resolve、relative；join 接收 string[]，resolve 接收 `{ cwd: string; paths: string[]; }`，relative 接收 `{ cwd: string; from: string; to: string; }`。不读取进程 cwd 或盘符环境。Windows 比较目前仅提供 ASCII 大小写折叠；其他差异和实际调用见 [路径标准库实施](../../docs/2026-10-03/路径标准库实施.md)。

`std:crypto` 提供 sha256/sha512；hmacSha256/hmacSha512 与 verifyHmacSha256/verifyHmacSha512；hkdfSha256/hkdfSha512；pbkdf2Sha256/pbkdf2Sha512；encrypt/decryptAes128Gcm、encrypt/decryptAes256Gcm、encrypt/decryptChaCha20Poly1305，以及 timingSafeEqual。所有密码材料和数据使用 u8[]，具体字段与错误见 [密码学标准库实施](../../docs/2026-10-03/密码学标准库实施.md)。密钥和 nonce 由调用方显式提供，同一密钥下 nonce 必须唯一。解密认证失败返回错误，不输出明文；时序安全比较只约束比较原语，不代表整个应用具有恒定执行时间。

native_modules 仅接受 path 或 header，动态 library 入口已取消。旧动态插件实施文档只保留历史证据，不代表当前功能。

`zxc build <source.zx> --out program` 支持 `--asm program.s`、`--target triple`、`--cpu features`、`--optimize Debug|ReleaseSafe|ReleaseFast|ReleaseSmall`。默认 ReleaseSafe。PATH 中需提供兼容 Zig；使用 std: 模块时从 share/zxc/standard 定位普通静态源码。汇编生成不代表超级优化或形式化正确性证明已经完成。

`--mode app` 是 build 的默认模式。`zxc build <source.zx> --mode lib --out directory` 交付源码模块包：root.zig 导出 Input/Output/execute，build.zig 注册名为 library 的 Zig 模块，native/ 保存引用的静态源码依赖，interfaces/ 保存项目原生声明，source/ 保存重写为内部相对导入的 ZX 源码，zxc.json 提供默认 library 包映射。ZX 消费方可使用该配置导入 library；合并多个库时将对应入口与原生声明合并到消费方配置。Zig 消费方可从本地 build 依赖获取 module("library")。目标和优化由消费方构建选择，lib 模式不接受 app 的汇编、target、cpu、optimize 参数。

lib 会按真实 Zig AST 复制 native.path 的文件导入与字面量嵌入资源，保留模块内目录布局并使用包内路径；计算资源路径需在 native_modules.bundle_files 声明模块根目录相对文件，清单会标记其未获静态闭包证明。C 搜索目录与系统链接库仍属于外部依赖，不因 Zig 源码已打包而获得完整可迁移保证。没有独立 C ABI 或动态库导出入口。详情见 [原生库依赖打包实施](../../docs/2026-10-03/原生库依赖打包实施.md) 与 [库构建实施](../../docs/2026-10-03/应用与库构建实施.md)。

`zxc verify <source.zx> --solver /path/to/z3 --out query.smt2` 生成并实际求解契约与安全义务，保存源码、类型、输入映射和结果。前提必须 sat，违例必须 unsat；其他结果均不返回证明成功。当前支持定宽整数、bool、静态对象/元组和分支，支持有界深度的无环纯 ZX 函数调用，拒绝外部调用、Store、浮点及动态集合。成功结论覆盖入口前提下的受支持执行路径及实际调用，不代表未调用模块的独立契约已经获证。CLI 遇到契约时使用同一份 IR 重新求解并生成代码，运行时顺序检查 requires；可在生成/build 时用 --solver 指定工具。无 I/O 的 compileProject 与 zig.emit 仍拒绝未经验证的契约；详见 [契约验证证据](../../docs/2026-10-03/契约验证实现与证据.md)。

输出 Zig 模块不依赖 zx_runtime。纯函数执行形态：

```zig
var arena = std.heap.ArenaAllocator.init(backing_allocator);

defer arena.deinit();

const output = try generated.execute(&arena, input);
```

完整数值和所有权契约见 [ZX IR 契约](../zx/IR契约.md) 与 [语言设计](../../docs/zx_design_doc.md)。

### FPGA 计算内核

`zxc fpga <source.zx> --out kernel.sv` 生成组合 SystemVerilog 和 `kernel.sv.json` 端口、源码及硬件图清单。`--clocked` 增加单级输出寄存器和 ready/valid 背压接口，使用同步高有效 reset；接受输入后在该时钟沿更新输出，背压期间保持数据及 fault。无停顿时每周期可接受一个输入。含契约的程序必须通过本次真实求解，可用 `--solver` 指定 Z3。

当前支持 bool、固定宽度整数、静态对象/元组、分支、短路和无环纯 ZX 调用。fault 表示输入前提或运算安全义务失败，此时输出数据不可使用。动态集合、浮点、Store、外部调用和插件不属于硬件子集。符号模型使用共享定义，硬件节点保留首次创建的表达式来源；控制流合成节点的 span 为零，不表示精确源码定位。

已完成通用逻辑综合检查；尚无具体器件映射、布局布线、工作频率或板级测量结论。单级寄存器接口不代表内部逻辑自动流水化。
