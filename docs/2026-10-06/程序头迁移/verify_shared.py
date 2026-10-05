import json
from pathlib import Path
import subprocess
import sys


root = Path(__file__).resolve().parents[3]
sys.path.insert(0, str(root / "docs/2026-10-05/语法前端迁移/表达式语法"))

sys.path.insert(0, str(root / "docs/2026-10-06/语句块迁移"))

from expand_ast import expand_expression
from expand_body import expand_body


grammar = root / "packages/compiler/src/zx/frontend/parser/expressions/grammar"
sources = [grammar / name for name in ["arguments_finish.zx", "primary.zx", "template.zx"]]
sources.append(root / "packages/test/tests/collections/iterate/fixtures/snapshot.zx")
records = []

for path in sources:
    source = path.read_bytes()
    shared = json.loads(subprocess.check_output(["/tmp/zxc_shared_expression", json.dumps(list(source))]))
    results = shared["results"]
    state = shared["state"]
    starts = list(range(len(results)))
    output = subprocess.check_output(["/tmp/zxc_expression_loop_reference", str(path), json.dumps(starts), "0", "0"], text=True)
    independent = [json.loads(line) for line in output.splitlines()]
    failures = []
    valid = 0

    assert len(independent) == len(results)

    for record, result in zip(independent, results):
        expected = record["expected"]
        actual = record["actual"]
        value = None if actual["diagnostic"]["message"] else expand_expression(source, actual["tree"], actual["types"], actual["result"], lambda index: expand_body(source, {"tree": actual["body"], "expressions": actual["tree"], "types": actual["types"]}, index))
        single = {"value": value, "index": actual["index"], "diagnostic": actual["diagnostic"]}

        if single != expected:
            failures.append({"start": record["start"], "kind": "independent", "expected": expected, "actual": single})

        expected_valid = not expected["diagnostic"]["message"]
        value = expand_expression(source, state["tree"], state["types"]["tree"], result["root"], lambda index: expand_body(source, {"tree": shared["body"], "expressions": state["tree"], "types": state["types"]["tree"]}, index)) if result["valid"] else None

        if result["valid"] != expected_valid or result["index"] != expected["index"] or value != expected["value"]:
            failures.append({"start": record["start"], "kind": "shared", "expected": expected, "actual": {**result, "value": value}})

        valid += expected_valid

    records.append({"source": str(path.relative_to(root)), "requests": len(results), "valid": valid, "nodes": len(state["tree"]["nodes"]), "failures": failures})

report = {
    "sources": len(records),
    "requests": sum(record["requests"] for record in records),
    "valid": sum(record["valid"] for record in records),
    "failures": sum(len(record["failures"]) for record in records),
    "records": records,
}
Path(__file__).with_name("共享表达式核对.json").write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n")
print(json.dumps({key: value for key, value in report.items() if key != "records"}))

if report["failures"]:
    raise SystemExit(1)
