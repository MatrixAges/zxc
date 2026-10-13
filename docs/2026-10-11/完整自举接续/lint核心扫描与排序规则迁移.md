# lint 核心扫描、边界与导入排序规则迁移

## Intent：最终目标

将 `packages/lint` 中承担行缩进规划（`indentation_line`）、空行边界编辑（`spacing_boundary`）、RX 标签与注释边界扫描（`rx_bounds`）以及 ZX 导入分组与排序比较（`import_order`）的 4 组自有规则迁入统一 RX + ZX 模块，并收口 `packages/lint/build.zig` 的生成模块注入机制，使新增或迁移的 lint 规则统一通过单个 `generated` 目录与 `entries.zig` 的 `.owner = .lint` 列表挂载。

## Data：可用证据

- `std:bytes` 扩展了零分配字节切片查找与比较契约（`indexOfScalar`、`lastIndexOfScalar`、`indexOfSlice`、`indexOfText`、`startsWith`、`startsWithText`、`equals`、`lessThan`），底层直接映射 `std.mem` 原生字节扫描与比较，无动态分配。
- `packages/lint/build.zig` 将逐个规则传入 `LazyPath` 改为统一接收 `.generated = parser_source.main` 目录，`packages/compiler/build.zig` 通过 `inline for (@import("build/entries.zig").main)` 自动挂载所有 `.owner = .lint` 的生成模块，消除了手工逐项接线。
- 4 组迁移模块的 RX 编排与 ZX 原子职责：
    1. `indentation_line`（`packages/lint/src/indentation/line/line.rx` + `model.zx`、`scan.zx`、`check.zx`）：RX 先调用 `scan` 反向扫描行首空白与制表符，对非行首位置直接短路返回无需编辑，再调用 `check` 比对 4 空格目标缩进。
    2. `spacing_boundary`（`packages/lint/src/spacing/boundary/boundary.rx` + `model.zx`、`scan.zx`、`check.zx`）：RX 先调用 `scan` 在语句间隙切片中定位首尾换行与 CRLF 标志，无换行时直接短路，有换行时调用 `check` 判定单换行或双换行是否已匹配。
    3. `rx_bounds`（`packages/lint/src/rx/bounds/resolve.rx` + `model.zx`、`tag_end.zx`、`opening.zx`、`comment_end.zx`、`closing_start.zx`）：RX 按请求类型（开始标签、结束标签、注释结尾、标签结尾）编排 `closing_start`、`tag_end`、`opening` 与 `comment_end` 四个原子扫描函数。
    4. `import_order`（`packages/lint/src/imports/order/compare.rx` + `model.zx`、`category.zx`、`classify.zx`、`path_order.zx`）：RX 先调用 `classify` 计算左右导入项的类别与分组（`std:` / `zig:` / `c:` / 外部包 / `@/` / 相对路径及 `import type` 偏移），类别不同直接短路返回大小与同组结果，类别相同时调用 `path_order` 按 UTF-8 字节序与原始起始偏移稳定比较。

## Edges：边界与限制

- 栈上零堆分配边界：RX/ZX 生成代码在构造返回记录或中间调用参数记录时通过传入的 `std.mem.Allocator` 分配结构体。各规则的 `root.zig` 统一使用栈上 `var storage: [256]u8 = undefined; var fixed = std.heap.FixedBufferAllocator.init(&storage);` 调用 `generated.executeIn(fixed.allocator(), &input)`，完全在栈帧内完成记录构造，零堆分配、零运行库开销。
- 字符串字面量零拷贝：`rx_bounds` 与 `import_order` 中对 `"<!--"`、`"-->"`、`"<![CDATA["`、`"]]>"`、`"std:"`、`"zig:"` 等前缀与子串的匹配统一通过 `std:bytes.startsWithText` / `indexOfText` 借用静态 `string` 字面量，避免在 ZX 中构造 `u8[]` 数组字面量产生额外分配。
- `seed` 模式保留：`packages/lint/bootstrap/{indentation_line,spacing_boundary,rx_bounds,import_order}.zig` 仅在 `seed = true` 构建初始生成器时使用；正式构建强制使用生成的 RX/ZX 模块。
- 未满足项：`packages/lint` 中依赖宿主 AST 指针递归遍历的 `expressions.zig`、`shape.zig`、`indentation/zx.zig`、`rx/root.zig` 树遍历规划及 `configuration/{json,yaml}.zig` 仍为手写 Zig，不能据此宣称 `packages/lint` 已整体完成自举。

## Answer：验证结果

1. `zig build -Doptimize=debug` 构建通过，`entries.zig` 主生成入口增至 54 个（其中 `.owner = .lint` 共 6 个：`naming`、`length`、`indentation_line`、`spacing_boundary`、`rx_bounds`、`import_order`）。
2. 使用新构建的 `./zig-out/bin/zxc` 对全部 6 组 `packages/lint/src/{naming,length,indentation/line,spacing/boundary,rx/bounds,imports/order}/*.*x` 执行 `zxc fmt --check` 与 `zxc lint`，全部零诊断通过，所有 `.zx` 文件均在 45 行以内（远低于 120 行阈值）。
3. 运行 `node packages/test/tests/formatting/rx/cli_test.ts ./zig-out/bin/zxc`（52/52 通过）与 `node packages/test/tests/formatting/zx/imports/cli_test.ts ./zig-out/bin/zxc debug`（22/22 通过），验证 RX 标签/注释边界、四空格行缩进、空行边界编辑与 ZX 导入分组排序在 LF/CRLF 下的完整行为等价。

## 自我批判

本批迁移完成了 `lint` 包中所有基于字节范围和导入元数据的规则（连同此前的 `naming` 与 `length` 共 6 个 RX/ZX 入口），并统一了 `lint` 的生成模块挂载构建图；但围绕 AST 节点递归的表达式风格、语句同形比较与 YAML/JSON 配置格式化尚未迁入 RX/ZX，需在后续批次继续推进。
