from pathlib import Path
import json
import shutil


doc = Path(__file__).resolve().parent
inputs = json.loads((doc / "执行输入.json").read_text())
run = Path(inputs["run"])
generation = json.loads((run / "generator-state.json").read_text())
(doc / "日志").mkdir(exist_ok=True)
shutil.copyfile(run / "generator-state.json", doc / "生成器证据.json")

for step in generation["steps"]:
    source = Path(step["log"])
    shutil.copyfile(source, doc / "日志" / source.name)

for mode in ["Debug", "ReleaseSafe"]:
    for kind in ["generation", "execution"]:
        source = run / (mode + "-" + kind + ".json")
        state = json.loads(source.read_text())
        assert state["status"] == "terminal" and state["exit_code"] == 0
        shutil.copyfile(source, doc / source.name)

    logs = doc / "日志" / mode
    emitted = doc / "生成源码" / mode
    logs.mkdir(parents=True, exist_ok=True)
    emitted.mkdir(parents=True, exist_ok=True)

    for source in (run / mode).glob("*.txt"):
        shutil.copyfile(source, logs / source.name)

    generated = json.loads((run / (mode + "-generation.json")).read_text())

    for item in generated["programs"]:
        for key, suffix in [("source_path", ".zig.txt"), ("test_path", "_test.zig.txt")]:
            shutil.copyfile(item[key], emitted / (item["method"] + suffix))

print("collected primary execution logs and generated sources")
