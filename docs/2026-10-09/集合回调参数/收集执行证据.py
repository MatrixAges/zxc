from pathlib import Path

import hashlib
import json
import shutil
import subprocess

doc = Path(__file__).resolve().parent
inputs = json.loads((doc / "执行输入.json").read_text())
root = Path(inputs["root"])
run = Path(inputs["run"])
sha = lambda data: hashlib.sha256(data).hexdigest()
archive = {}


def copy(source, target):
    destination = doc / target
    destination.parent.mkdir(parents=True, exist_ok=True)
    shutil.copyfile(source, destination)
    archive[target] = {"source": str(source), "sha256": sha(destination.read_bytes())}


copy(run / "generator-state.json", "生成器证据.json.txt")

for source in (run / "generated").glob("*.zig"):
    copy(source, "生成源码/编译模块/" + source.name + ".txt")

for mode in ["Debug", "ReleaseSafe"]:
    for phase in ["generation", "execution", "pure"]:
        path = run / (mode + "-" + phase + ".json")
        state = json.loads(path.read_text())
        assert state["status"] == "terminal" and state["exit_code"] == 0
        copy(path, mode + "-" + phase + ".json.txt")

    generation = json.loads((run / (mode + "-generation.json")).read_text())

    for program in generation["programs"]:
        for name in program["files"]:
            source = Path(name)
            copy(source, "生成源码/" + mode + "/" + program["name"] + "/" + source.name + ".txt")

    for method in ["map", "filter", "every", "some"]:
        copy(run / mode / (method + "-pure.zig"), "生成源码/" + mode + "/" + method + "-pure.zig.txt")
        copy(run / (method + "-cases.zig"), "生成源码/纯值测试/" + method + "-cases.zig.txt")

runtime_directories = [
    Path(entry["directory"])
    for mode in ["Debug", "ReleaseSafe"]
    for entry in json.loads((run / (mode + "-execution.json")).read_text())["executions"]
]
logs = [*run.glob("*.txt"), *[path for mode in ["Debug", "ReleaseSafe"] for path in (run / mode).glob("*.txt")], *[directory / "execution.log" for directory in runtime_directories]]

for path in logs:
    copy(path, "日志/" + str(path.relative_to(run)) + (".txt" if path.suffix == ".log" else ""))

for path in [directory / "execution.json" for directory in runtime_directories]:
    copy(path, "日志/" + str(path.relative_to(run)) + ".txt")
    options = path.parent / "options.zig"
    copy(options, "日志/" + str(options.relative_to(run)) + ".txt")

external = {}

for mode in ["Debug", "ReleaseSafe"]:
    generation = json.loads((run / (mode + "-generation.json")).read_text())

    for name, identity in generation["external"].items():
        path = Path(name)
        assert sha(path.read_bytes()) == identity
        target = "外部输入/" + identity + "/" + path.name + ".txt"
        copy(path, target)
        external[name] = {"sha256": identity, "saved": target}

(doc / "外部输入.json").write_text(json.dumps(external, ensure_ascii=False, indent=4) + "\n")

checks = [
    ("类型检查.txt", ["/usr/local/bin/node", "node_modules/typescript/bin/tsc", "--ignoreConfig", "--noEmit", "--allowImportingTsExtensions", "--module", "nodenext", "--target", "esnext", "--types", "node", "--strict", "--skipLibCheck", "src/generate_callback_arguments.ts", "tests/collections/callback_arguments/run_test.ts"]),
    ("生成幂等.txt", ["/usr/local/bin/node", "src/generate_callback_arguments.ts", "--check"]),
    ("矩阵审计.json.txt", ["/usr/local/bin/node", "src/audit_matrix.ts"]),
]
records = []

for name, command in checks:
    result = subprocess.run(command, cwd=root / "packages/test", capture_output=True)
    path = doc / name
    path.write_bytes(result.stdout + result.stderr)
    assert result.returncode == 0, path.read_text()
    records.append({"command": command, "exit_code": result.returncode, "log": name, "sha256": sha(path.read_bytes())})

(doc / "静态检查.json").write_text(json.dumps(records, ensure_ascii=False, indent=4) + "\n")
(doc / "证据归档.json").write_text(json.dumps(archive, ensure_ascii=False, indent=4) + "\n")
print("archived", len(archive), "evidence files")
