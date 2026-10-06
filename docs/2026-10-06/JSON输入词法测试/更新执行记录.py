# -*- coding: utf-8 -*-
from pathlib import Path


root = Path('/Users/xiewendao/Documents/MatrixAges/zxc')
directory = Path(__file__).resolve().parent


def appendSection(path, text):
    current = path.read_text()
    heading = text.strip().splitlines()[0]

    if heading not in current:
        path.write_text(current + text)


path = directory / '逐份结论.md'
text = path.read_text()
text = text.replace('当前为已核对原文及草稿，正式登记在两模式目标验证后复制。', '两模式真实目标均已验证，23 份完整 adapted 已复制到正式登记；所有局部错误类型及通道适配均明示。')
path.write_text(text)
appendSection(path, '''
## 执行与自我复核

23 份原文普通/严格模式共 46/46 执行，透明记录原 JSON.parse 调用的输入与结果，保留实际异常重抛给标准 harness，共 54 次调用。既没有修改原文，也没有以重新编码后的合法 JSON 替代非法控制字符。本文所有原始输入已与 27 条正式 JSONL 逐字节核对。

Debug/ReleaseSafe 最终各执行 27 个具名案例、79 次目标观察，Wasm 27、native 26、WASI 26；42 次成功、37 次准确拒绝，两次含 NUL 的 argv 目标观察未执行且单独记录。每模式六次正式应用构建、58 条真实进程命令；两模式 Node runner 均实际运行而不复用运行结果缓存。

初轮两模式 27 个案例均通过，但两个 has_side_effects 节点使用相同报告名。Zig 0.17 的 Maker/Step/Run.zig 对此使用即时 hash 形成输出目录，文件输入依赖不提供两组报告的独立目录；报告相互覆盖，只留下最后一组。按 suite 名和模式命名输出后，两模式完整重跑，两组报告保留全部 79 次目标观察。首次日志与不完整报告原样保存，不从被覆盖报告推断完整执行证据。

测试采用真正生成的输入、普通恒等应用和正式 JSON 输出，唯一通道选择依据是 target 和通用 NUL 能力，没有按案例 ID 定制应用逻辑，也没有新增解析器或运行库。原文语义适配不代表 JS API 或异常对象兼容，整体 Test262 对齐尚未完成；没有发现此固定生产版本的实现违约，未通知实现聊天。
''')
path = root / 'docs/2026-10-06/JSON输入词法测试计划.md'
appendSection(path, '''
## 执行结果

固定生产 00b2b36e，Debug/ReleaseSafe 最终门禁各 32/32 构建步骤通过，27/27 具名案例实际执行，79/79 目标观察准确通过。原文 46/46 普通/严格执行，54 次真实 JSON.parse 调用的原始输入与结果已与 27 条案例核对。全部 23 份完整 adapted 已登记，五个选定家族待审为零；其他 JSON.parse 原文仍待审。

两模式各六次正式应用构建，58 条真实进程命令；Wasm 27 次观察保留所有原始控制字节，native/WASI 各 26 次，含 NUL 的两个 argv 目标观察单独记录。g2-4 实际错误名为 UnexpectedEndOfInput，g5-2 为 SyntaxError，准确差异未被模糊匹配掩盖。23 份测试依赖指纹、五份生产入口源码、实际 CLI 编译器、Zig JSON/argv/构建运行工具源码及应用二进制指纹见 [执行结果](JSON输入词法测试/执行结果.json)。

类型检查、生成一致性、矩阵审计均通过。累计 80,188 个登记案例（runtime 62,645）、2,499 份已审阅（713 adapted、103 equivalent、1,683 excluded），51,098 份未审阅，4,970 个关联案例。统计不代表当前全量执行通过率。

自我复核修正了首次报告被覆盖的问题：按 suite 和模式命名输出并实际重跑，两报告保存全部目标观察；首次通过日志及残留报告仍保留。源码原文没有被改写，27 个观察不按八个组合控制字符、三个目标或两个模式放大成独立案例。生产实现没有违约，未通知指定实现聊天。
''')
path = root / 'docs/2026-10-06/测试任务接替记录.md'
appendSection(path, '''
## JSON 输入词法接续

JSON.parse g1/g2/g4/g5/g6 五个旧词法家族的 23 份完整原文已 adapted，27 个完整文本/结果观察全部保留。正式 application_json runtime kind 真实构建并运行 native/Wasm/WASI；固定 00b2b36e，两模式各 27 个具名案例、79 次实际目标观察通过，含 NUL 的两个 argv 目标观察仅作通道限制记录，Wasm 全量执行。原文普通/严格模式共 46 次完整执行及 54 次真实 JSON.parse 调用另计。见 [JSON 输入词法测试计划](JSON输入词法测试计划.md)。

当前矩阵为 80,188 个目录案例、2,499 份已审阅、51,098 份未审阅、4,970 个关联案例；原生引用新增独立用例仍为 147。默认 runtime 与生成一致性已纳入新类型门禁。本轮专项采用 00b2b36e，不自动证明期间新提交 cbd51648 的项目纯类型索引优化；下一步继续完整 JSON 词法观察与当前源码的完整回归。
''')

print('IDEA results, report-collision self-review, and continuation record updated')
