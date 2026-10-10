# coding: utf-8
import gzip
import hashlib
import json
from pathlib import Path


document = Path(__file__).resolve().parent
root = document.parents[2]
base = Path.home() / '.codex/conformance/number-rounding-695c654ce'
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


for phase in ('r1', 'r2', 'r3'):
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

for path in sorted((base / 'r3').glob('compiler-origin-*')):
    save(path, '编译器来源/' + path.name + '.gz')

for path in sorted((base / 'r3/publication').glob('audit.*')):
    save(path, '发布目录审计/' + path.name + '.gz')

manifest = json.loads((base / 'r3/起点.json').read_text())
formal = manifest['delivery_paths'] + ['packages/test/upstream/reviews/language/types/number/rounding_steps.jsonl']
identities = {name: hashlib.sha256((root / name).read_bytes()).hexdigest() for name in formal}

for name in manifest['delivery_paths']:
    assert identities[name] == manifest['inputs'][name], name

for name in formal:
    save(root / name, '正式源码/' + name + '.gz')

(document / '归档清单.json').write_text(json.dumps(records, ensure_ascii=False, indent=2) + '\n')
(document / '正式源码身份.json').write_text(json.dumps({
    'parent_commit': manifest['parent_commit'], 'compiler_source_commit': manifest['compiler_source_commit'],
    'run': str(base / 'r3'), 'formal': identities, 'scope': manifest['scope'],
}, ensure_ascii=False, indent=2) + '\n')
print('Archived', len(records), 'lossless records and', len(identities), 'formal source identities')
