from pathlib import Path

import ast
import hashlib
import json
import subprocess

doc = Path(__file__).resolve().parent
inputs = json.loads((doc / "执行输入.json").read_text())
root = Path(inputs["root"])
run = Path(inputs["run"])
main = doc.parents[2]
formal = inputs["formal"]
node = "/usr/local/bin/node"
commands = [
    ("catalog", [node, "src/generate_immutable_list.ts", "--check"]),
    ("audit", [node, "src/audit_matrix.ts"]),
    ("strict-types", [node, str(main / "packages/test/node_modules/typescript/bin/tsc"), "--ignoreConfig", "--noEmit", "--allowImportingTsExtensions", "--module", "nodenext", "--target", "esnext", "--types", "node", "--typeRoots", str(main / "packages/test/node_modules/@types"), "--strict", "--skipLibCheck", *[str(root / name) for name in formal if name.endswith(".ts")]]),
    ("spacing", [node, str(main / "scripts/format.mjs"), "--check", *[str(root / name) for name in formal if name.endswith(".zig")]]),
    ("prettier", [node, str(main / "node_modules/.pnpm/prettier@3.9.8/node_modules/prettier/bin/prettier.cjs"), "--check", *[str(root / name) for name in formal if name.endswith((".ts", ".json"))]]),
    ("original-runner-syntax", [node, "--check", str(doc / "执行原文.mjs")]),
]
commands += [("ast-" + str(index), [inputs["zig"], "ast-check", str(root / name)]) for index, name in enumerate(formal) if name.endswith(".zig")]
records = []
for name, command in commands:
    log = run / (name + ".txt")
    with log.open("wb") as output:
        result = subprocess.run(command, cwd=root / "packages/test", stdout=output, stderr=subprocess.STDOUT)
    records.append({"name": name, "command": command, "exit_code": result.returncode, "log": str(log), "log_sha256": hashlib.sha256(log.read_bytes()).hexdigest()})
    print(name, result.returncode, flush=True)
    assert result.returncode == 0, log.read_text()
for name in formal:
    if name.endswith(".zx"):
        path = root / name
        count = len(path.read_text().splitlines())
        assert count <= 120
        records.append({"name": "ZX line count", "path": name, "lines": count, "sha256": hashlib.sha256(path.read_bytes()).hexdigest(), "exit_code": 0})
for path in doc.glob("*.py"):
    ast.parse(path.read_text())
    records.append({"name": "Python syntax", "path": str(path), "sha256": hashlib.sha256(path.read_bytes()).hexdigest(), "exit_code": 0})
(doc / "静态检查.json").write_text(json.dumps(records, ensure_ascii=False, indent=4) + "\n")
print("PASS:", len(records), "static checks")
