import hashlib
import json
from pathlib import Path
import subprocess


directory = Path(__file__).resolve().parent
fixed = Path('/Users/xiewendao/.codex/worktrees/json-output-conformance/zxc')
archive = Path('/Users/xiewendao/.codex/worktrees/native-reference-conformance/zxc/packages/test/.zig-cache/o/c16bf5716bbe508e223213805c3f3621/bundle/zig.archive')
paths = [
    'packages/test/build/runtime.zig',
    'packages/test/build/application_json_gateway.zig',
    'packages/test/build/application_json.zig',
    'packages/test/suites.json',
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
]
paths.extend(str(path.relative_to(fixed)) for path in sorted((fixed / 'packages/test/tests/built_ins/json/output').iterdir()))
value = {
    'source_commit': subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=fixed, text=True).strip(),
    'cwd': str(fixed / 'packages/test'),
    'production_change': False,
    'formal_change': 'Only two appended JSONL records in object.jsonl',
    'new_case_count': 2,
    'shared_case_count': 52,
    'archive': {'path': str(archive), 'sha256': hashlib.sha256(archive.read_bytes()).hexdigest()},
    'sources': {path: hashlib.sha256((fixed / path).read_bytes()).hexdigest() for path in paths},
    'debug': {
        'command': 'zig build test-application-json-output -Doptimize=debug -Dzig-archive=' + str(archive) + ' -j2 --summary all',
        'handle': 71502,
        'log': '/tmp/zxc-json-large-prefix-debug.log',
        'terminal_exit_code': None,
    },
    'safe': {'terminal_exit_code': None},
    'complete': False,
}
assert value['source_commit'].startswith('fef9471a')
(directory / '执行起点.json').write_text(json.dumps(value, ensure_ascii=False, indent=2) + '\n')
print('52 shared-case fingerprints bound to fef9471a; Debug pending')
