from datetime import datetime, timezone
import gzip
import hashlib
import json
from pathlib import Path
import re


document = Path(__file__).resolve().parent
base = Path('/Users/xiewendao/.codex/conformance')
project = base / 'rx-diagnostic-preflight-bbd92b5c5/r1'
store = base / 'store-diagnostic-bbd92b5c5/r1'
records = []
assert not (document / '预验证归档清单.json').exists()


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def save(source, name):
    raw = source.read_bytes()
    encoded = gzip.compress(raw, mtime=0)
    target = document / '诊断预验证' / (name + '.gz')
    target.parent.mkdir(parents=True, exist_ok=True)
    target.write_bytes(encoded)
    records.append({
        'source': str(source),
        'saved': str(target.relative_to(document)),
        'encoding': 'gzip',
        'raw_bytes': len(raw),
        'raw_sha256': hashlib.sha256(raw).hexdigest(),
        'saved_bytes': len(encoded),
        'saved_sha256': hashlib.sha256(encoded).hexdigest(),
    })


start = json.loads((project / 'start.json').read_text())
assert digest(Path(start['cli'])) == start['cli_sha256']

for path, identity in start['inputs'].items():
    assert digest(Path(path)) == identity, path

for mode, count in (('project', 9), ('watch', 1)):
    terminal = json.loads((project / (mode + '.terminal.json')).read_text())
    assert terminal['exit_code'] == 0
    assert terminal['changed_inputs'] == []
    stdout = (project / (mode + '.stdout.txt')).read_text()
    assert re.search(r'^ℹ tests ' + str(count) + r'$', stdout, re.MULTILINE), stdout
    assert re.search(r'^ℹ pass ' + str(count) + r'$', stdout, re.MULTILINE), stdout
    assert re.search(r'^ℹ fail 0$', stdout, re.MULTILINE), stdout

for path in sorted(project.iterdir()):
    if path.is_file():
        save(path, '项目与监听/' + path.name)

terminal = json.loads((store / 'terminal.json').read_text())
assert terminal['source_commit'] == start['source_commit']
assert terminal['cli_sha256'] == start['cli_sha256']
expected = {
    'helper_write': 'write.zx:1:1: module: source function dependency has not been analyzed in its required context\n',
    'missing_parameter': 'main.rx:1:50: capability: a Call.setter target must declare its second parameter as { store }\n',
}

assert {record['mode'] for record in terminal['records']} == set(expected)

for record in terminal['records']:
    assert record['exit_code'] == 1
    assert record['stderr'].endswith(expected[record['mode']])
    directory = store / record['mode']
    assert (directory / 'stderr.txt').read_text() == record['stderr']

    for name, identity in record['source_sha256'].items():
        assert digest(directory / name) == identity, name

for path in sorted(store.rglob('*')):
    if path.is_file():
        save(path, 'Store/' + str(path.relative_to(store)))

result = {
    'archived_at': datetime.now(timezone.utc).isoformat(),
    'source_commit': start['source_commit'],
    'cli_sha256': start['cli_sha256'],
    'project_named_tests': 9,
    'watch_named_tests': 1,
    'store_expected_rejections': 2,
    'final_formatted_source_execution': False,
    'current_two_mode_execution': False,
    'boundary': 'Old bbd CLI preflight only; archived TS precedes the repository formatter.',
}
(document / '预验证归档清单.json').write_text(json.dumps(records, ensure_ascii=False, indent=4) + '\n')
(document / '预验证结果.json').write_text(json.dumps(result, ensure_ascii=False, indent=4) + '\n')
print('Archived strict diagnostic preflight evidence; current two-mode gates remain pending.')
