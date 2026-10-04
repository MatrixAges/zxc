# -*- coding: utf-8 -*-
import hashlib
import json
import subprocess
import tempfile
from pathlib import Path

root = Path(__file__).resolve().parent
compiler = Path('.zig-cache/o/ab99b3078f8e9fd5730c68eae59089e1/zxc').resolve()
results = {'compiler_sha256': hashlib.sha256(compiler.read_bytes()).hexdigest(), 'cases': []}

try:
    with tempfile.TemporaryDirectory(prefix='zxc-rx-branch-error-') as temporary:
        directory = Path(temporary)

        for source, name in [('分支错误主模块.rx', 'main.rx'), ('分支错误子模块.rx', 'leaf.rx'), ('索引函数.zx', 'first.zx')]:
            (directory / name).write_bytes((root / source).read_bytes())

        application = directory / 'app'
        built = subprocess.run([str(compiler), 'build', 'main.rx', '--out', str(application)], cwd=directory, capture_output=True, text=True, timeout=180)
        results['build'] = {'status': built.returncode, 'stderr': built.stderr}
        assert built.returncode == 0, built.stderr

        for enabled in [False, True]:
            for values in [[], [7]]:
                data = {'enabled': enabled, 'values': values}
                failure = enabled and not values
                result = subprocess.run([str(application), json.dumps(data)], cwd=directory, capture_output=True, text=True, timeout=10)
                results['cases'].append({'input': data, 'status': result.returncode, 'stdout': result.stdout, 'stderr': result.stderr})
                assert result.returncode == (1 if failure else 0), results['cases'][-1]

                if failure:
                    assert result.stdout == ''
                    assert result.stderr.splitlines()[0] == 'error: IndexOutOfBounds'
                else:
                    assert result.stderr == ''
                    assert json.loads(result.stdout) == (values[0] if enabled else 9)
finally:
    (root / '分支错误结果.json').write_text(json.dumps(results, ensure_ascii=False, indent=2) + '\n')

print('RX branch error draft: 4 executions passed, including selected service error')
