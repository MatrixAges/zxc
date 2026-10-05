import json
import subprocess
from pathlib import Path

root = Path(__file__).resolve().parents[3]
data = root / "docs/2026-10-05/RX新属性验证/属性案例.json"
rows = json.loads(data.read_text())
modified = []

for row in rows:
    name = row["name"]

    if name in ["call-service-string", "call-service-expression", "call-out-string", "call-out-expression"]:
        attribute = "service" if name.startswith("call-service-") else "out"
        row.update({
            "name": name + "-rejected",
            "attribute": attribute,
            "code": "unknown_attribute",
            "offset": row["source"].index(attribute + "="),
        })
    elif name == "task-out-string":
        row["source"] = row["source"].replace('<Return value="text"/>', '<Call fn="echo" in="text"/>')
        row.update({
            "name": "task-out-string-rejected",
            "attribute": "out",
            "offset": row["source"].index("out=") + 5,
        })
    elif name == "task-out-expression":
        row["source"] = row["source"].replace("out={ctx.value}", "out={$ctx.echo}")
        row["source"] = row["source"].replace('<Return value="text"/>', '<Call fn="echo" in="text"/>')
        row["name"] = "task-out-expression-schema"
        row.pop("attribute")
        row.pop("offset")
    else:
        continue

    modified.append(name)

if modified:
    data.write_text(json.dumps(rows, ensure_ascii=False, indent=2) + "\n")
    subprocess.run(["python3", str(data.parent / "生成用例.py")], check=True)

fixture = root / "packages/test/tests/rx/attributes/fixture.zig"
source = fixture.read_text()
source = source.replace(
    "    attribute: ?[]const u8 = null,\n    offset:",
    '    attribute: ?[]const u8 = null,\n    code: @FieldType(rx.Diagnostic, "code") = .invalid_attribute,\n    offset:',
)
source = source.replace(
    "try std.testing.expectEqual(.invalid_attribute, result.value.diagnostic.code);",
    "try std.testing.expectEqual(case.code, result.value.diagnostic.code);",
)
fixture.write_text(source)

print(json.dumps({"调整Schema行": modified}, ensure_ascii=False, indent=2))
