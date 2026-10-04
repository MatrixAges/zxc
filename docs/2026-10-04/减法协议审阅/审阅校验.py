from pathlib import Path
import hashlib
import json
import re
import sys

archive = Path(sys.argv[1])
index = {row["path"]: row["sha256"] for row in map(json.loads, Path("packages/test/upstream/index/language.jsonl").read_text().splitlines())}
files = ["S11.6.2_A2.2_T1.js", "S11.6.2_A2.3_T1.js", "bigint-and-number.js", "bigint-arithmetic.js", "bigint-errors.js", "bigint-toprimitive.js", "bigint-wrapped-values.js", "order-of-evaluation.js"]

for name in files:
    path = "test/language/expressions/subtraction/" + name
    data = (archive / path).read_bytes()

    assert hashlib.sha256(data).hexdigest() == index[path], path

    source = data.decode()
    print(name, "CHECK", len(re.findall(r"//CHECK#\d+", source)), "sameValue", source.count("assert.sameValue("), "throws", source.count("assert.throws("))

source = (archive / "test/language/expressions/subtraction/bigint-arithmetic.js").read_text()
pattern = r"assert\.sameValue\(\s*(-?0x[0-9A-F]+)n - (-?0x[0-9A-F]+)n,\s*(-?0x[0-9A-F]+)n,\s*'[^']*'\s*\);"
rows = re.findall(pattern, source)
assert len(rows) == source.count("assert.sameValue(") == 289
remainder = re.sub(pattern, "", source)
remainder = re.sub(r"/\*.*?\*/|//[^\n]*", "", remainder, flags=re.S)
assert not remainder.strip()

for left, right, expected in rows:
    assert int(left, 16) - int(right, 16) == int(expected, 16)

print("289 exact arithmetic assertions verified; not a zxc execution result")
