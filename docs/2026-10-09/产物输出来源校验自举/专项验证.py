import json
import shlex
import subprocess
import sys
from pathlib import Path

root = Path.cwd()
out = root / "docs/2026-10-09/产物输出来源校验自举"
commands = [shlex.split(line.removeprefix("info(verbose): ")) for line in (out / "正式构建日志.txt").read_text().splitlines() if line.startswith("info(verbose): ")]
base = next(command for command in commands if "-Mroot=packages/cli/src/main.zig" in command)
results = {}

cases = {"产物提取": "artifact/extract", "无效输入": "artifact/invalid", "产物资源": "artifact/resources", "混合提取": "artifact/mixed/extract", "混合资源": "artifact/mixed/resources"}

for name, source in cases.items():
    if len(sys.argv) > 1 and name not in sys.argv[1:]:
        continue
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
            command.extend(["--dep", "record_fixture", "--dep", "allocation_testing"])
            argument = "-Mroot=packages/test/tests/incremental/" + source + "_test.zig"
        command.append(argument)

    command[command.index("--name") + 1] = "test"
    command.extend([
        "--dep", "compiler",
        "-Mrecord_fixture=packages/test/tests/incremental/module_records/fixture.zig",
        "-Mallocation_testing=packages/test/tests/support/allocation_testing.zig",
        "--test-no-exec", "-femit-bin=" + str(executable),
    ])
    (out / (name + "命令.json")).write_text(json.dumps(command, ensure_ascii=False, indent=2))

    with (out / (name + "编译.txt")).open("w") as log:
        compiled = subprocess.run(command, stdout=log, stderr=log)
    if compiled.returncode:
        raise SystemExit(compiled.returncode)

    subprocess.run(["codesign", "--force", "--sign", "-", str(executable)], check=True, capture_output=True)
    with (out / (name + "运行.txt")).open("w") as log:
        checked = subprocess.run([str(executable)], stdout=log, stderr=log)
    results[name] = checked.returncode
    print(name + "运行返回 " + str(checked.returncode), flush=True)
    if checked.returncode:
        raise SystemExit(checked.returncode)

(out / "验证结果.json").write_text(json.dumps(results, ensure_ascii=False, indent=2) + "\n")
