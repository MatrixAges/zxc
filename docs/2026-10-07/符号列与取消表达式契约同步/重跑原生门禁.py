from pathlib import Path
import hashlib
import json
import re
import subprocess

root = Path.cwd()
doc = Path(__file__).resolve().parent
all_runs = []
for mode in ["Debug", "ReleaseSafe"]:
    first = json.loads((doc / ("首次尝试" + mode + "证据.json")).read_text())
    final = json.loads((doc / (mode + "证据.json")).read_text())
    binaries = first["logged_zig_test_binaries"] + final["logged_zig_test_binaries"]
    assert len(binaries) == 9 and len({item["path"] for item in binaries}) == 9
    checks = 0
    for index, binary in enumerate(binaries):
        data = Path(binary["path"]).read_bytes()
        assert hashlib.sha256(data).hexdigest() == binary["sha256"]
        result = subprocess.run([binary["path"]], cwd=root, capture_output=True, timeout=120)
        output = result.stdout + result.stderr
        saved = doc / "日志" / f"{mode}-原生重跑-{index}.txt"
        saved.write_bytes(output)
        count = re.search(rb"All (\d+) tests passed", output)
        assert result.returncode == 0 and count, output.decode()
        checks += int(count[1])
        all_runs.append({"mode": mode, "binary": binary, "exit_code": result.returncode, "tests": int(count[1]), "log": str(saved.relative_to(doc)), "log_sha256": hashlib.sha256(output).hexdigest()})
    assert checks == 84, checks
(doc / "原生重跑证据.json").write_text(json.dumps({"runs": all_runs, "total_checks": sum(run["tests"] for run in all_runs)}, ensure_ascii=False, indent=2) + "\n")
print("PASS: all 18 original native test binaries executed directly; 168 checks passed")
