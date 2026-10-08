from pathlib import Path
import json
import shutil


doc = Path(__file__).resolve().parent
inputs = json.loads((doc / "执行输入.json").read_text())
run = Path(inputs["run"])
shutil.copyfile(run / "generator-state.json", doc / "生成器证据.json")

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

    state = json.loads((run / (mode + "-generation.json")).read_text())

    for item in state["programs"]:
        target = emitted / item["name"]
        target.mkdir(exist_ok=True)

        for source in item["files"]:
            path = Path(source)
            shutil.copyfile(path, target / (path.name + ".txt"))

    executed = json.loads((run / (mode + "-execution.json")).read_text())

    for item in executed["executions"]:
        directory = Path(item["directory"])
        target = emitted / item["name"] / "runtime" / item["root_name"]
        target.mkdir(parents=True, exist_ok=True)

        for name in ["execution.log", "execution.json", "options.zig"]:
            shutil.copyfile(directory / name, target / (name + ".txt"))

print("collected generated modules and isolated value/capacity execution evidence")
