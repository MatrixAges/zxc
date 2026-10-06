# -*- coding: utf-8 -*-
import hashlib
import json
from pathlib import Path
import shutil


root = Path('/Users/xiewendao/Documents/MatrixAges/zxc')
fixed = Path('/Users/xiewendao/.codex/worktrees/native-reference-conformance/zxc')
directory = Path(__file__).resolve().parent
value = json.loads((directory / '实际结果.json').read_text())
observations = [row for group in value['results'] for row in group['observations']]
commands = [row for group in value['results'] for row in group['commands']]
artifacts = [row for group in value['results'] for row in group['artifacts']]

assert len(observations) == 21 and len(commands) == 20 and len(artifacts) == 6
assert all(row['status'] == 0 and row['error'] is None and row['signal'] is None for row in commands)
assert all(row['response']['status'] == 0 for row in observations)
invalid = [row for row in observations if row['parse_error'] is not None]
nan_strings = [row for row in observations if isinstance(row['parsed'], str)]
finite = [row for row in observations if row['parsed'] == 1]

assert len(invalid) == 12 and len(nan_strings) == 3 and len(finite) == 6
assert all(row['response']['output'].strip() in ('inf', '-inf') for row in invalid)
assert all(row['parsed'] == '-nan' for row in nan_strings)
assert all(row['parse_error']['name'] == 'SyntaxError' for row in invalid)
assert all(bytes.fromhex(row['input_utf8_hex']).decode() == row['input'] for row in observations)
assert hashlib.sha256(Path(value['compiler']).read_bytes()).hexdigest() == value['compiler_sha256']

sources = ['packages/genz/src/host/cli/output.zig', 'packages/genz/src/host/cli/input.zig', 'packages/genz/src/host/wasm/json.zig', 'packages/genz/src/host/wasm/common.zig']
fingerprints = {path: hashlib.sha256((fixed / path).read_bytes()).hexdigest() for path in sources}
fingerprints.update({path.name: hashlib.sha256(path.read_bytes()).hexdigest() for path in [*directory.glob('*.zx'), directory / '实际核验.mjs']})
stdlib = Path('/Users/xiewendao/.local/share/zig/zig-x86_64-macos-0.17.0/lib/std/json/Stringify.zig')
fingerprints[str(stdlib)] = hashlib.sha256(stdlib.read_bytes()).hexdigest()
record = {
    '固定生产提交': 'ebe3d60553c01252fd13341ab6e7304e4737dd2b',
    '执行编译器SHA256': value['compiler_sha256'],
    '应用优化模式': value['optimize'],
    '真实应用产物': 6,
    '真实进程命令': 20,
    '目标观察': 21,
    '有限正常控制': 6,
    '成功状态却非法JSON': 12,
    'NaN改为string': 3,
    '三个目标': ['native', 'wasm32-freestanding', 'wasm32-wasi'],
    '来源SHA256': fingerprints,
    '已通知实现会话': '01a1017f-f09f-7001-95ef-8e966ebd6aee',
    '正式序列化政策': '实现会话已在fbdae9c5明确并修复NonFiniteJsonNumber；本报告仅记录修复前ebe3d605缺陷，不等于修复复验',
    '正式回归登记': False,
    '自我批判': '首次脚本相对导入路径多一级，入口加载前失败，无应用执行。修正脚本后真实六产物和21观察完成。有限控制证明普通schema与目标可用；两种业务函数只有恒等或除法，不含用例特判。初次通知进程命令误写24，实际20已单独补正，其他数字不变。Node对现有非法输出的实际SyntaxError不能误标成应用返回SyntaxError。NaN目前输出是合法JSON string，区别于裸Inf的非法JSON。两者都不能当成已修复或登记通过。',
}
(directory / '核验结论.json').write_text(json.dumps(record, ensure_ascii=False, indent=2) + '\n')
shutil.copyfile('/tmp/zxc-json-nonfinite-repro.log', directory / '实际执行日志.txt')
print('21 actual target observations; 12 invalid JSON and 3 f64-to-string results; 20 process commands')
