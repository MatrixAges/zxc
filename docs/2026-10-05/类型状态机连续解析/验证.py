import hashlib
import json
from pathlib import Path
import subprocess
import tempfile
import time
from tree import expand


folder = Path(__file__).resolve().parent
repo = folder.parents[2]
previous = folder.parent / "类型状态机边界差分"
reference = previous / "zig-out/bin/type-boundary-observe"
reference_record = json.loads((previous / "验证结果.json").read_text())
runner = folder / "zig-out/runner"
compiler = repo / "zig-out/bin/zxc"


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


assert digest(reference) == reference_record["program_sha256"]
sources = sorted(folder.glob("*.zx")) + sorted(folder.glob("*.py")) + sorted((repo / "packages/compiler/src/zx/frontend/parser/types").glob("*.zx")) + sorted((repo / "packages/compiler/src/zx/frontend/lexer").rglob("*.zx"))
source_hashes = {str(path.relative_to(repo)): digest(path) for path in sources}
compiler_hash = digest(compiler)
runner.parent.mkdir(exist_ok=True)

with (folder / "构建.log").open("w") as output:
    subprocess.run([str(compiler), "build", str(folder / "source.zx"), "--out", str(runner), "--optimize", "ReleaseSafe", "--no-cache"], cwd=repo, stdout=output, stderr=subprocess.STDOUT, check=True)

assert all(digest(repo / path) == value for path, value in source_hashes.items())
runner_hash = digest(runner)
cases = [json.loads(line) for line in (folder / "输入清单.jsonl").read_text().splitlines()]
failures = []
executions = 0
started = time.monotonic()

with tempfile.TemporaryDirectory(prefix="zxc-type-sequence-") as temporary:
    path = Path(temporary) / "source.zx"

    for case in cases:
        source = case["source"].encode()
        assert hashlib.sha256(source).hexdigest() == case["sha256"]
        path.write_bytes(source)

        try:
            baseline = subprocess.run([str(reference), str(path), json.dumps(case["starts"]), "0"], capture_output=True, check=True, timeout=15)
            expected = [json.loads(line)["expected"] for line in baseline.stdout.splitlines()]
            assert len(expected) == len(case["starts"])
            assert all(row["diagnostic"]["message"] == "" for row in expected)
            previous_tree = {"nodes": [], "fields": [], "items": []}
            previous_roots = []

            for count in range(len(case["starts"]) + 1):
                argument = {"source": list(source), "starts": case["starts"][:count]}
                completed = subprocess.run([str(runner), json.dumps(argument)], capture_output=True, check=True, timeout=15)
                actual = json.loads(completed.stdout)
                executions += 1
                tree = actual["state"]["tree"]
                control = actual["state"]["control"]

                assert actual["next"] == count
                assert len(actual["roots"]) == count
                assert len(actual["stops"]) == count
                assert actual["starts"] == argument["starts"]
                assert control["diagnostic"]["message"] == ""
                assert actual["state"]["frames"] == []
                assert count == 0 or control["phase"] == "Done"
                assert count != 0 or tree == {"nodes": [], "fields": [], "items": []}
                assert actual["roots"][:len(previous_roots)] == previous_roots

                for table in previous_tree:
                    assert tree[table][:len(previous_tree[table])] == previous_tree[table]

                for index, root in enumerate(actual["roots"]):
                    assert index == 0 or actual["roots"][index - 1] < root
                    assert expand(source, tree, root) == expected[index]["value"]
                    assert actual["stops"][index] == expected[index]["index"]

                previous_tree = tree
                previous_roots = actual["roots"]
        except (AssertionError, ValueError, subprocess.SubprocessError) as error:
            failures.append({"name": case["name"], "error": repr(error), "stderr": (getattr(error, "stderr", None) or b"").decode(errors="replace")[:4000]})

assert digest(compiler) == compiler_hash
assert digest(runner) == runner_hash
assert digest(reference) == reference_record["program_sha256"]
changed = [path for path, value in source_hashes.items() if digest(repo / path) != value]
report = {
    "sequences": len(cases), "executions": executions, "failures": len(failures),
    "seconds": time.monotonic() - started, "runner_sha256": runner_hash,
    "compiler_sha256": compiler_hash, "reference_sha256": reference_record["program_sha256"],
    "sources": source_hashes, "sources_changed_during_run": changed,
    "inventory_sha256": digest(folder / "输入清单.jsonl"),
}
(folder / "失败差异.jsonl").write_text("".join(json.dumps(row, ensure_ascii=False) + "\n" for row in failures))
(folder / "验证结果.json").write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n")
print(json.dumps({key: value for key, value in report.items() if key != "sources"}))
raise SystemExit(1 if failures or changed else 0)
