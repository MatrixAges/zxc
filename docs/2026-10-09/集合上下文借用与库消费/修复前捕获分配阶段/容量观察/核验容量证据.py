from pathlib import Path
import hashlib
import json
import re


doc = Path(__file__).resolve().parent
inputs = json.loads((doc.parent / "执行输入.json").read_text())
run = Path(inputs["run"])
sha = lambda data: hashlib.sha256(data).hexdigest()
failed = 0

for mode in ["Debug", "ReleaseSafe"]:
    state = json.loads((doc / mode / "运行状态.json").read_text())
    assert state == json.loads((run / "capacity" / mode / "state.json").read_text())
    assert state["status"] == "terminal" and state["exit_code"] == 1
    assert len(state["executions"]) == 12
    assert sha((doc / "predicate_capacity.zig").read_bytes()) == state["source_sha256"]

    for item in state["executions"]:
        assert item["signature_exit"] == 0
        assert sha(Path(item["binary"]).read_bytes()) == item["binary_sha256"]
        raw = Path(item["log"]).read_bytes()
        assert sha(raw) == item["log_sha256"]
        assert (doc / mode / Path(item["log"]).name).read_bytes() == raw
        samples = {int(count): int(capacity) for count, capacity in re.findall(rb"count=(\d+) capacity=(\d+)", raw)}
        assert set(samples) == {0, 1, 64, 257, 4096}
        expected_failure = not item["name"].startswith("list-")
        assert item["exit_code"] == int(expected_failure)
        assert (samples[4096] > samples[1]) == expected_failure
        failed += expected_failure

assert failed == 16
print("CONFIRMED: sixteen actual failing capacity gates; eight list control gates passed")
