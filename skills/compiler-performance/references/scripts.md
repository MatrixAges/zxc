# 脚本调用

## 环境与输出约定

Node.js 20+，全部为 `.mjs`，只依赖内置模块。相对于当前 skill 目录调用 `scripts/`。脚本不读取 Claude 配置、不安装依赖、不自动修改源码、不删除缓存。测量脚本会执行你明确传入的命令，该命令本身的写入行为由任务范围决定。

每次使用新的报告路径，避免覆盖基线。仓库若规定忽略 `docs/**/*.json` 和日志，沿用该规则；Markdown 记录引用报告路径与关键数字。不要把报告放进待比较的产物树。普通使用先运行 `--help`，不需要读取全部脚本源码。

## measure.mjs：限时顺序测量

```bash
node "$skill_dir/scripts/measure.mjs" \
  --scenario warm-generator \
  --runs 3 \
  --timeout 120 \
  --cwd /absolute/path/repository \
  --input /absolute/path/manifest.json \
  --input /absolute/path/toolchain-version.txt \
  --out /tmp/compiler-before.json \
  -- /absolute/path/generator --manifest /absolute/path/manifest.json /tmp/output /tmp/cache
```

`--` 后传实际命令和参数，直接 spawn，不执行 shell 展开。确实需要管道时，显式运行 shell，并保证真实失败码不被后续过滤命令覆盖。`--input` 可重复，输入相对路径基于 `--cwd`；报告路径基于脚本启动目录。

产出：JSON 报告，以及 `<报告路径>.logs/` 中每轮独立的 stdout/stderr。

报告记录：

- 实际可执行路径及 SHA-256，cwd、argv、主机 OS/架构/逻辑核数；
- 显式输入前后内容摘要；输入或可执行文件改变则 `valid=false`；
- 每轮墙钟、外部 time 的 wall/user/system、峰值 RSS、退出码、信号和超时原因；
- 日志尾部符合 `infer Nms, emit Nms` 的原始阶段摘要，不推算缺失阶段；
- 仅全部成功且输入未变时，给出墙钟中位数。

退出码：被测命令非零时保留退出码并停止后续轮次；超时 124，中断 130/143，启动故障 125，参数/证据问题 2。超时先终止本次新建进程组，最多一秒后强制结束该组；不会按名称杀其他构建进程。主动脱离进程组的 daemon 不在此保证内，不用这个脚本验证 daemon 生命周期。

macOS 读取 `/usr/bin/time -l`，RSS 为字节；Linux 读取 GNU `/usr/bin/time`，将 KiB 转字节。不是整棵进程树的同时峰值。缺失指标保持 null。Linux 分支尚未在本机实跑。

冷暖是调用者声明：脚本不清缓存。连续多轮会热身；要测多次冷构建，每次准备独立缓存并分别运行。源码版本、环境开关、缓存范围及其他并发负载需另记，`--input` 不能代替全仓快照。输出日志保留原文，命令或编译器输出若包含秘密，不要直接发布报告。

## compare_outputs.mjs：完整文件集合与内容摘要对比

```bash
node "$skill_dir/scripts/compare_outputs.mjs" \
  /tmp/generated-incremental /tmp/generated-clean \
  --out /tmp/generated-diff.json
```

比较相对文件集合与逐文件流式 SHA-256，支持二进制。缺失、额外和内容变化分别列出。退出码 0 相同、1 有差异、2 输入或 IO 错误。拒绝同一目录、双空集合和树内符号链接，避免无效验证或越界遍历；空目录和文件权限不属于比较对象。

默认不忽略任何文件。确认 `.zxc-inputs` 只包含预期变化的生成器身份时，才可显式添加 `--exclude .zxc-inputs`；每个排除项必须是精确相对文件路径，无通配符，并在报告保留。先看未排除差异，再解释为何排除，不能忽略所有变化来制造一致。

产物应来自已完成且不再写入的两轮构建。本脚本不是文件系统快照，不能拿仍在生成的目录作为有效证明。

## profile.mjs：带进程身份的 macOS 采样

```bash
node "$skill_dir/scripts/profile.mjs" \
  --pid 12345 \
  --seconds 3 \
  --interval 1 \
  --out /tmp/compiler-profile
```

仅支持 macOS 的 `/usr/bin/sample`；`--interval` 单位毫秒，采样持续 1–60 秒。产出 `sample.txt`、`target.json` 和 `profiler.log`，保留采样前后 PID/PPID/启动时间/命令及 profiler 状态。目标退出时 after 可为空；前后身份变化视为异常。权限或 profiler 错误直接保留并返回失败，不自动 sudo。

必须先由实际启动记录或进程信息确认 PID，不采用 `pgrep ... | head`。采样本身另设持续时间加十秒的强制上限。它不解析原始调用树，不将短窗口百分比当端到端百分比，也不自动解释 strip 或折叠符号。

## inspect_generated.mjs：生成代码静态成本线索

```bash
node "$skill_dir/scripts/inspect_generated.mjs" \
  /absolute/path/generated \
  --top 20 \
  --out /tmp/generated-inventory.json
```

扫描 `.zig`，汇总字节、行数、函数及 `@memcpy`、dupe、renew、reserve、defer/errdefer、try 的文本计数；按体积、复制位置、清理位置排序。支持与另一轮报告对照，但不自动声称优化收益。

计数包括注释和字符串，只提供源码检查入口。脚本不做语义去重、不估计真实执行次数、不用 defer×try 预测 IR 大小、不自动删除代码。需要进一步用 AST、实际 IR 或采样核实。
