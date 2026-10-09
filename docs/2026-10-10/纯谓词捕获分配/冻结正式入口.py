from pathlib import Path

import hashlib
import json
import shutil


doc = Path(__file__).resolve().parent
inputs_path = doc / "执行输入.json"
inputs = json.loads(inputs_path.read_text())
root = Path(inputs["root"])
run = Path(inputs["run"])
sha = lambda data: hashlib.sha256(data).hexdigest()
assert not (run / "registered-execution.json").exists()
for mode in ["Debug", "ReleaseSafe"]:
    state = json.loads((run / (mode + "-execution.json")).read_text())
    assert state["status"] == "terminal" and state["exit_code"] == 0
for name, identity in inputs["formal_sha256"].items():
    assert sha((root / name).read_bytes()) == identity
(run / "preintegration-inputs.json.txt").write_bytes(inputs_path.read_bytes())
formal = [str(path.relative_to(doc / "草稿")) for path in sorted((doc / "草稿").rglob("*")) if path.is_file()]
assert len(formal) == 17
for name in formal:
    path = root / name
    path.parent.mkdir(parents=True, exist_ok=True)
    shutil.copyfile(doc / "草稿" / name, path)
inputs["formal"] = formal
inputs["formal_sha256"] = {name: sha((root / name).read_bytes()) for name in formal}
inputs["packages"] = {name: identity for name, identity in inputs["packages"].items() if name not in formal}
for path in [doc / "执行正式驱动.py", Path("/usr/local/bin/node"), root / "packages/test/tests/ownership/field_facts/runtime/arguments.ts"]:
    inputs["tools"][str(path)] = sha(path.read_bytes())
inputs_path.write_text(json.dumps(inputs, ensure_ascii=False, indent=4) + "\n")
print("17 formal paths frozen after both independent execution cohorts ended")
