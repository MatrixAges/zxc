# -*- coding: utf-8 -*-
import hashlib
import json
from pathlib import Path
import re
import subprocess


root = Path('/Users/xiewendao/Documents/MatrixAges/zxc')
fixed = Path('/Users/xiewendao/.codex/worktrees/native-reference-conformance/zxc')
directory = Path(__file__).resolve().parent


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def write(name, value):
    (directory / name).write_text(json.dumps(value, ensure_ascii=False, indent=2) + '\n')


paths = json.loads((directory / '正式文件列表.json').read_text())
paths += ['packages/test/build.zig', 'packages/test/build/catalog.zig', 'packages/test/build/runtime.zig', 'packages/test/build/application_json.zig', 'packages/test/src/shared/json.ts', 'packages/test/src/shared/catalog.ts', 'packages/test/src/shared/files.ts', 'packages/test/src/shared/upstream.ts', 'packages/test/src/audit_matrix.ts', 'packages/test/src/query_upstream.ts', 'packages/test/tests/targets/wasm/host.ts', 'packages/test/tests/targets/wasm/wasi_host.ts']
paths += [str(path.relative_to(fixed)) for path in (fixed / 'packages/test/tests/targets/application_json').glob('*.ts')]
paths += [str(path.relative_to(fixed)) for path in (fixed / 'packages/test/tests/built_ins/json/parse/lexical').iterdir()]
paths = sorted(set(paths))
fingerprints = {path: {'执行检出SHA256': digest(fixed / path), '主检出SHA256': digest(root / path), '相同': (fixed / path).read_bytes() == (root / path).read_bytes()} for path in paths}

for path in json.loads((directory / '正式文件列表.json').read_text()):
    assert fingerprints[path]['相同'], path

cases = {}

for path in (fixed / 'packages/test/tests/built_ins/json/parse/lexical').glob('*.jsonl'):
    for line in path.read_text().splitlines():
        case = json.loads(line)
        assert case['id'] not in cases
        cases[case['id']] = case

assert len(cases) == 372
assert sum('value' in case['expected'] for case in cases.values()) == 16
new_ids = {proof['case'] for row in json.loads((directory / '逐份审阅.json').read_text()) for proof in row['观察']}
control_id = 'built_ins/json/parse/lexical/object_controls/valid'
assert len(new_ids) == 344 and control_id not in new_ids
gates = {}
compilers = {}

for mode, label in [('debug', 'Debug'), ('safe', 'ReleaseSafe')]:
    log = Path('/tmp/zxc-json-controls-' + mode + '.log')
    latest = {}

    for path in (fixed / 'packages/test/.zig-cache/o').glob('*/application-json-*-' + mode + '.json'):
        report = json.loads(path.read_text())
        key = report['source']

        if key not in latest or path.stat().st_mtime_ns > latest[key][0].stat().st_mtime_ns:
            latest[key] = (path, report)

    assert len(latest) == 4
    observations = []
    commands = []
    reports = []

    for path, report in sorted(latest.values(), key=lambda item: item[1]['source']):
        assert path.stat().st_mtime >= log.stat().st_birthtime
        assert report['optimize'] == mode and len(report['artifacts']) == 3
        assert {item['target'] for item in report['artifacts']} == {'native', 'wasm32-freestanding', 'wasm32-wasi'}
        assert all(re.fullmatch(r'[0-9a-f]{64}', item['sha256']) for item in report['artifacts'])
        reports.append({'原始报告路径': str(path), **report})
        observations.extend(report['observations'])
        commands.extend(report['commands'])

    assert len(observations) == 1116
    assert {(item['id'], item['target']) for item in observations} == {(case_id, target) for case_id in cases for target in ('native', 'wasm32-freestanding', 'wasm32-wasi')}

    for item in observations:
        case = cases[item['id']]
        raw = case['json_text'].encode('utf-8')
        assert raw.hex() == item['input_utf8_hex']
        transportable = item['target'] == 'wasm32-freestanding' or b'\x00' not in raw
        assert item['executed'] == transportable

        if not transportable:
            assert item['reason'] == 'argv cannot transport NUL'
            continue

        assert item['passed'], item
        response = item['response']

        if 'value' in case['expected']:
            assert response['status'] == 0 and json.loads(response['output']) == case['expected']['value']
        elif item['target'] == 'wasm32-freestanding':
            assert response['status'] == 1 and response['output'] == case['expected']['error']
        else:
            assert response['status'] != 0
            assert re.search(r'^error: ([A-Za-z][A-Za-z0-9]*)\b', response['stderr'], re.MULTILINE)[1] == case['expected']['error']

    assert len(commands) == 734
    assert all(item['signal'] is None and item['error'] is None for item in commands)
    builds = [item for item in commands if item['argv'][0] == 'build']
    assert len(builds) == 12
    assert all(item['status'] == 0 and item['argv'][item['argv'].index('--optimize') + 1] == mode for item in builds)

    for item in builds:
        compilers[item['command']] = digest(Path(item['command']))

    assert sum(item['status'] == 0 for item in commands) == 44
    assert sum(item['status'] != 0 for item in commands) == 690
    executed = [item for item in observations if item['executed']]
    added = [item for item in executed if item['id'] in new_ids]
    controls = [item for item in executed if item['id'] == control_id]
    assert len(executed) == 1094 and len(added) == 1012 and len(controls) == 3
    assert sum(item['response']['status'] == 0 for item in executed) == 48
    text = log.read_text()
    assert 'Build Summary: 34/34 steps succeeded' in text
    assert sum(int(value) for value in re.findall(r'^ℹ tests (\d+)$', text, re.MULTILINE)) == 372
    assert sum(int(value) for value in re.findall(r'^ℹ fail (\d+)$', text, re.MULTILINE)) == 0
    assert len(re.findall(r'run node \(application-json-[a-z-]+-' + mode + r'\.json\) success', text)) == 4
    (directory / (label + '日志.txt')).write_bytes(log.read_bytes())
    write(label + '运行报告.json', reports)
    gates[label] = {'命令': 'zig build test-application-json -Doptimize=' + mode + ' -j2 --summary all', '退出码': 0, '构建步骤': '34/34', '独立案例实际执行': 372, '实际目标观察': 1094, '成功观察': 48, '准确拒绝观察': 1046, 'Wasm完整观察': 372, 'native观察': 361, 'WASI观察': 361, '新增完整原文目标观察': 1012, '新增独立合法控制目标观察': 3, '旧词法目标观察': 79, 'argv无法传输NUL的目标观察': 22, '正式应用构建': 12, '真实进程命令': 734, '运行结果缓存': 0, '日志SHA256': digest(log)}

original = json.loads((directory / '原文结果.json').read_text())
assert original['files'] == 19 and len(original['results']) == 38
assert original['observed_json_parse_calls'] == 688 and all(item['passed'] for item in original['results'])
audit = json.loads((directory / '覆盖审计.json').read_text())
assert audit['catalog_cases'] == 80533 and sum(audit['reviewed'].values()) == 2518
assert audit['reviewed']['adapted'] == 732 and audit['unreviewed'] == 51079 and audit['linked_cases'] == 5314
closure = json.loads((directory / '家族闭合.json').read_text())
assert all(item['matched_unreviewed'] == 0 for item in closure['查询'])
env = subprocess.check_output(['zig', 'env'], text=True)
zig_lib = Path(re.search(r'\.lib_dir = "([^"]+)"', env)[1])
tools = {str(zig_lib / path): digest(zig_lib / path) for path in ('std/json/Scanner.zig', 'std/json/static.zig', 'std/json/Stringify.zig', 'std/process/Args.zig', 'compiler/Maker/Step/Run.zig')}
producers = ['packages/genz/src/host/cli/input.zig', 'packages/genz/src/host/cli/root.zig', 'packages/genz/src/host/cli/output.zig', 'packages/genz/src/host/wasm/json.zig', 'packages/genz/src/host/wasm/common.zig']
write('执行结果.json', {'固定生产提交': subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=fixed, text=True).strip(), '固定生产源码树': subprocess.check_output(['git', 'rev-parse', 'HEAD^{tree}'], cwd=fixed, text=True).strip(), '测试检出': str(fixed), '测试来源': fingerprints, '固定生产JSON入口SHA256': {path: digest(fixed / path) for path in producers}, '执行编译器SHA256': compilers, '工具源码SHA256': tools, '工具': {'Zig': subprocess.check_output(['zig', 'version'], text=True).strip(), 'Node': subprocess.check_output(['node', '--version'], text=True).strip()}, '门禁': gates, '类型检查退出码': 0, '生成一致性退出码': 0, '新增完整原文审阅': 19, '原文执行': {'文件': 19, '普通与严格执行': 38, 'JSON.parse调用': 688, '完整逻辑观察': 344, '计为ZX目标执行': False}, '完整矩阵审计': audit, '家族闭合': closure, '自我复核': '19份全部观察逐字节保留。343拒绝检查精确SyntaxError，结构化空白成功输出多一项本地值断言；独立name控制不计上游。2-3/5/8/10在控制字符前已非法，未声称覆盖更后方scanner位置。所有Wasm输入真实执行，22个argv NUL目标明确缺测。普通ZX恒等业务无case ID或输入分支，生成普通Zig及标准JSON调用；无新增专用运行库。当前主检出另有归档传播修复，固定执行提交仍为1a，不能借此声称新提交或根全量已通过。'})
print(json.dumps({'新增登记案例': 345, '新增adapted': 19, '各模式实际目标观察': 1094, '未审阅': audit['unreviewed']}, ensure_ascii=False))
