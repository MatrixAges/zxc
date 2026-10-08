from pathlib import Path
import json
import shutil


doc = Path(__file__).resolve().parent
inputs = json.loads((doc / "执行输入.json").read_text())
run = Path(inputs["run"])
logs = doc / "日志"
logs.mkdir(exist_ok=True)

for source in run.glob("*-state.json"):
    state = json.loads(source.read_text())
    assert state["status"] == "terminal", source
    shutil.copyfile(source, doc / source.name)

for source in run.glob("*.txt"):
    shutil.copyfile(source, logs / source.name)

emitted = doc / "生成源码"
emitted.mkdir(exist_ok=True)

for source in (run / "generated").glob("*.zig"):
    shutil.copyfile(source, emitted / (source.name + ".txt"))

probe = Path(inputs["root"]) / "packages/test/tests/collections/predicates/probe_test.zig"
shutil.copyfile(probe, doc / "捕获与错误探针.zig.txt")
print("collected terminal gate states, raw logs and 81 generated modules")
