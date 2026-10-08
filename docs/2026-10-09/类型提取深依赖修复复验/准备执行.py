from pathlib import Path

import hashlib
import json
import re
import shlex
import shutil
import subprocess

doc = Path(__file__).resolve().parent
main = doc.parents[2]
old = main / "docs/2026-10-08/类型提取共享依赖前沿"
root = Path("/Users/xiewendao/.codex/worktrees/type-frontier-fixed-conformance/zxc")
run = Path("/Users/xiewendao/.codex/conformance/type-frontier-fixed-25cc3108d/r3")
zig = Path("/Users/xiewendao/.codex/conformance/diagnostics/zig-signed-probe-20261009/zig")
entitlements = zig.parent / "empty.plist"
sha = lambda data: hashlib.sha256(data).hexdigest()

assert subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=root, text=True).strip() == "25cc3108d1369845a712966647149da354fa4ae2"
assert not (run / "generator-state.json").exists()
run.mkdir(parents=True, exist_ok=True)

formal = json.loads((old / "正式路径.json").read_text())

for name in formal:
    if name == "packages/test/build.zig":
        continue

    target = root / name

    target.parent.mkdir(parents=True, exist_ok=True)
    shutil.copyfile(old / "草稿" / name, target)

source = root / "packages/test/tests/incremental/artifact/frontier/source.zig"
text = source.read_text()

assert text.count('\\n\\nimport type') in [0, 2]
text = text.replace('\\n\\nimport type', '\\nimport type')
before = 'import type {{ {s} }} from \\"{s}\\"\\nimport type {{ Mode }} from \\"./leaf\\"'
after = 'import type {{ Mode }} from \\"./leaf\\"\\nimport type {{ {s} }} from \\"{s}\\"'

assert text.count(before) == 1
source.write_text(text.replace(before, after))

build = root / formal[0]
text = build.read_text()
before = '"mixed/extract", "mixed/resources"'

assert text.count(before) == 1

if '"frontier/graph"' not in text:
    build.write_text(text.replace(before, before + ', "frontier/graph", "frontier/resources"'))

for target in [root / "node_modules", root / "packages/test/node_modules"]:
    if not target.exists():
        target.symlink_to(main / target.relative_to(root), target_is_directory=True)

subprocess.run(["node", "scripts/format.mjs", *formal], cwd=root, check=True)

for name in formal:
    target = doc / "草稿" / name

    target.parent.mkdir(parents=True, exist_ok=True)
    shutil.copyfile(root / name, target)

commands = json.loads((old / "Debug完整证据.json").read_text())["commands"]
generated = run / "generated"
generated.mkdir(exist_ok=True)

external = run / "external"

external.mkdir(exist_ok=True)

inputs = {}

def adapt(command):
    result = []

    for argument in command:
        if argument == "--listen=-":
            continue

        if argument.startswith("-M"):
            prefix, value = argument.split("=", 1)

            path = Path(value)

            if path.is_absolute():
                data = path.read_bytes()
                directory = external / sha(data)

                directory.mkdir(exist_ok=True)

                target = directory / path.name

                target.write_bytes(data)

                inputs[str(path)] = {"snapshot": str(target), "sha256": sha(data)}

                for relative in re.findall(r'@embedFile\("([^\"]+)"\)', data.decode()):
                    embedded = path.parent / relative
                    copied = directory / relative

                    copied.parent.mkdir(parents=True, exist_ok=True)
                    copied.write_bytes(embedded.read_bytes())

                    inputs[str(embedded)] = {"snapshot": str(copied), "sha256": sha(copied.read_bytes())}

                argument = prefix + "=" + str(target)

        result.append(argument)

    result[0] = str(zig)

    for flag, value in [("--cache-dir", str(run / "cache-seed")), ("--global-cache-dir", str(run / "cache-global"))]:
        if flag in result:
            result[result.index(flag) + 1] = value

    return result

compile_command = adapt(shlex.split(commands[4]["command"]))
compile_command += ["-femit-bin=" + str(run / "generate-parser"), "--entitlements", str(entitlements)]
original_run = shlex.split(commands[7]["command"])
generator_command = [str(run / "generate-parser"), original_run[1]]
generator_command += [str(generated / Path(value).name) for value in original_run[2:-2]]
generator_command += [str(generated / "artifact_roots.zig"), str(generated / "artifact_roots_abi.zig")]
generator_command += [str(generated / "naming.zig"), original_run[-1]]
expected = re.findall(r'run.addOutputFileArg\("([^\"]+)"\)', (root / "packages/compiler/build/parser.zig").read_text())

assert [Path(value).name for value in generator_command[2:-1]] == expected

test_commands = [shlex.split(item["command"]) for item in commands if " test " in item["command"]]

assert len(test_commands) == 7

configuration = {
    "root": str(root), "run": str(run), "source_commit": "25cc3108d1369845a712966647149da354fa4ae2",
    "formal": formal, "zig": str(zig), "entitlements": str(entitlements),
    "generator_compile": compile_command, "generator_run": generator_command,
    "test_templates": test_commands, "external_inputs": inputs,
    "tools": {str(path): sha(path.read_bytes()) for path in [zig, entitlements, Path("/usr/local/bin/node")]},
    "packages": {str(path.relative_to(root)): sha(path.read_bytes()) for path in (root / "packages").rglob("*") if path.is_file() and "node_modules" not in path.parts},
}

(doc / "执行输入.json").write_text(json.dumps(configuration, ensure_ascii=False, indent=4) + "\n")
(doc / "正式路径.json").write_text(json.dumps(formal, indent=4) + "\n")

print("prepared", len(configuration["packages"]), "package inputs", len(expected), "generated outputs")
