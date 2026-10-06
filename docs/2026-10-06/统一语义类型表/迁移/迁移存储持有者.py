from pathlib import Path
import json
import re

root = Path(__file__).resolve().parents[4]
changed = []

for path in (root / "packages" / "compiler" / "src").rglob("*.zig"):
    before = path.read_text()
    after = before
    owners = [r"\btypes\.items", r"\bpool\.items"]

    if re.search(r"^items: ir\.TypeStorage", before, re.M):
        owners.append(r"\bself\.items")

    for owner in owners:
        after = re.sub("(" + owner + r")\.items\b", r"\1.view()", after)
        after = re.sub("(" + owner + r")\.appendSlice\b", r"\1.appendDelta", after)
        after = re.sub("(" + owner + r")\.toOwnedSlice\b", r"\1.finish", after)

    if after != before:
        path.write_text(after)
        changed.append(str(path.relative_to(root)))

Path(__file__).with_name("持有者迁移清单.json").write_text(json.dumps(changed, ensure_ascii=False, indent=4) + "\n")
print(f"Migrated {len(changed)} storage owner files")
