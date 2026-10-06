import hashlib
import json
import os
from pathlib import Path
import re
import subprocess


doc = Path(__file__).resolve().parent
manifest = json.loads((doc / "输入清单.json").read_text())
fixed = Path(manifest["cwd"]).parents[1]
records = []
outputs = {}
for mode in ["Debug", "ReleaseSafe"]:
    cache = Path("/tmp/zxc-detached-reader-" + mode.lower() + "-" + manifest["source"][:8])
    compilers = [p for p in cache.rglob("zxc") if p.is_file() and os.access(p, os.X_OK)]
    assert len(compilers) == 1
    compiled = {}
    for path in cache.rglob("program.zig"):
        compiled.setdefault(hashlib.sha256(path.read_bytes()).hexdigest(), []).append(str(path))
    for kind in ["legacy", "increment", "square", "object_key"]:
        suite = "language/expressions/arrow/bodies/cases" if kind == "legacy" else "language/expressions/arrow/returns/" + kind + "/cases"
        name = "arrow-bodies-cases" if kind == "legacy" else "arrow-bodies-returns-" + kind
        rows = [json.loads(line) for line in (fixed / "packages/test/tests" / (suite + ".jsonl")).read_text().splitlines()]
        expected = {row["id"] for row in rows}
        binaries = [p for p in cache.rglob(name) if p.is_file() and os.access(p, os.X_OK)]
        assert len(binaries) == 1
        binary = binaries[0]
        argv = [str(binary), "--seed=0x1262"]
        result = subprocess.run(argv, capture_output=True, text=True)
        raw = result.stdout + result.stderr
        passed = set(re.findall(r"\d+/\d+ cases\.test\.(.+)\.\.\.OK", raw))
        assert result.returncode == 0 and passed == expected
        assert "All " + str(len(rows)) + " tests passed." in raw
        target = doc / "生成产物" / mode / kind
        target.mkdir(parents=True, exist_ok=True)
        (target / "执行原始日志.txt").write_text(raw)
        program = target / "program.txt"
        compile_argv = [str(compilers[0]), str(fixed / "packages/test/tests" / (suite + ".zx")), "--out", str(program)]
        emitted = subprocess.run(compile_argv, cwd=manifest["cwd"], capture_output=True, text=True)
        assert emitted.returncode == 0, emitted.stderr
        sha = hashlib.sha256(program.read_bytes()).hexdigest()
        assert sha in compiled
        outputs[str(program.relative_to(doc))] = {"sha256": sha, "tested_output_paths": compiled[sha]}
        candidates = []
        for path in cache.rglob("cases.zig"):
            ids = set(re.findall(r'test "([^"\n]+)"', path.read_text()))
            if ids == expected:
                candidates.append(path)
        assert len(candidates) == 1
        cases = target / "cases.txt"
        cases.write_bytes(candidates[0].read_bytes())
        outputs[str(cases.relative_to(doc))] = {"sha256": hashlib.sha256(cases.read_bytes()).hexdigest(), "tested_output_paths": [str(candidates[0])]}
        records.append({"mode": mode, "suite": suite, "name": name, "argv": argv, "exit_code": result.returncode, "actual_passes": len(passed), "case_ids": sorted(passed), "binary_sha256": hashlib.sha256(binary.read_bytes()).hexdigest(), "raw_log": str((target / "执行原始日志.txt").relative_to(doc)), "log_sha256": hashlib.sha256(raw.encode()).hexdigest(), "compile_argv": compile_argv, "emit_exit_code": emitted.returncode})
(doc / "产物清单.json").write_text(json.dumps(outputs, ensure_ascii=False, indent=2) + "\n")
(doc / "实际执行结果.json").write_text(json.dumps(records, ensure_ascii=False, indent=2) + "\n")
print(json.dumps({mode: sum(item["actual_passes"] for item in records if item["mode"] == mode) for mode in ["Debug", "ReleaseSafe"]}))
