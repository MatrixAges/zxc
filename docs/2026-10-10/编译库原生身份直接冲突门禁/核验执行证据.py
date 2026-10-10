import gzip
import hashlib
import json
from pathlib import Path
import re


document = Path(__file__).resolve().parent
root = document.parents[2]
decoded = {}


def digest(raw):
    return hashlib.sha256(raw).hexdigest()


for record in json.loads((document / '归档清单.json').read_text()):
    data = (document / record['saved']).read_bytes()
    raw = gzip.decompress(data)
    assert digest(data) == record['saved_sha256']
    assert digest(raw) == record['raw_sha256']
    assert len(data) == record['saved_bytes'] and len(raw) == record['raw_bytes']
    assert Path(record['source']).read_bytes() == raw
    decoded[record['saved'][:-3]] = raw

identity = json.loads((document / '正式源码身份.json').read_text())

for name, expected in identity['overlays'].items():
    assert digest((root / name).read_bytes()) == expected
    assert digest(decoded['正式源码/' + name]) == expected

source = decoded['正式源码/packages/test/tests/library/imports/native_conflicts_test.zig'].decode()
expected_names = re.findall(r'^test "([^"\n]+)"', source, re.MULTILINE)
assert len(expected_names) == 4
result = json.loads((document / '执行结果.json').read_text())
assert result['unique_named_tests'] == 4
assert result['final_named_executions'] == 8
assert result['final_route_observations'] == 16
assert result['preflight_named_executions'] == 4
assert result['reused_generated_compiler_files'] == 93
assert result['explicit_module_inputs'] == 114

for round_name, modes in (('r1', ('debug',)), ('r2', ('debug', 'safe'))):
    manifest = json.loads(decoded[round_name + '/起点.json'])
    assert manifest['source_commit'] == identity['source_commit']

    for mode in modes:
        terminal = json.loads(decoded[round_name + '/' + mode + '.terminal.json'])
        assert terminal['terminal_exit_code'] == 0 and terminal['gate_passed']
        assert terminal['changed_inputs'] == []
        assert terminal['actual_names'] == terminal['expected_names'] == expected_names
        assert digest(decoded[round_name + '/运行门禁.py']) == terminal['runner_sha256']
        log = decoded[round_name + '/' + mode + '.log.txt']
        assert digest(log) == terminal['log_sha256']
        assert b'All 4 tests passed.' in log
        assert digest(Path(terminal['binary']).read_bytes()) == terminal['binary_sha256']

    if round_name == 'r2':
        assert len(manifest['module_inputs']) == 114

        for name, expected in manifest['module_inputs'].items():
            assert digest(Path(name).read_bytes()) == expected

print('PASS: four direct conflict tests, both final modes, repeated-load controls and immutable execution evidence')
