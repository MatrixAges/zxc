# -*- coding: utf-8 -*-
import hashlib
import json
from pathlib import Path
import re


directory = Path(__file__).resolve().parent
path = directory / '执行起点.json'
value = json.loads(path.read_text())
log = Path('/tmp/zxc-root-complete-debug-build.log')
summary = re.search(r'Build Summary: (.+)', log.read_text())[1]

value['first_gate']['terminal_exit_code'] = 0
value['first_gate']['build_summary'] = summary
value['first_gate']['log_sha256'] = hashlib.sha256(log.read_bytes()).hexdigest()
(directory / 'Debug构建日志.txt').write_bytes(log.read_bytes())

value['perimeter'][0]['terminal_exit_code'] = 1
value['perimeter'][0]['reason'] = 'pnpm first invocation installed dependencies; parallel calls raced in local esbuild staging; zero packages downloaded'
value['perimeter'][1]['terminal_exit_code'] = 1
value['perimeter'][1]['reason'] = '61 formatting differences; all 61 files byte-identical to 1a7241d6 baseline'

direct = {
    'command': 'node packages/test/node_modules/typescript/bin/tsc --noEmit --project packages/test/tsconfig.json',
    'exit_code': 0,
    'log': '类型检查直接执行日志.txt',
}

if not any(item['command'] == direct['command'] for item in value['perimeter']):
    value['perimeter'].append(direct)

(directory / direct['log']).write_bytes(Path('/tmp/zxc-root-complete-typecheck-direct.log').read_bytes())
if 'current_gate' not in value:
    value['current_gate'] = {
        'command': 'zig build test -Doptimize=debug -Dzig-archive=' + value['archive']['path'] + ' -j2 --summary all',
        'env': value['first_gate']['env'],
        'handle': 17158,
        'log': '/tmp/zxc-root-complete-debug-test.log',
        'terminal_exit_code': None,
    }

path.write_text(json.dumps(value, ensure_ascii=False, indent=2) + '\n')
print(summary)
