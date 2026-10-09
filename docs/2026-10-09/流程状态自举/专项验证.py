import json
import subprocess
import sys
from pathlib import Path

root = Path.cwd()
out = root / "docs/2026-10-09/流程状态自举"
commands = json.loads((out / "正式构建命令.json").read_text())
base = next(command for command in commands if "-Mroot=packages/cli/src/main.zig" in command)
base = base[1:] if base[0] == "info(verbose):" else base
sources = {
    "捕获往返": "language/expressions/typed_try/library/roundtrip_test.zig",
    "捕获拒绝": "language/expressions/typed_try/library/rejection_test.zig",
    "捕获分配": "language/expressions/typed_try/library/allocation_test.zig",
    "RX可选": "rx/inference/optional/contract_test.zig",
    "RX范围": "rx/inference/root.zig",
    "IR契约": "contracts/ir_test.zig",
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
    root_end = base.index("-Mroot=packages/cli/src/main.zig")
    root_deps = {base[index + 1] for index in range(root_end) if base[index] == "--dep"}

    for argument in base:
        if argument == "--listen=-":
            continue
        if argument == "build-exe":
            argument = "test"
        elif argument == "-Osafe":
            argument = "-Odebug"
        elif argument == "-Mroot=packages/cli/src/main.zig":
            for dependency in ("allocation_testing", "rx", "rx_analysis", "zx"):
                if dependency not in root_deps:
                    command.extend(["--dep", dependency])
            argument = "-Mroot=packages/test/tests/" + sources[name]
        command.append(argument)

    command[command.index("--name") + 1] = "test"
    command.extend([
        "-Mallocation_testing=packages/test/tests/support/allocation_testing.zig",
        "--test-no-exec", "-femit-bin=" + str(executable),
    ])
    if name == "RX范围":
        command.extend(["--test-filter", "scope_test"])

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
