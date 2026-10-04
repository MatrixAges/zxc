# compiler

ZX 源码 → Token → AST → 类型与所有权检查 → IR → genz → Zig。

## Intent：最终目标

提供可独立调用的声明式前端、开放 IR 和 Zig 后端，同时执行命名与 AST 空行门禁。第三方后端依赖 compiler 的 frontend 模块与 core 数据模型。RX/ZX 语言实现在 src/rx、src/zx；命令与系统交互位于独立 cli 包。

## Data：实现范围

- 纯类型与可执行文件，类型/枚举/默认函数导入，./、../、@/ 路径及导入无环检查。
- number→f64、boolean→bool、Array<T>→T[]；标量、对象、枚举、optional、list、tuple；const、解构、if、switch、match 表达式、return。
- 列表和对象字面量、展开、索引、length、模板、字符串比较、三元与空值回退。
- 无捕获 map/filter/reduce，统一元组返回的消费式列表更新；禁止 clone 深拷贝。
- Call 注入的 `$name.value` Store getter/setter、类型与独立读写权限、暂存与宿主统一提交。
- 显式注册并审查的 zig:/c: 接口与模块成员，保留旧 lib: 兼容；无前缀 ZX 包入口映射；普通项目函数的 Input/Output 类型连接。
- 内建 std:encoding、std:crypto、std:path、std:querystring、std:zlib 与 std:os 系列纯计算接口；它们不是完整 Node.js 标准库兼容实现。
- 原生 build、C 头文件桥接、目标与 CPU 配置，以及真实汇编输出。
- 原生模块采用静态编译链接；动态插件与懒加载已按用户决定取消。
- app/lib 构建模式；lib 交付独立 Zig 模块、实际静态源码依赖、ZX 源码与项目配置，不携带 zxc runtime。
- requires/ensures 契约、独立契约 IR 与有限整数子集的 SMT 验证。
- 第三方 IR 的结构、作用域、调用图顺序、所有权与权限检查。

ZX 代码不允许显式分号。简单语句与声明通过换行、块结束或文件结束分隔；对象类型字段使用逗号或换行。字符串、注释和模板原文中的分号保留为内容。表达式可跨行，`return` 后换行不会自动截断返回值。

语法通过 Token 组合子声明；表达式优先级集中在 zx 操作符规则表。类型分析和所有权使用独立算法，不把所有阶段伪装成语法配置。

`??` 与 `&&`/`||` 在同一二元表达式中混用时必须显式加括号。例如 `value ?? left && right` 是语法错误，`value ?? (left && right)` 和 `(value ?? left) && right` 明确指定分组后才进入类型检查。条件表达式的各分支、函数参数和括号内表达式分别判断，不把不同表达式中的运算符视为混用。

## Edges：边界

数据库按用户要求不实现。没有 JavaScript 隐式转换、Python 大整数、一般闭包、任意循环或运行时 capability import。IR 是实验版 8 的内存 API，没有稳定序列化 ABI。

Store 的实际版本检查、锁、持久化和跨对象原子发布由宿主 commit 实现。编译器不包含完整 RX XML 加载器或生产 Runtime 调度器，不能把生成端的提交接口视为生产持久化已经实现。

ZX 不提供指针类型、取地址或解引用语法。参数、返回值和局部绑定始终使用普通 ZX 类型；聚合值的引用传递及具体存储表示由编译器处理。clone 已删除。

以下为 Zig 宿主集成细节：生成入口使用调用方 Arena，聚合列表元素保存引用槽。新构造数据在 Arena 中分配，所有权移动不递归复制数据。push/concat/splice 为自身操作分配结果列表，pop/reverse/sort 可复用独占存储。新建聚合返回值的所有权摘要已进入 IR，输入借用不能直接消费。原生共享 ABI 和 Store 生命周期还在迁移；调用方必须使输入和 Arena 覆盖所有输出及被保留的 Store 引用。

std:encoding 的 encodeUtf8/decodeUtf8 验证后返回输入的只读视图，不复制内容。Zig 直接消费方不传 allocator，也不释放这两个借用结果；输入存活期须覆盖视图使用期。

std:os 提供 arch()、platform()、endianness()，返回最终编译目标的架构、平台与字节序。接口无参数，交叉编译时不读取开发机信息；返回静态只读字符串，Zig 消费方不释放。名称映射、扩展目标及示例见 [系统目标信息参考](../../docs/2026-10-04/系统目标信息参考.md)。

std:crypto 新增 scrypt 密钥派生，显式接收密码与盐字节、N/r/p、输出长度和内存预算；派生前检查参数及完整缓冲请求量。接口与边界见 [scrypt 密钥派生参考](../../docs/2026-10-04/scrypt密钥派生参考.md)。

std:querystring 使用有序 Entry 列表保留重复键。parse/stringify 使用默认分隔符，parseWith/stringifyWith 接收显式配置；escape/unescape 提供百分号编解码。该模块不提供 JavaScript 对象隐式转换或完整 URL 解析。

std:zlib 提供 gzip/deflate/deflateRaw，输入 u8[]；gzipWith/deflateWith/deflateRawWith 接收 `{ data: u8[], level: i32, }`，级别为 -1（默认）、0（不压缩）、1–9。gunzip/inflate/inflateRaw 接收 `{ data: u8[], max_output_length: u32, }`。结果均为新分配字节数组。解压验证容器校验和、gzip 长度及总输出上限，支持连续 gzip 成员，拒绝尾随垃圾。新增 zstdDecompress 接收 `{ data: u8[], max_output_length: u32, max_window_length: u32, }`，支持连续 Zstd 帧、可跳过帧和校验和验证；两个上限分别约束总输出与单帧窗口。当前不提供流、预设字典、其他压缩参数、Brotli 或 Zstd 编码。详见 [Zstd 解压参考](../../docs/2026-10-04/Zstd解压参考.md)。

## Answer：使用与验证

仓库根目录：

```sh
zig build
zig build test
zig build zx-example

zig-out/bin/zxc packages/cli/examples/quote.zx --out /tmp/quote.zig
zig-out/bin/zxc fmt packages/cli/examples/quote.zx --check

zig-out/bin/zxc build packages/cli/examples/quote.zx --out .zxc/quote --asm .zxc/quote.s
```

分发的 zxc 内嵌官方 Zig 0.16.0 和 ZX 标准实现，用户只需复制可执行文件，无需安装 Zig 或保持旁置 share 目录。首次 `zxc build` 将资源释放到按内容摘要区分的用户缓存，后续复用；不会运行时下载工具链。macOS 默认 `$HOME/Library/Caches/zxc`，Linux 默认 `$XDG_CACHE_HOME/zxc` 或 `$HOME/.cache/zxc`，Windows 默认 `%LOCALAPPDATA%/zxc/cache`；可用绝对路径环境变量 `ZXC_CACHE_DIR` 覆盖缓存根。纯解析、格式化和读取内嵌包索引不展开工具链。

构建 zxc 本身仍需要 Zig。构建工具根据 zxc 的运行宿主获取锁定的官方 Zig 0.16.0 归档，核对 SHA256 后原样内嵌；不重新构建 Zig、不裁剪或重压缩发行内容。可用 `zig build dist -Dzig-archive=/absolute/path/to/official.tar.xz`（Windows 为 `.zip`）指定本地归档，离线完成构建。每个 zxc 仅内嵌对应宿主的一份发行包；Windows ARM64 使用 x64 Zig 的系统仿真方案，默认仍生成 ARM64 程序。运行期内置 XZ/ZIP 解压，不依赖外部解压命令。官方 Zig 二进制内部的 LLVM/Clang 保留。项目显式声明的系统原生库、外部求解器和 FPGA 工具仍按各自契约提供。

compiler 包内 `zig build test` 覆盖 RX/ZX 前端、第三方 IR 与编译 API；CLI 包内 `zig build test` 覆盖实际生成 Zig 执行及 Store 宿主契约。`zig build test-frontend` 只运行前端测试。

公开模块：

- `dependency.module("frontend")`：parse、analyze、analyzeWithContext、project.analyze、validateIr；依赖 core 数据、dsl 语法框架与 lint 命名规则。
- `dependency.module("compiler")`：上述入口加 compile、compileWithContext、compileProject、compileProjectVerified、format、zig.emit。
- `dependency.module("standard")`：普通 Zig 标准算法模块；实际使用 std: 接口的生成模块将它绑定为 `zxc_standard`。普通语言操作直接生成 Zig，不依赖专用运行库。

parse 返回拥有源码副本的 ParseResult，analyze/project.analyze 返回拥有 IR 的 AnalysisResult，分别 deinit。源码可先于 IR 释放。compile/format 返回 source 或 diagnostic，调用 result.deinit(allocator)。

单文件有 import 时必须使用 project 入口；CLI 会加载实际依赖文件。项目配置统一为 pkg.yaml，可用 `--project path/to/pkg.yaml` 显式指定；不读取 zxc.json。没有清单的独立源码仍可编译，此时 `@/` 相对工作目录。项目集合的每个 Source 提供 path 与 source，entry 指定入口。函数导入和未使用的类型导入都参与环检测。

`compiler.analyzeProjectWithCache(allocator, sources, options, &cache)` 接受调用方持有的 `project.ParseCache{ .allocator = allocator }`，使用结束后 `cache.deinit()`。缓存按 root_dir 与 source.path 合并后的规范化路径及源码 SHA-256 复用 ZX 模块解析结果，`parsed`、`reused` 是累计实际解析及命中次数。原 `analyzeProject` 自动创建本次调用的缓存，使风格检查与模块分析共享 AST。底层 `project.analyzeWithCache` 仍仅进行语义分析，官方完整检查应使用 compiler 入口。

缓存不属于项目 Options，不参与配置序列化；不同调用仍重新进行风格、导入、环、类型和所有权检查。缓存可在分析结果之前释放，IR 拥有自己的数据。同一路径的新源码会替换旧条目，借用的 parse result 随之失效；缓存不支持并发读写，未再使用的路径条目保留到缓存释放。CLI 在一次命令内将同一缓存传给依赖装载、完整分析、验证/FPGA 分支及 lib 源码导入重写；RX 的单次 ZX 函数检查也共享装载与分析缓存。这里的 ParseCache 仅复用内存语法结果；持久语义缓存与持续构建见后文。

有 pkg.yaml 时，CLI 从入口文件定位最近的包及包含它的工作区，工作区成员来自根清单内的 `workspace.packages`。每个包分别声明 dependencies/dev_dependencies；裸导入查当前包的直接依赖，或以自身 name 引用自身 entry。`@/` 指向当前包根，文件路径不能越过包边界绕过声明。`project.Options.package_scopes` 以绝对包根和直接依赖映射提供相同的库接口。原生模块、接口及链接配置也位于当前包的 pkg.yaml。

`zxc pkg inspect [pkg.yaml]` 校验清单，`zxc pkg workspace [pkg.yaml]` 发现成员，`zxc pkg graph [pkg.yaml]` 校验并输出依赖图。当前解析 workspace: 来源，支持 `workspace:*`、`workspace:^`、`workspace:~`、显式语义版本范围、`workspace:包名@范围` 别名和 `workspace:../成员` 路径引用；缺失成员、版本不匹配和循环依赖均失败。范围支持精确版本、部分版本、x/*、^、~、比较符交集、|| 及连字符区间，预发布版本按比较集合约束。目录与源码别名不能绕过物理包边界。真实 app 示例见 [包管理示例](../../docs/2026-10-03/包管理示例/)。外部来源、锁文件、共享存储和安装命令尚未实现，graph 成功不代表已安装外部依赖。

`zxc pkg init <name> [--version <version>] [--entry <path>] [--private]` 在当前目录创建 pkg.yaml，默认版本 0.1.0，不覆盖已有文件。入口可选，必须是包内 .zx 路径；命令只创建清单，不生成源码。例如 `zxc pkg init @sample/quote --entry main.zx --private`。未知、重复、缺值参数或无效清单字段均失败；字段校验与 inspect 使用同一 Schema。

`zxc pkg index [index.json]` 校验并显示多版本索引；`zxc pkg resolve <name> <range> [index.json]` 选择最高匹配版本，输出来源及 SHA-256。默认使用内嵌索引，由 [pkgs 包](../pkgs/README.md)维护；当前没有已发布条目。resolve 只查询索引，不下载或安装。

Store 使用 compileWithContext 或 project.Options.context.stores，每项声明 handle、path、type_name、readable、writable。生成入口为 execute(arena, input, context)，context 提供对应 slot 的快照指针和 commit(pending)。参考 tests/runtime/store_test.zig。

`compiler.parseExpression(allocator, source, file_name)` 解析单个 ZX 表达式并要求消费到 EOF；返回值拥有源码、文件名、tokens 和 AST，使用后 deinit。`compiler.expressions.analyze` 以共享 types、显式 bindings 和可选 expected 类型检查表达式，返回拥有独立 arena 的类型表、符号、表达式节点与结果 ExprId。bindings 的 name 可以是 `$in` 或 `ctx.user` 等标识符路径，路径必须唯一且不互相覆盖，类型不能是 void。这些显式外部绑定不放宽普通 ZX 源码的 `$` 命名规则，也不能绕过回调的非捕获限制。

`compiler.expressions.compile` 使用相同参数生成可执行 Program，并执行所有权检查。Program.Input 是按 bindings 顺序排列的元组；没有 bindings 时为 void。外部值作为输入借用，表达式不能消费借用列表。Zig 宿主应先构造显式的 `std.meta.Child(program.Input)` 元组变量，再传其地址；当前工具链的动态匿名元组指针隐式转换已有独立错误复现。生成仍通过 zig.emit/emitBundle 的完整 IR 校验。仅需类型推导时可用 analyze，但不能把它的成功当作执行许可。

这些接口尚未自动建立 RX 前序 Call.out 的可见环境，也不负责 XML 属性位置映射、分支合流或 RX 编排执行。提供者表达式与 ZX 入口组合生成时必须共享同一份类型表和 zxc_abi，不能凭对象字段相同就互传两个独立 Zig 模块中的匿名类型。

`dependency.module("rx_analysis")` 中的 `expression.compile` 编译真实 XML 属性并映射源码范围。普通 CLI、service 调度、Module 类型来源和完整 RX 应用生成仍未接通。API 与所有权约定见[显式表达式编译参考](../../docs/2026-10-04/显式表达式编译参考.md)。

IR 实验版本 8 移除 Context 注入槽位与读取节点，保留原生声明组 identity。原生模块保存为 `Program.native_modules`，函数通过 `NativeModuleId` 和成员路径数组引用模块，并携带返回所有权摘要。同名 specifier 来自不同包实例时，IR、缓存和 ABI 按声明组隔离；没有显式 identity 的 API 调用继续以 specifier 作为身份。后端按模块表生成并复用导入；旧版本原始 IR 与语义缓存不再接受。标准库签名来自 standard/interfaces 中的真实 .d.zx 源码，原成员注册表已删除。

项目分析成功时，`AnalysisResult.modules` 保留入口可达的 ZX 模块记录，按依赖完成装载的顺序排列。每项包含规范化 `path`、原始解析源码的 SHA-256 `source_digest`、导出表、按源码顺序排列的直接 imports，以及 `body`：`types` 表示纯类型模块，`entry` 使用返回 Program 的入口主体，`function` 指向 Program.functions 中的模块函数。入口不会暴露已从 functions 列表移除的编号。

每个 import 保留绑定种类、源码中的 specifier、名称和 span；target 区分解析后的 ZX source 路径、native 声明接口与兼容 external 签名。记录包含未使用但已校验的 import；共享依赖只产生一份模块记录。字符串及数组随 AnalysisResult 的 arena 释放，独立 analyze 和诊断结果默认无记录。这些 TypeId/FunctionId 仍属于本次完整分析，不能直接持久化复用。

分析成功时，`AnalysisResult.nominal_types` 记录已知来源枚举的 `type_id`、`name` 和 `origin`，包含调用方传入的来源。项目 ZX 来源是规范化模块路径；独立 analyze/analyzeWithContext 使用解析时的 file_name；native 来源是声明组 identity（未指定时使用 specifier）；兼容 externals 来源是导入模块、绑定名和导出成员。来源与声明名共同标识声明，不按相同结构合并枚举。记录与 IR 共用分析结果的 arena，可在 ParseCache 释放后读取。

多个分析入口共享类型时，将上一结果的 types 和 nominal_types 分别传入 `context.types` 与 `context.nominal_types`。分析器校验并复制两者，保留共享前缀 ID，在函数体分析前按来源和声明名归并新枚举；同身份但成员或顺序不同会被拒绝。结果不借用上一结果的存储。缺失来源的输入枚举保持独立身份，不从结构猜测来源；越界、重复或名称不匹配的来源记录产生 contract 诊断。调用方须保持来源路径一致：独立分析的 file_name 不自动转换为项目规范路径，跨项目使用应提供稳定的绝对路径或命名空间。详见[共享名义类型参考](../../docs/2026-10-04/共享名义类型参考.md)。

原生接口通过 project.Options.native_interfaces 提供声明源码与模块绑定。声明支持类型、枚举及 `export declare function`；allocator 首参数标记和 throws 返回标记显式描述 ABI。CLI 的 native_interfaces 使用 specifier/path/module/namespace，其中 path 指向 .d.zx。旧 externals 仅作为兼容输入保留。CLI 不自动放行任意原生导入。

`compiler.zig.emitBundle(allocator, program)` 提供共享类型生成入口，返回 `source` 与 `types` 两份源码，使用后调用 `bundle.deinit(allocator)`。将 types 注册为同一个 `zxc_abi` Zig 模块，供生成程序与原生模块共同导入。原生模块通过 `@import("zxc_abi").native.@"zig:模块名".类型名` 或 `.函数名.Input/Output` 使用声明类型。原生实现需要显式创建声明中的记录时，通过 `@import("zxc_abi").layouts.@"zig:模块名".类型名` 获取存储布局；函数匿名参数和结果的布局也可从 `InputValue/OutputValue` 获取。此模式直接传递对象/元组引用和数组切片，不执行原生字段转换；CLI app/lib 已接入该入口，生成并链接同一个 ABI 模块；标准库复合参数与结果已使用共享声明类型。原生字段转换路径已删除。CLI 的 --out 在导出原生程序时同时写出 <输出文件>.abi.zig；Zig 消费方须将其注册为共享的 zxc_abi 模块。纯 ZX 导出仍是单文件。只返回单份源码的 emit/compile 接口拒绝原生模块，使用 analyzeProject 与 emitBundle，或向 compileProjectVerified 提供 type_output。可运行示例见 [共享原生类型示例](../../docs/2026-10-03/共享原生类型示例/)。

接口提供 export_name 时，同一 specifier 可声明多个成员，通过默认导入的命名空间调用。pkg.yaml 可声明 externals 和 native_modules；后者以 path 指定 Zig 文件，或以 header 指定 C 头文件并通过 c 命名空间导出。build 模式会完成对应链接，支持 libraries/include_paths/library_paths。生成的可执行文件接收一个 JSON Input 参数并输出 JSON Output；void Input 不接收参数。

应用 CLI 当前采用 Zig 的默认 JSON 输出约定：`u8[]` 字节构成合法 UTF-8 时输出 JSON 字符串，否则输出整数数组；空字节列表输出 `""`。例如 `[65, 66]` 输出 `"AB"`，`[255]` 输出 `[255]`，嵌套对象中的字节列表也遵循这一规则。消费端应按已知 ZX 输出类型恢复字节：字符串做 UTF-8 编码，数组逐项校验为 0–255 的整数后转换。字符串不是 Base64，不应按 UTF-16 字符码恢复。这只影响 CLI 的 JSON 表示，std:zlib 等接口的 ZX 返回类型和内容仍为字节列表。

`std:path` 按编译目标 OS 选择路径风格，`std:path/posix` 与 `std:path/win32` 固定风格。提供 isAbsolute、basename、dirname、extname、parse、format、normalize、join、resolve、relative；join 接收 string[]，resolve 接收 `{ cwd: string, paths: string[], }`，relative 接收 `{ cwd: string, from: string, to: string, }`。不读取进程 cwd 或盘符环境。Windows 比较目前仅提供 ASCII 大小写折叠；其他差异和实际调用见 [路径标准库实施](../../docs/2026-10-03/路径标准库实施.md)。

`std:crypto` 提供 sha256/sha512；hmacSha256/hmacSha512 与 verifyHmacSha256/verifyHmacSha512；hkdfSha256/hkdfSha512；pbkdf2Sha256/pbkdf2Sha512；encrypt/decryptAes128Gcm、encrypt/decryptAes256Gcm、encrypt/decryptChaCha20Poly1305，以及 timingSafeEqual。所有密码材料和数据使用 u8[]，具体字段与错误见 [密码学标准库实施](../../docs/2026-10-03/密码学标准库实施.md)。密钥和 nonce 由调用方显式提供，同一密钥下 nonce 必须唯一。解密认证失败返回错误，不输出明文；时序安全比较只约束比较原语，不代表整个应用具有恒定执行时间。

native_modules 仅接受 path 或 header，动态 library 入口已取消。旧动态插件实施文档只保留历史证据，不代表当前功能。

`zxc build <source.zx> --out program` 支持 `--asm program.s`、`--target triple`、`--cpu features`、`--optimize Debug|ReleaseSafe|ReleaseFast|ReleaseSmall`。默认 ReleaseSafe。编译使用内嵌 Zig 与标准实现；完整官方资源保留，`--target` 遵循 Zig 的目标支持范围，涉及系统库或 SDK 时仍需提供对应外部依赖。汇编生成不代表超级优化或形式化正确性证明已经完成。

app 构建在 `.zxc/build/` 中按生成源码、ABI、runner 和构建配置的内容摘要定位产物。摘要包含版本域及各字段长度；内容相同的 program.zig、abi.zig、main.zig 保留原文件，缺失或内容不符时原子写入。生成文件复用与下面的模块语义、Zig 生成缓存共同工作；接口未变化的依赖实现修改可以复用调用者模块。

`zxc build <source.zx> --watch --out program` 持续构建应用；添加 `--mode lib` 则持续导出库。每轮复用磁盘模块缓存，监听实际读取的源码、清单、工作区候选、原生源码与资源，以及后端报告的依赖；可用 `--cache-stats` 查看分析和生成复用计数。当前每 500ms 检查输入内容；后端失败时约每 2 秒重试，以发现首次 C 编译失败后新建的头文件。相同后端错误安静去重，输入变化后允许重新报告。

watch 构建失败时保留上一份产物；发现新后端输入或构建期间输入变化时，重新构建验证后再发布。库先生成暂存目录，通过输入复核后逐文件原子替换，保留输出目录中其他文件；整个库目录并非原子事务，发布途中 I/O 错误可能留下新旧混合文件。输出应放在源码与工作区包发现范围之外，避免生成的文件反过来成为输入。`--watch` 只负责构建，不启动应用，也不迁移运行状态。实现与边界见 [持续构建与输入观测](../../docs/2026-10-04/热重载输入观测方案.md)。

`--mode app` 是 build 的默认模式。`zxc build <source.zx> --mode lib --out directory` 交付源码模块包：root.zig 导出 Input/Output/execute，build.zig 注册名为 library 的 Zig 模块，native/ 保存引用的静态源码依赖，interfaces/ 保存项目原生声明，source/ 保存重写为内部相对导入的 ZX 源码，pkg.yaml 保存包身份、源码入口及原生配置。无输入清单时使用 library@0.0.0，有清单则保留包名和版本。依赖源码已打包为闭包，不保留原工作区依赖边。包内 ZX 消费方可使用包名自引用；Zig 消费方从本地 build 依赖获取 module("library")。生成的 build.zig 含清单导出的原生构建参数，调整原始配置后应重新导出库。目标和优化由消费方构建选择，lib 模式不接受 app 的汇编、target、cpu、optimize 参数。

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

`compiler.project.artifact.extract(allocator, &analysis, module_index)` 提取拥有独立 arena 的单模块产物，使用后调用 `deinit`。输入必须是通过 IR 校验的项目分析结果。产物保留自有函数、直接依赖、实际解析的类型与函数绑定、导入函数签名以及所需原生接口；类型、函数和原生模块编号均转换为产物内部编号。原分析结果和 ParseCache 释放后，产物仍然有效。

模块产物不是完整 `Program`，必须经过完整联结或恢复到当前项目环境后才能生成 Zig。枚举需要项目分析记录的名义来源；共享类型表包含未记录来源的枚举时，提取返回 `MissingNominalOrigin`，不会用同名或相同成员推测类型身份。`AnalysisResult.modules` 通过 `type_range` 记录模块在依赖装载后新增的类型区间，并保留 `type_imports` 和 `function_imports`，供产物提取恢复分析时的绑定环境。

`compiler.project.artifact.type_link.merge(allocator, modules)` 统一模块产物的类型表，返回 `types`、`nominal_types` 和与输入模块顺序一致的 `mappings`，使用后调用 `deinit`。映射将每个局部 TypeId 转为统一 TypeId；返回数据不依赖输入产物生命周期。结构类型按已映射的子类型比较；枚举按来源及声明名驻留，同一身份出现不同成员或顺序时返回 `ConflictingNominalType`。该接口只联结类型，不联结函数、契约和原生调用，也不返回可执行 Program。

`compiler.project.artifact.linker.link(allocator, modules, entry_path)` 从指定入口联结可达模块，返回拥有独立 arena 的 `program` 和 `nominal_types`，使用后调用 `deinit`。模块数组不要求预先排序；重复路径、缺失依赖和循环会被拒绝，包括未被调用的源码导入。联结会核对来源模块的导出、导入签名、返回所有权及原生 ABI，并在返回前执行完整 IR 校验；释放输入产物后仍可使用结果生成 Zig。

该接口不执行源码读取、缓存命中判定或形式化证明。涉及契约的生成仍遵守既有验证门禁。联结发现 `ConflictingInterface` 或 `ConflictingNominalType` 表示输入产物之间存在不一致，不能据此声称任何旧产物仍可复用；缓存调度需要先重新分析受影响模块。

`compiler.project.SemanticCache.init(allocator)` 创建进程内解析与语义缓存，使用后调用 `deinit`。`compiler.analyzeProjectIncremental(allocator, sources, options, &cache)` 保留公开编译入口的源码风格检查，并在每轮解析当前依赖后尝试恢复模块产物。底层 `project.analyzeIncremental` 与已有底层项目分析 API 一样不负责 lint。

候选由模块路径、源码摘要和入口编译环境区分；恢复还必须通过当前类型别名、函数签名、返回所有权、原生 ABI 及依赖目标比较。接口未变化的依赖实现变化不会迫使调用者重新执行 Analyzer，但返回 Program 会包含本轮最新的依赖函数。源码循环、缺失导入和非法编译环境仍通过正常分析路径处理。

`analyzed`、`reused`、`uncacheable` 是累计 ZX 模块计数；`parse_cache.parsed` 是累计源码解析次数。`native.analyzed`、`native.reused` 分别统计原生声明的实际分析和复用次数，不计入 ZX 模块命中数。原生候选覆盖 specifier、声明路径、源码、实现模块与 namespace；恢复时仍执行类型映射与 IR 校验。缺失外部注入枚举来源的产物不缓存，正常分析继续完成并递增 `uncacheable`。缓存不保存形式化证明结论；该对象本身不执行磁盘 IO，CLI 负责持久化。分析结果拥有独立 arena，可在释放缓存之后使用。

CLI 的普通编译、`build`、`verify` 和 `fpga` 默认把模块语义产物存入项目根目录的 `.zxc/cache/semantic/<构建指纹>/`。指纹覆盖编译器源码、构建辅助源码及配置、标准声明清单和接口，以及 zx/dsl/lint/genz 源码及构建配置，并包含 Zig 版本、构建目标和优化模式。源码、编译环境或当前依赖不匹配时重新分析；证明结论不会被缓存命中替代。

使用 `--no-cache` 禁用模块语义缓存及其磁盘读写，`--cache-stats` 在 stderr 显示分析、复用、加载、写入、磁盘格式丢弃和不可缓存计数；`native_analyzed`、`native_reused`、`native_loaded`、`native_written` 单独报告原生接口。原生条目存于同一构建指纹目录下的 `native/`，只加载当前源码导入的已注册接口。缓存只原子写入新建或更新的条目，未变化文件保持时间戳。单条目读取上限为 64 MiB，JSON 嵌套上限为 2048；格式、指纹、摘要、类型或恢复后的 IR 校验不通过时重新分析。磁盘读写故障会报告错误并继续正常编译，内存分配失败仍返回错误。`fmt` 不接受缓存选项。

例如，在 `packages/compiler` 目录执行已有模块示例：

```sh
../../zig-out/bin/zxc tests/runtime/cases/modules.zx --out /tmp/modules.zig --cache-stats
../../zig-out/bin/zxc tests/runtime/cases/modules.zx --out /tmp/modules.zig --cache-stats
../../zig-out/bin/zxc tests/runtime/cases/modules.zx --out /tmp/modules.zig --no-cache
```

模块提取先收集本模块新增类型及引用的依赖类型，再沿原类型表顺序分配局部编号。保留本模块自身未被表达式引用的声明类型，避免冷热编译只因遍历顺序改变 `zx_type_*` 名称；不会复制无关依赖的整张全局类型表。

`compiler.zig.emitModules(allocator, &analysis)` 从完整项目分析结果生成独立模块 bundle，包含 `entry`、`types`、`modules`，使用 `bundle.deinit()` 释放。每个文件提供 `name`、`source`、`imports`；结果不借用分析 arena。该入口拒绝未证明的契约。`compiler.compileProjectModulesVerified(allocator, options)` 共用正常分析、IR 校验及形式化证明流程，返回 `.bundle` 或 `.diagnostic`，结果使用 `deinit()` 释放；选项类型是 `compiler.CompileOptions`。

`zxc build` 的 app/lib 模式使用分模块生成。入口导出原有 Input/Output/execute，每个可达 ZX 函数和原生适配器导出独立的 `call(allocator, in)`。类型名称根据完整结构生成；枚举还包含来源和声明身份。缺失名义来源会返回错误，不使用临时 TypeId 代替身份。稳定函数 import key 与实现内容分离，外部函数的导出名也是声明身份的一部分。

应用的生成函数文件保存于 `.zxc/build/modules/<稳定函数名>/<源码摘要>.zig`，未变化文件保留路径和时间戳。入口构建键包含完整模块源码和导入图。库导出把函数文件写入自身的 `modules/`，`library.json` 的 `generated_modules` 和 `entry_dependencies` 描述注册关系，生成的 build.zig 自动完成注册。手动用 Zig `-M` 消费时也需要依据该清单注册模块；所有消费者共同引用唯一的 zxc_abi，不能各建一份同内容的 ABI 模块。

普通源码导出仍使用既有单文件或主源码加 ABI 契约。app/lib 的生成缓存分别保存入口、函数和共享 ABI 的源码，命中时跳过对应 lowering。共享 ABI 变化仍可能触发 Zig 后端失效，不把生成缓存命中等同于机器码无需重编译。

`compiler.zig.GenerationCache.init(allocator)` 创建进程内生成缓存；`initPersistent(allocator, io, directory, compiler_digest)` 可增加持久存储，调用者负责提供覆盖编译器及生成器实现的构建摘要。使用后调用 `deinit()`。通过 `emitModulesCached(allocator, &analysis, &cache)` 使用，或把缓存传给 `CompileOptions.generation_cache` 后调用 `compileProjectModulesVerified`；旧单文件编译接口不使用该选项。缓存返回源码会复制到结果 bundle，释放缓存不影响已有结果。

生成输入摘要逐字段覆盖 IR，将全局类型、函数和原生模块编号转换成稳定身份；函数体变化不会进入调用者的源码生成键。共享 ABI 的键包含类型图和原生签名。内存中每个生成单元只保留最近一次输入对应的源码；磁盘按输入摘要寻址，保留不同输入版本。所有权检查、IR 校验及必要的形式化证明仍在源码缓存查询之前执行。

CLI 将生成缓存保存至 `.zxc/cache/zig/<构建指纹>/`，`--no-cache` 同时禁用语义和生成缓存。`--cache-stats` 的 `zxc generation` 行报告 `generated`、`reused`、`loaded`、`written`、`discarded`、`io_errors`；计数包含入口、函数和共享 ABI 的生成或命中事件。存储核对格式、编译器摘要、输入摘要和输出校验和；源码单条目最多 64 MiB，原子替换发布。普通 IO 故障会报告并退回生成，OOM 继续返回错误。生成源码不依赖 CLI 目标架构设置，目标、CPU 和优化模式仍进入后续 Zig 构建配置与缓存键。
