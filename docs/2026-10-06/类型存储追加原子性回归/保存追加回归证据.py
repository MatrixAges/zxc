import hashlib
import json
from pathlib import Path
import re
import subprocess


directory = Path(__file__).resolve().parent
root = directory.parents[2]
fixed = Path('/Users/xiewendao/.codex/worktrees/json-output-conformance/zxc')
manifest = json.loads((directory / '执行起点.json').read_text())
assert subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=fixed, text=True).strip() == manifest['production_commit']
status = subprocess.check_output(['git', 'status', '--porcelain', '--untracked-files=all'], cwd=fixed, text=True)
assert {line[3:] for line in status.splitlines()} == set(manifest['formal_sources'])
for name, digest in manifest['formal_sources'].items():
    data = (root / name).read_bytes()
    assert data == (fixed / name).read_bytes() == (directory / '草稿' / name).read_bytes()
    assert hashlib.sha256(data).hexdigest() == digest

results = {}
for gate in manifest['completed_gates']:
    assert gate['terminal_exit_code'] == 0
    log = directory / gate['raw_log']
    text = log.read_text()
    summary = re.search(r'Build Summary: (\d+)/(\d+) steps succeeded; (\d+)/(\d+) tests passed', text)
    assert summary and summary[1] == summary[2] and summary[3] == summary[4]
    tail = text[summary.start():]
    actual = [int(match[1]) for match in re.finditer(r'\brun test\b[^\n]*? (\d+) pass \((\d+) total\)', tail)]
    assert sum(actual) == int(summary[3])
    assert len(re.findall(r'run test 4 pass \(4 total\)', tail)) == 1
    results[gate['mode']] = {
        'terminal_exit_code': 0,
        'argv': gate['argv'],
        'summary': summary[0],
        'actual_managed_tests': sum(actual),
        'actual_new_declarations': 4,
        'cached_test_steps': [line for line in tail.splitlines() if re.search(r'\brun test\b.*?\bcached(?:\s|$)', line)],
        'raw_log': log.name,
        'sha256': hashlib.sha256(log.read_bytes()).hexdigest(),
    }

assert set(results) == {'Debug', 'ReleaseSafe'}
test = root / 'packages/test/tests/incremental/type_merge/storage_append_test.zig'
assert len(re.findall(r'^test "', test.read_text(), re.MULTILINE)) == 4
production = fixed / 'packages/core/src/type_table/storage.zig'
proof = {
    'production_commit': manifest['production_commit'],
    'storage_source_sha256': hashlib.sha256(production.read_bytes()).hexdigest(),
    'formal_sources': manifest['formal_sources'],
    'new_unique_declarations': 4,
    'new_catalog_ids': 0,
    'results': results,
    'scope': 'Capacity preparation failures preserve all logical columns and retry on the same owner. Delta ranges are local and references are global; only complete base/merged type-only Program tables receive full IR validation. Borrowed addresses and nominal origin metadata are outside scope.',
}
proof_path = directory / '最终来源与证据.json'
proof_path.write_text(json.dumps(proof, ensure_ascii=False, indent=4) + '\n')
subprocess.run(['pnpm', 'exec', 'prettier', '--write', str(proof_path)], cwd=root, check=True, stdout=subprocess.DEVNULL)
print('Verified four allocation atomicity declarations, both modes, all formal sources and raw logs')
