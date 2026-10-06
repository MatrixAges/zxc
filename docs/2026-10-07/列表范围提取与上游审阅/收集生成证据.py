import hashlib
import json
import re
from pathlib import Path

doc = Path(__file__).resolve().parent
outputs = {}
for label in ["Debug", "ReleaseSafe", "最终Debug", "最终ReleaseSafe"]:
    manifest = json.loads((doc / ("最终输入清单.json" if label.startswith("最终") else "输入清单.json")).read_text())
    cache = Path("/tmp/zxc-list-range-" + label.lower() + "-" + manifest["source"][:8])
    programs = {}
    for path in cache.rglob("program.zig"):
        source = path.read_text()
        if "remaining_length" not in source:
            continue
        if "extract: bool" in source:
            name = "lazy"
        elif "children: []const i64" in source:
            name = "products"
        elif "struct { i64, bool, []const u8," in source:
            name = "tuples"
        elif "items: []const []const u8" in source:
            name = "text"
        elif ".reverse(i64," in source:
            name = "composed"
        else:
            name = "integer"
        assert name not in programs, name
        programs[name] = path
    assert set(programs) == {"integer", "text", "products", "tuples", "composed", "lazy"}
    cases = {}
    for path in cache.rglob("cases.zig"):
        text = path.read_text()
        names = set(re.findall(r'^test "built_ins/list/range_extract/([^/]+)/', text, re.MULTILINE))
        if not names:
            continue
        assert len(names) == 1
        name = names.pop()
        assert name not in cases
        cases[name] = path
    assert programs.keys() == cases.keys()
    for name in programs:
        for kind, original in [("program", programs[name]), ("cases", cases[name])]:
            target = doc / "生成产物" / label / name / (kind + ".txt")
            target.parent.mkdir(parents=True, exist_ok=True)
            target.write_bytes(original.read_bytes())
            outputs[str(target.relative_to(doc))] = {"build_output_path": str(original), "sha256": hashlib.sha256(target.read_bytes()).hexdigest()}
(doc / "产物清单.json").write_text(json.dumps(outputs, ensure_ascii=False, indent=2) + "\n")
print(json.dumps({"saved_outputs": len(outputs)}))
