# -*- coding: utf-8 -*-
import hashlib
import json
import subprocess
from pathlib import Path

base = Path(__file__).resolve().parent.parent
output = base / "调用生成"
main = base / "调用演示/consume.zig"
files = json.loads((output / "modules.json").read_text())
results = {}

for name in ["standalone", "modular"]:
    binary = output / name
    command = ["zig", "build-exe", "--dep", "program", "-Mroot=" + str(main)]

    if name == "standalone":
        command += ["-Mprogram=" + str(output / "standalone.zig")]
    else:
        for file in reversed(files):
            command += ["--dep", "zxc_abi"]

            for imported in file["imports"]:
                command += ["--dep", imported]

            module = "program" if file["name"] == "application" else file["name"]
            command += ["-M" + module + "=" + str(output / (file["name"] + ".zig"))]

        command += ["-Mzxc_abi=" + str(output / "types.zig")]

    command += ["-femit-bin=" + str(binary)]
    subprocess.run(command, check=True)
    results[name] = {"binary_sha256": hashlib.sha256(binary.read_bytes()).hexdigest(), "runs": {}}

    for conflict_at in ["0", "2"]:
        result = subprocess.run([str(binary), conflict_at], text=True, capture_output=True)
        text = result.stdout + result.stderr
        results[name]["runs"][conflict_at] = {"exit_code": result.returncode, "output": text}
        print(name, conflict_at, text, end="")

results["sources"] = {
    str(path.relative_to(base)): hashlib.sha256(path.read_bytes()).hexdigest()
    for folder in [base / "调用演示", output]
    for path in sorted(folder.iterdir())
    if path.is_file() and path.suffix in [".zig", ".zon", ".zx", ".py"]
}
(output / "运行结果.json").write_text(json.dumps(results, ensure_ascii=False, indent=2) + "\n")
