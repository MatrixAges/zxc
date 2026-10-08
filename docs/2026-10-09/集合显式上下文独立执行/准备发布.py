from pathlib import Path
import hashlib
import json
import subprocess


doc = Path(__file__).resolve().parent
root = doc.parents[2]
probe = root / "docs/2026-10-09/原生工具启动阻塞核验"
baseline = json.loads((doc / "执行输入.json").read_text())
formal = baseline["formal_files"]
sha = lambda path: hashlib.sha256(path.read_bytes()).hexdigest()
protected = {
    path: sha(root / path)
    for path in subprocess.check_output(["git", "ls-files", "packages"], cwd=root, text=True).split("\n")
    if path and path not in formal and (root / path).is_file()
}
foreign = [root / path for path in ["AGENTS.md", "package.json", "pnpm-lock.yaml", "pnpm-workspace.yaml", "docs/2026-10-04/RX状态联结/.DS_Store", "docs/2026-10-08/用户目标.md"]]
foreign.extend(path for path in (root / "docs/2026-10-08/用户目标整理").rglob("*") if path.is_file())
ds = "docs/2026-10-04/RX状态联结/.DS_Store"
publication = {
    "parent": subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=root, text=True).strip(),
    "foreign_path": ds,
    "foreign_sha256": sha(root / ds),
    "foreign_inputs": {str(path.relative_to(root)): sha(path) for path in foreign if path.exists()},
    "protected_inputs": protected,
}
(doc / "发布基线.json").write_text(json.dumps(publication, ensure_ascii=False, indent=4) + "\n")
paths = set(formal)

for directory in [doc, probe]:
    paths.update(str(path.relative_to(root)) for path in directory.rglob("*") if path.is_file())

paths.add(str((doc / "提交文件清单.json").relative_to(root)))
manifest = sorted(paths)
(doc / "提交文件清单.json").write_text(json.dumps(manifest, ensure_ascii=False, indent=4) + "\n")
assert not subprocess.check_output(["git", "diff", "--cached", "--name-only"], cwd=root)
subprocess.run(["git", "add", "--", *manifest], cwd=root, check=True)
print(json.dumps({"files": len(manifest), "protected": len(protected), "foreign": len(publication["foreign_inputs"]), "parent": publication["parent"]}))
