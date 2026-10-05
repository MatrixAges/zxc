import hashlib
import json
from pathlib import Path
import subprocess
import sys
import tempfile


sources = {str(path): path.read_bytes() for path in sorted(Path("packages").rglob("*.zx")) if "node_modules" not in path.parts}

for path in sorted(Path("packages/test/tests/language").rglob("*.jsonl")):
    for line in path.read_text().splitlines():
        case = json.loads(line)

        if "source_hex" in case:
            sources[str(path) + ":" + case["id"]] = bytes.fromhex(case["source_hex"])
        elif "source" in case:
            sources[str(path) + ":" + case["id"]] = case["source"].encode()

for value in sys.argv[3:]:
    path = Path(value)
    sources[str(path)] = path.read_bytes()

records = []
operators = set()

with tempfile.TemporaryDirectory(prefix="zxc-expression-hints-") as directory:
    source_path = Path(directory) / "source.zx"

    for name, source in sources.items():
        source_path.write_bytes(source)
        result = json.loads(subprocess.check_output([sys.argv[1], str(source_path)]))
        actual = result["actual"]
        streams = [actual["hints"], *actual["interpolation_hints"]]
        hints = [hint for stream in streams for hint in stream]
        operators.update(hint["binary"]["operator"] for hint in hints)
        failed = result["expected"] != actual
        records.append({"source": name, "sha256": hashlib.sha256(source).hexdigest(), "tokens": len(hints), "lambdas": sum(hint["lambda"] for hint in hints), "generic": sum(hint["generic"] for hint in hints), "failed": failed})

        if failed:
            Path(sys.argv[2]).with_suffix(".failure.json").write_text(json.dumps({"source": name, **result}, ensure_ascii=False, indent=2) + "\n")

result = {"sources": len(records), "tokens": sum(item["tokens"] for item in records), "lambdas": sum(item["lambdas"] for item in records), "generic": sum(item["generic"] for item in records), "operators": sorted(operators), "failures": sum(item["failed"] for item in records), "records": records}
Path(sys.argv[2]).write_text(json.dumps(result, ensure_ascii=False, indent=2) + "\n")
print(json.dumps({key: value for key, value in result.items() if key != "records"}))

if result["failures"]:
    raise SystemExit(1)
