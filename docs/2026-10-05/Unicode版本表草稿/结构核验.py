from pathlib import Path
import hashlib
import json
import re
import yaml

base = Path('/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd')
folder = Path(__file__).resolve().parent
rows = []
pairs = {}

for path in sorted((base / 'test/language/identifiers').glob('*unicode-*')):
    if not re.search(r'unicode-\d', path.name):
        continue

    raw = path.read_bytes()
    text = raw.decode()
    header, body = text.split('/*---', 1)[1].split('---*/', 1)
    metadata = yaml.safe_load(header)
    body = body.strip()
    private = 'class-fields-private' in metadata.get('features', [])
    assert not any(key in metadata for key in ['negative', 'flags', 'includes']), path

    content = body
    if private:
        assert content.startswith('class _ {\n') and content.endswith('\n};'), path
        content = content[len('class _ {\n'):-len('\n};')]

    pattern = r'  #([^;\n]+);' if private else r'var ([^;\n]+);'
    names = []

    for line in content.split('\n'):
        match = re.fullmatch(pattern, line)
        assert match, (path, line[:80])
        names.append(match[1])

    decoded = [re.sub(r'\\u(?:\{([0-9A-Fa-f]+)\}|([0-9A-Fa-f]{4}))', lambda m: chr(int(m[1] or m[2], 16)), name) for name in names]
    assert all('\\' not in name for name in decoded)
    assert all(any(ord(char) > 127 for char in name) for name in decoded)
    part = 'ID_Continue' in metadata['description']
    assert (len(names) == 1 and decoded[0].startswith('_')) if part else all(len(name) == 1 for name in decoded)

    key = path.name.replace('-escaped', '')
    if key in pairs:
        assert pairs[key] == decoded, path
    else:
        pairs[key] = decoded

    rows.append(dict(path=str(path.relative_to(base)), sha256=hashlib.sha256(raw).hexdigest(), metadata=metadata, body=body, private=private, part=part, names_count=len(names), codepoints=sum(len(name) for name in decoded), probe=names[0], flags=[], negative=None))

assert len(rows) == 120 and len(pairs) == 60
(folder / '原文证据.jsonl').write_text(''.join(json.dumps(row, ensure_ascii=False) + '\n' for row in rows))
print(json.dumps(dict(files=len(rows), pairs=len(pairs), declarations=sum(row['names_count'] for row in rows), private=sum(row['private'] for row in rows))))
