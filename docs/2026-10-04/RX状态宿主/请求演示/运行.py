import hashlib
import json
import subprocess
from pathlib import Path

base = Path(__file__).resolve().parent.parent
root = base.parents[2]
output = base / "请求生成"
generator = base / "初值演示/zig-out/bin/store-initializers"
project = base / "请求项目/sources.json"

subprocess.run([str(generator), str(project), str(output)], check=True)
subprocess.run(
    ["node", str(root / "scripts/format.mjs"), *[str(path) for path in output.glob("*.zig")]],
    cwd=root, check=True,
)
modules = json.loads((output / "modules.json").read_text())
initializers = json.loads((output / "initializers.json").read_text())
slots = json.loads((output / "slots.json").read_text())

if len(slots) != 1:
    raise RuntimeError("This explicit host example expects one application Store slot")

initial = next(item for item in initializers if item["identity"] == slots[0]["path"])
command = [
    "zig", "build-exe", "--dep", "application", "--dep", "runtime",
    "--dep", "initial=" + initial["module_name"],
    "-Mroot=" + str(base / "请求演示/consume.zig"),
]

module_map = {module["name"]: module for module in modules}
needed = set()
pending = ["application", initial["module_name"]]

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

command += [
    "-Mzxc_abi=" + str(output / "types.zig"),
    "-Mruntime=" + str(root / "packages/runtime/src/root.zig"),
    "-femit-bin=" + str(output / "consume"),
]
subprocess.run(command, check=True)
runs = []

for increment in ["1", "7"]:
    result = subprocess.run([str(output / "consume"), increment], text=True, capture_output=True, check=True)
    print(result.stdout + result.stderr, end="")
    runs.append({"increment": increment, "exit_code": result.returncode, "output": result.stdout + result.stderr})

record = {
    "persistence": "explicit in-memory host; no disk save",
    "binary_sha256": hashlib.sha256((output / "consume").read_bytes()).hexdigest(),
    "runs": runs,
    "sources": {
        str(path.relative_to(root)): hashlib.sha256(path.read_bytes()).hexdigest()
        for folder in [base / "请求演示", base / "请求项目", output, root / "packages/runtime/src", root / "packages/runtime/src/store"]
        for path in sorted(folder.iterdir())
        if path.is_file() and path.suffix in [".zig", ".rx", ".zx", ".py"]
    },
}
(output / "运行结果.json").write_text(json.dumps(record, ensure_ascii=False, indent=2) + "\n")
