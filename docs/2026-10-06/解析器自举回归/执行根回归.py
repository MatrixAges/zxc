from datetime import datetime, timezone
from pathlib import Path
import hashlib
import json
import os
import subprocess
import sys


root = Path(sys.argv[1]).resolve()
label = sys.argv[2]
output = Path(__file__).resolve().parent
solver = Path('/tmp/zxc-z3-5.1.0/z3-5.1.0-x64-osx-13.3/bin/z3')


def git(*args):
    return subprocess.check_output(['git', *args], cwd=root, text=True).strip()


def snapshot():
    return {
        '固定检出': git('rev-parse', 'HEAD'),
        '根源码树': git('rev-parse', 'HEAD^{tree}'),
        '工作树状态': git('status', '--porcelain'),
    }


def save():
    path = output / f'{label}执行结果.json'
    path.write_text(json.dumps(result, ensure_ascii=False, indent=2) + '\n')


assert solver.is_file()
initial = snapshot()
assert initial['工作树状态'] == '', initial

environment = {**os.environ, 'ZXC_TEST_SOLVER': str(solver)}
result = {
    '启动时间UTC': datetime.now(timezone.utc).isoformat(),
    '初始检出': initial,
    '工具': {
        'Zig': subprocess.check_output(['zig', 'version'], text=True).strip(),
        'Node': subprocess.check_output(['node', '--version'], text=True).strip(),
        'Z3': subprocess.check_output([str(solver), '--version'], text=True).strip(),
        'Z3路径': str(solver),
        'Z3指纹': hashlib.sha256(solver.read_bytes()).hexdigest(),
    },
    '门禁': [],
    '完成': False,
}

save()

for name, args in [
    ('根ReleaseSafe测试', ['zig', 'build', 'test']),
    ('ReleaseSafe发行构建', ['zig', 'build']),
]:
    command = [*args, '-Doptimize=ReleaseSafe', '-j2', '--summary', 'all']
    log = output / f'{label}{name}日志.txt'
    started = datetime.now(timezone.utc).isoformat()

    with log.open('wb') as stream:
        completed = subprocess.run(command, cwd=root, env=environment, stdout=stream, stderr=subprocess.STDOUT)

    current = snapshot()
    result['门禁'].append({
        '名称': name,
        '命令': command,
        '启动时间UTC': started,
        '结束时间UTC': datetime.now(timezone.utc).isoformat(),
        '退出码': completed.returncode,
        '日志': log.name,
        '日志SHA256': hashlib.sha256(log.read_bytes()).hexdigest(),
        '执行后检出': current,
        '源码未改变': current == initial,
    })
    save()
    print(f'{name}退出{completed.returncode}；源码未改变={current == initial}', flush=True)

    if completed.returncode != 0 or current != initial:
        sys.exit(completed.returncode or 1)

result['完成'] = True
save()
