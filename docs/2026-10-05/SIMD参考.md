# SIMD 与汇编参考

## Intent：用途

通过普通 ZX map 表达逐元素计算，由 genz 在适用时生成目标相关 SIMD，并使用 --asm 查看实际汇编。无需引入解释器或向业务代码写入平台指令。

## Data：用法

```typescript
export type Input = f64[]

export type Output = f64[]

export default function (in: Input): Output {
  return in.map(value => value * value + value)
}
```

```sh
zxc build main.zx --out main --asm main.s --cpu baseline
zxc build main.zx --host node --out addon.node --asm addon.s --cpu x86_64_v3
zxc build main.zx --target wasm32-freestanding --cpu baseline+simd128 --out main.wasm --asm main.s
```

--cpu 按 Zig 目标 CPU/特性格式填写，与 --target 对应。指定更强 CPU 后，产物只能在支持相应指令的环境执行。--optimize 沿用 Debug、ReleaseSafe、ReleaseFast、ReleaseSmall，默认 ReleaseSafe；不需要开启 fast-math。

## Edges：适用范围

显式向量化覆盖输入和输出元素类型相同的 f32/f64 map，回调由元素引用、数值常量、取负和加减乘除组成。函数调用、条件选择、整数检查、改变元素类型等表达式继续走普通 map。回调仍遵守不捕获外部绑定的语言规则。

向量宽度通过 std.simd.suggestVectorLength 在目标编译期确定，不进行运行时 CPU 探测。没有可用 SIMD 建议时使用单 lane；非整块长度保留标量尾部。浮点运算树保持原顺序，不重排 reduce，也不通过 fast-math 放宽语义。

所有普通 map 都按输入长度一次分配结果，按原元素顺序写入。filter 与 reduce 不套用该分配规则。OOM 可在开始执行 map 回调前发生，不能依赖旧实现的逐项扩容次数或失败时机。

## Answer：执行证据

同一运行时输入示例已观察到 x86 baseline 的 mulpd/addpd、x86_64_v3 的 vmulpd/vaddpd、AArch64 的向量 fmul/fadd，以及 WASM 的 f64x2.mul/f64x2.add。汇编片段保存在 [SIMD 资源目录](SIMD/)。

本机 Node 实际运行覆盖空数组、短数组、非整块尾部、较长数组及浮点特殊值，结果与优化前产物一致。f32 常量广播、取负与除法已运行；普通嵌套 map/filter/reduce 也已核对。WASM SIMD 在 Node 的 WebAssembly 宿主实际执行；ARM 只验证交叉构建及指令生成。没有由指令存在推导整体应用提速倍数。

首次只做预分配时，LLVM 仅展开标量循环，实际汇编没有 SIMD，随后才增加显式 Vector 路径。LLVM 的自动向量化有适用条件，不能以循环形式或构建成功替代汇编证据。背景见 [LLVM Vectorizers](https://llvm.org/docs/Vectorizers.html)。
