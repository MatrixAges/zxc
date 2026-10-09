from pathlib import Path

import hashlib
import json
import re
import shutil
import subprocess

doc = Path(__file__).resolve().parent
main = doc.parents[2]
old = json.loads((main / "docs/2026-10-09/原生依赖身份与扫描边界/执行输入.json").read_text())
root = Path.home() / ".codex/worktrees/predicate-allocation-conformance/zxc"
run = Path.home() / ".codex/conformance/predicate-allocation-7eb37ce6e/r2"
commit = "7eb37ce6e05d08f71dd0a3345020b45fe5e99828"
sha = lambda data: hashlib.sha256(data).hexdigest()
assert not (run / "generator-state.json").exists(), "inspect existing execution before preparing again"
assert subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=root, text=True).strip() == commit
run.mkdir(parents=True, exist_ok=True)
(run / "generated").mkdir(exist_ok=True)
inputs = {key: old[key] for key in ["zig", "entitlements"]}
inputs.update(root=str(root), run=str(run), source_commit=commit, generated_count=83, external={}, compile_templates={})
inputs["formal"] = [str(path.relative_to(doc / "草稿")) for path in sorted((doc / "草稿").rglob("*")) if path.is_file()]

for name in inputs["formal"]:
    target = root / name
    target.parent.mkdir(parents=True, exist_ok=True)
    shutil.copyfile(doc / "草稿" / name, target)


def groups(command):
    blocks = {}
    current = []

    for arg in command[2:]:
        current.append(arg)

        if arg.startswith("-M"):
            blocks[arg.split("=", 1)[0][2:]] = current
            current = []

    return blocks, current


seed = [arg.replace(old["root"], str(root)).replace(old["run"], str(run)) for arg in old["generator_compile"]]
blocks, tail = groups(seed)
removed = set()
command = seed[:2]

for name, block in blocks.items():
    if name in removed:
        continue

    cleaned = []
    index = 0

    while index < len(block):
        if block[index] == "--dep" and block[index + 1].split("=")[-1] in removed:
            index += 2
            continue

        cleaned.append(block[index])
        index += 1

    command += cleaned

inputs["generator_compile"] = command + tail
inputs["generator_run"] = [arg.replace(old["root"], str(root)).replace(old["run"], str(run)) for arg in old["generator_run"] if Path(arg).name not in {"name_sort.zig", "ordering_abi.zig", "type_remap.zig", "remap_abi.zig"}]
def snapshot(path):
    identity = sha(path.read_bytes())
    target = run / "external" / identity / path.name
    target.parent.mkdir(parents=True, exist_ok=True)
    target.write_bytes(path.read_bytes())
    inputs["external"][str(target)] = identity

    for relative in re.findall(r'@embedFile\("([^"\n]+)"\)', path.read_text()):
        source = path.parent / relative
        saved = target.parent / relative
        saved.parent.mkdir(parents=True, exist_ok=True)
        saved.write_bytes(source.read_bytes())
        inputs["external"][str(saved)] = sha(saved.read_bytes())

    return str(target)



for path, expected in old["external"].items():
    if not path.endswith("/options.zig"):
        continue

    target = Path(path.replace(old["run"], str(run)))
    target.parent.mkdir(parents=True, exist_ok=True)
    target.write_bytes(Path(path).read_bytes())
    assert sha(target.read_bytes()) == expected
    inputs["external"][str(target)] = expected

for index, argument in enumerate(inputs["generator_compile"]):
    if argument.startswith("-M"):
        prefix, value = argument.split("=", 1)
        path = Path(value)

        if prefix == "-Mstandard_interfaces":
            inputs["generator_compile"][index] = prefix + "=" + str(run / "standard/catalog.zig")
        elif path.is_absolute() and not value.startswith(str(root) + "/") and not value.startswith(str(run) + "/"):
            inputs["generator_compile"][index] = prefix + "=" + snapshot(path)

formal = json.loads((main / "docs/2026-10-09/产物依赖资格校验自举/产物提取命令.json").read_text())
blocks, tail = groups(formal)
needed = set()
pending = ["compiler"]

while pending:
    name = pending.pop()

    if name in needed:
        continue

    needed.add(name)
    block = blocks[name]
    pending += [block[i + 1].split("=")[-1] for i, arg in enumerate(block[:-1]) if arg == "--dep"]

module_graph = [arg for name, block in blocks.items() if name in needed for arg in block]
generated_names = {Path(arg).name for arg in inputs["generator_run"][2:-1]} | {"lexer.zig"}
assert len(generated_names) == 83

for mode in ["Debug", "ReleaseSafe"]:
    adapted = [inputs["zig"], "test", "-O" + mode, "--dep", "compiler", "--dep", "frontend", "--dep", "zx", "--dep", "allocation_testing", "-Mroot=ROOT"]

    for arg in module_graph:
        if arg.startswith("-O"):
            arg = "-O" + mode
        elif arg.startswith("-M"):
            prefix, value = arg.split("=", 1)
            path = Path(value)

            if prefix == "-Mstandard_interfaces":
                value = str(run / "standard/catalog.zig")
            elif value.startswith("packages/"):
                value = str(root / value)
            elif path.name in generated_names:
                value = str(run / "generated" / path.name)
            elif "/packages/" in value:
                value = str(root / "packages" / value.split("/packages/", 1)[1])
            else:
                value = snapshot(path if path.is_absolute() else main / path)

            arg = prefix + "=" + value

        adapted.append(arg)

    adapted += ["-O" + mode, "-Mallocation_testing=" + str(root / "packages/test/tests/support/allocation_testing.zig"), "--cache-dir", str(run / ("cache-host-" + mode)), "--global-cache-dir", str(run / "cache-global"), "--entitlements", inputs["entitlements"], "-femit-bin=BINARY"]
    adapted[1] = "build-exe"
    position = adapted.index("-Mroot=ROOT")
    adapted[position:position] = ["--dep", "library_output"]
    adapted[position + 2] = "-Mroot=" + str(root / "packages/test/tests/ownership/field_facts/runtime/compile.zig")
    adapted += ["-O" + mode, "-Mlibrary_output=" + str(root / "packages/test/tests/library/runtime/save.zig")]
    inputs["compile_templates"][mode] = adapted
catalog_dir = run / "standard"
(catalog_dir / "interfaces").mkdir(parents=True, exist_ok=True)
modules = json.loads((root / "packages/compiler/standard/modules.json").read_text())
catalog_inputs = []

for index, module in enumerate(modules):
    fragments = module.get("fragments", [])
    text = None

    if fragments:
        text = "".join((root / "packages/compiler/standard" / path).read_text() + "\n" for path in [module["path"], *fragments])
    else:
        source = root / "packages/compiler/standard" / module["path"]
        target = catalog_dir / "interfaces" / (str(index) + ".d.zx")
        target.write_bytes(source.read_bytes())
        inputs["external"][str(target)] = sha(target.read_bytes())

    catalog_inputs.append({"specifier": module["specifier"], "path": module["specifier"] if text is not None else "standard/" + module["path"], "source": "interfaces/" + str(index) + ".d.zx", "text": text, "module": module["module"], "namespace": module["namespace"], "implementation_path": module["implementation_path"]})

(catalog_dir / "catalog.json").write_text(json.dumps(catalog_inputs, ensure_ascii=False, indent=4) + "\n")
inputs["external"][str(catalog_dir / "catalog.json")] = sha((catalog_dir / "catalog.json").read_bytes())
inputs["catalog_compile"] = [inputs["zig"], "build-exe", "-ODebug", "--dep", "genz", "-Mroot=" + str(root / "packages/compiler/build/generate_catalog.zig"), "-ODebug", "--dep", "zx", "-Mgenz=" + str(root / "packages/genz/src/root.zig"), "-ODebug", "-Mzx=" + str(root / "packages/core/src/root.zig"), "-femit-bin=" + str(run / "generate-catalog"), "--entitlements", inputs["entitlements"], "--cache-dir", str(run / "cache-catalog"), "--global-cache-dir", str(run / "cache-global")]
inputs["catalog_run"] = [str(run / "generate-catalog"), str(catalog_dir / "catalog.json"), str(catalog_dir / "catalog.zig")]
inputs["lexer_compile"] = ["-Mroot=" + str(root / "packages/compiler/build/generate_lexer.zig") if argument.startswith("-Mroot=") else "-femit-bin=" + str(run / "generate-lexer") if argument.startswith("-femit-bin=") else argument for argument in inputs["generator_compile"]]
inputs["lexer_run"] = [str(run / "generate-lexer"), str(root / "packages/compiler/src/zx/frontend/lexer"), str(run / "generated/lexer.zig")]


inputs["packages"] = {name: sha((root / name).read_bytes()) for name in subprocess.check_output(["git", "ls-files", "-z", "--", "packages"], cwd=root).decode().strip("\0").split("\0") if name not in inputs["formal"]}
inputs["formal_sha256"] = {name: sha((root / name).read_bytes()) for name in inputs["formal"]}
inputs["tools"] = {name: sha(Path(name).read_bytes()) for name in [inputs["zig"], inputs["entitlements"], *[str(doc / name) for name in ["执行生成器.py", "运行门禁.py"]]]}
(doc / "执行输入.json").write_text(json.dumps(inputs, ensure_ascii=False, indent=4) + "\n")
print("prepared", commit, "with", inputs["generated_count"], "fresh generated modules")

inputs["suites"] = [method + "/" + variant for method in ["every", "some"] for variant in ["plain", "scalar", "object", "source", "scalar_source", "list"]]
(doc / "执行输入.json").write_text(json.dumps(inputs, ensure_ascii=False, indent=4) + "\n")
