from datetime import datetime, timezone
import gzip
import hashlib
import json
from pathlib import Path
import shlex


doc = Path(__file__).resolve().parent
base = Path('/Users/xiewendao/.codex/conformance/indexed-root-bbd92b5c5')
original = base / 'r1'
corrected = base / 'timeout-correction/r1'
terminal = json.loads((corrected / '终态.json').read_text())
assert terminal['terminal_exit_code'] == 0
assert not any(terminal[key] for key in ('changed_sources', 'changed_tools', 'changed_dependencies'))
assert not (doc / '归档清单.json').exists()
records = []


def save(source, relative, prefix=False, origins=None):
    raw = source.read_bytes()
    encoded = len(raw) > 50 * 1024 * 1024
    saved = relative + ('.gz' if encoded else '')
    destination = doc / saved
    destination.parent.mkdir(parents=True, exist_ok=True)
    data = gzip.compress(raw, mtime=0) if encoded else raw
    destination.write_bytes(data)
    records.append({'source': str(source), 'saved': saved,
                    'raw_sha256': hashlib.sha256(raw).hexdigest(), 'raw_bytes': len(raw),
                    'saved_sha256': hashlib.sha256(data).hexdigest(), 'saved_bytes': len(data),
                    'encoding': 'gzip' if encoded else 'identity',
                    'prefix_snapshot': prefix, 'origins': origins or [str(source)]})


for name in ('起点.json', '启动.json', '终态.json', '执行日志.txt', '进程记录.jsonl'):
    save(corrected / name, '冷构建证据/' + name + ('' if name.endswith('.txt') else '.txt'))

save(original / '起点.json', '根回归阶段证据/起点.json.txt')
save(original / 'debug.start.json', '根回归阶段证据/Debug启动.json.txt')
save(original / 'debug.log.txt', '根回归阶段证据/Debug日志快照.txt', prefix=True)
save(original / 'debug.processes.jsonl', '根回归阶段证据/Debug进程快照.jsonl.txt', prefix=True)

manifest = json.loads((corrected / '起点.json').read_text())
fixed_root = Path(manifest['cwd'])
save(fixed_root / 'packages/test/tests/build_modes/build_test.ts', '冷构建证据/修正测试驱动.ts.txt')
save(Path('/Users/xiewendao/.codex/worktrees/indexed-root-regression/zxc/packages/test/tests/build_modes/build_test.ts'),
     '根回归阶段证据/原始测试驱动.ts.txt')

parser_outputs = None

for line in (original / 'debug.log.txt').read_text(errors='replace').splitlines():
    if not line.startswith('info(verbose): '):
        continue

    argv = shlex.split(line[len('info(verbose): '):])

    if argv and Path(argv[0]).name == 'generate-parser':
        assert parser_outputs is None
        parser_outputs = [Path(path) for path in argv[2:-2]]

assert parser_outputs is not None and len(parser_outputs) == 86
fixed_cache = fixed_root / 'packages/cli/.zig-cache/o'
fixed_parser = next(fixed_cache.glob('*/analyzer.zig')).parent
original_lexer = next((original / 'local-debug/o').glob('*/lexer.zig'))
fixed_lexer = next(fixed_cache.glob('*/lexer.zig'))

for source in parser_outputs + [original_lexer]:
    counterpart = fixed_lexer if source.name == 'lexer.zig' else fixed_parser / source.name
    assert source.read_bytes() == counterpart.read_bytes(), source.name
    save(source, '生成编译器/' + source.name + '.txt', origins=[str(source), str(counterpart)])

(doc / '归档清单.json').write_text(json.dumps(records, ensure_ascii=False, indent=4) + '\n')
state = {'snapshot_at': datetime.now(timezone.utc).isoformat(), 'root_debug_terminal_at_snapshot': (original / 'debug.terminal.json').exists(),
         'root_debug_session': 81471, 'root_debug_pid': 64064, 'corrected_gate_exit_code': 0,
         'generated_compiler_modules': 87, 'generated_outputs_identical_across_runs': True,
         'corrected_gate_duration_seconds': (datetime.fromisoformat(terminal['finished_at']) - datetime.fromisoformat(terminal['started_at'])).total_seconds()}
(doc / '阶段状态.json').write_text(json.dumps(state, ensure_ascii=False, indent=4) + '\n')
print(json.dumps(state, ensure_ascii=False, indent=2))
