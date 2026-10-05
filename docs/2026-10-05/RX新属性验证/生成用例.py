import json
from pathlib import Path
import subprocess
import sys


directory = Path(__file__).resolve().parent
root = directory.parents[2]
target = root / 'packages/test/tests/rx/attributes'

for source, name in [('解析案例.json', 'parsing'), ('属性案例.json', 'schema')]:
    cases = json.loads((directory / source).read_text())
    lines = ['const fixture = @import("fixture.zig");', '']

    for case in cases:
        value = dict(case)
        title = value.pop('name')
        literal = json.dumps(value, ensure_ascii=True, separators=(',', ':'))
        lines.extend([f'test "{title}" {{', '    try fixture.check(', '        \\\\' + literal, '    );', '}', ''])

    content = subprocess.run(['zig', 'fmt', '--stdin'], input='\n'.join(lines), text=True, capture_output=True, check=True).stdout
    path = target / f'{name}_test.zig'

    if '--check' in sys.argv:
        assert path.read_text() == content, path
    else:
        path.write_text(content)

    print(f'{name}: {len(cases)} cases')
