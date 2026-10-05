import importlib.util
import json
import sys
from pathlib import Path

sys.dont_write_bytecode = True

root = Path(__file__).resolve().parents[3]
helper_path = root / "docs/2026-10-06/RX公开推导迁移/迁移材料.py"
sys.path.insert(0, str(helper_path.parent))
spec = importlib.util.spec_from_file_location("migration", helper_path)
migration = importlib.util.module_from_spec(spec)
spec.loader.exec_module(migration)

def convert(source):
    replacements = []

    for node in migration.scanner.tags(source):
        if node["name"] != "Call":
            continue

        for attr in node["attrs"]:
            if attr["key"] != "out":
                continue

            raw = attr["raw"]
            assert raw.startswith(("\"ctx.", "'ctx.")) and raw[-1] == raw[0]
            alias = raw[5:-1]
            replacements.append((attr["key_start"], attr["key_end"], "name"))
            replacements.append((attr["value_start"], attr["value_end"], migration.scanner.quoted(alias)))

    for start, end, value in sorted(replacements, reverse=True):
        source = source[:start] + value + source[end:]

    return migration.convert_xml(source)


base = root / "packages/test/tests/rx/attributes/runtime/fixtures"
modified = []

for path in sorted(base.rglob("*.rx")):
    original = path.read_text()
    updated = convert(original)

    if updated == original:
        continue

    modified.append(str(path.relative_to(root)))
    path.write_text(updated)

print(json.dumps({"files": modified}, ensure_ascii=False, indent=2))
