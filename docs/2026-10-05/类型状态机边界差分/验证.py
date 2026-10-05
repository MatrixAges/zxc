import hashlib
import json
from pathlib import Path
import subprocess
import sys
import tempfile
import time


sys.setrecursionlimit(10000)
folder = Path(__file__).resolve().parent
repo = folder.parents[2]
provenance = repo / "docs/2026-10-05/语法前端迁移/类型语法/源码与产物核对.json"
record = json.loads(provenance.read_text())
artifact = next(item for item in record["artifacts"] if item["path"] == "/tmp/zxc_type_source.zig")
program = folder / "zig-out/bin/type-boundary-observe"


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


assert digest(Path(artifact["path"])) == artifact["sha256"]
for item in record["sources"]:
    assert digest(repo / item["path"]) == item["sha256"], item["path"]

observer_sources = {name: digest(folder / name) for name in ("build.zig", "build.zig.zon", "observe.zig", "验证.py")}

with (folder / "构建.log").open("w") as output:
    subprocess.run(["zig", "build", "-Doptimize=ReleaseSafe", "--summary", "all"], cwd=folder, stdout=output, stderr=subprocess.STDOUT, check=True)

program_hash = digest(program)


def expand(source, tree, index):
    assert 0 <= index < len(tree["nodes"])
    node = tree["nodes"][index]
    kind = node["kind"]

    def name(span):
        assert 0 <= span["start"] <= span["end"] <= len(source)
        return {"text": source[span["start"]:span["end"]].decode(), "span": span}

    if kind == "Named":
        return {"named": name(node["name"])}

    if kind in ("Optional", "List", "Application"):
        assert node["child"] < index
        child = expand(source, tree, node["child"])
        if kind == "Application":
            return {"application": {"name": name(node["name"]), "argument": child}}
        return {kind.lower(): child}

    assert kind in ("Object", "Tuple")
    edges = tree["fields"] if kind == "Object" else tree["items"]
    head = node["head"]
    values = []

    for _ in range(node["count"]):
        assert 0 < head <= len(edges)
        edge = edges[head - 1]
        assert edge["previous"] < head
        assert edge["value"] < index
        value = expand(source, tree, edge["value"])
        values.append({"name": name(edge["name"]), "value": value} if kind == "Object" else value)
        head = edge["previous"]

    assert head == 0
    return {kind.lower(): list(reversed(values))}


cases = [json.loads(line) for line in (folder / "输入清单.jsonl").read_text().splitlines()]
failures = []
diagnostics = set()
kinds = set()
started = time.monotonic()

with tempfile.TemporaryDirectory(prefix="zxc-type-boundary-") as temporary:
    path = Path(temporary) / "input.zx"
    for case in cases:
        source = case["source"].encode()
        assert hashlib.sha256(source).hexdigest() == case["sha256"]
        path.write_bytes(source)

        try:
            completed = subprocess.run([str(program), str(path), json.dumps([case["start"]]), str(case["depth"])], capture_output=True, timeout=15, check=True)
            output = json.loads(completed.stdout)
            assert output["start"] == case["start"]
            state = output["actual"]
            control = state["control"]
            assert control["phase"] == "Done"
            actual = {"value": None, "index": control["index"], "diagnostic": control["diagnostic"]}
            kinds.update(node["kind"] for node in state["tree"]["nodes"])

            if control["diagnostic"]["message"]:
                diagnostics.add(control["diagnostic"]["message"])
            else:
                assert state["frames"] == []
                actual["value"] = expand(source, state["tree"], control["result"])

            if output["expected"] != actual:
                failures.append({"name": case["name"], "expected": output["expected"], "actual": actual})
        except (AssertionError, ValueError, subprocess.SubprocessError) as error:
            failures.append({"name": case["name"], "execution_error": repr(error), "stderr": (getattr(error, "stderr", None) or b"").decode(errors="replace")[:4000]})

assert digest(program) == program_hash
assert digest(Path(artifact["path"])) == artifact["sha256"]
assert all(digest(folder / name) == value for name, value in observer_sources.items())
changed = [item["path"] for item in record["sources"] if digest(repo / item["path"]) != item["sha256"]]
report = {
    "cases": len(cases), "failures": len(failures), "seconds": time.monotonic() - started,
    "node_kinds": sorted(kinds), "diagnostics": sorted(diagnostics),
    "generated_source": artifact, "program_sha256": program_hash, "provenance_sha256": digest(provenance),
    "inventory_sha256": digest(folder / "输入清单.jsonl"), "sources_changed_during_run": changed,
    "observer_sources": observer_sources,
}
(folder / "失败差异.jsonl").write_text("".join(json.dumps(row, ensure_ascii=False) + "\n" for row in failures))
(folder / "验证结果.json").write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n")
print(json.dumps(report, ensure_ascii=False))
raise SystemExit(1 if failures or changed else 0)
