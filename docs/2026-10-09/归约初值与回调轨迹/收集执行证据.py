from pathlib import Path

import hashlib
import json
import subprocess

doc = Path(__file__).resolve().parent
inputs = json.loads((doc / "执行输入.json").read_text())
root = Path(inputs["root"])
run = Path(inputs["run"])
sha = lambda data: hashlib.sha256(data).hexdigest()
manifest = []

for path in run.rglob("*"):
    relative = path.relative_to(run)

    if not path.is_file() or any(part.startswith("cache-") for part in relative.parts):
        continue

    if path.suffix not in [".zig", ".json", ".txt", ".log"]:
        continue

    target = doc / "执行证据" / (str(relative) + ".txt")
    target.parent.mkdir(parents=True, exist_ok=True)
    target.write_bytes(path.read_bytes())
    manifest.append({"source": str(path), "saved": str(target.relative_to(doc)), "sha256": sha(path.read_bytes())})

for name, identity in inputs["external"].items():
    path = Path(name)
    assert sha(path.read_bytes()) == identity
    target = doc / "执行证据" / "外部输入" / (identity + ".zig.txt")
    target.parent.mkdir(parents=True, exist_ok=True)
    target.write_bytes(path.read_bytes())
    manifest.append({"source": str(path), "saved": str(target.relative_to(doc)), "sha256": identity})

(doc / "证据清单.json").write_text(json.dumps(manifest, ensure_ascii=False, indent=4) + "\n")

commands = {
    "generator": ["node", "src/generate_reduce_trace.ts", "--check"],
    "audit": ["node", "src/audit_matrix.ts"],
    "typecheck": ["node", str(doc.parents[2] / "packages/test/node_modules/typescript/bin/tsc"), "--ignoreConfig", "--noEmit", "--allowImportingTsExtensions", "--module", "nodenext", "--target", "esnext", "--types", "node", "--typeRoots", str(doc.parents[2] / "packages/test/node_modules/@types"), "--strict", "--skipLibCheck", "src/generate_reduce_trace.ts", "src/models/reduce_trace.ts", "src/emit_reduce_tests.ts"],
}
checks = {}

for name, command in commands.items():
    result = subprocess.run(command, cwd=root / "packages/test", capture_output=True)
    target = doc / "执行证据" / (name + "-check.txt")
    target.write_bytes(result.stdout + result.stderr)
    checks[name] = {"command": command, "exit_code": result.returncode, "saved": str(target.relative_to(doc)), "sha256": sha(target.read_bytes())}
    assert result.returncode == 0, target.read_text()

(doc / "静态检查.json").write_text(json.dumps(checks, ensure_ascii=False, indent=4) + "\n")
print("archived", len(manifest), "execution inputs and results; static checks passed")
