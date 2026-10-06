import hashlib
import json
from pathlib import Path
import subprocess
from tempfile import TemporaryDirectory


directory = Path(__file__).resolve().parent
fixed = Path('/Users/xiewendao/.codex/worktrees/json-output-conformance/zxc')
compiler = fixed / 'zig-out/bin/zxc'
execution = json.loads((directory / '应用执行.json').read_text())
assert hashlib.sha256(compiler.read_bytes()).hexdigest() == execution['compiler_sha256']
records = []

with TemporaryDirectory(prefix='zxc-uri-generated-') as temporary:
    for operation in ['escape', 'unescape']:
        source = fixed / f'packages/test/tests/standard/querystring/{operation}/cases.zx'
        program = Path(temporary) / 'program.zig'
        argv = [str(compiler), str(source), '--out', str(program)]
        result = subprocess.run(argv, cwd=fixed, capture_output=True, text=True)
        record = {'argv': argv, 'status': result.returncode, 'stdout': result.stdout, 'stderr': result.stderr, 'source_sha256': hashlib.sha256(source.read_bytes()).hexdigest()}
        assert result.returncode == 0, record
        candidates = [path for path in (fixed / 'packages/test/.zig-cache/o').glob('*/program.zig') if path.read_bytes() == program.read_bytes()]
        assert candidates, operation
        for suffix, label in [('program.zig', '普通生成源码'), ('program.zig.abi.zig', '静态ABI源码')]:
            generated = Path(temporary) / suffix
            saved = directory / f'{operation}{label}.txt'
            saved.write_bytes(generated.read_bytes())
            record[label] = {'path': saved.name, 'sha256': hashlib.sha256(saved.read_bytes()).hexdigest()}
        record['matching_cached_programs'] = [str(path) for path in candidates]
        records.append(record)

(directory / '生成源码核对.json').write_text(json.dumps(records, ensure_ascii=False, indent=4) + '\n')
print('Saved two ordinary generated programs and their static ABI; exact byte matches found in gate cache')
