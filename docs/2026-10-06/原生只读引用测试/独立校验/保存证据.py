# -*- coding: utf-8 -*-

from pathlib import Path
import hashlib
import json
import shutil
import subprocess


根目录 = Path(__file__).resolve().parents[4]
固定目录 = Path('/Users/xiewendao/.codex/worktrees/native-reference-conformance/zxc')
记录目录 = Path(__file__).resolve().parent
来源 = [Path('packages/test/build/native_references.zig')]

来源 += [
    路径.relative_to(根目录)
    for 路径 in sorted((根目录 / 'packages/test/tests/native/references/ir').glob('*.zig'))
]


def 指纹(路径):
    return hashlib.sha256(路径.read_bytes()).hexdigest()


for 路径 in 来源:
    assert (根目录 / 路径).read_bytes() == (固定目录 / 路径).read_bytes(), 路径

门禁 = {}

for 模式, 名称 in [('Debug', 'debug'), ('ReleaseSafe', 'safe')]:
    原日志 = Path('/tmp/zxc-native-references-ir-final-' + 名称 + '.log')
    最终日志 = 记录目录 / (模式 + '最终日志.txt')

    assert 'Build Summary: 27/27 steps succeeded; 15/15 tests passed' in 原日志.read_text()
    shutil.copyfile(原日志, 最终日志)

    门禁[模式] = {
        '命令': 'zig build test-native-references-ir '
        + ('-Doptimize=safe ' if 模式 == 'ReleaseSafe' else '')
        + '-j2 --summary all',
        '退出码': 0,
        '构建步骤': '27/27',
        '独立声明': 15,
        '实际执行通过': 15,
        '缓存测试': 0,
        '日志': 最终日志.name,
        '日志SHA256': 指纹(最终日志),
    }

结果 = {
    '固定生产提交': subprocess.check_output(
        ['git', 'rev-parse', 'HEAD'], cwd=固定目录, text=True
    ).strip(),
    '固定生产源码树': subprocess.check_output(
        ['git', 'rev-parse', 'HEAD^{tree}'], cwd=固定目录, text=True
    ).strip(),
    '测试检出': str(固定目录),
    '工具': {'Zig': '0.17.0'},
    '测试来源SHA256': {str(路径): 指纹(根目录 / 路径) for 路径 in 来源},
    '门禁': 门禁,
    '新增独立声明': 15,
    '新增Test262审阅': 0,
    '新增JSONL目录案例': 0,
    '自我复核': '首轮14/15通过；OOM驱动把合法OutOfMemory误报为ExpectedInvalidIr。'
    '修正帮助函数以继续要求InvalidIr，并将实际OOM传播给逐分配点驱动。'
    '临时Store槽位改为arena分配，避免返回测试自身的局部存储指针。最终两模式15/15。',
}

(记录目录 / '执行结果.json').write_text(
    json.dumps(结果, ensure_ascii=False, indent=2) + '\n'
)
