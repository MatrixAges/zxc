from pathlib import Path
import hashlib
import json
import re
import subprocess
import sys

root = Path(sys.argv[1]).resolve()
doc = Path(__file__).resolve().parent
commit = "49edda5e15776dccf22b756ab1487de9bdaed2e9"
sha = lambda data: hashlib.sha256(data).hexdigest()
previous = lambda path: subprocess.check_output(["git", "-C", str(root), "show", commit + ":" + path])
package = root / "packages/test"

for item in json.loads((doc / "原用例身份.json").read_text())["protected"]:
    assert sha((root / item["path"]).read_bytes()) == item["sha256"], item["path"]

def closure(entry):
    found = set()
    active = set()

    def visit(path):
        assert path not in active, path
        if path in found:
            return
        active.add(path)
        source = path.read_bytes().decode()
        for imported in re.findall(r'^import \w+ from "([^"\n]+)"', source, re.M):
            assert imported.startswith("./"), imported
            visit((path.parent / (imported + ".zx")).resolve())
        active.remove(path)
        found.add(path)

    visit(entry)
    return found

entries = ["language/lexical/numeric/decimal_original/cases", "language/expressions/comparison/whitespace"]
before = json.loads(previous("packages/test/suites.json"))
after = json.loads((package / "suites.json").read_text())
stripped = json.loads(json.dumps(after))
all_sources = set()
registered = {}

for entry in entries:
    path = package / "tests" / (entry + ".zx")
    files = closure(path)
    all_sources |= files
    sources = sorted(str(file.relative_to(package / "tests")) for file in files if file != path)
    suite = next(item for item in after["runtime"] if item["path"] == entry)
    assert suite["sources"] == sources
    del next(item for item in stripped["runtime"] if item["path"] == entry)["sources"]
    registered[entry] = sources

assert stripped == before

line_counts = []
for path in sorted(all_sources):
    source = path.read_bytes().decode()
    lines = len(re.split(r"\r\n|\r|\n", source)) - int(source.endswith(("\r", "\n")))
    assert lines <= 120, (path, lines)
    line_counts.append({"path": str(path.relative_to(root)), "lines": lines, "sha256": sha(path.read_bytes())})

decimal = package / "tests/language/lexical/numeric/decimal_original/cases"
old_cases = {}
new_cases = {}
for path in sorted(decimal.rglob("*.zx")):
    relative = str(path.relative_to(root))
    for index, token in re.findall(r"case (\d+):\n\s+return ([^\r\n]+)", path.read_bytes().decode()):
        assert int(index) not in new_cases
        new_cases[int(index)] = token
    if path.parent == decimal:
        for index, token in re.findall(r"case (\d+):\n\s+return ([^\r\n]+)", previous(relative).decode()):
            assert int(index) not in old_cases
            old_cases[int(index)] = token
assert old_cases == new_cases and len(new_cases) == 403
assert (decimal.with_suffix(".zx")).read_bytes() == previous(str(decimal.with_suffix(".zx").relative_to(root)))

relational = package / "tests/language/expressions/comparison/whitespace"
pattern = r"    case (\d+): return ([\s\S]*?)(?=\n\n    case|\n\n    default:)"
old_branches = dict(re.findall(pattern, previous(str(relational.with_suffix(".zx").relative_to(root))).decode()))
new_branches = {}
for path in closure(relational.with_suffix(".zx")):
    for shape, expression in re.findall(pattern, path.read_bytes().decode()):
        assert shape not in new_branches
        new_branches[shape] = expression
assert old_branches == new_branches and len(new_branches) == 72

result = {"source_commit": commit, "decimal_tokens_preserved": len(new_cases), "relational_expression_bytes_preserved": len(new_branches), "registered_import_closures": registered, "zx_line_counts": line_counts, "maximum_lines": max(item["lines"] for item in line_counts), "other_suite_fields_changed": False, "counted_line_terminators": ["LF", "CRLF", "CR"], "VT_FF_preserved_as_payload": True}
if "--save" in sys.argv:
    (doc / "生成身份核验.json").write_text(json.dumps(result, ensure_ascii=False, indent=2) + "\n")
else:
    assert json.loads((doc / "生成身份核验.json").read_text()) == result
print("PASS: 403 exact decimal tokens, 72 exact relational expressions, unchanged catalog/reviews, exact imported dependencies and all generated ZX <=120 lines")
