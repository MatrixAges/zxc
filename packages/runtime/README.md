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

目前完成版本与内存基础；原生 runner、磁盘快照和发行资源的接入仍在实施。

## Answer：交付与验证

独立模块名为 runtime。实施、架构和实际程序记录见 [状态宿主实施计划](../../docs/2026-10-04/RX状态宿主实施计划.md)。本包没有内嵌测试，也不把未执行的并发或分配失败路径标作已经验证。
