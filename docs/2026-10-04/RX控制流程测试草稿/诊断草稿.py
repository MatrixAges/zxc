# -*- coding: utf-8 -*-
import json
import re
import subprocess
import tempfile
from pathlib import Path

root = Path(__file__).resolve().parent
compiler = Path('.zig-cache/o/ab99b3078f8e9fd5730c68eae59089e1/zxc').resolve()
rows = json.loads((root / '诊断案例.json').read_text())
results = []

try:
    with tempfile.TemporaryDirectory(prefix='zxc-rx-flow-diagnostics-') as temporary:
        directory = Path(temporary)
        (directory / 'helper.zx').write_bytes((root / '函数.zx').read_bytes())

        for row in rows:
            (directory / 'main.rx').write_text(row['source'] + '\n')
            output = directory / 'program.zig'
            output.unlink(missing_ok=True)
            result = subprocess.run([str(compiler), 'main.rx', '--out', str(output)], cwd=directory, capture_output=True, text=True, timeout=30)
            results.append({'name': row['name'], 'status': result.returncode, 'stderr': result.stderr})

            if row['diagnostic'] is None:
                assert result.returncode == 0, results[-1]
                assert output.exists()
            else:
                assert result.returncode == 1, results[-1]
                assert re.search(r'main\.rx:1:\d+: ' + row['diagnostic'] + ':', result.stderr), results[-1]
                assert not output.exists()
finally:
    (root / '诊断结果.json').write_text(json.dumps(results, ensure_ascii=False, indent=2) + '\n')

print('RX control-flow draft: 6 static diagnostic/control cases passed')
