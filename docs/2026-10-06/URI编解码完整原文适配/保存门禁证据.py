import hashlib
import json
from pathlib import Path
import re
import shutil
import sys


directory = Path(__file__).resolve().parent
fixed = Path('/Users/xiewendao/.codex/worktrees/json-output-conformance/zxc')
mode, handle, exit_code = sys.argv[1:]
assert exit_code == '0'
log = Path('/tmp/zxc-uri-' + mode + '.log')
text = log.read_text()
summary = re.search(r'Build Summary: (\d+)/(\d+) steps succeeded; (\d+)/(\d+) tests passed', text)
assert summary and summary[1] == summary[2] and summary[3] == summary[4]
suites = json.loads((fixed / 'packages/test/suites.json').read_text())['runtime']
suites = [row for row in suites if row['path'].startswith('standard/querystring/')]
leaves = re.findall(r'run test (querystring-\S+) (\d+) pass \((\d+) total\)', text)
assert len(leaves) == len(suites) == 6
assert sum(int(row[1]) for row in leaves) == int(summary[3])
saved = directory / {'debug': 'Debug', 'safe': 'ReleaseSafe'}[mode]
saved.mkdir(exist_ok=True)
shutil.copyfile(log, saved / '原始日志.txt')
cache = fixed / 'packages/test/.zig-cache/o'
reports = []

for suite in suites:
    catalog = fixed / ('packages/test/tests/' + suite['path'] + '.jsonl')
    rows = [json.loads(line) for line in catalog.read_text().splitlines()]
    leaf = next(row for row in leaves if row[0] == suite['name'])
    assert int(leaf[1]) == int(leaf[2]) == len(rows)
    expected = [row['id'] for row in rows]
    candidates = []
    for path in cache.glob('*/cases.zig'):
        source = path.read_text()
        ids = re.findall(r'^test "([^"]+)"', source, re.MULTILINE)
        if ids == expected:
            candidates.append(path)
    assert candidates, suite['name']
    hashes = {hashlib.sha256(path.read_bytes()).hexdigest() for path in candidates}
    assert len(hashes) == 1, suite['name']
    source = max(candidates, key=lambda path: path.stat().st_mtime)
    raw = saved / (suite['name'] + '具名断言.txt')
    raw.write_bytes(source.read_bytes())
    reports.append({
        'name': suite['name'],
        'catalog': str(catalog),
        'catalog_sha256': hashlib.sha256(catalog.read_bytes()).hexdigest(),
        'ids': expected,
        'actual_passed': len(rows),
        'cached_test': False,
        'matching_generated_candidates': [str(path) for path in candidates],
        'generated_assertion_file': raw.name,
        'generated_assertion_sha256': hashes.pop(),
    })

result = {
    'production_commit': 'a7662c5c',
    'cwd': str(fixed / 'packages/test'),
    'mode': mode,
    'handle': int(handle),
    'exit_code': 0,
    'argv': ['zig', 'build', 'test-querystring', '-Doptimize=' + mode, '-Dzig-archive=/Users/xiewendao/.codex/worktrees/native-reference-conformance/zxc/packages/test/.zig-cache/o/c16bf5716bbe508e223213805c3f3621/bundle/zig.archive', '-j2', '--summary', 'all'],
    'build_summary': summary[0],
    'actual_managed_executions': int(summary[3]),
    'reports': reports,
    'log_sha256': hashlib.sha256(log.read_bytes()).hexdigest(),
    'generated_note': '具名断言按全部ID与顺序匹配缓存输出；相同内容的多个候选全部列出，不把某个候选路径冒充唯一实际编译路径。实际通过以本次完整门禁叶子和终态退出码为证据。',
}
(saved / '执行结果.json').write_text(json.dumps(result, ensure_ascii=False, indent=4) + '\n')
print(f'Saved {mode}: {summary[3]} actual named executions in six suites, no cached test leaves')
