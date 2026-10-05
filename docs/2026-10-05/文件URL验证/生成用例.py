import json
from pathlib import Path
import subprocess
import sys


root = Path(__file__).resolve().parents[3]
document = json.loads(Path(__file__).with_name('参考用例.json').read_text())
target = root / 'packages/test/tests/standard/resources/url/file'
assert len(document['cases']) == 1449
identities = {(item['operation'], item['windows'], item['input'], item.get('cwd')) for item in document['cases']}
assert len(identities) == len(document['cases'])

for operation in ['from_path', 'to_path', 'to_bytes']:
    for windows in [False, True]:
        lines = ['const fixture = @import("fixture.zig");', '']

        for index, value in enumerate(document['cases']):
            if value['operation'] != operation or value['windows'] != windows:
                continue

            source = json.dumps(value, ensure_ascii=True, separators=(',', ':'))
            lines.extend([f'test "{operation} case {index}" {{', '    try fixture.check(', '        \\\\' + source, '    );', '}', ''])

        source = subprocess.run(['zig', 'fmt', '--stdin'], input='\n'.join(lines), text=True, capture_output=True, check=True).stdout
        path = target / f'{operation}_{"windows" if windows else "posix"}_test.zig'

        if '--check' in sys.argv:
            assert path.read_text() == source, path
        else:
            path.write_text(source)

print(f'{len(document["cases"])} file URL cases verified')
