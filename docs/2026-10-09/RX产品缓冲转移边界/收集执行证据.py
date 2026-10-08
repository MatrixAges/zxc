from pathlib import Path
import hashlib
import json
import shutil


doc = Path(__file__).resolve().parent
inputs = json.loads((doc / "执行输入.json").read_text())
run = Path(inputs["run"])
sha = lambda data: hashlib.sha256(data).hexdigest()
logs = doc / "日志"
sources = doc / "生成源码"
logs.mkdir(exist_ok=True)
sources.mkdir(exist_ok=True)

for mode in ["Debug", "ReleaseSafe"]:
    for phase in ["generation", "execution"]:
        state = json.loads((run / (mode + "-" + phase + ".json")).read_text())
        assert state["status"] == "terminal", (mode, phase)
        (doc / (mode + "-" + phase + ".json")).write_text(json.dumps(state, ensure_ascii=False, indent=4) + "\n")
        entries = state["programs"] if phase == "generation" else state["executions"]

        if phase == "generation":
            path = Path(state["compile_log"])
            assert sha(path.read_bytes()) == state["compile_log_sha256"]
            shutil.copyfile(path, logs / (mode + "-host-compile.txt"))

        for item in entries:
            for key in ["log", "compile_log"]:
                if key not in item:
                    continue

                path = Path(item[key])
                assert sha(path.read_bytes()) == item[key + "_sha256"]
                shutil.copyfile(path, logs / (mode + "-" + path.name))

            if phase == "generation" and mode == "Debug":
                for key in ["source", "types"]:
                    path = Path(item[key])
                    assert sha(path.read_bytes()) == item[key + "_sha256"]
                    shutil.copyfile(path, sources / (path.name + ".txt"))

generator = json.loads((run / "generator-state.json").read_text())
assert generator["status"] == "terminal"
(doc / "生成器证据.json").write_text(json.dumps(generator, ensure_ascii=False, indent=4) + "\n")

for item in generator["steps"]:
    path = Path(item["log"])
    assert sha(path.read_bytes()) == item["log_sha256"]
    shutil.copyfile(path, logs / path.name)

print("collected terminal generation and execution evidence; raw sources use .zig.txt")
