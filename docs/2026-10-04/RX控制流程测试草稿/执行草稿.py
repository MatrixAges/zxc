# -*- coding: utf-8 -*-
import hashlib
import json
import subprocess
import tempfile
import xml.etree.ElementTree as xml
from pathlib import Path

root = Path(__file__).resolve().parent
compiler = Path('.zig-cache/o/ab99b3078f8e9fd5730c68eae59089e1/zxc').resolve()
results = {'compiler_sha256': hashlib.sha256(compiler.read_bytes()).hexdigest(), 'builds': [], 'cases': []}

try:
    with tempfile.TemporaryDirectory(prefix='zxc-rx-flow-probe-') as temporary:
        directory = Path(temporary)

        for source, name in [('子模块.rx', 'leaf.rx'), ('函数.zx', 'helper.zx')]:
            (directory / name).write_bytes((root / source).read_bytes())

        application = directory / 'app'

        for default_first in [False, True]:
            module = xml.fromstring((root / '主模块.rx').read_text())
            selection = module.find('./Task/Switch')

            if default_first:
                fallback = selection.find('Default')
                selection.remove(fallback)
                selection.insert(0, fallback)

            (directory / 'main.rx').write_text(xml.tostring(module, encoding='unicode') + '\n')
            built = subprocess.run([str(compiler), 'build', 'main.rx', '--out', str(application)], cwd=directory, capture_output=True, text=True, timeout=180)
            results['builds'].append({'default_first': default_first, 'status': built.returncode, 'stderr': built.stderr})
            assert built.returncode == 0, built.stderr

            for enabled in [False, True]:
                for value in [0, 7]:
                    data = {'enabled': enabled, 'value': value}
                    expected = value + (11 if enabled else 0)
                    result = subprocess.run([str(application), json.dumps(data)], cwd=directory, capture_output=True, text=True, timeout=10)
                    results['cases'].append({'default_first': default_first, 'input': data, 'expected': expected, 'status': result.returncode, 'stdout': result.stdout, 'stderr': result.stderr})

                    assert result.returncode == 0, result.stderr
                    assert json.loads(result.stdout) == expected, results['cases'][-1]
finally:
    (root / '执行结果.json').write_text(json.dumps(results, ensure_ascii=False, indent=2) + '\n')

print('RX Task/Switch draft: 8 actual executions passed across both Default positions')
