import hashlib
import json
import os
from pathlib import Path
import subprocess


doc = Path(__file__).resolve().parent
manifest = json.loads((doc / "输入清单.json").read_text())
modes = ["object", "tuple", "optional", "projection", "nested", "concat", "reference", "reverse"]
outputs = {}
replays = []
for label in ["Debug", "ReleaseSafe", "修复Debug", "修复ReleaseSafe"]:
    manifest = json.loads((doc / ("修复输入清单.json" if label.startswith("修复") else "输入清单.json")).read_text())
    cache = Path("/tmp/zxc-detached-reader-" + label.lower() + "-" + manifest["source"][:8])
    tools = [p for p in cache.rglob("compile-detached-reader") if p.is_file() and os.access(p, os.X_OK)]
    assert len(tools) == 1, tools
    tool = tools[0]
    candidates = {}
    for name in ["source.zig", "source_abi.zig", "library.zig", "library_abi.zig"]:
        candidates[name] = {}
        for path in cache.rglob(name):
            candidates[name].setdefault(hashlib.sha256(path.read_bytes()).hexdigest(), []).append(str(path))
    for mode in modes:
        target = doc / "生成产物" / label / mode
        target.mkdir(parents=True, exist_ok=True)
        paths = [target / name for name in ["source.txt", "source_abi.txt", "library.txt", "library_abi.txt"]]
        argv = [str(tool), mode, *map(str, paths)]
        result = subprocess.run(argv, cwd=manifest["cwd"], capture_output=True, text=True)
        assert result.returncode == 0, result.stderr
        replays.append({"label": label, "mode": mode, "argv": argv, "exit_code": result.returncode, "tool_sha256": hashlib.sha256(tool.read_bytes()).hexdigest()})
        for path, name in zip(paths, candidates):
            sha = hashlib.sha256(path.read_bytes()).hexdigest()
            assert sha in candidates[name], (mode, name, sha)
            outputs[str(path.relative_to(doc))] = {"sha256": sha, "tested_output_paths": candidates[name][sha]}
(doc / "产物清单.json").write_text(json.dumps(outputs, ensure_ascii=False, indent=2) + "\n")
(doc / "生成重放记录.json").write_text(json.dumps(replays, ensure_ascii=False, indent=2) + "\n")
print(json.dumps({"outputs": len(outputs), "emit_replays": len(replays)}))
