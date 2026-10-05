import hashlib
import json
from pathlib import Path
import subprocess
import tempfile
import time


folder = Path(__file__).resolve().parent
repo = folder.parents[2]
previous = folder.parent / "词法草稿差分"
reference = previous / "reference"
program = folder / "zig-out/bin/lexer-adapter-observe"
expected_hash = json.loads((previous / "验证结果.json").read_text())["reference_sha256"]
assert hashlib.sha256(reference.read_bytes()).hexdigest() == expected_hash
inventory = previous / "输入清单.jsonl"
cases = [json.loads(line) for line in inventory.read_text().splitlines()]
sources = sorted(path for path in (repo / "packages/compiler/src/zx/frontend/lexer").rglob("*") if path.is_file()) + [repo / "packages/compiler/src/zx/frontend/lex.zig", repo / "packages/compiler/build/lexer.zig", repo / "packages/compiler/build/compiler.zig", repo / "packages/compiler/build/generate_lexer.zig"]
source_hashes = {str(path.relative_to(repo)): hashlib.sha256(path.read_bytes()).hexdigest() for path in sources}
with (folder / "构建.log").open("w") as output:
    subprocess.run(["zig", "build", "-Doptimize=ReleaseSafe", "--summary", "all"], cwd=folder, stdout=output, stderr=subprocess.STDOUT, check=True)
if any(hashlib.sha256((repo / path).read_bytes()).hexdigest() != digest for path, digest in source_hashes.items()):
    raise RuntimeError("lexer sources changed during observer build")
program_hash = hashlib.sha256(program.read_bytes()).hexdigest()


def execute(command):
    try:
        result = subprocess.run(command, capture_output=True, timeout=15)
    except subprocess.TimeoutExpired:
        return {"execution_error": "timeout"}
    if result.returncode != 0:
        return {"execution_error": result.returncode, "stderr": result.stderr.decode("utf8", errors="replace")}
    try:
        return json.loads(result.stdout)
    except (ValueError, UnicodeDecodeError):
        return {"execution_error": "invalid_json", "stdout": result.stdout.hex()}


started = time.monotonic()
failures = []
with tempfile.TemporaryDirectory(prefix="zxc-official-lexer-") as temporary:
    source_path = Path(temporary) / "source.bin"
    with (folder / "失败差异.jsonl").open("w") as differences:
        for index, case in enumerate(cases, 1):
            source = bytes.fromhex(case["hex"])
            assert hashlib.sha256(source).hexdigest() == case["sha256"]
            source_path.write_bytes(source)
            expected = execute([str(reference), str(source_path)])
            actual = execute([str(program), str(source_path)])
            if expected != actual or "execution_error" in expected or "execution_error" in actual:
                differences.write(json.dumps({**case, "expected": expected, "actual": actual}, ensure_ascii=False) + "\n")
                differences.flush()
                failures.append(case["name"])
            if index % 512 == 0:
                print(json.dumps({"completed": index, "total": len(cases), "failures": len(failures)}), flush=True)

assert hashlib.sha256(program.read_bytes()).hexdigest() == program_hash
assert hashlib.sha256(reference.read_bytes()).hexdigest() == expected_hash
report = {
    "cases": len(cases), "failure_count": len(failures), "failures": failures,
    "seconds": time.monotonic() - started,
    "program_sha256": program_hash, "reference_sha256": expected_hash,
    "inventory_sha256": hashlib.sha256(inventory.read_bytes()).hexdigest(),
    "sources_observed_at_run_start": source_hashes,
    "sources_changed_during_run": [path for path, digest in source_hashes.items() if hashlib.sha256((repo / path).read_bytes()).hexdigest() != digest],
}
(folder / "验证结果.json").write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n")
print(json.dumps({key: report[key] for key in ["cases", "failure_count", "seconds", "sources_changed_during_run"]}), flush=True)
raise SystemExit(1 if failures else 0)
