import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile

sys.path.insert(0, str(Path(__file__).resolve().parents[4] / "docs/2026-10-06/语句块迁移"))

from expand_ast import expand_expression
from expand_body import expand_body


scanner, reference, destination = sys.argv[1:4]
depth = os.environ.get("ZXC_REFERENCE_DEPTH", "0")
minimum = os.environ.get("ZXC_REFERENCE_MINIMUM", "0")
roots = [Path(value) for value in sys.argv[4:]]
sources = {}

for root in roots:
    paths = [root] if root.is_file() else sorted([*root.rglob("*.zx"), *root.rglob("*.jsonl")])

    for path in paths:
        if "node_modules" in path.parts:
            continue

        if path.suffix == ".jsonl":
            for line in path.read_text().splitlines():
                case = json.loads(line)

                if "source_hex" in case:
                    sources[str(path) + ":" + case["id"]] = bytes.fromhex(case["source_hex"])
                elif "source" in case:
                    sources[str(path) + ":" + case["id"]] = case["source"].encode()
        else:
            sources[str(path)] = path.read_bytes()

records = []
node_kinds = set()
diagnostics = set()

with tempfile.TemporaryDirectory(prefix="zxc-expression-ast-") as directory:
    source_path = Path(directory) / "source.zx"

    for label, source in sources.items():
        source_path.write_bytes(source)
        lexed = json.loads(subprocess.check_output([scanner, json.dumps(list(source))]))
        starts = list(range(len(lexed["tokens"]))) if not lexed["diagnostic"]["message"] else [0]
        output = subprocess.check_output([reference, str(source_path), json.dumps(starts), depth, minimum], text=True)
        outcomes = [json.loads(line) for line in output.split("\n") if line]
        assert len(outcomes) == len(starts)
        failures = []

        for outcome in outcomes:
            expected, state = outcome["expected"], outcome["actual"]
            actual = {"value": None, "index": state["index"], "diagnostic": state["diagnostic"]}

            if not state["diagnostic"]["message"]:
                body_state = {"tree": state["body"], "expressions": state["tree"], "types": state["types"]}
                actual["value"] = expand_expression(source, state["tree"], state["types"], state["result"], lambda index: expand_body(source, body_state, index))
            else:
                diagnostics.add(state["diagnostic"]["message"])

            node_kinds.update(node["kind"] for node in state["tree"]["nodes"])

            if actual != expected:
                failures.append({"start": outcome["start"], "expected": expected, "actual": actual})

        records.append({"source": label, "sha256": hashlib.sha256(source).hexdigest(), "count": len(outcomes), "failures": failures})

        if failures:
            break

result = {"depth": int(depth), "minimum": int(minimum), "sources": len(records), "parses": sum(item["count"] for item in records), "failures": sum(len(item["failures"]) for item in records), "node_kinds": sorted(node_kinds), "diagnostics": sorted(diagnostics), "records": records}
Path(destination).write_text(json.dumps(result, ensure_ascii=False, indent=2) + "\n")
print(json.dumps({key: value for key, value in result.items() if key != "records"}))

if result["failures"]:
    raise SystemExit(1)
