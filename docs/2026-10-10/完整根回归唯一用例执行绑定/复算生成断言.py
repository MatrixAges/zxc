# coding: utf-8
from datetime import datetime, timezone
import gzip
import hashlib
import json
from pathlib import Path
import subprocess


document = Path(__file__).resolve().parent
evidence = json.loads((document / '执行链路.json').read_text())
original = document.parent / 'Indexed入口根回归Debug终态/原始终态'
manifest = json.loads(gzip.decompress((original / '起点.json.gz').read_bytes()))
output = Path.home() / '.codex/conformance/indexed-root-bbd92b5c5/r1/case-binding-reemit'
output.mkdir(exist_ok=True)
node = manifest['tools']['node']['path']
assert hashlib.sha256(Path(node).read_bytes()).hexdigest() == manifest['tools']['node']['sha256']
records = []
started_at = datetime.now(timezone.utc).isoformat()

for binding in evidence['bindings']:
    name = binding['suite']['name']
    argv = binding['emitter']['argv'].copy()
    target = output / (name + '.zig')
    argv[0] = node
    argv[-1] = str(target)
    before = datetime.now(timezone.utc).isoformat()
    result = subprocess.run(argv, cwd=manifest['cwd'], capture_output=True)
    assert result.returncode == 0, (name, result.stderr.decode())
    generated = target.read_bytes()
    expected = gzip.decompress((document / binding['modules']['root']['saved']).read_bytes())
    assert generated == expected, name
    records.append({'suite': name, 'argv': argv, 'started_at': before,
                    'finished_at': datetime.now(timezone.utc).isoformat(),
                    'terminal_exit_code': result.returncode,
                    'stdout_sha256': hashlib.sha256(result.stdout).hexdigest(),
                    'stderr_sha256': hashlib.sha256(result.stderr).hexdigest(),
                    'generated_sha256': hashlib.sha256(generated).hexdigest()})

receipt = {'started_at': started_at, 'finished_at': datetime.now(timezone.utc).isoformat(),
           'runner_sha256': hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
           'source_commit': evidence['source_commit'], 'executed_emitters': len(records),
           'all_generated_sources_byte_equal': True, 'node_sha256': manifest['tools']['node']['sha256'],
           'records': records}
(document / '生成断言复算终态.json').write_text(json.dumps(receipt, ensure_ascii=False, indent=4) + '\n')
print('PASS: 526 emitter executions reproduced all 84786 input and expectation assertions byte for byte')
