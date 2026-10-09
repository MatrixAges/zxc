from pathlib import Path

import hashlib
import json
import shutil
import subprocess

doc = Path(__file__).resolve().parent
main = doc.parents[2]
inputs = json.loads((doc / "执行输入.json").read_text())
formal = inputs["formal"]
sha = lambda data: hashlib.sha256(data).hexdigest()

subprocess.run(["python3", str(doc / "核验执行证据.py")], check=True)

assert not subprocess.check_output(["git", "diff", "--cached", "--name-only"], cwd=main)
parent = subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=main, text=True).strip()

for name in formal:
    current = main / name
    original = subprocess.run(["git", "show", inputs["source_commit"] + ":" + name], cwd=main, capture_output=True)

    intended = (doc / "草稿" / name).read_bytes()
    if current.exists() and current.read_bytes() == intended:
        continue
    if original.returncode == 0:
        assert current.read_bytes() == original.stdout, name
    else:
        assert not current.exists(), name

protected = {}

advanced = {}
package_files = subprocess.check_output(["git", "ls-files", "-z", "--", "packages"], cwd=main).decode().strip("\0").split("\0")

for name in package_files:
    path = main / name

    if name in formal:
        continue

    identity = sha(path.read_bytes())

    if inputs["packages"].get(name) != identity:
        advanced[name] = {"tested_sha256": inputs["packages"].get(name), "current_sha256": identity}

    protected[name] = identity

status = subprocess.check_output(["git", "status", "--porcelain=v1", "-z", "--untracked-files=all"], cwd=main).decode().split("\0")
foreign = {}

for item in status:
    if not item:
        continue

    name = item[3:]

    if name.startswith(str(doc.relative_to(main)) + "/") or name in formal:
        continue

    path = main / name

    if path.is_file():
        foreign[name] = sha(path.read_bytes())

baseline = {"parent": parent, "tested_source": inputs["source_commit"], "protected_inputs": protected, "foreign_inputs": foreign}
baseline["advanced_package_inputs"] = advanced

baseline["protected_root_inputs"] = {
    name: sha((main / name).read_bytes())

    for name in ["pnpm-lock.yaml", "pnpm-workspace.yaml", "package.json"]
}

(doc / "发布基线.json").write_text(json.dumps(baseline, ensure_ascii=False, indent=4) + "\n")

for name in formal:
    path = main / name

    path.parent.mkdir(parents=True, exist_ok=True)
    shutil.copyfile(doc / "草稿" / name, path)

files = sorted(formal + [str(path.relative_to(main)) for path in doc.rglob("*") if path.is_file() and path.name != "提交文件清单.json" and "__pycache__" not in path.parts])

files.append(str((doc / "提交文件清单.json").relative_to(main)))
(doc / "提交文件清单.json").write_text(json.dumps(sorted(files), ensure_ascii=False, indent=4) + "\n")

print("prepared", len(files), "owned files;", len(protected), "protected package files;", len(foreign), "foreign inputs")
