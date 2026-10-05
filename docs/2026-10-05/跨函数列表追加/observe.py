import hashlib
import json
from pathlib import Path
import subprocess
import sys


folder = Path(__file__).resolve().parent
entry = Path(sys.argv[1]).resolve()
sources = sorted({path.resolve() for root in sys.argv[2:] for path in Path(root).rglob("*.zx")})

subprocess.run(["zig", "build", "-Doptimize=ReleaseSafe", "--summary", "all"], cwd=folder, check=True)

with (folder / "来源观测.jsonl").open("w") as output:
    subprocess.run(
        [str(folder / "zig-out/bin/list-flow-observe"), str(entry), *map(str, sources)],
        stdout=output,
        check=True,
    )

record = {
    "entry": str(entry),
    "sources": [{"path": str(path), "sha256": hashlib.sha256(path.read_bytes()).hexdigest()} for path in sources],
    "code_generation_enabled": False,
}

(folder / "观测输入.json").write_text(json.dumps(record, ensure_ascii=False, indent=2) + "\n")
