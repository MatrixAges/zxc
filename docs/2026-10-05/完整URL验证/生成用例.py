import hashlib
import json
from pathlib import Path
import subprocess
import sys


root = Path(__file__).resolve().parents[3]
upstream = root / 'packages/test/upstream/wpt'
target = root / 'packages/test/tests/standard/resources/url/parser'
lock = json.loads((upstream / 'lock.json').read_text())

for name, digest in lock['files'].items():
    path = upstream / name
    assert hashlib.sha256(path.read_bytes()).hexdigest() == digest, name

data = json.loads((upstream / 'url/resources/urltestdata.json').read_text())
cases = [(index, value) for index, value in enumerate(data) if isinstance(value, dict)]
assert len(cases) == 896
assert sum(value.get('failure', False) for _, value in cases) == 269


def literal(value):
    raw = json.dumps(value, ensure_ascii=False, separators=(',', ':')).encode('utf-8')
    return '"' + ''.join(chr(byte) if 32 <= byte < 127 and byte not in (34, 92) else f'\\x{byte:02x}' for byte in raw) + '"'


target.mkdir(parents=True, exist_ok=True)

for group in range(9):
    lines = ['const fixture = @import("fixture.zig");', '']

    for index, value in cases[group * 100:(group + 1) * 100]:
        lines.extend([f'test "WPT URL source index {index}" {{', f'    try fixture.check({literal(value)});', '}', ''])

    source = subprocess.run(['zig', 'fmt', '--stdin'], input='\n'.join(lines), text=True, capture_output=True, check=True).stdout
    path = target / f'group_{group}_test.zig'

    if '--check' in sys.argv:
        assert path.read_text() == source, path
    else:
        path.write_text(source)

print('896 WPT URL cases: 627 success, 269 failure; upstream hashes verified')
