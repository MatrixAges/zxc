import json
from pathlib import Path
import subprocess
import sys
import tempfile


root = Path(__file__).resolve().parents[3]
sys.path.insert(0, str(root / "docs/2026-10-05/语法前端迁移/表达式语法"))

from expand_body import expand_body


paths = set((root / "packages/compiler/src/zx/frontend/parser").rglob("*.zx"))
paths.update((root / "packages/test/tests/collections/iterate/fixtures").glob("*.zx"))
paths.update((root / "docs/2026-10-06/状态迭代/示例").glob("*.zx"))
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


def state_blocks(value):
    result = []

    if isinstance(value, dict):
        if "state_block" in value:
            result.append(value["state_block"])

        for child in value.values():
            result.extend(state_blocks(child))
    elif isinstance(value, list):
        for child in value:
            result.extend(state_blocks(child))

    return result


def compare(label, source, record):
    state = record["actual"]

    if "expected_error" in record:
        diagnostic = state["type_diagnostic"] if state["type_diagnostic"]["message"] else state["value_diagnostic"] if state["expression_diagnostic"] else state["diagnostic"]
        actual = {"code": diagnostic["code"], "span": {"start": diagnostic["start"], "end": diagnostic["end"]}, "message": diagnostic["message"]}

        if actual != record["expected_error"]:
            failures.append({"source": label, "expected_error": record["expected_error"], "actual_error": actual})

        records.append({"source": label, "statements": 0, "blocks": 0, "cases": 0, "diagnostic": True})
        return

    failed = state["expression_diagnostic"] or bool(state["diagnostic"]["message"])
    actual = {key: state[key] for key in ["index", "last_end"]}
    actual["body"] = None if failed else expand_body(source, state)

    if failed or actual != record["expected"]:
        failures.append({"source": label, "expected": record["expected"], "actual": actual, "control": state["diagnostic"], "expression": state["value_diagnostic"], "type": state["type_diagnostic"]})

    records.append({"source": label, "statements": len(state["tree"]["statements"]), "blocks": len(state["tree"]["blocks"]), "cases": len(state["tree"]["cases"]), "diagnostic": False})


with tempfile.TemporaryDirectory(prefix="zxc_body_replay_") as directory:
    source_path = Path(directory) / "source.zx"

    for label, source in sources:
        source_path.write_bytes(source)
        record = json.loads(subprocess.check_output(["/tmp/zxc_body_reference", str(source_path)], text=True, timeout=30))

        if "skipped" in record:
            skipped.append({"source": label, **record})
            continue

        compare(label, source, record)
        body = record["expected"]["body"]
        entries = [(body["span"]["start"], "normal", [254, 256])]
        entries.extend((block["span"]["start"], "state", [0, 254, 256]) for block in state_blocks(body))

        for offset, mode, depths in entries:
            for depth in depths:
                replay = json.loads(subprocess.check_output(["/tmp/zxc_body_reference", str(source_path), str(offset), str(depth), mode], text=True, timeout=30))
                compare(f"{label}:{offset}:{mode}:depth={depth}", source, replay)

report = {"sources": len(sources), "entries": len(records), "diagnostics": sum(item["diagnostic"] for item in records), "statements": sum(item["statements"] for item in records), "blocks": sum(item["blocks"] for item in records), "cases": sum(item["cases"] for item in records), "failures": failures, "skipped": skipped, "records": records}
Path(__file__).with_name("语句块核对.json").write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n")
print(json.dumps({key: len(value) if key in {"failures", "skipped"} else value for key, value in report.items() if key != "records"}))

if failures:
    raise SystemExit(1)
