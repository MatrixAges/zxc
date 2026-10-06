# -*- coding: utf-8 -*-
import hashlib
import json
from pathlib import Path
import re


directory = Path(__file__).resolve().parent
path = directory / '复跑起点.json'
value = json.loads(path.read_text())
log = Path('/tmp/zxc-root-complete-rerun-debug-build.log')
summary = re.search(r'Build Summary: (.+)', log.read_text())[1]

assert summary == '35/35 steps succeeded'
build = {**value['current_gate'], 'terminal_exit_code': 0, 'build_summary': summary, 'log_sha256': hashlib.sha256(log.read_bytes()).hexdigest()}
value['debug_build'] = build
value['typecheck'] = {
    'command': 'node packages/test/node_modules/typescript/bin/tsc --noEmit --project packages/test/tsconfig.json',
    'terminal_exit_code': 0,
    'log': '复跑类型检查日志.txt',
}

(directory / '复跑Debug构建日志.txt').write_bytes(log.read_bytes())
(directory / '复跑类型检查日志.txt').write_bytes(Path('/tmp/zxc-root-complete-rerun-typecheck.log').read_bytes())
value['current_gate'] = {
    'command': 'zig build test -Doptimize=debug -Dzig-archive=' + value['archive']['path'] + ' -j2 --summary all',
    'env': build['env'],
    'handle': 19999,
    'log': '/tmp/zxc-root-complete-rerun-debug-test.log',
    'terminal_exit_code': None,
}

path.write_text(json.dumps(value, ensure_ascii=False, indent=2) + '\n')
print(summary)
