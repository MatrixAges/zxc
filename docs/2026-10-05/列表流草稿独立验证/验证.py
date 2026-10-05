import hashlib
import json
from pathlib import Path
import subprocess


folder = Path(__file__).resolve().parent
repo = folder.parents[2]
draft = folder.parent / "跨函数列表追加"
observer = draft / "zig-out/bin/list-flow-observe"
cases = [
    ("push", True, "u64[]", "return {items: in.items.push(in.value)[0]}", [None]),
    ("concat", True, "u64[]", "return {items: in.items.concat([in.value])[0]}", [None]),
    ("carry", True, "u64[]", "return {items: in.items}", [None]),
    ("conditional", True, "u64[]", "return {items: in.value == 0 ? in.items : in.items.push(in.value)[0]}", [None]),
    ("reset", True, "u64[]", "return {items: in.value == 0 ? [] : in.items.push(in.value)[0]}", []),
    ("reverse", True, "u64[]", "return {items: in.items.reverse()[0]}", []),
    ("borrowed", False, "u64[]", "return {items: in.items}", ["borrowed_input"]),
    ("read", True, "u64[]", "return {seen: in.items[0], items: in.items.push(in.value)[0]}", ["element_read"]),
]
records = []

for name, owned, kind, body, expected in cases:
    location = folder / "输入" / name
    location.mkdir(parents=True, exist_ok=True)
    input_type = "{ items: " + kind + ", value: u64 }"
    output_type = "{ items: u64[], seen: u64 }" if name == "read" else "{ items: u64[] }"
    signature = "owned Input" if owned else "Input"
    declarations = f"export type Input = {input_type}\n\nexport type Output = {output_type}\n\n"
    helper = declarations + f"export default function (in: {signature}): Output {{\n  {body}\n}}\n"
    entry = 'import step from "./step.zx"\n\n' + declarations + f"export default function (in: {signature}): Output {{\n  return step(in)\n}}\n"
    (location / "main.zx").write_text(entry)
    (location / "step.zx").write_text(helper)
    command = [str(observer), str(location / "main.zx"), str(location / "main.zx"), str(location / "step.zx")]
    result = subprocess.run(command, capture_output=True, text=True, timeout=30)
    summary = [json.loads(line) for line in result.stdout.splitlines()] if result.returncode == 0 else []
    actual = [lane["rejection"] for row in summary for lane in row["provenance"]]
    passed = result.returncode == 0 and len(summary) == 1 and actual == expected
    records.append({"name": name, "expected_rejections": expected, "actual": summary, "exit_code": result.returncode, "stderr": result.stderr, "passed": passed})

location = folder / "输入" / "separate_fields"
location.mkdir(parents=True, exist_ok=True)
declarations = "export type Input = { a: u64[], b: u64[], value: u64 }\n\nexport type Output = { a: u64[], b: u64[] }\n\n"
(location / "main.zx").write_text('import step from "./step.zx"\n\n' + declarations + "export default function (in: owned Input): Output {\n  return step(in)\n}\n")
(location / "step.zx").write_text(declarations + "export default function (in: owned Input): Output {\n  return {a: in.a.push(in.value)[0], b: in.b.concat([in.value])[0]}\n}\n")
result = subprocess.run([str(observer), str(location / "main.zx"), str(location / "main.zx"), str(location / "step.zx")], capture_output=True, text=True, timeout=30)
summary = [json.loads(line) for line in result.stdout.splitlines()] if result.returncode == 0 else []
lanes = [lane for row in summary for lane in row["provenance"]]
paths = {(tuple(lane["input"]), tuple(lane["output"])) for lane in lanes}
passed = result.returncode == 0 and len(summary) == 1 and len(lanes) == 2 and paths == {((0,), (0,)), ((1,), (1,))} and all(lane["rejection"] is None for lane in lanes)
records.append({"name": "separate_fields", "expected_paths": [[[0], [0]], [[1], [1]]], "actual": summary, "exit_code": result.returncode, "stderr": result.stderr, "passed": passed})

for swapped in [False, True]:
    name = "forward_swapped" if swapped else "forward_identity"
    target = folder / "输入" / name
    target.mkdir(parents=True, exist_ok=True)
    (target / "step.zx").write_text((location / "step.zx").read_text())
    (target / "main.zx").write_text((location / "main.zx").read_text().replace('./step.zx', './forward.zx'))
    argument = "{a: in.b, b: in.a, value: in.value}" if swapped else "in"
    (target / "forward.zx").write_text('import step from "./step.zx"\n\n' + declarations + f"export default function (in: owned Input): Output {{\n  return step({argument})\n}}\n")
    result = subprocess.run([str(observer), str(target / "main.zx"), *map(str, sorted(target.glob("*.zx")))], capture_output=True, text=True, timeout=30)
    summary = [json.loads(line) for line in result.stdout.splitlines()] if result.returncode == 0 else []
    forward = [row for row in summary if row["file"].endswith("/forward.zx")]
    lanes = forward[0]["provenance"] if len(forward) == 1 else []
    expected = {((1,), (0,)), ((0,), (1,))} if swapped else {((0,), (0,)), ((1,), (1,))}
    paths = {(tuple(lane["input"]), tuple(lane["output"])) for lane in lanes}
    passed = result.returncode == 0 and len(summary) == 2 and len(lanes) == 2 and paths == expected and all(lane["rejection"] is None and len(lane["calls"]) == 1 for lane in lanes)
    records.append({"name": name, "expected_paths": [[list(a), list(b)] for a, b in sorted(expected)], "actual": summary, "exit_code": result.returncode, "stderr": result.stderr, "passed": passed})

sources = list((folder / "输入").rglob("*.zx")) + [draft / name for name in ["flow.zig", "trace.zig", "may.zig", "audit.zig", "observe.zig"]]
report = {"count": len(records), "failures": sum(not record["passed"] for record in records), "records": records, "sha256": {str(source.relative_to(repo)): hashlib.sha256(source.read_bytes()).hexdigest() for source in sources}, "observer_sha256": hashlib.sha256(observer.read_bytes()).hexdigest(), "code_generation_verified": False}
(folder / "验证结果.json").write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n")
print(json.dumps({"count": report["count"], "failures": report["failures"]}))
raise SystemExit(1 if report["failures"] else 0)
