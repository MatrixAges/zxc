# RX 状态联结实施计划

## Intent：最终目标

让真实 .store.rx 定义进入类型系统、显式调用授权和可运行的状态宿主，保留每个 Call 独立提交的语义。当前开始类型定义与初值阶段；完成初值分析不能记作 Store 调用或持久化已完成。

## Data：可用证据

Store Schema 已保存 name/version、Object 和 Field(name/type/value)，CLI 只做结构检查。ZX Program 有 StoreSlot，Function 没有 Store 能力；RX 将 ZX 入口转成普通 Function 时会丢弃这一实体，Zig helper 也清空 stores。旧 RX 设计给出单个 Call 的快照读取、单 Object setter、暂存、提交与失败丢弃边界。当前正式 ZX 接口通过显式 StoreBinding 和 context.commit 实现入口级提交。

## Edges：边界与限制

每个 Call 的写入独立提交，后续调用失败不回滚已提交调用；不能合并成整个 RX 流程的单次提交。普通 ZX 导入函数不自动继承权限，Call.service 使用被调模块自己的 Store 声明。只读 getter 与 setter 权限分开，不恢复已删除的 Context 功能。

本阶段 Field.type 使用 ZX 类型表达式，Field.value 使用无环境的 ZX 表达式；禁止插入额外声明或函数。不引入动态 any/map、不擅自将空属性解释为默认值。空字符串写为显式字符串字面量。原生 SDK、持久化、并发版本与快照恢复仍要在后续宿主阶段实现。

Store 的身份由规范化定义文件路径与 Object 名组成，显示 Store.name 不作为全局身份。允许同一文件分段声明同名 Object 的不同字段，沿用 Schema 的重复字段拒绝。类型化初始化程序必须通过现有所有权与 IR 校验，输出内存由调用方 arena 持有。

不新增测试、不执行全量测试或浏览器确认。新库 API 和 CLI 定义检查使用真实 XML，验证只使用既有回归和可审阅的应用材料。

## Answer：实施阶段与成功标准

1. 提供 Store 定义分析 API，解析真实字段类型和初值，输出独立的对象初始化 Program；CLI check-rx 的 Store 定义装载接入类型检查。
2. 为带能力的 Call 保留授权与独立 pending/commit 边界，补齐 IR 或生成适配接口；不得把合并 StoreSlot 当作完成。
3. 接入 Module 注册、Call.in 快照和 setter 解析，按共享 TypeId 验证完整 Object 替换。
4. 生成持有状态的宿主，解决请求 arena 与状态存活期、版本检查、失败与恢复；逐项验证后才宣称 RX Store 可执行。

```mermaid
flowchart LR
  XML[Store真实定义] --> Typed[字段类型及初值Program]
  Typed --> Registry[路径与Object身份注册]
  Registry --> Call[每个Call显式授权]
  Call --> Pending[独立暂存]
  Pending --> Commit[宿主版本校验与提交]
```

```mermaid
sequenceDiagram
  participant D as Store定义
  participant C as 编译器
  participant H as 状态宿主
  participant F as 授权Call
  D->>C: 类型与初值表达式
  C->>H: 经过校验的初始化程序
  H->>F: 当前快照与只写能力
  F->>H: 本次Call的pending
  H-->>F: 提交成功或冲突
```

## 阶段一实施

新增 rx_analysis.store.analyze。它先复用 Store Schema，再按规范化文件与 Object 名分析；同名 Object 的所有字段片段按源顺序收集，类型字段排序后仍用字段名映射实际索引。Field.type 只允许一个类型表达式，Field.value 交给既有 XML 属性表达式编译器。共享类型表保持前缀编号稳定，所有初始化 Program 最终使用同一份类型表。

每个 Object 生成无输入的纯初始化 Program，经既有所有权与 IR 校验。API 独立拥有结果，释放输入 XML 后仍能生成代码。CLI collection 在装载 Store 时调用该接口报告语义错误；目前不把初始化程序交付给 RX 调用执行器，后续授权与宿主阶段继续保留。

## 自我复核

没有把初始化 Program 当作动态解释器，也没有把定义分析当作状态提交完成。初值中的运行时运算错误与内存分配错误仍可能在初始化执行时发生。字段字符串必须使用 ZX 双引号字面量；XML 自身的引号与 ZX 字符串引号是不同层次。

静态复核追踪了 XML 释放后的所有权、类型前缀、字段排序和声明注入边界，未发现确定缺陷。父 arena 统一持有中间分析分配；不能提前 deinit 被结果类型表引用的子分析数据。当前尚无新的分配失败专项，不把常规运行成功外推为全部资源失败路径已验证。

## 阶段一验证

- CLI 构建 17/17 步骤通过，既有 RX 文本回归 19/19 步骤、120/120 测试通过。
- 既有 RX CLI 专项 14/14 步骤通过，包含 11 个命令场景、9 个磁盘服务项目场景和 watch 生命周期；未运行全量测试。
- [真实 Store 示例](RX状态联结/示例/state.store.rx)通过 check-rx --entry。独立 [API 使用程序](RX状态联结/演示/generate.zig)先释放 XML 文本和解析结果，再生成两个 Object 的 Zig 初始化程序；演示构建 4/4 步骤通过。
- 两个初始化程序分别编译执行，dispatcher 输出 cursor=0、history=[1,2,3]、label=ready，settings 输出 limits={enabled:true,limit:8}。类型规范顺序与源声明顺序不同，真实输出仍对应正确字段。
- [实际初始化结果](RX状态联结/初始化结果.json)保存输出与材料摘要，[实现快照](RX状态联结/实现/)对应本轮正式源码。未添加测试文件、未调用浏览器。

下一阶段继续每个 Call 的能力携带、setter 解析和状态宿主。当前 CLI 装载只校验后释放定义，没有把它误接到尚无状态生命周期的普通函数执行链。
