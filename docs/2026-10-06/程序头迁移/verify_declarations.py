import json
from pathlib import Path
import subprocess
import sys
import tempfile


root = Path(__file__).resolve().parents[3]
sys.path.insert(0, str(root / "docs/2026-10-05/语法前端迁移/表达式语法"))

from expand_ast import expand_type, name


sources = [(str(path.relative_to(root)), path.read_bytes()) for path in sorted(
    (root / "packages/compiler/src/zx/frontend/parser").rglob("*.zx")
)]
keyword_model = root / "packages/compiler/src/zx/frontend/lexer/keyword_model.zx"
sources.append((str(keyword_model.relative_to(root)), keyword_model.read_bytes()))

for relative in [
    "packages/compiler/standard/interfaces/http.d.zx",
    "packages/test/tests/rx/inference/ownership/fixtures/main.zx",
    "packages/test/tests/rx/inference/optional/fixtures/text.zx",
]:
    path = root / relative
    sources.append((relative, path.read_bytes()))

for category in ["relational_names", "division_assignment"]:
    path = root / "packages/test/tests/language/types" / category / "cases.jsonl"

    for line in path.read_text().splitlines():
        row = json.loads(line)
        sources.append((f"{path.relative_to(root)}:{row['id']}", row["source"].encode()))

records = []
failures = []

with tempfile.TemporaryDirectory(prefix="zxc_declaration_replay_") as directory:
    source_path = Path(directory) / "source.zx"

    for depth in [0, 254, 256]:
        count = 0
        declarations = 0
        enumerations = 0
        diagnostics = 0
        type_kinds = set()

        for label, source in sources:
            source_path.write_bytes(source)
            output = subprocess.check_output(["/tmp/zxc_declaration_reference", str(source_path), str(depth)], text=True)

            for line in output.splitlines():
                record = json.loads(line)
                state = record["actual"]
                actual = []
                count += 1
                diagnostics += bool(state["diagnostic"]["message"])

                for declaration in state["declarations"]:
                    if declaration["enumeration"]:
                        first = declaration["first"]
                        members = state["members"][first:first + declaration["count"]]
                        value = {"enumeration": [name(source, member) for member in members]}
                        enumerations += 1
                    else:
                        value = expand_type(source, state["types"], declaration["value"])

                    declarations += 1
                    actual.append({"name": name(source, declaration["name"]), "span": declaration["span"], "value": value})

                type_kinds.update(node["kind"] for node in state["types"]["nodes"])
                result = {"declarations": actual, "index": state["index"], "diagnostic": state["diagnostic"]}

                if result != record["expected"]:
                    failures.append({"source": label, "depth": depth, "start": record["start"], "expected": record["expected"], "actual": result})

        records.append({"depth": depth, "sources": len(sources), "parses": count, "declarations": declarations, "enumerations": enumerations, "diagnostics": diagnostics, "type_kinds": sorted(type_kinds)})

report = {"parses": sum(record["parses"] for record in records), "failures": failures, "records": records}
Path(__file__).with_name("声明序列核对.json").write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n")
print(json.dumps({**report, "failures": len(failures)}))

if failures:
    raise SystemExit(1)
