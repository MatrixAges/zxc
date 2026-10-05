import hashlib
import json
import subprocess
from pathlib import Path

root = Path(__file__).resolve().parents[1]
source = root / "Unicode数据"
target = root.parents[2] / "packages/compiler/standard/src/url/host/idna/data"
metadata = json.loads((source / "来源.json").read_text())

for item in metadata["files"]:
    if hashlib.sha256((source / item["file"]).read_bytes()).hexdigest() != item["sha256"]:
        raise ValueError(f"source digest mismatch: {item['file']}")

header = ["// " + line for line in (source / "license.txt").read_text().splitlines()]
header.append(f"// Unicode {metadata['version']}; generated from Unicode data.")
mapping = header + ["pub const Status = enum { valid, ignored, mapped, deviation, disallowed };",
                    "pub const Entry = struct { first: u21, last: u21, status: Status, values: []const u21 };",
                    "", "pub const entries = [_]Entry{"]
expected = 0
mapping_count = 0

for line in (source / "IdnaMappingTable.txt").read_text().splitlines():
    fields = [part.strip() for part in line.split("#", 1)[0].split(";")]

    if len(fields) < 2:
        continue

    bounds = fields[0].split("..")
    first, last = int(bounds[0], 16), int(bounds[-1], 16)

    if first != expected or last < first:
        raise ValueError("non-contiguous IDNA table")

    expected = last + 1
    status = fields[1]

    if status not in {"valid", "ignored", "mapped", "deviation", "disallowed"}:
        raise ValueError(status)

    values = ", ".join(f"0x{int(value, 16):x}" for value in fields[2].split()) if len(fields) > 2 else ""
    mapping.append(f"    .{{ .first = 0x{first:x}, .last = 0x{last:x}, .status = .{status}, .values = &.{{ {values} }} }},")
    mapping_count += 1

if expected != 0x110000:
    raise ValueError("incomplete IDNA table")

mapping.append("};")
(target / "mapping.zig").write_text("\n".join(mapping) + "\n")
properties = [("L", False, "U")] * 0x110000
range_start = None

for line in (source / "UnicodeData.txt").read_text().splitlines():
    fields = line.split(";")
    point = int(fields[0], 16)
    value = (fields[4], fields[2].startswith("M"), "U")

    if fields[1].endswith(", First>"):
        range_start = point
    elif fields[1].endswith(", Last>"):
        properties[range_start:point + 1] = [value] * (point + 1 - range_start)
        range_start = None
    else:
        properties[point] = value

for line in (source / "DerivedJoiningType.txt").read_text().splitlines():
    fields = [part.strip() for part in line.split("#", 1)[0].split(";")]

    if len(fields) < 2:
        continue

    bounds = fields[0].split("..")

    for point in range(int(bounds[0], 16), int(bounds[-1], 16) + 1):
        bidi, mark, _ = properties[point]
        properties[point] = (bidi, mark, fields[1])

classes = sorted({value[0] for value in properties})
joins = sorted({value[2] for value in properties})
lines = header + ["pub const Bidi = enum { " + ", ".join(classes) + " };",
                  "pub const Joining = enum { " + ", ".join(joins) + " };",
                  "pub const Properties = struct { bidi: Bidi = .L, mark: bool = false, joining: Joining = .U };",
                  "pub const Entry = struct { first: u21, last: u21, value: Properties };",
                  "", "pub const entries = [_]Entry{"]
start = 0
property_count = 0

for end in range(1, len(properties) + 1):
    if end != len(properties) and properties[end] == properties[start]:
        continue

    bidi, mark, joining = properties[start]

    if properties[start] != ("L", False, "U"):
        lines.append(f"    .{{ .first = 0x{start:x}, .last = 0x{end - 1:x}, .value = .{{ .bidi = .{bidi}, .mark = {str(mark).lower()}, .joining = .{joining} }} }},")
        property_count += 1

    start = end

lines.append("};")
(target / "properties.zig").write_text("\n".join(lines) + "\n")
subprocess.run(["zig", "fmt", str(target / "mapping.zig"), str(target / "properties.zig")], check=True)
print(json.dumps({"version": metadata["version"], "mapping_ranges": mapping_count, "property_ranges": property_count}))
