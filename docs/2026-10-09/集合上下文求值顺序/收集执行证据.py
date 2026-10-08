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
    shutil.copyfile(state["compile_log"], logs / "compile.txt")

    for item in state["programs"]:
        shutil.copyfile(item["log"], logs / Path(item["log"]).name)

        for key, suffix in [("source", ".zig.txt"), ("types", "_abi.zig.txt")]:
            shutil.copyfile(item[key], emitted / (item["name"] + suffix))

print("collected primary execution logs and generated programs")
