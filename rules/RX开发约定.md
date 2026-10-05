# RX 开发约定

本文用于修改 zxc 本身。应用开发指导位于 `packages/skills/`，不要把这里的内部实现要求复制到使用者文档中。

## 修改前阅读

- [RX 模块文档](../packages/compiler/src/rx/README.md)：当前语法、公开接口和边界。
- [公共标签](../packages/compiler/src/rx/labels)：普通 RX Schema。
- [Gateway 标签](../packages/compiler/src/rx/features/gateway/labels)与 [Store 标签](../packages/compiler/src/rx/features/store/labels)：专用 Schema。
- [模块注册](../packages/compiler/src/rx/modules.zig)与 [依赖图校验](../packages/compiler/src/rx/module_graph.zig)：路径身份和无环约束。

旧设计文档可能保留历史语法，以用户最新要求及当前实现为准。legacy 中的 MVP 不代表正式版本已经实现的全部能力。

## 文件职责

- 公共标签在 `packages/compiler/src/rx/labels/`，一个标签一个同名 PascalCase.zig 文件。
- 专用标签在 `src/features/gateway/labels/`、`src/features/store/labels/`。
- 标签专属 refine 与 Schema 放在同一个文件；跨标签适配器保留独立职责。
- `flow.zig` 和 feature 的 `root.zig` 聚合导出，重构时保留现有公共契约。
- 按任务授权新增的测试全部在对应子包 `tests/`，与 `src/` 同级；生产实现不写内嵌 test。
- 遵循职责建立目录层级，不把全部实现堆在一个目录，也不为短 helper 机械拆文件。

## 不可放宽的约束

Call 目标只接受 fn/module，service 仅用于 Route；Call 参数属性为 in；Call 不接受 out；Task.out 为可选花括号表达式，在子步骤结束后聚合结果，不能与同一任务的 Return 并用。Call 不接受 name，直接取调用目标最后路径段并去掉源码后缀，结果固定为 $ctx.<name>；Task 使用 $ctx.task.<name>，包括带 out 的顺序 Task。Call 目标文件名不得为保留名 task；两类结果可同名，同一作用域同类结果不得重名，void 调用保留执行但不产生值绑定。Module.in/out 仍是类型契约。

RX 属性值仅负责数据引用、组装和简单运算；禁止函数/方法调用、lambda 和状态更新块，包括嵌套对象、分支或模板中的调用。loop、集合处理及其他计算在 ZX 中实现，由 Call.fn 或 Call.module 编排。普通属性编译、项目类型推导和 Store 初值必须共用这一边界。

模块身份必须来自规范化文件路径。Import 与所有嵌套节点中的 Call.module 都构成依赖边；自引用、间接环、条件分支环及未使用 Import 的环都必须拒绝。

不要加入关闭环检测的选项，不漏扫分支，不通过动态目标、路径变体或生产代码中的特例让测试通过。共享子模块、重复调用和合法菱形依赖不应被误判为环。

## 内部校验接口

RX 保留带位置的 XML AST 校验入口，并通过 `parseXml` 与 `parseModules` 支持真实文本。文本入口持有源码副本，集合结果统一管理解析与校验结果生命周期。

- `rx.validate` 根据文件名检查单文件语法。
- `rx.validateModules` 检查完整普通模块集合，包括路径规范化、重复注册、引用存在性与循环依赖。
- Gateway、Store 特殊文件在库层使用单文件入口；CLI 的 Gateway 入口另行装载 Route.service 普通目标并校验模块图，模块 Store.from 另行读取和校验 Store 定义。Store 字段类型、初值 Program 与项目级 getter/setter 分析已接入；生成源码可接受显式宿主，Store 应由 genz 生成应用级共享内存状态，启动初始化一次、跨请求保留；当前已撤除磁盘实现；独立请求入口已按成功提交接管请求 arena，静态独占写入已支持边界回收，一般共享值的有界回收仍未实现。定义检查本身不创建状态。

接口接入示意：

```zig
const sources = [_]rx.ModuleSource{
    .{ .path = "checkout.rx", .node = checkout_ast },
    .{ .path = "orders.rx", .node = orders_ast },
};

var result = try rx.validateModules(allocator, &sources);

defer result.deinit();
```

AST 必须对应实际输入文件，不能用手写的替代结构宣称完成端到端解析验证。诊断中的 source_index 对应输入文件，issue.location 与 attribute 指向错误位置。结果拥有 arena，借用字符串仍需遵守输入生命周期。

单文件通过不能代替完整项目检查。只有集合入口返回 data，才表示传入集合通过了该入口覆盖的检查；执行使用 `rx_analysis.project.infer` 返回的 Program 或 `zxc build`；集合结构校验本身不是执行门禁。

## 构建与回归

在仓库根目录或 `packages/compiler` 内运行：

```sh
zig build
zig build test
```

这些命令执行库回归，不会自动发现和验证业务项目新增的 .rx 文件。

修改相关行为时，关注路径归一化、目标缺失、自环、多层环、嵌套分支、合法共享依赖、错误位置和分配失败。已有依赖图测试在 `packages/compiler/tests/rx/dependency_graph_test.zig`，通过枚举三节点有向图的 512 种情况，将生产 DFS 与独立拓扑算法对照。有限穷举不是一般规模的机器证明，也不能证明业务结果正确。

无关的文档改动无需重复运行全套业务回归。报告实际检查过的范围，不把计划执行的检查写成已通过。

## 能力边界

`zxc check-rx` 支持显式普通模块文件集合，以及 `--entry` 的普通模块/Gateway 可达依赖装载和 Store 定义检查。Gateway 先沿所有嵌套 Route.service 找到普通模块；普通模块沿 Import、所有嵌套 Call.module 和 Store.from 装载。入口装载检查物理身份和项目根边界，普通模块子集最终仍调用完整集合校验；Gateway/Store 只进入各自 Schema 检查，不混入普通调用图。它不扫描不可达文件。`zxc build` 已支持普通模块 Call.fn/Call.module/Return、Task 和 Switch 的项目推导与应用构建；Store 声明与单 Object setter 支持显式授权源码生成；目标为替代隐式全局变量的共享内存，当前已移除 --state-dir 与磁盘保存，顺序调用共享 State，独立请求由生成的 Request 管理 arena。Parallel 已支持直接纯计算 Call 和 Task 的真实线程执行与结果汇合；Task 静态提取为独立函数，通过 $ctx.task.<name> 公开分支返回值。Store 并发及原生副作用仍未实现。HTTP Gateway 已接通静态路由、统一服务链接和共享 State 的顺序请求宿主；独占 Store 写入已生成请求边界回收；其他协议、并发、超时及一般共享 Store 回收仍未实现。事件订阅调度尚未实现。Emit 的语法存在不代表事件处理已经可运行。表达式解析、ZX 类型联结与 Store 初始化执行也不能从结构校验成功推断出来。

维护公开指导时，用使用者能理解的版本和环境能力描述这些限制，不要求使用者阅读内部 AST、修改编译器或运行 zxc 仓库测试。

Store 语义以 [Store 设计](../docs/2026-10-05/Store设计.md)为准：不自动落盘或重启恢复，不把应用级共享状态改成每次调用的局部副本，不保存已释放请求内存的引用。

普通模块图按 ModuleSource.packages 中当前源码所属包的声明区分包引用与本地 RX；CLI 装载、编译库收集和项目推导必须使用同一 module_reference 分类。不能按文件存在与否切换解析方式，也不能跳过未声明的本地目标或环检查。Route.service 保留普通 RX 路径语义，不继承 Call.module 的包分类。
