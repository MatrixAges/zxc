import hashlib
import json
from pathlib import Path
import subprocess
import sys
import tempfile


baseline = json.loads(Path(sys.argv[1]).read_text())
reference, generated = sys.argv[2:4]
cases = {}

for path in Path(sys.argv[4]).rglob("*.jsonl"):
    for line in path.read_text().splitlines():
        case = json.loads(line)

        if "source_hex" in case:
            cases[case["id"]] = bytes.fromhex(case["source_hex"])
        elif "source" in case:
            cases[case["id"]] = case["source"].encode()

records = []

with tempfile.TemporaryDirectory(prefix="zxc-list-flow-") as temporary:
    current = Path(temporary) / "source.zx"

    for previous in baseline["records"]:
        identifier = previous["source"]
        source = Path(identifier).read_bytes() if Path(identifier).is_file() else cases[identifier]
        digest = hashlib.sha256(source).hexdigest()

        if digest != previous["sha256"]:
            raise RuntimeError(f"Source changed: {identifier}")

        current.write_bytes(source)
        expected = json.loads(subprocess.check_output([reference, str(current)]))
        actual = json.loads(subprocess.check_output([generated, json.dumps(list(source))]))
        record = {"source": identifier, "sha256": digest, "matched": expected == actual}

        if expected != actual:
            record.update(expected=expected, actual=actual)

        records.append(record)

result = {"count": len(records), "failure_count": sum(not item["matched"] for item in records), "records": records}
Path(sys.argv[5]).write_text(json.dumps(result, ensure_ascii=False, indent=2) + "\n")
print(json.dumps({"count": result["count"], "failure_count": result["failure_count"]}))

if result["failure_count"]:
    raise SystemExit(1)
