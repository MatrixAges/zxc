from pathlib import Path
import hashlib
import json
import sys

root = Path(sys.argv[1]).resolve()
doc = Path(__file__).resolve().parent
freeze = json.loads((doc / "输入冻结.json").read_text())
for record in freeze["paths"]:
    content = (root / record["path"]).read_bytes()
    assert hashlib.sha256(content).hexdigest() == record["sha256"], record["path"]
    assert content == (doc.parent / "草稿" / record["path"]).read_bytes(), record["path"]

binaries = 0
checks = 0
panics = 0
errors = 0
for label in ["Debug", "ReleaseSafe"]:
    evidence = json.loads((doc / f"{label}证据.json").read_text())
    assert evidence["source_commit"] == freeze["source_commit"]
    assert len(evidence["records"]) == len({item["name"] for item in evidence["records"]}) == 42
    assert hashlib.sha256((doc / evidence["log_path"]).read_bytes()).hexdigest() == evidence["log_sha256"]
    for record in evidence["records"]:
        binary = Path(record["binary"])
        assert hashlib.sha256(binary.read_bytes()).hexdigest() == record["sha256"], record["name"]
        catalog = root / record["catalog"]
        assert hashlib.sha256(catalog.read_bytes()).hexdigest() == record["catalog_sha256"]
        replay = (doc / record["replay"]).read_bytes()
        assert hashlib.sha256(replay).hexdigest() == record["replay_sha256"]
        actual = [json.loads(line) for line in replay.splitlines()]
        original = [json.loads(line) for line in catalog.read_bytes().splitlines()]
        assert len(actual) == len(original) == record["checks"]
        assert len({row["id"] for row in actual}) == len(actual)
        for result, row in zip(actual, original):
            assert result["id"] == row["id"] and result["passed"]
            if record["kind"] == "compound":
                assert result["signal"] is None and result["stdout"] == "" and not result.get("error")
                assert result["status"] == row["expected"]["status"] and result["stderr"] == row["expected"]["stderr"]
                args = row["arguments"]
                snapshot = f"ZX_REQUEST={args[0]},{args[1]},{args[2]},{args[3]},{args[4]},{0 if args[5] == 'true' else 3},1\n"
                assert result["stderr"].endswith(snapshot + f"ZX_INPUT=7,{args[1]},3,9,11\n")
                if row["arguments"][3] == "0":
                    assert result["status"] == 0 and result["stderr"].startswith("ZX_RESULT=")
                if result["status"] == 86:
                    assert result["stderr"].startswith(("ZX_PANIC=integer overflow\n", "ZX_PANIC=division by zero\n"))
            else:
                assert result["returncode"] == (86 if "panic" in row["expected"] else 0)
        assert record["panics"] > 0
        panics += record["panics"]
        errors += record["application_errors"]
        binaries += 1
        checks += record["checks"]
    assert sum(item["checks"] for item in evidence["records"] if item["kind"] == "compound") == 50280
    assert sum(item["checks"] for item in evidence["records"] if item["kind"] == "expression") == 464
    for artifact in evidence["artifacts"]:
        assert hashlib.sha256((doc / artifact["path"]).read_bytes()).hexdigest() == artifact["sha256"]
assert binaries == 84 and checks == 101488
print(f"PASS: {len(freeze['paths'])} frozen paths, {binaries} binary hashes, {checks} process checks, {panics} observed panics, {errors} application errors")
