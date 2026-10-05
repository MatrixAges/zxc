# zray

zxc 的本地开发控制台。使用 shadcn `sidebar-08`、`b1VlJBCq` 预设（Base UI / Luma / Neutral / Hugeicons）和本地 Google Sans、Geist Mono 字体。

## Intent：最终目标

连接模块源码、测试执行、Codex session 和迭代文档，让不同模块的开发可以并行推进、观察和回溯。

## Data：可用证据

- `app`：React + Rsbuild 前端；shadcn 配置位于 `app/components.json`。
- `server`：Hono 服务，通过 tRPC router 提供类型安全的查询和操作。
- 动态扫描有 `build.zig` 的包，索引 `src`、`examples`、`tests` 内的 `.zig`、`.zx`、`.rx`。
- 测试执行调用所属包目录中的 `zig build test`。通过 `build.zig` 的 `test` step 声明做文本发现，当前有 `compiler`、`rx`。
- 模块开发启动真实 `codex exec --json`，记录 session ID、执行事件、输出与文件变更。
- 每次启动或继续开发，都生成 `docs/YYYY-MM-DD/zray/模块迭代-<ID>.md`。

## Edges：边界与限制

- 本地单用户工具，仅绑定 `127.0.0.1`，不用于公网部署。
- 需要 Node.js 22.22.1+、pnpm、已登录且兼容当前配置的 Codex CLI。测试需要 Zig（仓库当前最低 0.17.0）。
- RX Runtime 尚未接入；模块预览展示源码，测试执行单位是整个包，不是单个文件或用例。
- 当前管理 zray 创建的 CLI sessions，支持继续这些 sessions；不扫描、导入或控制任意已有桌面会话。
- 模块按源文件关联，最多三个模块同时开发，同一个模块不能并发启动。
- 新会话有独立 Git worktree，包含 HEAD、当前已跟踪文件差异、目标包的未跟踪 Zig/ZX/RX 源码；不复制依赖安装目录和其他未跟踪资源。
- 继续 session 沿用原工作树，不重新同步主工作区。文档清单和界面 diff 是工作树的累计状态，包含初始差异。
- Codex 使用 `workspace-write` 和 `approval_policy=never`；超出沙箱的操作会失败，不会自动解除限制。
- 成果保留在工作树供审阅，需要自行合入。“待审阅”表示 Codex 正常结束，不代表通过验收；不自动提交、合并或删除工作树。
- 会话事件、元数据和工作树放在 `.zxc/zray`；可提交 Git 的迭代文档放在 `docs`。
- 服务正常关闭时停止受管进程；重启将原活动记录标为中断。服务被强杀或系统崩溃后，先确认没有遗留 Codex 进程，再继续 session。
- 测试历史仅在本次服务进程内保留。界面显示最近 200 KB 测试输出和最近 30 条会话事件，完整 Codex 事件落盘。

## Answer：启动、使用与验收

从仓库根目录启动：

```sh
pnpm install
pnpm dev:zray
```

开发界面：<http://127.0.0.1:4310>。Hono 后端：`127.0.0.1:4311`。前端通过 Rsbuild 代理访问 `/trpc`，不直接拼接后端地址。

如需分别启动，在仓库根目录运行：

```sh
pnpm dev:zray:server
pnpm dev:zray:app
```

服务启动时自动探测 PATH 中的 Codex，以及 macOS 标准应用目录中的 Codex / ChatGPT 内置 CLI，优先选择能读取配置且已登录的版本。若没有可用登录，保留可执行版本，让实际开发任务报告具体启动或登录错误。无需 `.env.local`，不修改全局配置。

使用流程：

1. 浏览模块源码，点击“用 Codex 开发”。
2. 写明本轮目标、修改边界与验收要求，启动 session。
3. 在看板查看会话动态，可为其他模块启动并行任务。
4. 检查变更与迭代文档，补充需求时点击“继续迭代”。
5. 审阅并验证工作树成果后自行合入。测试页运行主工作区的包测试；工作树验证由相应 session 或该工作树终端执行。

类型检查与构建：

```sh
pnpm --filter @zxc/zray-server typecheck
pnpm --filter @zxc/zray-app typecheck
pnpm build:zray
```

构建后，在仓库根运行 `pnpm start:zray`，由 Hono 在 <http://127.0.0.1:4311> 同时提供构建后的前端和 tRPC 接口。

`app` 和 `server` 是两个独立 workspace 包，分别拥有 package.json 和 tsconfig.json；zray 根目录不保留这两份配置。

前端业务放在 `app/features`，第三方 shadcn 组件在 `app/vendor`；后端按 `workspace`、`execution`、`sessions`、`rpc` 分组。包内不建立独立 `.git`、`.gitignore`、`.prettierignore`、Prettier 或 ESLint 配置，忽略和格式化规则由仓库根统一管理。

[实施方案与验证记录](../../docs/2026-10-03/zray开发控制台实施记录.md)
