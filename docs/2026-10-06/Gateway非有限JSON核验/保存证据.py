import hashlib
import json
from pathlib import Path
import shutil
import subprocess


directory = Path(__file__).resolve().parent
root = Path('/Users/xiewendao/Documents/MatrixAges/zxc')
fixed = Path('/Users/xiewendao/.codex/worktrees/native-reference-conformance/zxc')
record = json.loads((directory / '实际结果.json').read_text())
rows = record['observations']

assert len(rows) == 7
assert all(row['response']['status'] == 200 for row in rows)
assert all(row['response']['headers']['content-type'] == 'application/json' for row in rows)
assert all(bytes.fromhex(row['input_utf8_hex']).decode() == row['body'] for row in rows)
assert rows[0]['parsed'] == 1 and rows[-1]['parsed'] == 2
assert [row['response']['body'] for row in rows[1:5]] == ['inf', '-inf', 'inf', '-inf']
assert all(row['parse_error']['name'] == 'SyntaxError' for row in rows[1:5])
assert rows[5]['parsed'] == '-nan' and rows[5]['parse_error'] is None
assert record['stdout'] == '' and record['stderr'] == ''
assert hashlib.sha256(Path(record['compiler']).read_bytes()).hexdigest() == record['compiler_sha256']

sources = [
    'packages/genz/src/gateway/invoke.zig',
    'packages/test/tests/runtime/gateway/application.ts',
    'packages/test/tests/runtime/gateway/request.ts',
]
fingerprints = {path: hashlib.sha256((fixed / path).read_bytes()).hexdigest() for path in sources}

for path in sorted((directory / '应用').iterdir()):
    fingerprints[str(path.relative_to(directory))] = hashlib.sha256(path.read_bytes()).hexdigest()

fingerprints['实际核验.mjs'] = hashlib.sha256((directory / '实际核验.mjs').read_bytes()).hexdigest()
assert all((root / path).read_bytes() == (fixed / path).read_bytes() for path in sources[1:])

value = {
    '固定生产提交': subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=fixed, text=True).strip(),
    '实际编译器SHA256': record['compiler_sha256'],
    '实际服务产物SHA256': record['executable_sha256'],
    '优化模式': record['optimize'],
    '真实服务构建': 1,
    '同一进程请求': 7,
    'HTTP200非法JSON': 4,
    'HTTP200非有限数改为字符串': 1,
    '有限正常控制': 2,
    '来源SHA256': fingerprints,
    '实际结果SHA256': hashlib.sha256((directory / '实际结果.json').read_bytes()).hexdigest(),
    '已通知实现会话': '01a1017f-f09f-7001-95ef-8e966ebd6aee',
    '正式回归登记': False,
    '自我复核': '原始响应wire和逐项headers均保留；headers是Map，首轮JSON.stringify遗漏其内容，但原始wire完整证明content-type。本次修正采集格式后在同一固定源码重跑，不把源码预测或Node的解析错误当作Gateway拒绝。应用只有普通恒等与除法，临时端口由成熟驱动动态分配。',
}

(directory / '核验结论.json').write_text(json.dumps(value, ensure_ascii=False, indent=2) + '\n')
shutil.copyfile('/tmp/zxc-gateway-nonfinite-repro.log', directory / '实际执行日志.txt')
print('7 actual HTTP responses; 4 invalid JSON, 1 number-to-string result and 2 finite controls')
