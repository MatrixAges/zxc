import functools
import hashlib
import json
import subprocess
from pathlib import Path

root = Path(__file__).resolve().parents[1]
source = root / "Unicode数据"
repo = root.parents[2]
target = repo / "packages/compiler/standard/src/url/host/idna/data"
target.mkdir(parents=True, exist_ok=True)

metadata = json.loads((source / "来源.json").read_text())

for item in metadata["files"]:
    digest = hashlib.sha256((source / item["file"]).read_bytes()).hexdigest()

    if digest != item["sha256"]:
        raise ValueError(f"source digest mismatch: {item['file']}")

classes = {}
decompositions = {}

for line in (source / "UnicodeData.txt").read_text().splitlines():
    fields = line.split(";")
    point = int(fields[0], 16)
    combining = int(fields[3])

    if combining:
        classes[point] = combining

    decomposition = fields[5]

    if decomposition and not decomposition.startswith("<"):
        decompositions[point] = tuple(int(value, 16) for value in decomposition.split())

excluded = set()

for line in (source / "DerivedNormalizationProps.txt").read_text().splitlines():
    fields = line.split("#", 1)[0].split(";")

    if len(fields) < 2 or fields[1].strip() != "Full_Composition_Exclusion":
        continue

    bounds = fields[0].strip().split("..")
    first, last = int(bounds[0], 16), int(bounds[-1], 16)
    excluded.update(range(first, last + 1))

@functools.cache
def flatten(point):
    return tuple(child for value in decompositions.get(point, (point,))
                 for child in (flatten(value) if value != point else (value,)))

ranges = []

for point, value in sorted(classes.items()):
    if ranges and ranges[-1][1] + 1 == point and ranges[-1][2] == value:
        ranges[-1] = (ranges[-1][0], point, value)
    else:
        ranges.append((point, point, value))

pairs = sorted((value[0], value[1], point) for point, value in decompositions.items()
               if len(value) == 2 and point not in excluded)
lines = ["// " + line for line in (source / "license.txt").read_text().splitlines()]
lines += [f"// Unicode {metadata['version']}; generated from Unicode data.",
         "pub const Class = struct { first: u21, last: u21, value: u8 };",
         "pub const Decomposition = struct { point: u21, values: []const u21 };",
         "pub const Composition = struct { first: u21, second: u21, point: u21 };", "",
         "pub const classes = [_]Class{"]

for first, last, value in ranges:
    lines.append(f"    .{{ .first = 0x{first:x}, .last = 0x{last:x}, .value = {value} }},")

lines.extend(["};", "", "pub const decompositions = [_]Decomposition{"])

for point in sorted(decompositions):
    values = ", ".join(f"0x{value:x}" for value in flatten(point))
    lines.append(f"    .{{ .point = 0x{point:x}, .values = &.{{ {values} }} }},")

lines.extend(["};", "", "pub const compositions = [_]Composition{"])

for first, second, point in pairs:
    lines.append(f"    .{{ .first = 0x{first:x}, .second = 0x{second:x}, .point = 0x{point:x} }},")

lines.append("};")
(target / "normalization.zig").write_text("\n".join(lines) + "\n")
(target / "license.txt").write_bytes((source / "license.txt").read_bytes())
subprocess.run(["zig", "fmt", str(target / "normalization.zig")], check=True)
print(json.dumps({"version": metadata["version"], "class_ranges": len(ranges),
                  "decompositions": len(decompositions), "compositions": len(pairs)}))
