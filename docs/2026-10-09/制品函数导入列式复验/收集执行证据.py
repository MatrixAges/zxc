from pathlib import Path
import json
import shutil


doc = Path(__file__).resolve().parent
inputs = json.loads((doc / "执行输入.json").read_text())
run = Path(inputs["run"])

for name in ["generator-state.json", "final2-Debug-state.json", "final2-ReleaseSafe-state.json", "Debug-runtime.json", "ReleaseSafe-runtime.json"]:
    state = json.loads((run / name).read_text())
    assert state["status"] == "terminal" and state["exit_code"] == 0, name
    shutil.copyfile(run / name, doc / name)

for source in run.glob("*.txt"):
    target = doc / "日志" / source.name
    target.parent.mkdir(exist_ok=True)
    shutil.copyfile(source, target)

for mode in ["Debug", "ReleaseSafe"]:
    for source in (run / mode).glob("*.txt"):
        target = doc / "日志" / mode / source.name
        target.parent.mkdir(exist_ok=True)
        shutil.copyfile(source, target)

    for source in (run / mode).glob("*.zig"):
        target = doc / "生成源码" / mode / (source.name + ".txt")
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(source, target)

print("collected terminal regression and actual source/library execution evidence")
