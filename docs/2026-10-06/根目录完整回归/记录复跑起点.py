# -*- coding: utf-8 -*-
import datetime
import hashlib
import json
from pathlib import Path
import subprocess


directory = Path(__file__).resolve().parent
fixed = Path('/Users/xiewendao/.codex/worktrees/native-reference-conformance/zxc')
archive = fixed / 'packages/test/.zig-cache/o/c16bf5716bbe508e223213805c3f3621/bundle/zig.archive'
solver = Path('/tmp/zxc-z3-5.1.0/z3-5.1.0-x64-osx-13.3/bin/z3')
paths = ['build.zig', 'packages/test/build.zig', 'packages/test/build/runtime.zig', 'packages/test/build/safety.zig', 'packages/test/build/child_process.zig', 'packages/test/tests/build_modes/build_test.ts', 'packages/test/src/generate_module_paths.ts']

assert not subprocess.check_output(['git', 'status', '--porcelain'], cwd=fixed)
value = {
    'source_commit': subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=fixed, text=True).strip(),
    'source_tree': subprocess.check_output(['git', 'rev-parse', 'HEAD^{tree}'], cwd=fixed, text=True).strip(),
    'cwd': str(fixed),
    'clean_at_start': True,
    'recorded_at_utc': datetime.datetime.now(datetime.timezone.utc).isoformat(),
    'archive': {'path': str(archive), 'sha256': hashlib.sha256(archive.read_bytes()).hexdigest()},
    'solver': {'path': str(solver), 'sha256': hashlib.sha256(solver.read_bytes()).hexdigest()},
    'sources': {path: hashlib.sha256((fixed / path).read_bytes()).hexdigest() for path in paths},
    'current_gate': {
        'command': 'zig build -Doptimize=debug -Dzig-archive=' + str(archive) + ' -j2 --summary all',
        'env': {'ZXC_TEST_SOLVER': str(solver)},
        'handle': 26557,
        'log': '/tmp/zxc-root-complete-rerun-debug-build.log',
        'terminal_exit_code': None,
    },
    'root_test_completed': False,
    'safe_build_completed': False,
    'safe_test_completed': False,
    'dist_completed': False,
}

path = directory / '复跑起点.json'
assert not path.exists(), 'existing rerun manifest must not be overwritten'
path.write_text(json.dumps(value, ensure_ascii=False, indent=2) + '\n')
print(value['source_commit'])
