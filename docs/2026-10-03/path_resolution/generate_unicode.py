from pathlib import Path
import hashlib
import json

base = Path(__file__).parent
expected = {
    'UnicodeData.txt': '2e1efc1dcb59c575eedf5ccae60f95229f706ee6d031835247d843c11d96470c',
    'SpecialCasing.txt': 'efc25faf19de21b92c1194c111c932e03d2a5eaf18194e33f1156e96de4c9588',
    'DerivedCoreProperties.txt': '24c7fed1195c482faaefd5c1e7eb821c5ee1fb6de07ecdbaa64b56a99da22c08',
}
for name, digest in expected.items():
    if hashlib.sha256((base / 'ucd' / name).read_bytes()).hexdigest() != digest:
        raise ValueError('Unicode source hash mismatch: ' + name)

out = Path('packages/compiler/src/runtime/standard/path/unicode')
out.mkdir(exist_ok=True)
mappings = {}

for line in (base / 'ucd/UnicodeData.txt').read_text().splitlines():
    fields = line.split(';')
    if fields[13]:
        mappings[int(fields[0], 16)] = [int(fields[13], 16)]

final = []
for line in (base / 'ucd/SpecialCasing.txt').read_text().splitlines():
    fields = [x.strip() for x in line.split('#')[0].split(';')]
    if len(fields) < 5:
        continue
    cp = int(fields[0], 16)
    lower = [int(x, 16) for x in fields[1].split()]
    condition = fields[4]
    if not condition:
        mappings[cp] = lower
    elif condition == 'Final_Sigma':
        final.append((cp, lower[0]))
    elif not any(x in condition.split() for x in ['tr', 'az', 'lt']):
        raise ValueError(condition)

header = '// Generated from Unicode 17.0.0 UCD; see docs/2026-10-03/路径解析与Unicode比较测试.md.\n'
rows = [header, 'pub const Entry = struct { code: u32, lower: [2]u32 };', 'pub const mappings = [_]Entry{']
for cp, mapped in sorted(mappings.items()):
    assert 1 <= len(mapped) <= 2
    if mapped == [cp]:
        continue
    mapped = mapped + [0] * (2 - len(mapped))
    rows.append(f'    .{{ .code = 0x{cp:x}, .lower = .{{ 0x{mapped[0]:x}, 0x{mapped[1]:x} }} }},')
rows += ['};', 'pub const final_sigma = [_]struct { code: u32, lower: u32 }{']
rows += [f'    .{{ .code = 0x{cp:x}, .lower = 0x{lower:x} }},' for cp, lower in final]
rows += ['};', '']
(out / 'mapping.zig').write_text('\n'.join(rows))

properties = {'Cased': [], 'Case_Ignorable': []}
for line in (base / 'ucd/DerivedCoreProperties.txt').read_text().splitlines():
    fields = [x.strip() for x in line.split('#')[0].split(';')]
    if len(fields) != 2 or fields[1] not in properties:
        continue
    span = [int(x, 16) for x in fields[0].split('..')]
    properties[fields[1]].append((span[0], span[-1]))
rows = [header, 'pub const Range = struct { first: u32, last: u32 };']
for name, ranges in properties.items():
    merged = []
    for first, last in ranges:
        if merged and merged[-1][1] + 1 == first:
            merged[-1] = (merged[-1][0], last)
        else:
            merged.append((first, last))
    rows.append('pub const ' + name.lower() + ' = [_]Range{')
    rows.extend(f'    .{{ .first = 0x{a:x}, .last = 0x{b:x} }},' for a, b in merged)
    rows.append('};')
(out / 'properties.zig').write_text('\n'.join(rows) + '\n')
lock = {p.name: {'url': 'https://www.unicode.org/Public/17.0.0/ucd/' + p.name, 'sha256': hashlib.sha256(p.read_bytes()).hexdigest()} for p in sorted((base / 'ucd').iterdir())}
(base / 'ucd_lock.json').write_text(json.dumps(lock, indent=2) + '\n')
