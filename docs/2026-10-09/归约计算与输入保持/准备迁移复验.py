from pathlib import Path

import hashlib
import json
import re
import shutil
import subprocess

doc = Path(__file__).resolve().parent
main = doc.parents[2]
old = json.loads((doc / "执行输入.json").read_text())
old_run = Path(old["run"])
root = Path.home() / ".codex/worktrees/reduce-fold-flow-state-conformance/zxc"
run = Path.home() / ".codex/conformance/reduce-fold-flow-state-30fa25f4b/r1"
commit = "30fa25f4b14cf092cb28a5bf98fa3754440c0d60"
sha = lambda data: hashlib.sha256(data).hexdigest()
assert old["source_commit"] != commit, "migration cohort already prepared; inspect the recorded execution state"
assert subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=root, text=True).strip() == commit

for mode in ["Debug", "ReleaseSafe"]:
    state = json.loads((old_run / (mode + "-execution.json")).read_text())
    assert state["status"] == "terminal" and state["exit_code"] == 0

archive = doc / "迁移前固定版本"
archive.mkdir(exist_ok=True)

if not (archive / "证据清单.json.txt").exists():
    shutil.move(str(doc / "执行证据"), str(archive / "执行证据"))
    manifest = json.loads((doc / "证据清单.json").read_text())

    for entry in manifest:
        entry["saved"] = "迁移前固定版本/" + entry["saved"]

    (archive / "证据清单.json.txt").write_text(json.dumps(manifest, ensure_ascii=False, indent=4) + "\n")

    for name in ["执行输入.json", "静态检查.json", "运行门禁.py", "核验执行证据.py", "执行生成器.py"]:
        (archive / (name + ".txt")).write_bytes((doc / name).read_bytes())

run.mkdir(parents=True, exist_ok=True)
(run / "generated").mkdir(exist_ok=True)
inputs = old.copy()
inputs.update(root=str(root), run=str(run), source_commit=commit, generated_count=89, template_root=str(root), template_run=str(run))

for name in old["formal"]:
    target = root / name
    target.parent.mkdir(parents=True, exist_ok=True)
    shutil.copyfile(doc / "草稿" / name, target)

command = [argument.replace(old["root"], str(root)).replace(old["run"], str(run)) for argument in old["generator_compile"]]
groups = []
pending = []

for argument in command[2:]:
    pending.append(argument)

    if argument.startswith("-M"):
        groups.append(pending)
        pending = []

rebuilt = command[:2]

for group in groups:
    module = group[-1].split("=", 1)[0][2:]

    if module in ["flow_workspace", "flow_state_interface"]:
        continue

    cleaned = []
    index = 0

    while index < len(group):
        if group[index] == "--dep" and group[index + 1] in ["flow_workspace", "flow_state_interface"]:
            index += 2
            continue

        cleaned.append(group[index])
        index += 1

    if module == "frontend":
        cleaned[-1:-1] = ["--dep", "refinement_seed"]

    rebuilt += cleaned

rebuilt += ["-Odebug", "--dep", "zx", "-Mrefinement_seed=" + str(root / "packages/compiler/bootstrap/refinement.zig")]
inputs["generator_compile"] = rebuilt + pending
inputs["generator_run"] = [argument.replace(old["root"], str(root)).replace(old["run"], str(run)) for argument in old["generator_run"]]
inputs["generator_run"][-2:-2] = [str(run / "generated" / (name + ".zig")) for name in ["refinement_mark", "refinement_restore", "refinement_add"]]
formal_command = json.loads((main / "docs/2026-10-09/流程状态自举/正式构建命令.json").read_text())[0]

if formal_command[0] == "info(verbose):":
    formal_command = formal_command[1:]

module_groups = {}
group = []

for argument in formal_command[2:]:
    group.append(argument)

    if argument.startswith("-M"):
        module_groups[argument.split("=", 1)[0][2:]] = group
        group = []

needed = set()
pending_modules = ["compiler"]

while pending_modules:
    name = pending_modules.pop()

    if name in needed:
        continue

    needed.add(name)
    module = module_groups[name]
    pending_modules += [module[index + 1].split("=")[-1] for index, argument in enumerate(module[:-1]) if argument == "--dep"]

formal_command = formal_command[:2] + ["-Osafe", "--dep", "compiler", module_groups["root"][-1]] + [argument for name, module in module_groups.items() if name in needed for argument in module] + group
inputs["compile_templates"] = {}
inputs["external"] = {}


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


generated_names = {Path(argument).name for argument in inputs["generator_run"][2:-1]} | {"lexer.zig"}

for mode in ["Debug", "ReleaseSafe"]:
    adapted = []

    for argument in formal_command:
        if argument == "--listen=-":
            continue

        if argument.startswith("-O"):
            argument = "-O" + mode
        elif argument.startswith("-M"):
            prefix, value = argument.split("=", 1)
            path = Path(value)

            if prefix == "-Mroot":
                adapted += ["--dep", "library_output"]
                value = str(root / "packages/test/tests/ownership/field_facts/runtime/compile.zig")
            elif prefix == "-Mstandard_interfaces":
                value = str(run / "standard/catalog.zig")
            elif value.startswith("packages/"):
                value = str(root / value)
            elif path.name in generated_names:
                value = str(run / "generated" / path.name)
            else:
                value = snapshot(path if path.is_absolute() else main / path)

            argument = prefix + "=" + value

        adapted.append(argument)

    adapted[0] = inputs["zig"]
    adapted[adapted.index("--cache-dir") + 1] = str(run / ("cache-host-" + mode))
    adapted[adapted.index("--global-cache-dir") + 1] = str(run / "cache-global")
    adapted += ["-O" + mode, "-Mlibrary_output=" + str(root / "packages/test/tests/library/runtime/save.zig"), "-femit-bin=" + str(run / mode / "compile-folds"), "--entitlements", inputs["entitlements"]]
    inputs["compile_templates"][mode] = adapted

for index, argument in enumerate(inputs["generator_compile"]):
    if not argument.startswith("-M"):
        continue

    prefix, value = argument.split("=", 1)
    path = Path(value)

    if prefix == "-Mstandard_interfaces":
        inputs["generator_compile"][index] = prefix + "=" + str(run / "standard/catalog.zig")
    elif path.is_absolute() and not value.startswith(str(root) + "/") and not value.startswith(str(run) + "/"):
        inputs["generator_compile"][index] = prefix + "=" + snapshot(path)

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
inputs["previous"] = {"root": old["root"], "run": old["run"], "source_commit": old["source_commit"], "manifest": str((archive / "证据清单.json.txt").relative_to(doc))}
(doc / "执行输入.json").write_text(json.dumps(inputs, ensure_ascii=False, indent=4) + "\n")
print("prepared", commit, "with 89 fresh generated module outputs and", len(inputs["external"]), "external snapshots")
