import hashlib
import json
import subprocess
import tempfile
from pathlib import Path

base = Path(__file__).resolve().parent.parent
root = base.parents[2]
output = base / "零运行时生成"
generator = base / "初值演示/zig-out/bin/store-initializers"

subprocess.run([str(generator), str(base / "请求项目/sources.json"), str(output)], check=True)
modules = json.loads((output / "modules.json").read_text())
initializers = json.loads((output / "initializers.json").read_text())
slots = json.loads((output / "slots.json").read_text())

if len(slots) != 1:
    raise RuntimeError("This concrete example expects one Store slot")

initial = next(item for item in initializers if item["identity"] == slots[0]["path"])
key = hashlib.sha256(initial["identity"].encode()).hexdigest()
file_name = key + ".json"
subprocess.run(["node", str(root / "scripts/format.mjs"), *[str(p) for p in output.glob("*.zig")]], cwd=root, check=True)
command = [
    "zig", "build-exe", "--dep", "application", "--dep", "zxc_state",
    "-Mroot=" + str(base / "零运行时演示/consume.zig"),
]
module_map = {module["name"]: module for module in modules}
needed = set()
pending = ["application", "zxc_state"]

while pending:
    name = pending.pop()

    if name in needed:
        continue

    needed.add(name)
    pending.extend(module_map[name]["imports"])

for module in modules:
    if module["name"] not in needed:
        continue

    command += ["--dep", "zxc_abi"]

    for dependency in module["imports"]:
        command += ["--dep", dependency]

    command += ["-M" + module["name"] + "=" + str(output / (module["name"] + ".zig"))]

command += ["-Mzxc_abi=" + str(output / "types.zig"), "-femit-bin=" + str(output / "consume")]
subprocess.run(command, check=True)
runs = []

with tempfile.TemporaryDirectory(prefix="state-", dir=output) as state:
    for increment in ["1", "7"]:
        result = subprocess.run([str(output / "consume"), state, increment], text=True, capture_output=True, check=True)
        print(result.stdout + result.stderr, end="")
        runs.append({"increment": increment, "exit_code": result.returncode, "output": result.stdout + result.stderr})

    snapshot = json.loads((Path(state) / file_name).read_text())

record = {
    "compiler_generated_concrete_state": True,
    "runtime_module_dependency": False,
    "command": command,
    "binary_sha256": hashlib.sha256((output / "consume").read_bytes()).hexdigest(),
    "runs": runs,
    "snapshot": snapshot,
}
(output / "运行结果.json").write_text(json.dumps(record, ensure_ascii=False, indent=2) + "\n")
