import hashlib
import json
import re
import subprocess
from pathlib import Path


root = Path(__file__).resolve().parents[3]
files = sorted(
    path for path in (root / "packages").rglob("*")
    if path.suffix in (".zx", ".rx") and "/src/" in str(path)
)
aliases = {
    "lint/naming": root / "packages/lint/src/naming/check.zx",
    "lint/naming/model": root / "packages/lint/src/naming/model.zx",
}
virtual_roots = {
    "lint/naming": root / "packages/lint/src/naming",
}
sources = {}
unresolved = []

for path in files:
    text = path.read_text()
    relative = path.relative_to(root).as_posix()
    pattern = r"\bfrom\s+[\"']([^\"']+)[\"']" if path.suffix == ".zx" else r'\b(?:fn|module|from)="([^"]+)"'
    dependencies = []
    native = []

    for reference in re.findall(pattern, text):
        if ":" in reference:
            native.append(reference)
            continue

        base = aliases.get(reference, (path.parent / reference).resolve())
        virtual = base.relative_to(root / "packages/compiler/src").as_posix() if base.is_relative_to(root / "packages/compiler/src") else ""

        for prefix, target in virtual_roots.items():
            if virtual.startswith(prefix + "/"):
                base = target / virtual[len(prefix) + 1:]

        candidates = [base] if base.suffix in (".zx", ".rx") else [Path(str(base) + suffix) for suffix in (".zx", ".rx", ".d.zx")]
        found = next((candidate for candidate in candidates if candidate.is_file()), None)

        if found is None:
            unresolved.append({"source": relative, "reference": reference})
        else:
            dependencies.append(found.relative_to(root).as_posix())

    sources[relative] = {
        "sha256": hashlib.sha256(path.read_bytes()).hexdigest(),
        "lines": len(text.splitlines()),
        "dependencies": sorted(set(dependencies)),
        "native_imports": sorted(set(native)),
    }

entries = []
reached = set()

for entry in sources:
    if not entry.endswith(".rx"):
        continue

    closure = set()
    pending = [entry]

    while pending:
        current = pending.pop()

        if current in closure:
            continue

        closure.add(current)
        pending.extend(sources[current]["dependencies"])

    reached.update(closure)
    entries.append({"entry": entry, "closure": sorted(closure)})

report = {
    "baseline": subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=root, text=True).strip(),
    "resolution_evidence": "packages/compiler/build/generate_parser.zig:13-14,267-268",
    "sources": sources,
    "entries": entries,
    "unresolved": unresolved,
    "outside_rx_closure": sorted(set(sources) - reached),
}
Path(__file__).with_name("当前依赖清单.json").write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n")
print(json.dumps({"sources": len(sources), "entries": len(entries), "unresolved": unresolved}, ensure_ascii=False))
