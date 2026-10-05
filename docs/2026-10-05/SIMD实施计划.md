# SIMD 与汇编优化实施计划

## Intent：最终目标

消除数组 map 生成代码中的逐项扩容路径，使已知长度的逐元素计算具备直接向量化的循环形式，并通过实际汇编验证 SIMD。保留既有 --asm、--target、--cpu、--optimize 构建入口。

## Data：可用证据

当前 genz/zx/transform.zig 将 map 与 filter 都生成为 ArrayList.append 循环。map 输出长度已由输入决定，循环内扩容判断与潜在分配没有必要，也阻碍 LLVM 识别直接的数组运算。

## Edges：边界与限制

仅改变 map 的结果存储分配；filter 输出长度不确定，reduce 维持既有顺序。浮点归约不重排，不开启 fast-math，不为示例算式生成特例。map 一次预分配会让分配失败发生在回调执行前，不承诺保持此前逐项扩容的分配次数或 OOM 时机；回调的元素顺序保持不变。整数溢出与函数调用仍遵守已有生成语义。

自动向量化依赖目标架构、CPU、优化等级与回调形式；不能把单个汇编示例扩展为任意 map 都使用 SIMD 的承诺。无正式新增测试，不运行全量测试。

## Answer：交付与成功标准

为通用 for 节点提供可选索引，map 按输入长度一次分配并逐索引赋值。实际构建一个仅依赖运行时元素的浮点 map（遵守回调不捕获外部绑定的既有规则），运行并检查对应业务函数的 SIMD 汇编，另核对空数组和非向量长度尾部。保存源码、结果与相关汇编片段，形成 usage/reference。

```mermaid
flowchart LR
  A[ZX map] --> B[IR transform]
  B --> C[genz 分配确定长度结果]
  C --> D[按索引写入的普通循环]
  D --> E[Zig/LLVM 目标优化]
  E --> F[向量循环与标量尾部]
```

```mermaid
flowchart LR
  A[输入数组与捕获值] --> B[按序计算回调]
  C[一次分配的结果数组] --> D[写入对应索引]
  B --> D
  D --> E[返回结果切片]
```

## 汇编观察后的调整

预分配已消除扩容，但实际 ReleaseSafe 与 ReleaseFast 的 x86 baseline 汇编仍是标量 mulsd/addsd，仅做循环展开。不能把预分配本身当 SIMD 已交付。继续生成显式 Zig Vector：只覆盖同类型 f32/f64 map 的元素引用、数值常量、取负和四则运算，拒绝将调用、条件分支或整数检查强行向量化。向量宽度由 std.simd.suggestVectorLength 在编译期按目标确定，无 SIMD 目标使用单 lane；剩余元素沿原标量表达式执行。

## 实施与验证结果

通用 for 节点增加可选索引与 range 表达式；所有 map 单次分配。独立 zx/simd 负责浮点表达式资格检查、编译期目标宽度、向量块与标量尾部。常量回调不产生未使用的元素临时变量。

已观察 SSE mulpd/addpd、AVX vmulpd/vaddpd、AArch64 向量 fmul/fadd、WASM f64x2.mul/f64x2.add。片段和生成源码保存在 SIMD 目录。相同运行时数组经优化前后 Node 插件执行一致，覆盖空数组、短数组、尾部和 257 项数组；浮点特殊值亦按数值语义一致。f32 广播常量、取负、除法、常量清零回调和既有嵌套 map/filter/reduce 实际执行成功。WASM 有 SIMD 和无 SIMD 两种目标输出一致。ARM 只验证交叉构建和汇编。

## 自我批判

预分配只是必要改进，首次检查发现仍无 SIMD；随后才实现显式 Vector。没有把标准库其他函数中的向量指令计为本功能成果，也没有由指令存在推断提速比例。资格检查有明确范围，不声称任意回调可向量化；NaN 的观察比较数值类别，不证明所有 payload 位逐位一致。未运行全量测试或新增正式测试。
