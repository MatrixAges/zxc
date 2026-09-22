# compiler

ZX 源码 → Token → AST → 类型与所有权检查 → IR → genz → Zig。

## Intent：最终目标

提供可独立调用的声明式前端、开放 IR 和 Zig 后端，同时执行命名与 AST 空行门禁。第三方后端只需依赖 frontend 与 zx。

## Data：实现范围

- 纯类型与可执行文件，类型/枚举/默认函数导入，./、../、@/ 路径及导入无环检查。
- 标量、对象、枚举、optional、list、tuple；const、解构、if、switch、return。
- 列表和对象字面量、展开、索引、length、模板、字符串比较、三元与空值回退。
- 无捕获 map/filter/reduce，显式 clone，统一元组返回的消费式列表更新。
- Call 注入的 `$name.value` Store getter/setter、类型与独立读写权限、暂存与宿主统一提交。
- 显式注册并审查的 zig:/lib: 接口；普通项目函数的 Input/Output 类型连接。
- 第三方 IR 的结构、作用域、调用图顺序、所有权与权限检查。

语法通过 Token 组合子声明；表达式优先级集中在 zx 操作符规则表。类型分析和所有权使用独立算法，不把所有阶段伪装成语法配置。

## Edges：边界

数据库按用户要求不实现。没有 JavaScript 隐式转换、Python 大整数、一般闭包、任意循环或运行时 capability import。IR 是实验版 2 的内存 API，没有稳定序列化 ABI。

Store 的实际版本检查、锁、持久化和跨对象原子发布由宿主 commit 实现。编译器不包含完整 RX XML 加载器或生产 Runtime 调度器，不能把生成端的提交接口视为生产持久化已经实现。

生成入口必须使用调用级 Arena。getter 和浅对象更新不深拷贝列表；clone 是显式深复制。当前 push/concat/splice 分配结果列表，pop/reverse/sort 可复用独占存储。调用方负责输入、输出及长期 Store 数据的生命周期。

## Answer：使用与验证

仓库根目录：

```sh
zig build
zig build test
zig build zx-example

zig-out/bin/zxc packages/compiler/examples/quote.zx --out /tmp/quote.zig
zig-out/bin/zxc fmt packages/compiler/examples/quote.zx --check
```

包内 `zig build test` 包含前端、第三方 IR、完整编译分配失败、实际生成 Zig 执行及 Store 宿主契约测试。`zig build test-frontend` 只运行前端测试。

公开模块：

- `dependency.module("frontend")`：parse、analyze、analyzeWithContext、project.analyze、validateIr；只依赖 zx。
- `dependency.module("compiler")`：上述入口加 compile、compileWithContext、compileProject、format、zig.emit。
- `dependency.module("runtime")`：作为生成模块的 `zx_runtime` 导入，提供纯集合运行支持。

parse 返回拥有源码副本的 ParseResult，analyze/project.analyze 返回拥有 IR 的 AnalysisResult，分别 deinit。源码可先于 IR 释放。compile/format 返回 source 或 diagnostic，调用 result.deinit(allocator)。

单文件有 import 时必须使用 project 入口；CLI 会加载实际依赖文件。`@/` 相对 project.Options.root_dir；CLI 当前相对运行工作目录。项目集合的每个 Source 提供 path 与 source，entry 指定入口。函数导入和未使用的类型导入都参与环检测。

Store 使用 compileWithContext 或 project.Options.context.stores，每项声明 handle、path、type_name、readable、writable。生成入口为 execute(arena, input, context)，context 提供对应 slot 的快照指针和 commit(pending)。参考 tests/runtime/store_test.zig。

原生接口通过 project.Options.externals 注册 signature 与 implementation。signature 是声明 Input/Output 的纯类型 ZX；implementation 指定 Zig module/member、是否需要 allocator、是否返回错误，以及是否把 tuple Input 展开为位置实参。CLI 不自动放行任意原生导入。

输出 Zig 模块需要把 compiler 的 runtime 模块绑定为 `zx_runtime`。纯函数执行形态：

```zig
var arena = std.heap.ArenaAllocator.init(backing_allocator);

defer arena.deinit();

const output = try generated.execute(&arena, input);
```

完整数值和所有权契约见 [ZX IR 契约](../zx/IR契约.md) 与 [语言设计](../../docs/zx_design_doc.md)。
