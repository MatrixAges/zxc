# -*- coding: utf-8 -*-
import hashlib
import json
from pathlib import Path


directory = Path(__file__).resolve().parent
fixed = Path('/Users/xiewendao/.codex/worktrees/native-reference-conformance/zxc')
log = Path('/tmp/zxc-root-complete-debug-test.log')
text = log.read_text()

assert 'failed command: node ./packages/test/src/generate_module_paths.ts --check' in text
assert 'Build Summary:' not in text

snapshot = {'application_json': [], 'native_runtime': [], 'native_targets': [], 'safety': []}
started = log.stat().st_birthtime

for cache in (fixed / '.zig-cache/o', fixed / 'packages/test/.zig-cache/o'):
    for path in cache.glob('*/application-json-*-debug.json'):
        if path.stat().st_mtime < started:
            continue
        snapshot['application_json'].append({'path': str(path), 'report': json.loads(path.read_text())})

    for path in cache.glob('*/execution.json'):
        if path.stat().st_mtime < started:
            continue
        report = json.loads(path.read_text())
        if '/tests/native/references/runtime/' in report.get('source', '') and report.get('optimize') == 'debug':
            snapshot['native_runtime'].append({'path': str(path), 'report': report})

    for path in cache.glob('*/application-targets.json'):
        if path.stat().st_mtime >= started:
            report = json.loads(path.read_text())
            if report.get('optimize') == 'debug':
                snapshot['native_targets'].append({'path': str(path), 'report': report})

for path in (fixed / 'zig-out/conformance/debug').glob('*.jsonl'):
    snapshot['safety'].append({'path': str(path), 'mtime': path.stat().st_mtime, 'created_or_updated_after_start': path.stat().st_mtime >= started, 'rows': [json.loads(line) for line in path.read_text().splitlines()]})

(directory / '首轮Debug已完成报告.json').write_text(json.dumps(snapshot, ensure_ascii=False, indent=2) + '\n')
(directory / '首轮Debug中止日志.txt').write_bytes(log.read_bytes())
path = directory / '执行起点.json'
value = json.loads(path.read_text())
value['current_gate']['terminal_exit_code'] = 130
value['current_gate']['complete'] = False
value['current_gate']['termination'] = 'Explicit SIGINT to confirmed own maker PID 6355 after deterministic generator consistency failure; not an observation timeout'
value['current_gate']['known_failed_command'] = 'node ./packages/test/src/generate_module_paths.ts --check'
value['current_gate']['log_sha256'] = hashlib.sha256(log.read_bytes()).hexdigest()
value['current_gate']['snapshot'] = '首轮Debug已完成报告.json'
path.write_text(json.dumps(value, ensure_ascii=False, indent=2) + '\n')
print(json.dumps({key: len(reports) for key, reports in snapshot.items()}, ensure_ascii=False))
