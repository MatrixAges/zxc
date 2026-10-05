import hashlib
import json
from pathlib import Path
import subprocess
import sys


scanner, reference, destination = sys.argv[1:4]
roots = [Path(value) for value in sys.argv[4:]] or [Path("packages")]


def name(source, span):
    return {"text": source[span["start"]:span["end"]].decode(), "span": span}


def expand(source, tree, index):
    node = tree["nodes"][index]
    kind = node["kind"]

    if kind == "Named":
        return {"named": name(source, node["name"])}

    if kind == "Optional" or kind == "List":
        return {kind.lower(): expand(source, tree, node["child"])}

    if kind == "Application":
        return {"application": {"name": name(source, node["name"]), "argument": expand(source, tree, node["child"])}}

    table = tree["fields"] if kind == "Object" else tree["items"]
    head = node["head"]
    values = []

    for _ in range(node["count"]):
        assert head != 0
        edge = table[head - 1]
        value = expand(source, tree, edge["value"])
        values.append({"name": name(source, edge["name"]), "value": value} if kind == "Object" else value)
        head = edge["previous"]

    assert head == 0
    values.reverse()
    return {kind.lower(): values}


records = []
node_kinds = set()
diagnostics = set()

paths = sorted({path for root in roots for path in root.rglob("*.zx")})

for path in paths:
    if any(part in ("node_modules", ".zig-cache", "zig-out") for part in path.parts):
        continue

    source = path.read_bytes()
    lexed = json.loads(subprocess.check_output([scanner, json.dumps(list(source))]))

    if lexed["diagnostic"]["message"]:
        records.append({"source": str(path), "sha256": hashlib.sha256(source).hexdigest(), "skipped_lexical": True, "count": 0, "failures": []})
        continue

    tokens = lexed["tokens"]
    starts = sorted({index + 1 for index, token in enumerate(tokens[:-1]) if token["symbol"] == "Colon"} | {
        index + 3 for index in range(len(tokens) - 3)
        if tokens[index]["word"] == "Type" and tokens[index + 1]["kind"] == "Identifier" and tokens[index + 2]["symbol"] == "Assign"
    })

    if not starts:
        continue

    output = subprocess.check_output([reference, str(path), json.dumps(starts), "0"], text=True)
    outcomes = [json.loads(line) for line in output.splitlines()]
    assert len(outcomes) == len(starts)
    failures = []

    for outcome in outcomes:
        expected, state = outcome["expected"], outcome["actual"]
        control = state["control"]
        actual = {"value": None, "index": control["index"], "diagnostic": control["diagnostic"]}
        assert control["phase"] == "Done"

        if not control["diagnostic"]["message"]:
            assert not state["frames"]
            actual["value"] = expand(source, state["tree"], control["result"])
        else:
            diagnostics.add(control["diagnostic"]["message"])

        node_kinds.update(node["kind"] for node in state["tree"]["nodes"])

        if actual != expected:
            failures.append({"start": outcome["start"], "expected": expected, "actual": actual})

    records.append({"source": str(path), "sha256": hashlib.sha256(source).hexdigest(), "count": len(outcomes), "failures": failures})

result = {
    "roots": [str(root) for root in roots],
    "source_count": len(records),
    "parse_count": sum(record["count"] for record in records),
    "failure_count": sum(len(record["failures"]) for record in records),
    "node_kinds": sorted(node_kinds),
    "diagnostics": sorted(diagnostics),
    "records": records
}
Path(destination).write_text(json.dumps(result, ensure_ascii=False, indent=2) + "\n")
print(json.dumps({key: value for key, value in result.items() if key != "records"}))

if result["failure_count"]:
    raise SystemExit(1)
