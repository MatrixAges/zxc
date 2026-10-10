# coding: utf-8
import collections
from datetime import datetime
import gzip
import hashlib
import json
from pathlib import Path
import re


document = Path(__file__).resolve().parent
run = Path.home() / '.codex/conformance/indexed-root-bbd92b5c5/r1'
terminal = json.loads((run / 'debug.terminal.json').read_text())
assert terminal['terminal_exit_code'] == 1
assert not any(terminal[key] for key in ('changed_sources', 'changed_tools', 'changed_dependencies'))
assert not (run / 'safe.start.json').exists()
records = []


def digest(raw):
    return hashlib.sha256(raw).hexdigest()


for name in ('起点.json', '运行根门禁.py', 'debug.start.json', 'debug.terminal.json',
             'debug.log.txt', 'debug.processes.jsonl'):
    raw = (run / name).read_bytes()
    encoded = gzip.compress(raw, mtime=0)
    target = document / '原始终态' / (name + '.gz')
    target.parent.mkdir(exist_ok=True)
    target.write_bytes(encoded)
    assert gzip.decompress(encoded) == raw
    records.append({'source': str(run / name), 'saved': str(target.relative_to(document)),
                    'raw_sha256': digest(raw), 'raw_bytes': len(raw),
                    'saved_sha256': digest(encoded), 'saved_bytes': len(encoded)})

raw = (run / 'debug.log.txt').read_bytes()
assert digest(raw) == terminal['log_sha256']
lines = raw.decode().splitlines()
summary_index = next(index for index, line in enumerate(lines) if line.startswith('Build Summary:'))
assert terminal['build_summaries'] == [lines[summary_index]]
failures = []

for index, line in enumerate(lines[summary_index + 1:], summary_index + 2):
    plain_failure = re.search(r'\bfailure\b', line) and 'transitive failure' not in line
    failed_tests = re.search(r'run test.*\d+ fail', line)
    compile_errors = re.search(r'compile test.*\d+ errors?', line)

    if plain_failure or failed_tests or compile_errors:
        failures.append({'line': index, 'text': line})

assert len(failures) == 40
groups = collections.Counter()

for failure in failures:
    text = failure['text']

    if 'compile-' in text:
        groups[re.search(r'compile-[\w-]+', text)[0]] += 1
    elif 'run node failure' in text:
        groups['node'] += 1
    elif 'run test' in text:
        groups['zig_test_node'] += 1
    elif 'compile test' in text:
        groups['zig_compile_node'] += 1
    else:
        raise AssertionError(text)

expected_groups = {'compile-loop-initial-ownership': 5, 'compile-aggregate-loop': 6,
                   'compile-loop-columns': 7, 'compile-product-transfer': 4,
                   'compile-detached-reader': 10, 'node': 4,
                   'zig_test_node': 3, 'zig_compile_node': 1}
assert groups == expected_groups
names = [match[1] for line in lines[:summary_index]
         if (match := re.match(r'^\d+/\d+ (.*?)\.\.\.OK$', line))]
failed_test_rows = [item for item in failures if re.search(r'run test.*\d+ fail', item['text'])]
assert sum(int(re.search(r'(\d+) fail', item['text'])[1]) for item in failed_test_rows) == 10
duration = (datetime.fromisoformat(terminal['finished_at']) - datetime.fromisoformat(terminal['started_at'])).total_seconds()
result = {'source_commit': json.loads((run / '起点.json').read_text())['source_commit'],
          'started_at': terminal['started_at'], 'finished_at': terminal['finished_at'],
          'duration_seconds': duration, 'terminal_exit_code': terminal['terminal_exit_code'],
          'summary': lines[summary_index], 'log_bytes': len(raw), 'log_lines': len(lines),
          'direct_failed_steps': len(failures), 'failed_step_groups': dict(groups),
          'failed_steps': failures, 'failed_zig_tests': 10,
          'plain_ok_occurrences': len(names), 'distinct_plain_ok_names': len(set(names)),
          'count_boundary': 'Build summary counts and visible name counts are different measures; neither is a deduplicated semantic case count.',
          'release_safe_started_at_collection': False}
(document / '终态结果.json').write_text(json.dumps(result, ensure_ascii=False, indent=4) + '\n')
(document / '归档清单.json').write_text(json.dumps(records, ensure_ascii=False, indent=4) + '\n')
print(json.dumps({key: result[key] for key in ('terminal_exit_code', 'duration_seconds', 'direct_failed_steps', 'failed_zig_tests', 'distinct_plain_ok_names')}, indent=2))
