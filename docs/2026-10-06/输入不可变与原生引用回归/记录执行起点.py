import hashlib
import json
from pathlib import Path
import subprocess


directory = Path(__file__).resolve().parent
fixed = Path('/Users/xiewendao/.codex/worktrees/json-output-conformance/zxc')
archive = Path('/Users/xiewendao/.codex/worktrees/native-reference-conformance/zxc/packages/test/.zig-cache/o/c16bf5716bbe508e223213805c3f3621/bundle/zig.archive')
commit = subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=fixed, text=True).strip()
assert commit.startswith('f38d9b4f')
assert not subprocess.check_output(['git', 'status', '--porcelain', '--untracked-files=all'], cwd=fixed)
sources = []

for folder in ['packages/test/tests/native/references', 'packages/test/tests/ownership/input']:
    sources.extend(path for path in (fixed / folder).rglob('*') if path.is_file())

sources.extend(fixed / name for name in ['packages/test/build.zig', 'packages/test/build/native_references.zig', 'packages/test/build/native_reference_runtime.zig', 'packages/test/build/native_reference_targets.zig', 'packages/test/build/owned_input.zig', 'packages/test/tests/library/runtime/save.zig', 'packages/test/tests/support/allocation_testing.zig', 'packages/test/tests/targets/wasm/host.ts', 'packages/test/tests/targets/wasm/wasi_host.ts'])
value = {
    'production_commit': commit,
    'production_tree': subprocess.check_output(['git', 'rev-parse', 'HEAD^{tree}'], cwd=fixed, text=True).strip(),
    'cwd': str(fixed / 'packages/test'),
    'archive': {'path': str(archive), 'sha256': hashlib.sha256(archive.read_bytes()).hexdigest()},
    'sources': {str(path.relative_to(fixed)): hashlib.sha256(path.read_bytes()).hexdigest() for path in sorted(set(sources))},
    'debug': {'handle': 40112, 'log': '/tmp/zxc-input-reference-debug.log', 'steps': ['test-owned-input', 'test-native-references'], 'terminal_exit_code': None},
    'safe': None,
    'completed': False,
}
assert not (directory / '执行起点.json').exists()
(directory / '执行起点.json').write_text(json.dumps(value, ensure_ascii=False, indent=2) + '\n')
print('Clean fixed tree and ' + str(len(value['sources'])) + ' test dependency fingerprints recorded')
