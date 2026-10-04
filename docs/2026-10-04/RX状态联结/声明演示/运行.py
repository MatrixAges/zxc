# -*- coding: utf-8 -*-
import hashlib
import json
import subprocess
from pathlib import Path

base = Path(__file__).resolve().parent.parent
output = base / "声明生成"
binary = output / "consume"
command = [
    "zig", "build-exe", "--dep", "program", "--dep", "initial",
    "-Mroot=" + str(base / "声明演示/consume.zig"),
    "--dep", "zxc_abi", "-Mprogram=" + str(output / "application.zig"),
    "--dep", "zxc_abi", "-Minitial=" + str(output / "initial_0.zig"),
    "-Mzxc_abi=" + str(output / "types.zig"),
    "-femit-bin=" + str(binary),
]
subprocess.run(command, check=True)
results = {"binary_sha256": hashlib.sha256(binary.read_bytes()).hexdigest(), "runs": {}}

for conflict, increment in [("0", "1"), ("2", "1"), ("0", "7")]:
    result = subprocess.run([str(binary), conflict, increment], text=True, capture_output=True)
    text = result.stdout + result.stderr
    results["runs"][conflict + ":" + increment] = {"exit_code": result.returncode, "output": text}
    print(conflict, increment, text, end="")

results["cli_source_generated_only"] = True
results["sources"] = {
    str(path.relative_to(base)): hashlib.sha256(path.read_bytes()).hexdigest()
    for folder in [base / "声明演示", base / "真实声明", output]
    for path in sorted(folder.iterdir())
    if path.is_file() and path.suffix in [".zig", ".zon", ".zx", ".rx", ".py"]
}
(output / "运行结果.json").write_text(json.dumps(results, ensure_ascii=False, indent=2) + "\n")
