import hashlib
import json
from pathlib import Path
import subprocess
import sys


directory = Path(__file__).resolve().parent
root = directory.parents[2]
draft = directory / '草稿'
target_root = Path(sys.argv[1]).resolve() if len(sys.argv) == 2 else root
paths = [path.relative_to(draft) for path in draft.rglob('*') if path.is_file()]
baseline = '6ec98c71'
sources = {}
previous = json.loads((directory / '同步来源.json').read_text())['文件'] if (directory / '同步来源.json').exists() else {}
executions = [json.loads(path.read_text())['test_sources'] for path in directory.glob('*/执行结果.json')]

for name in paths:
    source = draft / name
    target = target_root / name
    original = subprocess.run(['git', 'show', f'{baseline}:{name}'], cwd=root, capture_output=True)
    if target.exists():
        prior_sha = previous.get(str(name), {}).get('草稿SHA256')
        target_sha = hashlib.sha256(target.read_bytes()).hexdigest()
        known = {record.get(str(name)) for record in executions}
        assert target.read_bytes() == source.read_bytes() or original.returncode == 0 and target.read_bytes() == original.stdout or target_sha == prior_sha or target_sha in known, str(name)
    else:
        assert original.returncode != 0, str(name)
    sources[str(name)] = {'草稿SHA256': hashlib.sha256(source.read_bytes()).hexdigest(), '基线SHA256': hashlib.sha256(original.stdout).hexdigest() if original.returncode == 0 else None}

for name in paths:
    target = target_root / name
    target.parent.mkdir(parents=True, exist_ok=True)
    target.write_bytes((draft / name).read_bytes())

(directory / '同步来源.json').write_text(json.dumps({'生产基线': baseline, '文件': sources}, ensure_ascii=False, indent=4) + '\n')
print(f'Synchronized {len(paths)} scoped test files to {target_root}')
