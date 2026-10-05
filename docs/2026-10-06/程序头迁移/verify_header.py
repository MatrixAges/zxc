import json
from pathlib import Path
import subprocess
import sys
import tempfile


root = Path(__file__).resolve().parents[3]
sys.path.insert(0, str(root / "docs/2026-10-05/语法前端迁移/表达式语法"))

sys.path.insert(0, str(root / "docs/2026-10-06/语句块迁移"))

from expand_ast import expand_expression
from expand_body import expand_body


paths = set((root / "packages/compiler/src/zx/frontend/parser").rglob("*.zx"))
paths.update((root / "packages/test/tests/rx/runtime/store").rglob("*.zx"))
paths.update((root / "packages/test/tests/targets/napi/fixtures/state").glob("*.zx"))
paths.update((root / "packages/test/tests/targets/wasm/fixtures/state").glob("*.zx"))

for directory in ["docs/2026-10-05", "docs/2026-10-06"]:
    for path in (root / directory).rglob("*.zx"):
        text = path.read_text()

        if "requires" in text or "ensures" in text:
            paths.add(path)

sources = [(str(path.relative_to(root)), path.read_bytes()) for path in sorted(paths)]
export = '''
import public_cases from './packages/test/tests/verification/public_cases.ts'
import enumeration_cases from './packages/test/tests/verification/enumeration/cases.ts'

const records = []

for (const item of public_cases) {
  for (const [name, source] of Object.entries(item.files)) {
    if (!name.endsWith(".zx")) continue

    records.push({label: `public_cases:${item.name}:${name}`, source})
  }
}

for (const item of enumeration_cases) {
  records.push({label: `enumeration_cases:${item.name}`, source: item.source})
}

console.log(JSON.stringify(records))
'''

for item in json.loads(subprocess.check_output(["bun", "--eval", export], cwd=root, text=True)):
    sources.append((item["label"], item["source"].encode()))

records = []
failures = []
skipped = []

with tempfile.TemporaryDirectory(prefix="zxc_header_replay_") as directory:
    source_path = Path(directory) / "source.zx"

    for label, source in sources:
        source_path.write_bytes(source)
        record = json.loads(subprocess.check_output(["/tmp/zxc_header_reference", str(source_path)], text=True))

        if "skipped" in record:
            skipped.append({"source": label, **record})
            continue

        state = record["actual"]
        failed = state["expression_diagnostic"] or bool(state["diagnostic"]["message"])
        contracts = []

        if not failed:
            for contract in state["contracts"]:
                contracts.append({
                    "kind": "ensures" if contract["ensures"] else "requires",
                    "predicate": expand_expression(source, state["tree"], state["types"], contract["predicate"], lambda index: expand_body(source, {"tree": state["body"], "expressions": state["tree"], "types": state["types"]}, index)),
                    "span": contract["span"],
                })

        actual = {key: state[key] for key in ["consumes_input", "has_store", "index", "last_end"]}
        actual["contracts"] = contracts

        if failed or actual != record["expected"]:
            failures.append({"source": label, "expected": record["expected"], "actual": actual, "control": state["diagnostic"], "predicate": state["predicate_diagnostic"]})

        records.append({
            "source": label,
            "consumes_input": state["consumes_input"],
            "has_store": state["has_store"],
            "requires": sum(item["kind"] == "requires" for item in contracts),
            "ensures": sum(item["kind"] == "ensures" for item in contracts),
            "nodes": len(state["tree"]["nodes"]),
        })

report = {
    "sources": len(sources),
    "headers": len(records),
    "owned_headers": sum(item["consumes_input"] for item in records),
    "store_headers": sum(item["has_store"] for item in records),
    "requires": sum(item["requires"] for item in records),
    "ensures": sum(item["ensures"] for item in records),
    "failures": failures,
    "skipped": skipped,
    "records": records,
}
Path(__file__).with_name("函数头核对.json").write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n")
print(json.dumps({key: len(value) if key in {"failures", "skipped"} else value for key, value in report.items() if key != "records"}))

if failures:
    raise SystemExit(1)
