from pathlib import Path

import hashlib
import json
import shutil

doc = Path(__file__).resolve().parent
inputs = json.loads((doc / "执行输入.json").read_text())
run = Path(inputs["run"])
sha = lambda data: hashlib.sha256(data).hexdigest()
logs = doc / "日志"

logs.mkdir(exist_ok=True)

for mode in ["Audit", "Debug", "ReleaseSafe"]:
    state = json.loads((run / (mode + "-state.json")).read_text())

    assert state["status"] == "terminal", mode
    (doc / (mode + "完整证据.json")).write_text(json.dumps(state, ensure_ascii=False, indent=4) + "\n")

    for item in state["executions"]:
        for key in ["compile_log", "log"]:
            path = Path(item[key])

            assert sha(path.read_bytes()) == item[key + "_sha256"]
            shutil.copyfile(path, logs / path.name)

generator = json.loads((run / "generator-state.json").read_text())
assert generator["status"] == "terminal"
(doc / "生成器证据.json").write_text(json.dumps(generator, ensure_ascii=False, indent=4) + "\n")

for item in generator["steps"]:
    path = Path(item["log"])

    assert sha(path.read_bytes()) == item["log_sha256"]

    shutil.copyfile(path, logs / path.name)

print("collected terminal states and exact raw logs")
