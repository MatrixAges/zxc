# runtime

zxc 生成应用的状态与执行生命周期支持，只依赖 Zig 标准库。

## Intent：最终目标

让 Store 版本拥有独立内存，使旧快照、请求输入和新提交互不依赖临时 arena 的存活期。

## Data：公开接口

`Store(T)` 接受 ZX ABI 的不可变值类型：标量、枚举、可选值、普通数组、元组、结构体、不可变对象指针和切片。递归类型、可变指针、裸指针及 sentinel 指针不属于该接口。

- `init(allocator, value, revision)` 深复制初值，创建 Store owner。
- `snapshot(io)` 返回持有当前版本的 Snapshot。`value()` 读取不可变值，`revision()` 读取修订号。
- `Snapshot.retain()` 创建另一个持有句柄；每个持有句柄必须对应一次 `deinit()`。
- `commit(io, expected, value, persistence)` 深复制候选值，核对 expected 的版本节点身份，在持久化成功后发布，并返回持有新版本的 Snapshot。
- `Store.deinit()` 释放 owner 的引用。仍被 Snapshot 持有的版本保持有效。

持久化参数提供方法：

```zig
pub fn save(self: *Persistence, io: std.Io, previous: u64, next: u64, value: State) !void
```

save 必须保证失败原子性。它在 Store 锁内执行，不得重入同一个 Store；只有返回成功才会发布内存版本。磁盘身份、schema、跨进程互斥与恢复由持久化实现负责，本接口不会自动提供这些机制。

## Edges：边界与限制

Snapshot 是显式持有句柄，直接赋值复制不会增加引用计数。把句柄传给只借用它的函数不需要 retain；两个独立使用者分别释放时必须先 retain。

所有版本数据由版本自己的 arena 持有。深复制不会保留输入的对象、列表或字符串指针；它不保持不可变数据内部的共享地址关系。传入的 allocator 必须活到所有 Store 和 Snapshot 释放之后；并发使用时 allocator 也须支持并发。

snapshot 与 commit 通过 std.Io.Mutex 协调，引用计数为原子计数。过期 Snapshot 和来自其他 Store 的 Snapshot 均返回 Conflict。revision 达到 u64 上限时拒绝继续提交。deinit 要求调用方已经停止针对该 owner 的并发操作。

提交返回的 Snapshot 不应在输出仍被使用时释放。生成宿主还需在提交前准备好快照保留列表的容量，保证发布后不会因保留句柄分配失败而丢失生命周期管理。

目前完成版本、请求内存管理和独立快照文件组件；原生 runner、自动宿主与发行资源的接入仍在实施。

## 请求期间的版本保留

`Request(T).init(allocator, io, &store)` 捕获当前 Snapshot，并提供地址稳定的 `value` 单元供生成 getter 引用。`request.commit(value, persistence)` 使用请求当前版本提交；成功后更新 value，保留旧 Snapshot，直至 `request.deinit()`。读取或序列化所有借用结果之后才能释放请求。

保留列表在提交前预留容量，提交成功后只有不再分配的句柄转移与值单元更新。分配、冲突或保存失败不会替换请求当前版本。请求使用独立列表分配器；该分配器与 Store 的分配器都必须覆盖各自持有资源的存活期。

一个 Request 不支持并发访问。创建 getter 指针后不能移动 Request；owner 地址在请求提交期间也必须稳定。请求只跟随自身成功提交更新，其他请求提交不会自动刷新它；使用旧版本写入仍返回 Conflict。它不负责磁盘恢复、跨 Object 事务或自动生成整个应用宿主。

## 磁盘快照

`SnapshotFile.init(allocator, directory, options)` 借用已打开的状态目录及 metadata 字符串。options.metadata 包含 identity、schema_version、type_identity；options.limit 是可选的读取与写入字节上限，默认 unlimited。生成宿主应使用编译器提供的物理身份和 ABI 类型身份。目录的创建、生命周期及创建后的持久性由调用方负责。

- `load(T, io, arena, initialize)` 在独占锁内读取和验证快照，返回 revision 与 value。文件不存在时才执行 `initialize(arena, {})`，保存 revision=0；已有文件不执行初始化函数。返回值借用 arena，交给 Store.init 深复制后才可释放。
- `save(io, previous, next, value)` 实现 Store 的持久化回调。它持锁核对磁盘 revision，验证 metadata 与旧值类型，再写临时文件、同步文件内容并原子替换快照。成功替换是提交点。
- `sync(io)` 同步目录 metadata。应在 Request.commit 成功发布内存版本后调用；初始化 load 之后也需要安排目录同步。此时同步失败表示状态已经提交、耐久性未获确认，不表示回滚，不能按未提交操作自动重试。

每个 identity 使用 SHA-256 摘要对应的 `.json` 文件与稳定 `.lock` 文件。所有写入者必须遵守相同锁协议；不要删除或替换锁文件。此组件不覆盖 RX 源文件，不提供跨 Object 事务、schema 迁移或损坏文件的自动重置。

恢复时拒绝格式、identity、schema 或 type_identity 不匹配的快照，并按 T 解析值。JSON 数字保留原始文本，避免动态 JSON 中间值先转成 f64 导致整数精度丢失。过期磁盘版本返回 Conflict；缺失、损坏或不兼容的既有状态不会在 save 中被当作初值重建。

目录 sync 的支持取决于平台和文件系统；当前实际执行验证在 macOS 上完成。调用方必须处理同步错误。进程重启恢复、文件 sync 和目录 sync 成功不等同于已经做过断电实验，也不提供不遵守锁协议的外部修改或任意网络文件系统的一致性保证。

## Answer：交付与验证

独立模块名为 runtime。实施、架构和实际程序记录见 [状态宿主实施计划](../../docs/2026-10-04/RX状态宿主实施计划.md)。本包没有内嵌测试，也不把未执行的并发或分配失败路径标作已经验证。
