# coding: utf-8
from pathlib import Path
import hashlib
import json
import re
import subprocess

doc = Path(__file__).resolve().parent
manifest = json.loads((doc / '输入清单.json').read_text())
item = next(row for row in json.loads((doc / 'Debug产物清单.json').read_text()) if row['kind'] == 'rows')
source = Path(next(row['actual_path'] for row in item['files'] if row['module'] == 'program')).read_text()
marker = 'if ((value_2).result) {'
assert source.count(marker) == 1
fault = source.replace(marker, 'if (true) {')
saved = doc / '生成产物' / manifest['source_commit'][:8] / 'Debug' / 'rows' / '停止标记故障控制.zig.txt'
saved.write_text(fault)
temporary = Path('/tmp/zxc-every-observer-eager-rows.zig')
temporary.write_text(fault)
argv = [('-Mprogram=' + str(temporary)) if arg.startswith('-Mprogram=') else arg
        for arg in item['compiler_argv'] if arg != '--listen=-']
result = subprocess.run(argv, cwd=Path(manifest['worktree']) / 'packages/test', stdout=subprocess.PIPE,
                        stderr=subprocess.STDOUT, timeout=180)
log = saved.with_name('停止标记故障控制输出.txt')
log.write_bytes(result.stdout)
blocks = re.split(r'^\d+/\d+ [^.]+\.test\.(.*?)\.\.\.', result.stdout.decode(), flags=re.M)
assert (len(blocks) - 1) // 2 == 8
failed = [blocks[index] for index in range(1, len(blocks), 2)
          if 'FAIL (IndexOutOfBounds)' in blocks[index + 1]]
assert result.returncode != 0 and {name.rsplit('/', 1)[1] for name in failed} == {'stopped_before_empty', 'stopped_after_true'}
evidence = {'argv': argv, 'exit_code': result.returncode, 'failed_names': failed,
            'fault': 'Evaluate every row even after the predicate result becomes false.',
            'fault_source': str(saved.relative_to(doc)), 'fault_sha256': hashlib.sha256(saved.read_bytes()).hexdigest(),
            'output_path': str(log.relative_to(doc)), 'output_sha256': hashlib.sha256(result.stdout).hexdigest()}
(doc / '反向检查.json').write_text(json.dumps(evidence, ensure_ascii=False, indent=2) + '\n')
print('Negative control: removing the stop guard fails exactly the two lazy bounds controls')
