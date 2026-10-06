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
    (directory / name).write_text(json.dumps(value, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')


sources = [Path(name) for name in (
    'packages/test/build.zig',
    'packages/test/build/catalog.zig',
    'packages/test/build/runtime.zig',
    'packages/test/build/application_json.zig',
    'packages/test/suites.json',
    'packages/test/src/generate_json_lexical.ts',
    'packages/test/src/shared/json.ts',
    'packages/test/src/shared/catalog.ts',
    'packages/test/src/shared/files.ts',
    'packages/test/src/shared/upstream.ts',
    'packages/test/src/audit_matrix.ts',
    'packages/test/src/query_upstream.ts',
    'packages/test/tests/targets/wasm/host.ts',
    'packages/test/tests/targets/wasm/wasi_host.ts',
    'packages/test/upstream/reviews/built_ins/json/lexical.jsonl',
)]
sources += sorted(path.relative_to(root) for path in (root / 'packages/test/tests/targets/application_json').glob('*.ts'))
sources += sorted(path.relative_to(root) for path in (root / 'packages/test/tests/built_ins/json/parse/lexical').iterdir())
fingerprints = {}

for source in sources:
    assert (root / source).read_bytes() == (fixed / source).read_bytes(), source
    fingerprints[str(source)] = digest(root / source)

cases = {}

for source in (root / 'packages/test/tests/built_ins/json/parse/lexical').glob('*.jsonl'):
    for line in source.read_text().splitlines():
        case = json.loads(line)
        assert case['id'] not in cases
        cases[case['id']] = case

assert len(cases) == 27
assert sum('value' in case['expected'] for case in cases.values()) == 14
gates = {}
compilers = {}

for mode, label in (('debug', 'Debug'), ('safe', 'ReleaseSafe')):
    latest = {}

    for path in (fixed / 'packages/test/.zig-cache/o').glob('*/application-json-*-' + mode + '.json'):
        report = json.loads(path.read_text())
        key = report['source']

        if key not in latest or path.stat().st_mtime_ns > latest[key][0].stat().st_mtime_ns:
            latest[key] = (path, report)

    assert len(latest) == 2
    observations = []
    commands = []
    reports = []

    for path, report in sorted(latest.values(), key=lambda item: item[1]['source']):
        assert report['optimize'] == mode
        assert len(report['artifacts']) == 3
        assert {artifact['target'] for artifact in report['artifacts']} == {'native', 'wasm32-freestanding', 'wasm32-wasi'}
        assert all(re.fullmatch(r'[0-9a-f]{64}', artifact['sha256']) for artifact in report['artifacts'])
        reports.append({'原始报告路径': str(path), **report})
        observations.extend(report['observations'])
        commands.extend(report['commands'])

    assert len(observations) == 81
    assert {(observation['id'], observation['target']) for observation in observations} == {(case_id, target) for case_id in cases for target in ('native', 'wasm32-freestanding', 'wasm32-wasi')}

    for observation in observations:
        case = cases[observation['id']]
        raw = case['json_text'].encode('utf-8')
        assert raw.hex() == observation['input_utf8_hex']
        transportable = observation['target'] == 'wasm32-freestanding' or b'\x00' not in raw
        assert observation['executed'] == transportable

        if transportable:
            assert observation['passed'], observation

            if 'value' in case['expected']:
                assert observation['response']['status'] == 0, observation
            elif observation['target'] == 'wasm32-freestanding':
                assert observation['response']['status'] == 1, observation
            else:
                assert observation['response']['status'] != 0, observation
        else:
            assert observation['reason'] == 'argv cannot transport NUL'

    assert len(commands) == 58
    assert all(command['signal'] is None and command['error'] is None for command in commands)
    builds = [command for command in commands if command['argv'][0] == 'build']
    assert len(builds) == 6
    assert all(command['status'] == 0 and command['argv'][command['argv'].index('--optimize') + 1] == mode for command in builds)

    for command in builds:
        compilers[command['command']] = digest(Path(command['command']))

    assert sum(command['status'] == 0 for command in commands) == 34
    assert sum(command['status'] != 0 for command in commands) == 24
    executed = [observation for observation in observations if observation['executed']]
    assert len(executed) == 79
    assert sum(observation['response']['status'] == 0 for observation in executed) == 42
    log = Path('/tmp/zxc-json-lexical-' + mode + '.log')
    text = log.read_text()
    assert 'Build Summary: 32/32 steps succeeded' in text
    assert sum(int(value) for value in re.findall(r'^ℹ tests (\d+)$', text, re.MULTILINE)) == 27
    assert sum(int(value) for value in re.findall(r'^ℹ fail (\d+)$', text, re.MULTILINE)) == 0
    assert len(re.findall(r'run node \(application-json-(?:numbers|strings)-' + mode + r'\.json\) success', text)) == 2
    (directory / (label + '日志.txt')).write_bytes(log.read_bytes())
    write(label + '运行报告.json', reports)
    gates[label] = {
        '命令': 'zig build test-application-json -Doptimize=' + mode + ' -j2 --summary all',
        '退出码': 0,
        '构建步骤': '32/32',
        '独立登记案例实际执行': 27,
        '原始输入目标实际观察': 79,
        '成功观察': 42,
        '准确拒绝观察': 37,
        'Wasm完整观察': 27,
        'native观察': 26,
        'WASI观察': 26,
        'argv不可传输NUL的目标观察': 2,
        '正式应用构建': 6,
        '真实进程命令': 58,
        '运行结果缓存': 0,
        '日志': label + '日志.txt',
        '日志SHA256': digest(log),
        '报告': label + '运行报告.json',
    }

original = json.loads((directory / '原文结果.json').read_text())
assert original['files'] == 23 and len(original['results']) == 46
assert all(result['passed'] for result in original['results'])
assert original['observed_json_parse_calls'] == 54
closure = json.loads((directory / '家族闭合.json').read_text())
assert all(query['matched_unreviewed'] == 0 for query in closure['查询'])
audit = json.loads((directory / '覆盖审计.json').read_text())
assert audit['catalog_cases'] == 80188 and sum(audit['reviewed'].values()) == 2499
assert audit['reviewed']['adapted'] == 713 and audit['unreviewed'] == 51098
assert audit['linked_cases'] == 4970
env = subprocess.check_output(['zig', 'env'], text=True)
zig_lib = Path(re.search(r'\.lib_dir = "([^"]+)"', env)[1])
tool_sources = {str(zig_lib / path): digest(zig_lib / path) for path in ('std/json/Scanner.zig', 'std/json/static.zig', 'std/json/Stringify.zig', 'std/process/Args.zig', 'compiler/Maker/Step/Run.zig')}
producer_paths = ('packages/genz/src/host/cli/input.zig', 'packages/genz/src/host/cli/root.zig', 'packages/genz/src/host/cli/output.zig', 'packages/genz/src/host/wasm/json.zig', 'packages/genz/src/host/wasm/common.zig')

write('执行结果.json', {
    '固定生产提交': subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=fixed, text=True).strip(),
    '固定生产源码树': subprocess.check_output(['git', 'rev-parse', 'HEAD^{tree}'], cwd=fixed, text=True).strip(),
    '测试检出': str(fixed),
    '测试来源SHA256': fingerprints,
    '固定生产JSON入口SHA256': {path: digest(fixed / path) for path in producer_paths},
    '执行编译器SHA256': compilers,
    '工具源码SHA256': tool_sources,
    '工具': {'Zig': subprocess.check_output(['zig', 'version'], text=True).strip(), 'Node': subprocess.check_output(['node', '--version'], text=True).strip()},
    '门禁': gates,
    '类型检查': {'命令': 'pnpm typecheck', '退出码': 0},
    '生成一致性': {'命令': 'node packages/test/src/generate_json_lexical.ts --check', '退出码': 0},
    '新增完整原文审阅': 23,
    '原文执行': {'文件': 23, '普通与严格模式执行': 46, '原始JSON.parse调用': 54, '完整逻辑观察': 27, '计为ZX目标执行': False},
    '完整矩阵审计': audit,
    '家族闭合': closure,
    '自我复核': '完整保留23份原文的27个文本/结果观察，类型化应用入口和JS函数/异常对象差异明示为adapted。g2-4拒绝映射UnexpectedEndOfInput，g5-2仍SyntaxError。Wasm全量原始字节，argv仅因通用NUL限制未执行两个目标观察；四个组合控制串未扩充上游观察数量。初轮两模式27个登记案例通过，但has_side_effects构建节点使用相同报告名覆盖了其他组的证据；按suite名和模式分开输出后完整重跑，最终每模式两报告79次实际观察保全，运行结果不复用缓存。未发现生产违约，未通知实现聊天。',
})

print(json.dumps({'新增登记案例': 27, '新增adapted原文': 23, '各模式实际目标观察': 79, '测试来源': len(fingerprints), '总登记案例': audit['catalog_cases'], '未审阅': audit['unreviewed']}, ensure_ascii=False))
