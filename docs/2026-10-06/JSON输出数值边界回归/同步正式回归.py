import json
from pathlib import Path
import shutil
import subprocess


root = Path('/Users/xiewendao/Documents/MatrixAges/zxc')
fixed = Path('/Users/xiewendao/.codex/worktrees/json-output-conformance/zxc')
directory = Path(__file__).resolve().parent
draft = directory / '草稿'
suites = json.loads((directory / '草稿清单.json').read_text())
suite_path = root / 'packages/test/suites.json'
catalog = json.loads(suite_path.read_text())

assert len(suites) == 8 and sum(suite['count'] for suite in suites) == 50
existing = [suite for suite in catalog['runtime'] if suite['name'].startswith('application-json-output-')]
planned = [{key: value for key, value in suite.items() if key != 'count'} for suite in suites]
assert not existing or existing == planned or existing == planned[:-1]

for path in sorted((draft / 'packages/test/tests/built_ins/json/output').iterdir()):
    relative = path.relative_to(draft)

    for checkout in [root, fixed]:
        destination = checkout / relative
        destination.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(path, destination)

if not existing:
    offset = next(index for index, suite in enumerate(catalog['runtime']) if suite['name'] == 'application-json-numbers')
    catalog['runtime'][offset:offset] = planned
    suite_path.write_text(json.dumps(catalog, ensure_ascii=False, indent='\t') + '\n')
elif existing == planned[:-1]:
    offset = next(index for index, suite in enumerate(catalog['runtime']) if suite['name'] == existing[-1]['name'])
    catalog['runtime'][offset + 1:offset + 1] = planned[-1:]
    suite_path.write_text(json.dumps(catalog, ensure_ascii=False, indent='\t') + '\n')

for relative in [
    'packages/test/suites.json',
    'packages/test/tests/targets/application_json/check.ts',
    'packages/test/tests/targets/application_json/gateway/run_test.ts',
    'packages/test/build/runtime.zig',
    'packages/test/build/application_json_gateway.zig',
]:
    source = root / relative

    for destination in [fixed / relative, draft / relative]:
        destination.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(source, destination)

commit = subprocess.check_output(['git', 'rev-parse', '--short', 'HEAD'], cwd=fixed, text=True).strip()
print('8 suites and 50 IDs synchronized; fixed production baseline ' + commit)
