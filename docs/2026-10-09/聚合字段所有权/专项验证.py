import json
import subprocess
import sys
from pathlib import Path

root = Path.cwd()
out = root / "docs/2026-10-09/聚合字段所有权"
commands = json.loads((out / "正式构建命令.json").read_text())
base = next(command for command in commands if "-Mroot=packages/cli/src/main.zig" in command)
base = base[1:] if base[0] == "info(verbose):" else base
sources = {
    "循环": "collections/iterate/analysis_test.zig",
    "输入": "ownership/input/modules.zig",
    "字段": "ownership/fields/root.zig",
    "贷款": "ownership/loans/root.zig",
    "归约": "ownership/reduce/root.zig",
    "缓存": "ownership/cached/root.zig",
    "返回": "ownership/returns_test.zig",
}

for name in sys.argv[1:]:
    executable = out / (name + "专项")
    command = []

    for argument in base:
        if argument == "--listen=-":
            continue
        if argument == "build-exe":
            argument = "test"
        elif argument == "-Osafe":
            argument = "-Odebug"
        elif argument == "-Mroot=packages/cli/src/main.zig":
            command.extend(["--dep", "allocation_testing"])
            argument = "-Mroot=packages/test/tests/" + sources[name]
        command.append(argument)

    command[command.index("--name") + 1] = "test"
    command.extend([
        "-Mallocation_testing=packages/test/tests/support/allocation_testing.zig",
        "--test-no-exec", "-femit-bin=" + str(executable),
    ])
    (out / (name + "专项命令.json")).write_text(json.dumps({"cwd": str(root), "command": command}, ensure_ascii=False, indent=2))

    with (out / (name + "专项编译.txt")).open("w") as log:
        compiled = subprocess.run(command, stdout=log, stderr=log)

    if compiled.returncode:
        print(name + "编译失败", flush=True)
        raise SystemExit(compiled.returncode)

    subprocess.run(["codesign", "--force", "--sign", "-", str(executable)], check=True, capture_output=True)

    with (out / (name + "专项运行.txt")).open("w") as log:
        checked = subprocess.run([str(executable)], stdout=log, stderr=log)

    print(name + "运行返回 " + str(checked.returncode), flush=True)

    if checked.returncode:
        raise SystemExit(checked.returncode)
