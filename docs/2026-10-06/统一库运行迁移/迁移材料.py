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

base = root / "packages/test/tests/library"
paths = [
    base / "runtime/fixtures/main.rx",
    base / "runtime/fixtures/select.rx",
    base / "runtime/store/advance.rx",
    base / "runtime/store/read.rx",
    base / "store_fixture.zig",
]
modified = []


def convert(source, suffix):
    if suffix == ".rx":
        source = source.replace('out="ctx.result"', 'name="result"')

        return migration.convert_xml(source)

    source = source.replace(" out='ctx.result'", " name='result'")

    return migration.convert_zig(source)


for path in paths:
    original = path.read_text()
    updated = convert(original, path.suffix)

    if updated == original:
        continue

    modified.append(str(path.relative_to(root)))
    path.write_text(updated)

print(json.dumps({"files": modified}, ensure_ascii=False, indent=2))
