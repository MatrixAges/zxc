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

external = {}

for mode in ["Debug", "ReleaseSafe"]:
    copy(run / ("final-" + mode + "-state.json"), "final-" + mode + "-state.json.txt")

    for phase in ["generation", "execution"]:
        source = run / (mode + "-" + phase + ".json")
        state = json.loads(source.read_text())
        assert state["status"] == "terminal" and state["exit_code"] == 0
        copy(source, mode + "-" + phase + ".json.txt")

    generation = json.loads((run / (mode + "-generation.json")).read_text())
    execution = json.loads((run / (mode + "-execution.json")).read_text())

    for program in generation["programs"]:
        for name in program["files"]:
            source = Path(name)
            copy(source, "生成源码/" + mode + "/" + program["name"] + "/" + source.name + ".txt")

    for entry in execution["executions"]:
        for name in ["execution.json", "execution.log", "options.zig"]:
            source = Path(entry["directory"]) / name
            copy(source, "日志/" + str(source.relative_to(run)) + ".txt")

    for name, identity in generation["external"].items():
        source = Path(name)
        assert sha(source.read_bytes()) == identity
        saved = "外部输入/" + identity + "/" + source.name + ".txt"
        copy(source, saved)
        external[name] = {"sha256": identity, "saved": saved}

    for source in (run / mode).glob("*.txt"):
        copy(source, "日志/" + mode + "/" + source.name)

for source in run.glob("*.txt"):
    copy(source, "日志/" + source.name)

checks = [
    ("类型检查.txt", ["/usr/local/bin/node", "node_modules/typescript/bin/tsc", "--ignoreConfig", "--noEmit", "--allowImportingTsExtensions", "--module", "nodenext", "--target", "esnext", "--types", "node", "--strict", "--skipLibCheck", "tests/ownership/field_facts/runtime/run_test.ts", "tests/ownership/field_facts/runtime/arguments.ts"]),
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
(doc / "外部输入.json").write_text(json.dumps(external, ensure_ascii=False, indent=4) + "\n")
(doc / "证据归档.json").write_text(json.dumps(archive, ensure_ascii=False, indent=4) + "\n")
print("archived", len(archive), "current evidence files")
