import hashlib
import json
import re
import subprocess
import tempfile
from pathlib import Path

base = Path(__file__).resolve().parent.parent
root = base.parents[2]
output = base / "请求生成"
build = base / "持久化生成"
build.mkdir(exist_ok=True)

modules = json.loads((output / "modules.json").read_text())
initializers = json.loads((output / "initializers.json").read_text())
slots = json.loads((output / "slots.json").read_text())

if len(slots) != 1:
    raise RuntimeError("This explicit host example expects one application Store slot")

initial = next(item for item in initializers if item["identity"] == slots[0]["path"])
command = [
    "zig", "build-exe", "--dep", "application", "--dep", "runtime",
    "--dep", "initial=" + initial["module_name"],
    "-Mroot=" + str(base / "持久化演示/consume.zig"),
]

module_map = {module["name"]: module for module in modules}
needed = set()
pending = ["application", initial["module_name"]]

while pending:
    name = pending.pop()

    if name in needed:
        continue

    needed.add(name)
    pending.extend(module_map[name]["imports"])

for module in modules:
    if module["name"] not in needed:
        continue

    command += ["--dep", "zxc_abi"]

    for dependency in module["imports"]:
        command += ["--dep", dependency]

    command += ["-M" + module["name"] + "=" + str(output / (module["name"] + ".zig"))]

command += [
    "-Mzxc_abi=" + str(output / "types.zig"),
    "-Mruntime=" + str(root / "packages/runtime/src/root.zig"),
    "-femit-bin=" + str(build / "consume"),
]
subprocess.run(command, check=True)
metadata = {
    "identity": initial["identity"],
    "schema_version": initial["schema_version"],
    "type_identity": initial["type_name"],
}
metadata_path = build / "metadata.json"
metadata_path.write_text(json.dumps(metadata, indent=2) + "\n")
runs = []

with tempfile.TemporaryDirectory(prefix="state-", dir=build) as state:
    for increment in ["1", "7"]:
        result = subprocess.run(
            [str(build / "consume"), state, increment, str(metadata_path)],
            text=True, capture_output=True, check=True,
        )
        print(result.stdout + result.stderr, end="")
        runs.append({"increment": increment, "exit_code": result.returncode, "output": result.stdout + result.stderr})

    snapshot_path = next(Path(state).glob("*.json"))
    before = json.loads(snapshot_path.read_text())
    processes = [subprocess.Popen(
        [str(build / "consume"), state, "1", str(metadata_path), "--wait"],
        text=True, stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE,
    ) for _ in range(8)]
    ready = []

    for process in processes:
        prefix = ""

        while True:
            line = process.stderr.readline()
            prefix += line

            if line == "ready\n":
                break
            if not line:
                raise RuntimeError(prefix)

        ready.append(prefix)

    for process in processes:
        process.stdin.write("\n")
        process.stdin.flush()

    concurrent = []

    for process, prefix in zip(processes, ready):
        stdout, stderr = process.communicate()
        concurrent.append({"exit_code": process.returncode, "output": prefix + stdout + stderr})

    after = json.loads(snapshot_path.read_text())
    commits = [int(revision) for run in concurrent for revision in re.findall(r"^commit revision=(\d+)$", run["output"], re.MULTILINE)]
    concurrency = {
        "runs": concurrent,
        "committed_revisions": sorted(commits),
        "revision_matches": after["revision"] == before["revision"] + len(commits),
        "value_matches": after["value"]["value"] == before["value"]["value"] + len(commits),
        "snapshot": after,
    }
    print("concurrent exits:", [run["exit_code"] for run in concurrent], "commits:", len(commits), "revision:", after["revision"])

    wrong = dict(metadata, schema_version=metadata["schema_version"] + 1)
    wrong_path = build / "incompatible_metadata.json"
    wrong_path.write_text(json.dumps(wrong, indent=2) + "\n")
    original_bytes = snapshot_path.read_bytes()
    refused = subprocess.run(
        [str(build / "consume"), state, "1", str(wrong_path)],
        text=True, capture_output=True,
    )
    mismatch = {
        "exit_code": refused.returncode,
        "output": refused.stdout + refused.stderr,
        "snapshot_unchanged": snapshot_path.read_bytes() == original_bytes,
    }
    print("schema mismatch exit:", refused.returncode, "unchanged:", mismatch["snapshot_unchanged"])
    snapshots = [json.loads(path.read_text()) for path in Path(state).glob("*.json")]

record = {
    "binary_sha256": hashlib.sha256((build / "consume").read_bytes()).hexdigest(),
    "runs": runs,
    "snapshots": snapshots,
    "concurrency": concurrency,
    "schema_mismatch": mismatch,
}
(build / "运行结果.json").write_text(json.dumps(record, ensure_ascii=False, indent=2) + "\n")
