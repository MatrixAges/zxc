from pathlib import Path
import json
import re

root = Path(__file__).resolve().parents[4]
changed = []

for package in ["core", "compiler", "genz", "napi"]:
    for path in (root / "packages" / package / "src").rglob("*.zig"):
        before = path.read_text()
        after = re.sub(r"\[\]const ir\.Type\b", "ir.TypeTable", before)
        after = after.replace("std.ArrayList(ir.Type)", "ir.TypeStorage")
        after = re.sub(r"(: ir\.TypeStorage) = \.empty", r"\1 = .{}", after)

        if after != before:
            path.write_text(after)
            changed.append(str(path.relative_to(root)))

Path(__file__).with_name("存储迁移清单.json").write_text(json.dumps(changed, ensure_ascii=False, indent=4) + "\n")
print(f"Migrated {len(changed)} production files")
