import json
import re
import shlex
import subprocess
from pathlib import Path

root = Path.cwd()
out = root / "docs/2026-10-09/类型合并状态自举"
work = out / "引用身份"
work.mkdir(exist_ok=True)
commands = [shlex.split(line.removeprefix("info(verbose): ")) for line in (out / "正式构建日志.txt").read_text().splitlines() if line.startswith("info(verbose): ")]
base = next(command for command in commands if "-Mroot=packages/cli/src/main.zig" in command)
base = base[1:] if base[0] == "info(verbose):" else base
command = [argument for argument in base if argument != "--listen=-"]
command[command.index("-Mroot=packages/cli/src/main.zig")] = "-Mroot=packages/test/tests/collections/value_return/compile.zig"
command[command.index("--name") + 1] = "compile-value-return"
driver = work / "compile-value-return"
command.append("-femit-bin=" + str(driver))


def compile_binary(command, binary, log):
    with log.open("w") as output:
        result = subprocess.run(command, stdout=output, stderr=output)

    if result.returncode:
        raise RuntimeError(log.read_text())

    subprocess.run(["codesign", "--force", "--sign", "-", str(binary)], check=True, capture_output=True)


compile_binary(command, driver, work / "生成器编译.txt")
records = []

for mode in ("references", "escaping", "escape_optional", "escape_list", "escape_tuple", "escape_nested"):
    directory = work / mode
    directory.mkdir(exist_ok=True)
    source = directory / "source.zig"
    source_abi = directory / "source_abi.zig"
    library = directory / "library.zig"
    library_abi = directory / "library_abi.zig"
    subprocess.run([str(driver), mode, str(source), str(source_abi), str(library), str(library_abi)], check=True)
    options = directory / "options.zig"
    options.write_text('pub const mode: []const u8 = "' + mode + '";\n')
    runner = "references" if mode == "references" else "escaping" if mode == "escaping" else "containers"

    for route, program, abi in (("source", source, source_abi), ("library", library, library_abi)):
        binary = directory / (route + "-run")
        invocation = [base[0], "test", "-Odebug", "--dep", "program", "--dep", "allocation_testing", "--dep", "options",
            "-Mroot=packages/test/tests/collections/value_return/" + runner + ".zig",
            "-Odebug", "--dep", "zxc_abi", "-Mprogram=" + str(program),
            "-Odebug", "-Mzxc_abi=" + str(abi),
            "-Mallocation_testing=packages/test/tests/support/allocation_testing.zig", "-Moptions=" + str(options),
            "--test-no-exec", "-femit-bin=" + str(binary)]
        compile_binary(invocation, binary, directory / (route + "编译.txt"))
        log = directory / (route + "运行.txt")

        with log.open("w") as output:
            checked = subprocess.run([str(binary)], stdout=output, stderr=output)

        text = log.read_text()
        if checked.returncode:
            raise RuntimeError(text)

        count = int(re.search(r"All (\d+) tests passed\.", text).group(1))
        records.append({"mode": mode, "route": route, "passed": count})
        print(mode, route, count, flush=True)
        (out / "引用身份结果.json").write_text(json.dumps(records, ensure_ascii=False, indent=2) + "\n")
