from pathlib import Path

import hashlib
import gzip
import json

doc = Path(__file__).resolve().parent
inputs = json.loads((doc / "执行输入.json").read_text())
root = Path(inputs["root"])
run = Path(inputs["run"])
files = {}


def add(path, saved):
    files[str(path)] = saved + ".txt" if saved.endswith(".log") else saved


for name in inputs["formal"]:
    add(root / name, "执行证据/正式输入/" + name + ".txt")
for name in ["packages/test/tests/collections/reverse_ownership/compile.zig", "packages/test/tests/support/allocation_testing.zig"]:
    add(root / name, "执行证据/复用输入/" + name + ".txt")
generation = json.loads((run / "generator-state.json").read_text())
assert generation["status"] == "terminal" and generation["exit_code"] == 0
add(run / "generator-state.json", "执行证据/编译器生成状态.json.txt")
for name in generation["generated"]:
    add(Path(name), "执行证据/生成编译器/" + Path(name).name + ".txt")
for step in generation["steps"]:
    add(Path(step["log"]), "执行证据/编译器生成日志/" + Path(step["log"]).name)
for check in json.loads((doc / "静态检查.json").read_text()):
    if "log" in check:
        add(Path(check["log"]), "执行证据/静态检查/" + Path(check["log"]).name)
for mode in ["Debug", "ReleaseSafe"]:
    state = json.loads((run / (mode + "-execution.json")).read_text())
    assert state["status"] == "terminal" and state["exit_code"] == 0
    add(run / (mode + "-execution.json"), "执行证据/" + mode + "状态.json.txt")
    for step in state["steps"]:
        path = Path(step["log"])
        add(path, "执行证据/" + mode + "/" + path.name)
    for program in state["programs"]:
        for name in program["files"]:
            path = Path(name)
            add(path, "执行证据/" + mode + "/" + path.name + (".txt" if path.suffix == ".zig" else ""))
records = []
for name, saved in sorted(files.items()):
    data = Path(name).read_bytes()
    compressed = len(data) > 50 * 1024 * 1024
    if compressed:
        saved += ".gz"
    target = doc / saved
    target.parent.mkdir(parents=True, exist_ok=True)
    target.write_bytes(gzip.compress(data, mtime=0) if compressed else data)
    record = {"source": name, "saved": saved, "sha256": hashlib.sha256(data).hexdigest()}
    if compressed:
        record["encoding"] = "gzip"
    records.append(record)
(doc / "证据清单.json").write_text(json.dumps(records, ensure_ascii=False, indent=4) + "\n")
print("archived", len(records), "evidence records")
