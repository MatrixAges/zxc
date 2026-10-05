from pathlib import Path
import hashlib
import json
import random
import re
import sys
import subprocess

folder = Path(__file__).resolve().parent
root = folder.parents[2]
upstream = root / 'packages/test/upstream/rfc/3492'
target = root / 'packages/test/tests/standard/resources/url/idna/punycode'
manifest = json.loads((upstream / 'manifest.json').read_text())
payload = (upstream / 'rfc3492.txt').read_bytes()
assert len(payload) == manifest['bytes']
assert hashlib.sha256(payload).hexdigest() == manifest['sha256']
text = payload.decode('ascii')
section = text.split('\n7.1 Sample strings\n', 1)[1].split('\n7.2 Decoding traces\n', 1)[0]
blocks = list(re.finditer(r'^   \(([A-S])\)', section, re.M))
assert ''.join(match.group(1) for match in blocks) == 'ABCDEFGHIJKLMNOPQRS'

def quote(value):
    return '"' + ''.join({'"':'\\"', '\\':'\\\\', '\n':'\\n', '\r':'\\r', '\t':'\\t'}.get(c, f'\\x{ord(c):02x}' if ord(c)<32 or ord(c)==127 else c) for c in value) + '"'

def points(values):
    return '&.{' + ', '.join(f'0x{point:x}' for point in values) + '}'

def make_test(name, body):
    return '\ntest ' + quote(name) + ' {\n    ' + body + '\n}\n'

cases = []
for index, match in enumerate(blocks):
    block = section[match.end():blocks[index+1].start() if index+1<len(blocks) else len(section)]
    before, after = block.split('Punycode: ', 1)
    values = [int(value,16) for value in re.findall(r'[uU]\+([0-9A-F]{4,6})', before)]
    lines = after.splitlines()
    original = lines.pop(0).strip()
    while original.endswith('\\'):
        original = original[:-1] + lines.pop(0).strip()
    cut = original.rfind('-') + 1
    canonical = original[:cut] + original[cut:].lower()
    scalar_text = ''.join(chr(value) for value in values)
    assert scalar_text.encode('punycode').decode('ascii') == canonical
    assert original.encode('ascii').decode('punycode') == scalar_text
    cases.append({'id':match.group(1), 'points':values, 'original':original, 'encoded':canonical})

source = 'pub const Case = struct { id: []const u8, points: []const u21, original: []const u8, encoded: []const u8 };\n\npub const cases = [_]Case{\n'
for entry in cases:
    source += f'    .{{ .id = {quote(entry["id"])}, .points = {points(entry["points"])}, .original = {quote(entry["original"])}, .encoded = {quote(entry["encoded"])} }},\n'
source += '};\n'
files = {'rfc_cases.zig':source}
rfc = 'const std = @import("std");\nconst fixture = @import("fixture.zig");\nconst cases = @import("rfc_cases.zig").cases;\n'
for index, entry in enumerate(cases):
    rfc += make_test(f'RFC3492 {entry["id"]} encode', f'try fixture.checkEncode(std.testing.allocator, cases[{index}].points, cases[{index}].encoded);')
    rfc += make_test(f'RFC3492 {entry["id"]} decode', f'try fixture.checkDecode(std.testing.allocator, cases[{index}].original, cases[{index}].points);')
files['rfc_test.zig'] = rfc

boundaries = [
 ('empty', []), ('basic ASCII case', list(map(ord,'ABCxyz'))), ('basic punctuation', list(map(ord,'a-b_c. /'))),
 ('C0 DEL', [0,31,127]), ('minimum nonbasic', [128]), ('next nonbasic', [129]),
 ('before surrogate range', [0xd7ff]), ('after surrogate range', [0xe000]), ('noncharacter', [0xffff]),
 ('supplementary start', [0x10000]), ('Unicode maximum', [0x10ffff]),
 ('wide mixed repeated', [0x10ffff,128,0x10ffff,128,97]),
 ('composed', [0xe9]), ('decomposed', [0x65,0x301]),
 ('bucher', list(map(ord,'bücher'))), ('manana', list(map(ord,'mañana'))),
 ('duplicate emoji', [0x1f600]*12), ('last delimiter', list(map(ord,'a--é--')))
]
boundary = 'const std = @import("std");\nconst fixture = @import("fixture.zig");\n'
for name, values in boundaries:
    encoded = ''.join(chr(point) for point in values).encode('punycode').decode('ascii')
    boundary += make_test('Punycode boundary encode '+name, f'try fixture.checkEncode(std.testing.allocator, {points(values)}, {quote(encoded)});')
    boundary += make_test('Punycode boundary decode '+name, f'try fixture.checkDecode(std.testing.allocator, {quote(encoded)}, {points(values)});')
files['boundary_test.zig'] = boundary

randomizer = random.Random(3492)
mixed = []
for index in range(256):
    values = []
    for _ in range(index % 33):
        if randomizer.randrange(3) == 0:
            point = randomizer.randrange(128)
        else:
            point = randomizer.randrange(0x110000)
            while 0xd800 <= point <= 0xdfff:
                point = randomizer.randrange(0x110000)
        values.append(point)
    encoded = ''.join(chr(point) for point in values).encode('punycode').decode('ascii')
    mixed.append((values,encoded))
source = 'pub const cases = [_]struct { points: []const u21, encoded: []const u8 }{\n'
for values,encoded in mixed:
    source += f'    .{{ .points = {points(values)}, .encoded = {quote(encoded)} }},\n'
source += '};\n'
files['mixed_cases.zig'] = source

for name, source in files.items():
    source = subprocess.run(['zig','fmt','--stdin'],input=source,text=True,capture_output=True,check=True).stdout
    if '--check' in sys.argv:
        assert (target/name).read_text() == source, name
    else:
        (target/name).write_text(source)

record = {'rfc_sha256':manifest['sha256'], 'rfc_samples':len(cases), 'scalar_boundaries':len(boundaries), 'mixed_sequences':len(mixed), 'seed':3492, 'python':sys.version, 'case_annotation_adjustments':[entry['id'] for entry in cases if entry['original'] != entry['encoded']]}
if '--check' not in sys.argv:
    (folder/'独立核对.json').write_text(json.dumps(record,ensure_ascii=False,indent=2)+'\n')
print(json.dumps(record,ensure_ascii=False))
