import hashlib
import json
import subprocess
from pathlib import Path

base = Path(__file__).resolve().parent.parent
root = base.parents[2]
output = base / "零运行时生成"
generator = base / "初值演示/zig-out/bin/store-initializers"

subprocess.run([str(generator), str(base / "请求项目/sources.json"), str(output)], check=True)
modules = json.loads((output / "modules.json").read_text())
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

for inputs in [["1", "7"], ["7"]]:
    result = subprocess.run([str(output / "consume"), *inputs], text=True, capture_output=True, check=True)
    print(result.stdout + result.stderr, end="")
    runs.append({"inputs_in_one_application": inputs, "exit_code": result.returncode, "output": result.stdout + result.stderr})

record = {
    "compiler_generated_concrete_state": True,
    "runtime_module_dependency": False,
    "command": command,
    "binary_sha256": hashlib.sha256((output / "consume").read_bytes()).hexdigest(),
    "runs": runs,
    "storage": "application_memory",
}
(output / "运行结果.json").write_text(json.dumps(record, ensure_ascii=False, indent=2) + "\n")
