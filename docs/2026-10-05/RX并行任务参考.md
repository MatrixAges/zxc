# RX 并行任务参考

## Intent：使用目标

在一个 Parallel 中并行执行多个包含顺序调用或条件控制的纯计算分支，等待全部分支完成后使用显式输出。

## Data：语法与示例

```xml
<Module>
  <Parallel>
    <Task name="number">
      <Call fn="identity" in={$in.value} />
      <Return value={ctx.identity} />
    </Task>
    <Task name="flag">
      <Call fn="invert" in={$in.enabled} />
      <Return value={ctx.invert} />
    </Task>
  </Parallel>
  <Return value={{value: ctx.task.number, enabled: ctx.task.flag}} />
</Module>
```

完整的 [可运行示例](并行任务/示例/main.rx) 还包括外层绑定捕获、Switch、嵌套 Parallel 和无输出 Task；实现依据和验证记录见 [实施计划](并行任务实施计划.md)。[动态列表示例](并行任务/示例/lists.rx) 演示分支分配输出，以及父流程继续消费未被捕获的外层列表。

## Edges：执行边界

- Call 无 out 属性；Task 保留可选 out 表达式，用来聚合分支输出。Call 结果通过 ctx.<name> 读取；直属 Parallel 的 Task 结果通过 ctx.task.<name> 读取，两类结果可同名。Call 的 name 不得为保留名 task。
- 直属 Parallel Task 是独立执行边界，内部 Return 结束该分支；普通顺序 Task 可通过 out 表达式发布聚合值；未写 out 时仍只是分组，其 Return 结束最近的模块或并行 Task 边界。
- Task.out 必须用花括号表达式，不能写字符串绑定路径；它在子步骤结束后求值，与同一任务的 Return 不可并用。
- Task 可以读取进入 Parallel 前的 $in 与结果绑定，不能引用兄弟结果。编译器只捕获实际使用的外层符号，输入按借用处理，不复制所有权。
- Task 内 Call 的结果只在分支内部可见；Task 结果和直属 Call 结果在全部分支结束后一起进入外层作用域，同类结果名不得重叠。
- 没有 out 与 Return 的分支为 void，不产生可读取的结果。非 void 分支必须覆盖全部返回路径；void 分支仍执行并传播错误。
- Task 中的调用闭包必须为纯计算，不能访问 Store 或执行原生 external。需要共享数据时，在父流程先取得授权快照，再交给纯分支读取；不会把 Task 中的状态访问自动移动到父线程。
- 全部线程完成后按声明顺序报告首个错误。线程启动失败时等待已启动线程，不取消其他分支、不降级成顺序调用。

## Answer：构建与交付

在仓库根运行；`z3` 应替换为可用求解器路径：

```sh
zxc build docs/2026-10-05/并行任务/示例/main.rx --solver z3 --out parallel_tasks
./parallel_tasks '{"enabled":true,"value":255}'
zxc verify docs/2026-10-05/并行任务/示例/main.rx --solver z3 --out tasks.smt2
zxc fpga docs/2026-10-05/并行任务/示例/main.rx --solver z3 --out tasks.sv
zxc build docs/2026-10-05/并行任务/示例/pkg.yaml --mode lib --solver z3 --out published
```

示例输出为 `{"enabled":false,"value":255}`。Task 编译成普通静态函数，沿用统一编译库和 Parallel 调用 IR；消费端不需要专用任务运行库。支持的 bool、枚举、定宽整数与对象、元组可进入既有纯函数证明和 FPGA 后端；动态数据仍受后端类型限制。

证明覆盖计算安全与到达契约，不覆盖操作系统调度、线程资源和锁实现。硬件产物表达纯函数关系，不承诺分支与物理运算单元一一对应。

已发布的示例库与消费端位于 [消费目录](并行任务/消费/main.zx)。消费前离线安装工作区，再指定源码入口与项目清单：

```sh
zxc pkg install docs/2026-10-05/并行任务/消费/pkg.yaml --offline
zxc build docs/2026-10-05/并行任务/消费/main.zx --project docs/2026-10-05/并行任务/消费/pkg.yaml --solver z3 --out consumer_app
./consumer_app '{"enabled":false,"value":0}'
```

消费端输出为 `{"enabled":true,"value":0}`，且继续检查自身与库内到达的契约。

多个 Task 可以只读共享父流程中产生的 owned 列表，捕获包装本身不会消费它，也不会复制列表。真实示例与所有权边界核对见 [聚合借用修复记录](聚合借用修复实施计划.md)。消费式操作仍必须使用独立 owned 值，不能消费借用的捕获。
