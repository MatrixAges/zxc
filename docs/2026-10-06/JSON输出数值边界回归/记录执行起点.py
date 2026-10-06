import hashlib
import json
from pathlib import Path
import subprocess


directory = Path(__file__).resolve().parent
fixed = Path('/Users/xiewendao/.codex/worktrees/json-output-conformance/zxc')
archive = Path('/Users/xiewendao/.codex/worktrees/native-reference-conformance/zxc/packages/test/.zig-cache/o/c16bf5716bbe508e223213805c3f3621/bundle/zig.archive')
paths = [
    'packages/test/suites.json',
    'packages/test/build/runtime.zig',
    'packages/test/build/application_json.zig',
    'packages/test/build/application_json_gateway.zig',
    'packages/test/tests/targets/application_json/check.ts',
    'packages/test/tests/targets/application_json/fixture.ts',
    'packages/test/tests/targets/application_json/model.ts',
    'packages/test/tests/targets/application_json/run_test.ts',
    'packages/test/tests/targets/application_json/gateway/run_test.ts',
    'packages/test/tests/runtime/gateway/application.ts',
    'packages/test/tests/runtime/gateway/request.ts',
    'packages/test/tests/targets/wasm/host.ts',
    'packages/test/tests/targets/wasm/wasi_host.ts',
    'packages/genz/src/host/json_output.zig',
    'packages/genz/src/host/cli/output.zig',
    'packages/genz/src/host/wasm/json.zig',
    'packages/genz/src/gateway/invoke.zig',
    'packages/genz/src/gateway/root.zig',
]
paths.extend(str(path.relative_to(fixed)) for path in sorted((fixed / 'packages/test/tests/built_ins/json/output').iterdir()))
record = {
    'production_commit': subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=fixed, text=True).strip(),
    'cwd': str(fixed / 'packages/test'),
    'node': subprocess.check_output(['node', '--version'], text=True).strip(),
    'zig': subprocess.check_output(['zig', 'version'], text=True).strip(),
    'archive': {'path': str(archive), 'sha256': hashlib.sha256(archive.read_bytes()).hexdigest()},
    'sources': {path: hashlib.sha256((fixed / path).read_bytes()).hexdigest() for path in paths},
    'new_suite_count': 8,
    'new_case_count': 50,
    'existing_application_json_count': 372,
    'debug': {
        'command': 'zig build test-application-json test-application-json-gateway -Doptimize=debug -Dzig-archive=' + str(archive) + ' -j2 --summary all',
        'handle': 72562,
        'log': '/tmp/zxc-json-output-final-debug.log',
        'terminal_exit_code': None,
    },
    'safe': {'terminal_exit_code': None},
    'complete': False,
}

assert record['production_commit'].startswith('e5d21277')
(directory / '执行起点.json').write_text(json.dumps(record, ensure_ascii=False, indent=2) + '\n')
print('e5d21277 and 50 shared-case source fingerprints recorded; Debug remains pending')
