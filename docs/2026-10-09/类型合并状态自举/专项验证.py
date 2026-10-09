import json
import shlex
import subprocess
import sys
from pathlib import Path

root = Path.cwd()
out = root / "docs/2026-10-09/类型合并状态自举"
commands = [shlex.split(line.removeprefix("info(verbose): ")) for line in (out / "正式构建日志.txt").read_text().splitlines() if line.startswith("info(verbose): ")]
base = next(command for command in commands if "-Mroot=packages/cli/src/main.zig" in command)
results = {}

cases = {"身份": "identity", "无效输入": "invalid", "分配失败": "resources", "批量映射": "bulk/mapping", "批量名义": "bulk/nominal", "批量所有权": "bulk/ownership", "批量分配失败": "bulk/resources", "压缩映射": "compaction/mapping", "压缩分配失败": "compaction/resources", "来源预检": "preflight/origins", "前缀预检": "preflight/prefix", "预检分配失败": "preflight/resources"}

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
            command.extend(["--dep", "record_fixture", "--dep", "allocation_testing", "--dep", "type_merge_fixture"])
            argument = "-Mroot=packages/test/tests/incremental/type_merge/" + source + "_test.zig"
        command.append(argument)

    command[command.index("--name") + 1] = "test"
    command.extend([
        "--dep", "compiler",
        "-Mrecord_fixture=packages/test/tests/incremental/module_records/fixture.zig",
        "-Mallocation_testing=packages/test/tests/support/allocation_testing.zig",
        "--dep", "compiler", "-Mtype_merge_fixture=packages/test/tests/incremental/type_merge/preflight/fixture.zig",
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
