from pathlib import Path
import hashlib
import json
import re
import subprocess
import sys

root = Path(sys.argv[1]).resolve()
doc = Path(__file__).resolve().parent
results = []

for mode in ["Debug", "ReleaseSafe"]:
    evidence = json.loads((doc / f"新门禁{mode}证据.json").read_text())
    initial = json.loads((doc / f"首轮{mode}证据.json").read_text())
    binaries = {
        Path(item["path"]).name: item
        for item in initial["logged_zig_test_binaries"]
        if Path(item["path"]).name != "function-effects-resources"
    }
    binaries.update({Path(item["path"]).name: item for item in evidence["logged_zig_test_binaries"]})

    assert len(binaries) == 3

    for item in binaries.values():
        binary = Path(item["path"])
        kind = binary.name.removeprefix("function-effects-")
        source = root / f"packages/test/tests/ir/effects/{kind}_test.zig"
        names = re.findall(r'^test "([^"]+)"', source.read_text(), re.MULTILINE)

        assert names
        assert hashlib.sha256(binary.read_bytes()).hexdigest() == item["sha256"]

        completed = subprocess.run([str(binary)], cwd=root, capture_output=True, timeout=180)
        raw = completed.stdout + completed.stderr
        lines = raw.decode().splitlines()
        successes = [line for line in lines if line.endswith("...OK")]

        assert completed.returncode == 0, raw.decode()
        assert len(successes) == len(names), raw.decode()

        for name in names:
            assert sum(f".test.{name}...OK" in line for line in successes) == 1, name

        saved = doc / "日志" / f"重放{mode}-{kind}.txt"
        saved.write_bytes(raw)
        results.append({
            "mode": mode,
            "kind": kind,
            "binary": item,
            "source": str(source.relative_to(root)),
            "source_sha256": hashlib.sha256(source.read_bytes()).hexdigest(),
            "names": names,
            "exit_code": completed.returncode,
            "log": str(saved.relative_to(doc)),
            "log_sha256": hashlib.sha256(raw).hexdigest(),
        })

(doc / "二进制重放证据.json").write_text(json.dumps(results, ensure_ascii=False, indent=2) + "\n")
print("PASS: actual named native checks", sum(len(item["names"]) for item in results))
