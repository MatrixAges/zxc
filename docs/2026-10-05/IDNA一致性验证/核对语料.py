from pathlib import Path
import hashlib
import json
import re
import struct

folder = Path(__file__).resolve().parent
root = folder.parents[2]
upstream = root / 'packages/test/upstream/unicode/18.0.0'
manifest = json.loads((upstream/'idna_manifest.json').read_text())
payload = (upstream/'IdnaTestV2.txt').read_bytes()
assert len(payload) == manifest['bytes']
assert hashlib.sha256(payload).hexdigest() == manifest['sha256']
pattern = re.compile(r'\\u([0-9A-Fa-f]{4})|\\x\{([0-9A-Fa-f]+)\}')

def decode(text):
    if text == '""':
        return b''
    result = pattern.sub(lambda match: chr(int(match.group(1) or match.group(2),16)),text)
    return result.encode('utf8',errors='surrogatepass')

hashing = hashlib.sha256()
accepted = rejected = malformed = 0
for line in payload.decode('utf8').splitlines():
    content = line.split('#')[0].strip()
    if not content:
        continue
    fields = [value.strip() for value in content.split(';')]
    assert len(fields) == 7
    source = fields[0]
    unicode = fields[1] or source
    ascii = fields[3] or unicode
    status = fields[4] or fields[2]
    codes = {value.strip() for value in status.strip('[]').split(',') if value.strip()}
    success = not (codes - set(manifest['ignored_status']))
    accepted += success
    rejected += not success
    hashing.update(bytes([int(success)]))
    for field in [source,unicode,ascii]:
        value = decode(field)
        hashing.update(struct.pack('<Q',len(value)))
        hashing.update(value)
    try:
        decode(source).decode('utf8')
    except UnicodeDecodeError:
        malformed += 1

assert accepted == manifest['expected']['accepted']
assert rejected == manifest['expected']['rejected']
assert accepted + rejected == manifest['rows']
result = {'rows':accepted+rejected,'accepted':accepted,'rejected':rejected,'malformed_inputs':malformed,'decoded_cases_sha256':hashing.hexdigest()}
(folder/'语料核对.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps(result))
