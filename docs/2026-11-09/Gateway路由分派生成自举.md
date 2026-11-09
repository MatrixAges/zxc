# Gateway 路由分派生成自举

## Intent：最终目标

把 `gateway/entry.zig` 的请求头守卫、路径提取、路由分组、方法分派、
Allow 头、404 和 dispatch 函数声明完整迁入 RX/ZX。RX 表达阶段依赖，
ZX 保留原子构造与有序集合算法。完整 Gateway 模块装配仍是后续职责。

## Data：可用证据

阶段前为 `e6ac1dbe`。正式入口已消费 `generated_gateway_dispatch`；原生
`dispatch.zig` 只做只读布局借用、错误映射、通用 AST 发布和根声明读取。
旧算法保留于 `dispatch_seed.zig`，仅用于初始引导。

```mermaid
flowchart LR
    Prepare[初始化] --> Symbols[符号与请求类型]
    Symbols --> Guard[请求头400守卫]
    Guard --> Paths[空路由或提取路径]
    Paths --> Routes[首次路径顺序与方法分组]
    Routes --> Missing[404响应]
    Missing --> Finish[公开函数签名]
    Finish --> Publish[结构化AST发布]
```

```mermaid
flowchart LR
    Native[Route数组及AST基址] --> Borrow[编译期布局校验的借用]
    Borrow --> RX[真实阶段编排]
    RX --> ZX[原子构造及集合算法]
    ZX --> Columns[共用Context及AST列]
    Columns --> Import[通用借用发布]
    Import --> Printer[统一printer]
```

- 保留原 O(n²) 首次路径扫描和分组顺序、组内原方法顺序、首个 `?` 截断。
  通配路由、400/405/404 文案、Allow 分隔符及原样返回错误联合均保持。
- Route 使用 `path:u8[]、method?:u8[]、service:u64` 对齐原生字节视图。
  `storage.view` 继续检查 size、align 和字段 offset。生成布局为
  method/path/service；原生内部字段声明顺序随之对齐，不分配转换数组。
- 方法组缺少 method 时显式返回不变量失败，不静默跳过。正常输入的互斥
  前提来自 RX 全方法掩码校验；原生在 AST 发布前拒绝无效方法组。
- 共用 `request_types.zx`、`response.zx` 和所属 `const.zx`，避免复制接口和
  响应构造。通用 `std:bytes.join` 直接调用 `std.mem.join`，与已有
  `string.join` 同算法；没有模板、RawCode 或专用运行库。

### 功能与引导证据

证据目录为 `.zig-cache/cold-build-analysis/ownership-research/gateway-dispatch`。

- 空 stage0 引导 31/31 步通过，新标准目录包含 bytes.join。
- production 和 confirm 均 21/21 步通过，工具 SHA 相同：
  `6940be70b128d168ba50ba9674b65479bafb27c6a7ab497ac4f76955cb4fbd2c`。
- 正式 Gateway、JSON Gateway、模块生成回归 62/62 步、71/71 项通过。
  既有 HTTP 用例覆盖 query、字面路径、405/Allow、通配方法、请求头拒绝和
  服务失败恢复。分配失败回归覆盖 RX 推导及模块生成/借用发布边界，
  不代表穷举了 Source dispatch 内的每个分配点。
- 审计发现 http_seed 仍从正式 invoke 引用已移除的 response，已改为导入
  invoke_seed。冻结修复前源码的独立编译确实报缺失成员，修复后可编译并运行
  seed Gateway 生成。临时诊断文件及日志均忽略，不新增仓库测试用例。
- RX/ZX 格式及 lint、原生格式检查通过；去除两处未使用的 bytes 导入。
  最终 review 引导 21/21 步通过，SHA 与 production/confirm 完全相同，
  覆盖 seed 依赖修复及导入清理后的最终源码。

### 性能证据与口径

完整冷构建固定为 P2、12 核、空 stage0、全新 local/global 缓存、相同 Zig
归档。单体峰值来自 time；树峰来自 0.2 s 采样。累计 CPU 不是用户等待时间。

| 指标               |       阶段前 |       阶段后 |
| ------------------ | -----------: | -----------: |
| 完整冷构建墙钟     |     130.22 s |     131.69 s |
| 完整冷构建累计 CPU |     195.99 s |     196.56 s |
| 单体峰值           | 2134851584 B | 2125643776 B |
| 树峰值             | 2144878592 B | 2136178688 B |

不把单轮内存略降宣称为收益，也不隐去墙钟 +1.47 s 和 CPU +0.57 s。
历史固定完整冷构建仍保留 129.74 s、CPU 216.03 s、单体 2075033600 B、
树峰 2247294976 B；该基线不随阶段更新。相对它，当前墙钟 +1.95 s、
CPU −19.47 s、单体 +50610176 B、树峰 −111116288 B，内存剩余差额仍需跟踪。

两次完整冷构建中 configurer 首次出现为 29.234/30.629 s，P2 关键对象
持续 33.734/33.776 s，host 持续约 32.85/32.83 s。maker 二进制完全相同，
但 maker 到 configurer 的依赖准备时间不同，不能仅凭二进制相同排除其成本。

为定位而补充一次正序及一次反序项目冷构建：冻结前后源码，使用同一个 maker
和 seed、相同 P2/12 核/空 stage0，各自全新 local/global 缓存；排除 maker
自身构建，保留依赖准备和所有项目步骤。四次均 43/43 步通过。

| 配对  |   前墙钟 |   后墙钟 | 前累计 CPU | 后累计 CPU |
| ----- | -------: | -------: | ---------: | ---------: |
| 前→后 | 100.74 s | 101.62 s |   169.38 s |   169.42 s |
| 后→前 | 102.08 s | 100.99 s |   169.20 s |   170.25 s |

这组墙钟差异方向相反，均值 101.410/101.305 s；CPU 均值
169.290/169.835 s，不能把墙钟略降当成整体性能改善。反序的进程 CPU 采样
显示未改源码的 cache-identity 编译 +0.93 s、RX 检查编译 +0.86 s，受影响的
seed generator 编译 −0.41 s、分区对象合计 −0.66 s、生成器运行 −0.42 s。
采样会漏掉短进程及退出前尾段，不能把这些近似值当精确 CPU 总量分解。

P2 host 另有三对隔离记录：中位 CPU 34.36/34.30 s、墙钟 32.43/32.35 s，
逐对方向混合，未观察到稳定退化或收益。固定 manifest 的生成器八轮交替、
排除首轮，中位固定累计基线/阶段前/阶段后 CPU 为 5.34/5.19/5.18 s，
墙钟为 1.16/1.11/1.11 s。2268 文件差异仅 types.zig 和两个清单/指纹；
types 增加 bytes.join 声明及对应参数元组，另有既有列表类型声明顺序变化。

结论限定为：受本次迁移影响的生成器、分区和 host 路径没有观察到稳定成本
增长；完整构建及隔离项目构建的 CPU 总量偏差继续保留，未证明整体冷构建
零差异，也不作为下一阶段可重复领取的容差。后续比较继续使用固定基线，
若同一方向持续增长，需要定位处理，不再为相同源码重复计时。

## Edges：边界与限制

Route 及字节输入只读借用，发布不复制底层输入文本；AST 列和必要名称仍有
线性分配，方法及分支追加保留 renewal。Builder 描述符仍存在装箱成本，
不能把零拷贝写成零分配。改算法、取消布局校验、回退迁移均不属于解决方法。

正式路径不回调 seed；seed 分支保留正常引导用途。entry.render 的整体模块
装配和 arena 生命周期尚在原生层，其他编译器原生规则及状态桥也未清零。
因此本阶段只证明路由分派职责迁移，不证明完整自举完成。

## Answer：交付与成功标准

交付 Source dispatch 全职责及真实 RX 编排、严格借用适配、独立 seed、
共享类型/响应原子和 bytes.join。汇总现有行为、阶段稳定性和实际成本证据，
统一提交全部未提交文件，英文 commit 推送并核对工作区和上游。

下一完整职责为 Gateway 模块前导与服务 imports 声明：上游已持有
`imports[1..]` 模块名数组，可直接借用；复用 Source constant builder 和
通用 borrowing-text 发布，避免从 Service[] 复制模块名称列。不把此后续
职责或最终传递依赖/三阶段自编译验收写成已完成。
