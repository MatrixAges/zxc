from pathlib import Path

import hashlib
import json
import shutil

doc = Path(__file__).resolve().parent
inputs = json.loads((doc / "执行输入.json").read_text())
run = Path(inputs["run"])
root = Path(inputs["root"])
sha = lambda data: hashlib.sha256(data).hexdigest()
assert not (doc / "证据清单.json").exists()
manifest = []
seen = set()


def save(path, group):
    path = Path(path)
    if str(path) in seen:
        return
    seen.add(str(path))
    identity = sha(path.read_bytes())
    target = doc / "执行证据" / group / (identity + "-" + path.name + ".txt")
    target.parent.mkdir(parents=True, exist_ok=True)
    shutil.copyfile(path, target)
    manifest.append({"source": str(path), "saved": str(target.relative_to(doc)), "sha256": identity})


save(run / "generator-state.json", "生成")
for path in run.glob("*.txt"):
    save(path, "生成")
for path in (run / "generated").glob("*.zig"):
    save(path, "生成源码")
save(run / "standard/catalog.zig", "生成源码")
for path in inputs["external"]:
    save(path, "输入")
for name in inputs["formal"]:
    save(root / name, "正式输入")
for name in ["tests/ownership/field_facts/runtime/compile.zig", "tests/library/runtime/save.zig", "tests/support/collections.zig", "src/emit_control_tests.ts", "src/shared/zig_literal.ts"]:
    save(root / "packages/test" / name, "消费者")
for mode in ["Debug", "ReleaseSafe"]:
    state_path = run / (mode + "-execution.json")
    state = json.loads(state_path.read_text())
    assert state["status"] == "terminal" and state["exit_code"] == 0
    save(state_path, "执行")
    for step in state["steps"]:
        save(step["log"], "执行")
    for item in state["programs"]:
        save(item["test_source"], "测试源码")
        for path in item["files"]:
            save(path, "执行产物")
for path in (run / "setup-diagnostics").glob("*"):
    save(path, "前期诊断")
(doc / "证据清单.json").write_text(json.dumps(manifest, ensure_ascii=False, indent=4) + "\n")
print("archived", len(manifest), "evidence records")
