from pathlib import Path
import hashlib
import json

folder = Path(__file__).resolve().parent
root = folder.parents[2]
upstream = root / 'packages/test/upstream/unicode/18.0.0'
manifest = json.loads((upstream / 'manifest.json').read_text())

for entry in manifest['files']:
    payload = (upstream / entry['file']).read_bytes()
    assert len(payload) == entry['bytes']
    assert hashlib.sha256(payload).hexdigest() == entry['sha256']

counts = {}
listed = set()
part = None
for line in (upstream / 'NormalizationTest.txt').read_text().splitlines():
    content = line.split('#')[0].strip()
    if not content:
        continue
    if content.startswith('@Part'):
        part = content[5:]
        counts[part] = 0
        continue
    columns = content.split(';')
    assert len(columns) == 6 and columns[-1] == ''
    values = [[int(point, 16) for point in column.split()] for column in columns[:5]]
    assert all(values)
    counts[part] += 1
    if part == '1':
        assert len(values[0]) == 1
        listed.add(values[0][0])

checked = 0
start = None
for line in (upstream / 'UnicodeData.txt').read_text().splitlines():
    fields = line.split(';')
    point = int(fields[0], 16)
    if fields[1].endswith(', First>'):
        assert start is None
        start = point
        continue
    if fields[1].endswith(', Last>'):
        assert start is not None
        points = range(start, point + 1)
        start = None
    else:
        assert start is None
        points = [point]
    checked += sum(value not in listed and not 0xd800 <= value <= 0xdfff for value in points)

assert start is None
assert counts == manifest['part_rows']
assert sum(counts.values()) == manifest['normalization_rows']
assert sum(counts.values()) * 5 == manifest['nfc_relations']
assert checked == manifest['assigned_scalar_identity_cases']
result = {'version': manifest['version'], 'hashes_verified': len(manifest['files']), 'part_rows': counts, 'nfc_relations': sum(counts.values()) * 5, 'assigned_scalar_identity_cases': checked}
(folder / '数据核对.json').write_text(json.dumps(result, ensure_ascii=False, indent=2) + '\n')
print(json.dumps(result, ensure_ascii=False))
