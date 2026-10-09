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


def save(source, group):
    source = Path(source)
    if str(source) in seen:
        return
    seen.add(str(source))
    identity = sha(source.read_bytes())
    target = doc / "执行证据" / group / (identity + "-" + source.name + ".txt")
    target.parent.mkdir(parents=True, exist_ok=True)
    shutil.copyfile(source, target)
    manifest.append({"source": str(source), "saved": str(target.relative_to(doc)), "sha256": identity})


save(run / "generator-state.json", "生成")
for path in run.glob("*.txt"):
    save(path, "生成与审计")
for path in (run / "generated").glob("*.zig"):
    save(path, "生成源码")
save(run / "standard/catalog.zig", "生成源码")
for path in inputs["external"]:
    save(path, "输入")
for name in inputs["formal"]:
    save(root / name, "正式输入")
for name in ["tests/ownership/field_facts/runtime/arguments.ts", "tests/library/runtime/save.zig", "tests/rx/runtime/parallel/library/archive.zig", "tests/rx/runtime/parallel/library/import.zig", "tests/rx/runtime/parallel/library/consumer.rx", "tests/rx/runtime/parallel/library/consumer_void.rx", "tests/rx/runtime/parallel/library/consumer.zx", "tests/support/allocation_testing.zig"]:
    save(root / "packages/test" / name, "消费者")
for name in ["src/emit_rx_floating.ts", "tests/rx/runtime/floating/check.zig", "tests/rx/runtime/floating/run_test.ts", "tests/rx/runtime/parallel/tracking.zig"]:
    save(root / "packages/test" / name, "回归及观察器")
for suite in inputs["suites"]:
    base = root / ("packages/test/tests/" + suite["path"])
    for path in [base.with_suffix(".rx"), base.with_suffix(".jsonl")]:
        save(path, "目录及源码")
    paths = [root / "packages/test/tests" / path for path in suite["sources"]] if suite["sources"] else [base / "identity.zx", base / "first.zx"]
    for path in paths:
        save(path, "目录及源码")
for mode in ["Debug", "ReleaseSafe"]:
    path = run / (mode + "-execution.json")
    state = json.loads(path.read_text())
    assert state["status"] == "terminal" and state["exit_code"] == 0
    save(path, "执行")
    for step in state["steps"]:
        save(step["log"], "执行")
    for item in state["programs"]:
        save(item["test_source"], "测试源码")
        for source in item["files"]:
            save(source, "执行产物")
(doc / "证据清单.json").write_text(json.dumps(manifest, ensure_ascii=False, indent=4) + "\n")
print("archived", len(manifest), "evidence records")
