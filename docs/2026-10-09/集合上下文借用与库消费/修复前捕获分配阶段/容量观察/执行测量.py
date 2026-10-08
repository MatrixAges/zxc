from pathlib import Path
import hashlib
import json
import subprocess


doc = Path(__file__).resolve().parent
inputs = json.loads((doc / "执行命令.json").read_text())
log = doc / "原始输出.txt"
with log.open("wb") as output:
    result = subprocess.run(inputs["command"], cwd=inputs["cwd"], stdout=output, stderr=subprocess.STDOUT)

state = {"status": "terminal", "exit_code": result.returncode, "log_sha256": hashlib.sha256(log.read_bytes()).hexdigest()}
(doc / "运行状态.json").write_text(json.dumps(state, indent=4) + "\n")
print(log.read_text())
print("measurement terminal", result.returncode)
