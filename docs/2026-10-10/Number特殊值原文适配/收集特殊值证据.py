# coding: utf-8
import gzip
import hashlib
import json
from pathlib import Path


document = Path(__file__).resolve().parent
root = document.parents[2]
base = Path.home() / '.codex/conformance/number-special-values-695c654ce'
records = []


def save(source, relative):
    raw = source.read_bytes()
    target = document / relative
    target.parent.mkdir(parents=True, exist_ok=True)
    encoded = gzip.compress(raw, mtime=0)
    target.write_bytes(encoded)
    assert gzip.decompress(encoded) == raw
    records.append({'source': str(source), 'saved': relative, 'encoding': 'gzip',
                    'raw_sha256': hashlib.sha256(raw).hexdigest(), 'raw_bytes': len(raw),
                    'saved_sha256': hashlib.sha256(encoded).hexdigest(), 'saved_bytes': len(encoded)})


for phase in ('r1', 'r2'):
    run = base / phase
    files = [run / 'runner.py', run / '起点.json']
    files.extend(path for path in run.glob('*.json') if path.name != '起点.json' and not path.name.startswith('compiler-origin-'))
    files.extend(run.glob('*.txt'))
    files.extend(path for path in (run / 'inputs').rglob('*') if path.is_file())
    files.extend((run / 'generated').rglob('*.zig'))

    for path in sorted(files):
        relative = str(path.relative_to(run))

        if relative.startswith('inputs/packages/test/.zxc/'):
            relative = relative.replace('inputs/packages/test/.zxc/', '编译缓存输出/', 1)

        save(path, phase + '/' + relative + '.gz')

for path in sorted((base / 'r2').glob('compiler-origin-*')):
    save(path, '编译器来源/' + path.name + '.gz')

for path in sorted((base / 'r2/publication').glob('audit*')):
    save(path, '发布目录审计/' + path.name + '.gz')

manifest = json.loads((base / 'r2/起点.json').read_text())
formal = manifest['delivery_paths'] + ['packages/test/upstream/reviews/language/types/number/special_values.jsonl']
identities = {name: hashlib.sha256((root / name).read_bytes()).hexdigest() for name in formal}

for name in manifest['delivery_paths']:
    assert identities[name] == manifest['inputs'][name], name

for name in formal:
    save(root / name, '正式源码/' + name + '.gz')

(document / '归档清单.json').write_text(json.dumps(records, ensure_ascii=False, indent=2) + '\n')
(document / '正式源码身份.json').write_text(json.dumps({
    'parent_commit': manifest['parent_commit'], 'compiler_source_commit': manifest['compiler_source_commit'],
    'run': str(base / 'r2'), 'formal': identities, 'scope': manifest['scope'],
}, ensure_ascii=False, indent=2) + '\n')
print('Archived', len(records), 'lossless records and', len(identities), 'formal source identities')

upstream = Path.home() / '.codex/conformance/upstream/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd'
candidates = json.loads((document / '候选原文身份.json').read_text())
original_records = len(records)

for item in candidates:
    path = upstream / item['path']
    assert hashlib.sha256(path.read_bytes()).hexdigest() == item['sha256']
    save(path, '原文/' + path.name + '.gz')

for name in ('sta.js', 'assert.js'):
    save(upstream / 'harness' / name, 'Harness/' + name + '.gz')

save(upstream / 'LICENSE', 'Harness/LICENSE.gz')

for path in sorted((base / 'r1/originals').iterdir()):
    assert path.is_file()
    save(path, '原文执行/' + path.name + '.gz')

(document / '原文归档清单.json').write_text(json.dumps(records[original_records:], ensure_ascii=False, indent=2) + '\n')
print('Archived', len(records), 'total lossless records')

prior_records = []

for path in sorted((base / 'r1/publication').glob('audit.*')):
    save(path, 'R1目录审计/' + path.name + '.gz')
    prior_records.append(records[-1])

(document / 'R1审计归档清单.json').write_text(json.dumps(prior_records, ensure_ascii=False, indent=4) + '\n')
print('Archived', len(records), 'including', len(prior_records), 'prior audit records')
