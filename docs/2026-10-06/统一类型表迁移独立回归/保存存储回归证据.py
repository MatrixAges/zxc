import hashlib
import json
from pathlib import Path
import re
import subprocess


directory = Path(__file__).resolve().parent
root = directory.parents[2]
fixed = Path('/Users/xiewendao/.codex/worktrees/json-output-conformance/zxc')
draft = directory / '草稿'
names = ['packages/test/build.zig', 'packages/test/tests/incremental/type_merge/storage_test.zig']
sources = {}
for name in names:
    assert (root / name).read_bytes() == (fixed / name).read_bytes() == (draft / name).read_bytes(), name
    sources[name] = hashlib.sha256((root / name).read_bytes()).hexdigest()

assert subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=fixed, text=True).strip().startswith('ba9dde18')
status = subprocess.check_output(['git', 'status', '--porcelain', '--untracked-files=all'], cwd=fixed, text=True)
assert {line[3:] for line in status.splitlines()} == set(names)
production = fixed / 'packages/core/src/type_table/storage.zig'
assert production.read_bytes() == (directory / '存储修复生产原始源码.txt').read_bytes()
results = {}
for label in ['Debug', 'ReleaseSafe']:
    prior = directory / ('存储结束首轮' + label + '原始日志.txt')
    assert '1 tests leaked memory' in prior.read_text()
    standalone = directory / ('存储修复后' + label + '原始日志.txt')
    assert 'All 1 tests passed.' in standalone.read_text()
    log = directory / ('存储正式' + label + '原始日志.txt')
    text = log.read_text()
    summary = re.search(r'Build Summary: (\d+)/(\d+) steps succeeded; (\d+)/(\d+) tests passed', text)
    assert summary and summary[1] == summary[2] and summary[3] == summary[4]
    tail = text[summary.start():]
    actual = [int(match[1]) for match in re.finditer(r'\brun test\b[^\n]*? (\d+) pass \((\d+) total\)', tail)]
    assert sum(actual) == int(summary[3])
    assert re.search(r'run test 2 pass \(2 total\)', tail)
    results[label] = {
        'terminal_exit_code': 0,
        'summary': summary[0],
        'actual_managed_test_passes': sum(actual),
        'cached_test_steps': [line for line in tail.splitlines() if re.search(r'\brun test\b.*?\bcached(?:\s|$)', line)],
        'prior_reproduction_exit_code': 1,
        'prior_reproduction_sha256': hashlib.sha256(prior.read_bytes()).hexdigest(),
        'fixed_standalone_exit_code': 0,
        'fixed_standalone_sha256': hashlib.sha256(standalone.read_bytes()).hexdigest(),
        'formal_log_sha256': hashlib.sha256(log.read_bytes()).hexdigest(),
        'argv': ['zig', 'build', 'test-type-merge', 'test-library-codec', 'test-cache-codec', '-Doptimize=' + label, '--summary', 'all'],
    }

assert len(re.findall(r'^test "', (root / names[1]).read_text(), re.MULTILINE)) == 2
proof = {
    'production_commit': 'ba9dde1824a1206fd3abc84c1e1dbad6a7c47ddd',
    'prior_production_commit': 'fc04002489a6a7d3bd06f29ee8d2c5a4296af6e4',
    'production_storage_sha256': hashlib.sha256(production.read_bytes()).hexdigest(),
    'formal_sources': sources,
    'new_unique_declarations': 2,
    'catalog_ids_added': 0,
    'results': results,
    'scope': 'Fixed finish ownership repair plus two scoped test files; nominal self-hosting changes after ba9dde18 require independent verification.',
}
(directory / '存储正式来源与证据.json').write_text(json.dumps(proof, ensure_ascii=False, indent=4) + '\n')
print('Verified two formal/draft/fixed files and both failure-to-success ownership regressions')
