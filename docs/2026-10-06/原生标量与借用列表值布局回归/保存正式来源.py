import hashlib
import json
from pathlib import Path
import re


directory = Path(__file__).resolve().parent
root = directory.parents[2]
draft = directory / '草稿'
fixed = Path('/Users/xiewendao/.codex/worktrees/json-output-conformance/zxc')
sources = {}
for source in sorted(draft.rglob('*')):
    if not source.is_file():
        continue

    name = source.relative_to(draft)
    assert source.read_bytes() == (root / name).read_bytes() == (fixed / name).read_bytes(), str(name)
    sources[str(name)] = hashlib.sha256(source.read_bytes()).hexdigest()

assert len(sources) == 14
for label in ['Debug', 'ReleaseSafe', '格式化后Debug', '格式化后ReleaseSafe']:
    saved = directory / label
    result = json.loads((saved / '执行结果.json').read_text())
    assert result['terminal_exit_code'] == 0
    assert hashlib.sha256((saved / '原始日志.txt').read_bytes()).hexdigest() == result['raw_log_sha256']
    for name, record in result['generated_zig'].items():
        assert hashlib.sha256((saved / name).read_bytes()).hexdigest() == record['sha256']

    for record in result['native_runtime_reports']:
        assert hashlib.sha256((saved / record['raw_report']).read_bytes()).hexdigest() == record['sha256']

    if result['native_target_reports']:
        assert hashlib.sha256((saved / '原生三目标执行报告.txt').read_bytes()).hexdigest() == result['native_target_reports'][0]['sha256']

    if label.startswith('格式化后'):
        assert result['test_sources'] == sources
    else:
        for name, sha in result['test_sources'].items():
            if name.endswith('/native_scalar/host.zig'):
                previous = (root / name).read_bytes().replace(b'const recorded = try record(3, value);\n\n', b'const recorded = try record(3, value);\n')
                assert hashlib.sha256(previous).hexdigest() == sha

                continue

            assert sources[name] == sha

initial = json.loads((directory / '首轮草稿来源.json').read_text())['文件']
for name in sources:
    if '/value_eligibility' in name:
        assert sources[name] == initial[name]['草稿SHA256']

declarations = sum(len(re.findall(r'^test "', (root / name).read_text(), re.MULTILINE)) for name in sources if name.endswith('/root.zig'))
assert declarations == 6
(directory / '正式来源.json').write_text(json.dumps({
    'production_commit': '6ec98c7148ae03370443e8d49812dbb4222270c3',
    'sources': sources,
    'new_runtime_declarations': declarations,
    'new_generation_declarations': 2,
    'catalog_ids_added': 0,
    'scope': 'Fixed production commit plus fourteen scoped test files. Formatting reruns bind final file bytes; prior unchanged test and driver evidence remains separately recorded.',
}, ensure_ascii=False, indent=4) + '\n')
print('Verified fourteen formal/draft/fixed files and all four stages of immutable execution evidence')
