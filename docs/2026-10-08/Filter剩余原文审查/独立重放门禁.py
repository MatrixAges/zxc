from pathlib import Path
import hashlib
import json
import subprocess


doc = Path(__file__).resolve().parent
baseline = json.loads((doc / "执行输入.json").read_text())
root = Path(baseline["root"])
sha = lambda data: hashlib.sha256(data).hexdigest()
assert subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=root, text=True).strip() == baseline["source_commit"]

for path, identity in baseline["inputs"].items():
    assert sha((root / path).read_bytes()) == identity, path
    assert sha((Path(baseline["snapshot"]) / path).read_bytes()) == identity, path

records = []

for mode in ["Debug", "ReleaseSafe"]:
    first = json.loads((doc / ("首轮" + mode + "完整证据.json")).read_text())
    assert first["passed"] and len(first["actual_executions"]) == 8

    for run in first["actual_executions"]:
        binary = Path(run["path"])
        assert sha(binary.read_bytes()) == run["sha256"]
        name = run["compiled"]["name"]
        log = doc / "日志" / (mode + "重放-" + name + ".txt")

        with log.open("wb") as output:
            result = subprocess.run([str(binary)], stdout=output, stderr=subprocess.STDOUT, timeout=60)

        assert result.returncode == 0, str(log)
        tests = sum(line.endswith("...OK") for line in log.read_text().split("\n"))
        assert tests > 0
        records.append({
            "mode": mode, "name": name, "command": [str(binary)],
            "binary_sha256": run["sha256"], "exit_code": result.returncode,
            "tests": tests, "compiled": run["compiled"],
            "log": str(log.relative_to(doc)), "log_sha256": sha(log.read_bytes()),
        })

    total = sum(item["tests"] for item in records if item["mode"] == mode)
    assert total == 121
    print(mode, "actual binaries", 8, "actual named checks", total)

(doc / "最终实际执行证据.json").write_text(json.dumps(records, ensure_ascii=False, indent=2) + "\n")
