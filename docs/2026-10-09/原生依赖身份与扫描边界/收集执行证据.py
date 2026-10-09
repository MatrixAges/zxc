from pathlib import Path

import hashlib
import json
import shutil

p = Path(__file__).resolve().parent
inputs = json.loads((p / "执行输入.json").read_text())
root = Path(inputs["root"])
run = Path(inputs["run"])
sha = lambda data: hashlib.sha256(data).hexdigest()
assert not (p / "证据清单.json").exists()
manifest = []
seen = set()


def save(path, group):
    path = Path(path)

    if str(path) in seen:
        return

    seen.add(str(path))
    identity = sha(path.read_bytes())
    destination = p / "执行证据" / group / (identity + "-" + path.name + ".txt")
    destination.parent.mkdir(parents=True, exist_ok=True)
    shutil.copyfile(path, destination)
    manifest.append({"source": str(path), "saved": str(destination.relative_to(p)), "sha256": identity})


save(run / "generator-state.json", "生成")
for path in run.glob("*.txt"):
    save(path, "生成")
for path in (run / "generated").glob("*.zig"):
    save(path, "生成源码")
save(run / "standard/catalog.zig", "生成源码")
for name in inputs["external"]:
    save(name, "输入")
for relative in ["tests/incremental/type_merge", "tests/incremental/artifact", "tests/library/imports", "tests/incremental/module_records", "tests/incremental/nominal", "tests/language/types/resolution", "tests/incremental/native_link"]:
    for path in (root / "packages/test" / relative).rglob("*"):
        if path.is_file():
            save(path, "测试源码")
save(root / "packages/test/tests/support/allocation_testing.zig", "测试源码")
for mode in ["Debug", "ReleaseSafe"]:
    state_path = run / (mode + "-aggregate-execution.json")
    state = json.loads(state_path.read_text())
    assert state["status"] == "terminal" and state["exit_code"] == 0
    save(state_path, "执行")
    for entry in state["gates"]:
        save(entry["log"], "执行")
        if "wrapper" in entry:
            save(entry["wrapper"], "测试入口")
for path in (run / "setup-diagnostics").glob("*"):
    save(path, "前期诊断")
(p / "证据清单.json").write_text(json.dumps(manifest, ensure_ascii=False, indent=4) + "\n")
print("archived", len(manifest), "evidence records")
