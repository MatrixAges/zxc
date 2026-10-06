import argparse
import hashlib
import json
import subprocess
import time
from pathlib import Path


parser = argparse.ArgumentParser()
parser.add_argument("before")
parser.add_argument("after")
parser.add_argument("--frames", action="store_true")
parser.add_argument("--prefix", default="")
args = parser.parse_args()
directory = Path(__file__).resolve().parent
root = directory.parents[3]
if args.frames:
    fixture = root / "packages/test/tests/rx/text/resources_test.zig"
    scales = [255, 256, 257, 1024]
    prefix = "帧栈"
else:
    fixture = root / "packages/test/tests/runtime/gateway/fixtures/main.gateway.rx"
    source = fixture.read_text()
    start = source.index(">") + 1
    end = source.rindex("</Gateway>")
    scales = [8, 16, 32, 64]
    prefix = ""
results = {}
prefix = args.prefix or prefix

for label, executable in [("修复前", args.before), ("修复后", args.after)]:
    rows = []

    for scale in scales:
        if args.frames:
            path = directory / f"nested_{scale}.rx"
            path.write_text("<A>" * scale + "</A>" * scale)
        else:
            path = directory / f"gateway_{scale}.rx"
            path.write_text(source[:start] + source[start:end] * scale + source[end:])
        started = time.perf_counter()
        output = subprocess.run(
            [executable, str(path)], capture_output=True, text=True, check=True
        )
        elapsed = time.perf_counter() - started
        row = json.loads(output.stdout)
        row.update(scale=scale, wall_seconds=elapsed)
        rows.append(row)

    results[label] = rows
    (directory / f"{prefix}{label}.json").write_text(
        json.dumps(rows, ensure_ascii=False, indent=2) + "\n"
    )

comparison = {
    "fixture": str(fixture.relative_to(root)),
    "fixture_sha256": hashlib.sha256(fixture.read_bytes()).hexdigest(),
    "measure": "arena capacity after generated XML parsing; wall time includes process startup, input IO and result hashing",
    "rows": [
        {
            "scale": before["scale"],
            "same_result": before["digest"] == after["digest"],
            "before_bytes": before["arena_bytes"],
            "after_bytes": after["arena_bytes"],
        }
        for before, after in zip(results["修复前"], results["修复后"])
    ],
}

(directory / f"{prefix}对照.json").write_text(
    json.dumps(comparison, ensure_ascii=False, indent=2) + "\n"
)
print(json.dumps(comparison, ensure_ascii=False, indent=2))
