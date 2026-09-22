# zxc DSL

用于定义和校验 RX 风格 XML DSL 的 Zig 0.16.0 库。模块名为 `dsl`，不包含固定业务标签，使用 Zig 编译期类型函数生成领域数据类型。

## 包与根构建

```text
packages/
└── dsl/
    ├── build.zig
    ├── build.zig.zon
    ├── src/
    └── examples/
```

包可独立构建和运行示例：

```sh
cd packages/dsl
zig build
zig build example
```

仓库根目录运行 `zig build` 构建 DSL 示例，`zig build dsl-example` 运行示例。根 manifest 通过 `.dsl = .{ .path = "packages/dsl" }` 声明依赖。MVP 编译器已归档至 `legacy`，不参与根默认构建。

其他 Zig 包按其目录填写本地路径，然后在自己的 `build.zig` 中接入：

```zig
const dependency = b.dependency("dsl", .{
    .target = target,
    .optimize = optimize,
});

consumer_module.addImport("dsl", dependency.module("dsl"));
```

根构建通过依赖包的示例 artifact 连接模块图，示例的 imports 显式引用 `dsl`，ZLS 可沿构建图解析 `@import("dsl")`。未来正式消费者按上面方式注册模块；无需相对路径穿透包边界，也无需额外 npm 包。构建图配置不代表已经实现 CLI 的 RX 文件解析功能。

## 定义规则与推导类型

```zig
const dsl = @import("dsl");

const Condition = dsl.element("Condition", struct {
    field: []const u8,
    operator: enum { equal, between },
    value: []const u8,
}, dsl.empty);

const Action = dsl.element("Action", struct {
    type: []const u8,
    enabled: bool = true,
}, dsl.empty);

const Rule = dsl.element("Rule", struct {
    id: []const u8,
    priority: ?f64 = null,
}, dsl.sequence(.{ Condition, Action }));

const RuleEngine = dsl.element("RuleEngine", struct {}, dsl.list(Rule, .{ .min = 1 }));
const RuleEngineData = RuleEngine.Data;
```

结果中 `data.children` 是 `[]const Rule.Data`；`rule.children[0]` 为 `Condition.Data`，`rule.children[1]` 为 `Action.Data`；属性在 `.attributes` 中。编译器直接检查访问类型。

属性采用原生 Zig 类型，不另造运行时类型系统：

| 声明               | 规则                                              |
| ------------------ | ------------------------------------------------- |
| `[]const u8`       | 原样保留解析器已解码的字符串，包括空字符串        |
| `bool`             | 仅接受 `true`、`false`，大小写敏感                |
| 整数类型           | `std.fmt.parseInt(T, value, 10)`，拒绝越界        |
| 浮点类型           | `std.fmt.parseFloat(T, value)`，拒绝 NaN 和无穷大 |
| `enum`             | 按枚举字段名精确匹配                              |
| `?T`               | 缺失为 null；存在时仍必须满足 T 的规则            |
| `field: T = value` | 缺失时使用显式默认值                              |

数字词法遵循 Zig 标准库解析规则，本包不宣称实现 XSD 数值词法。没有默认值的非 optional 属性必填；未知属性和重复属性都会失败；不支持的属性类型在编译期报错。

## 子元素组合

- `empty`：不允许任何子元素。
- `list(Schema, .{ .min = 0, .max = 10 })`：同一规则的有界列表，省略 max 时不限数量。
- `sequence(.{ A, B })`：恰好两个子元素，必须依次匹配 A、B；返回 tuple。
- `choice(.{ .action = Action, .note = Note })`：按标签名分派，返回带标签 union；重复标签的歧义在编译期拒绝。可用于 list 或 sequence 的元素位置。

这些都是编译期组合，不提供任意递归 Schema，也不在运行时注册新的标签。修改扩展后需重新编译应用。

## 输入与源码位置

本包的输入为 `dsl.ast.Node`，不是 XML 字符串。XML 解析器负责良构性检查、实体解码和位置记录，然后适配为：

- `Node.name`：元素完整名称，大小写敏感。
- `Node.location`：开始标签位置，用于标签错误和缺失属性诊断。
- `Node.attributes`：保留每个属性的名称、解码值、属性名位置及值位置。
- `Node.children`：按原文顺序保留直属子元素。
- `Node.text`：保留全部直属文本片段，包括 CDATA 的文本内容；本包只允许 XML 空白字符。

`Location.offset` 是从 0 开始的 UTF-8 源码字节偏移，line 和 column 从 1 开始，column 按 UTF-8 字节计数。适配器应将 CRLF 视为一次换行；位置必须指向原始 XML，而不是解码后的字符串。库原样传递位置，不通过搜索相同标签或属性字符串推测位置。

命名空间解析不在本包内：`ns:Tag` 按完整字符串匹配。若上游要提供展开名称，Schema 也必须使用同一名称约定。解析器必须设置适合业务的输入大小和深度限制；本包不会读取文件、解析 DTD 或解析外部实体。

示例手动构造合成 AST，并将位置统一设为 1:1，用于演示 Schema 与回调；它不是 XML 解析适配器，也不用于证明 XML 文本行列定位。

## 校验、结果与内存

```zig
var result = try dsl.validate(RuleEngine, allocator, root_node, {});

defer result.deinit();

switch (result.value) {
    .data => |data| consume(data),
    .diagnostic => |issue| report(issue),
}
```

`validate` 的错误联合只返回 `OutOfMemory`；业务校验失败位于 `.diagnostic`。诊断包含 `code`、`location`、`element`、可选的 `attribute`、`expected`、`child_count` 和 `message`。首个失败后停止，不返回部分业务数据。

结果拥有 arena 中分配的列表；字符串、元素名称和部分诊断信息借用 AST 或上下文。AST 及相关上下文字符串必须活到结果使用结束。结果不可复制后重复释放，不论成功失败都要 `deinit()`。校验失败时 arena 中的已分配数据同样由结果释放。

可以据诊断渲染 `Line 12, Column 5: <Condition> missing_attribute: operator`，也可以将结构化字段直接发送给 AI。子节点数量错误附带 min、max 和 actual；多余子节点定位到第一个超出上限的节点。

## 自定义语义与上下文

```zig
const CheckedCondition = dsl.refine(Condition, checkCondition);

fn checkCondition(
    data: Condition.Data,
    node: dsl.ast.Node,
    context: Context,
    reporter: *dsl.Reporter,
) dsl.Error!void {
    if (!context.contains(data.attributes.field)) {
        return reporter.fail(.{
            .code = .context,
            .location = node.location,
            .element = node.name,
            .attribute = "field",
            .message = "Field is not registered",
        });
    }
}
```

将 `CheckedCondition` 放入原来的 sequence 即可。回调收到已经通过结构与类型检查的数据、原始节点以及 `validate` 传入的 context。父节点 refine 在其所有子节点成功后执行，可检查重复 ID、跨节点关联或上下文注册表。

回调业务失败必须调用 `reporter.fail(...)` 并返回它的错误，不能直接返回 `error.InvalidDsl` 而不填写诊断；诊断字符串不能引用回调的局部栈缓冲区。回调应只校验，不执行外部副作用，否则后续节点失败时库无法回滚副作用。

完整可运行示例见 [examples/rules.zig](examples/rules.zig)，包含 `between` 的两个有限数字和升序检查，以及应用字段白名单。
