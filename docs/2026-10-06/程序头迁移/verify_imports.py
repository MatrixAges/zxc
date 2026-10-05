import json
from pathlib import Path
import re
import subprocess
import tempfile


root = Path(__file__).resolve().parents[3]
sources = [(str(path.relative_to(root)), path.read_bytes()) for path in sorted(
    (root / "packages/compiler/src/zx/frontend/parser").rglob("*.zx")
)]

fixtures = root / "packages/test/tests/formatting/zx/imports"

for path in sorted(fixtures.glob("*.zig")):
    for index, match in enumerate(re.finditer(r'\bsource = ("(?:[^"\\]|\\.)*")', path.read_text())):
        source = json.loads(match[1])

        if source.startswith("import "):
            sources.append((f"{path.relative_to(root)}:source:{index}", source.encode()))

keywords = root / "packages/test/tests/language/lexical/identifiers/keywords/cases.jsonl"

for line in keywords.read_text().splitlines():
    row = json.loads(line)

    if "import " in row["source"]:
        sources.append((f"{keywords.relative_to(root)}:{row['id']}", row["source"].encode()))

failures = []
parses = 0
diagnostics = 0

with tempfile.TemporaryDirectory(prefix="zxc_import_replay_") as directory:
    source_path = Path(directory) / "source.zx"

    for label, source in sources:
        source_path.write_bytes(source)
        result = subprocess.run(["/tmp/zxc_import_reference", str(source_path)], capture_output=True, text=True, check=True)

        for line in result.stdout.splitlines():
            record = json.loads(line)
            expected = record["expected"]
            actual = record["actual"]
            parses += 1
            diagnostics += bool(expected["diagnostic"]["message"])

            if expected["diagnostic"]["message"]:
                actual["names"] = actual["names"][:len(expected["names"])]

            if expected != actual:
                failures.append({"source": label, **record})

report = {
    "sources": len(sources),
    "parses": parses,
    "diagnostics": diagnostics,
    "failures": failures,
    "boundary": "Existing source replay only. Uncommitted name-table entries are ignored on failure. Path token spans are compared; path decoding remains in the future AST adapter.",
}
Path(__file__).with_name("导入序列核对.json").write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n")
print(json.dumps({key: value if key != "failures" else len(value) for key, value in report.items()}, ensure_ascii=False))

if failures:
    raise SystemExit(1)
