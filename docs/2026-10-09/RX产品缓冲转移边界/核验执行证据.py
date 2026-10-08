from pathlib import Path
import hashlib
import json
import re


doc = Path(__file__).resolve().parent
inputs = json.loads((doc / "执行输入.json").read_text())
root = Path(inputs["root"])
run = Path(inputs["run"])
sha = lambda data: hashlib.sha256(data).hexdigest()
modes = {"object": 2, "nested": 2, "shared": 0, "retained_target": 1, "retained_parent": 0, "borrowed": 0, "branch": 0, "duplicate": 0, "growth": 1}

for name, value in inputs["packages"].items():
    assert sha((root / name).read_bytes()) == value, name

for name, value in inputs["tools"].items():
    assert sha(Path(name).read_bytes()) == value, name

for item in inputs["external_inputs"].values():
    assert sha(Path(item["snapshot"]).read_bytes()) == item["sha256"]

for name in inputs["formal"]:
    assert (root / name).read_bytes() == (doc / "草稿" / name).read_bytes(), name

generator = json.loads((run / "generator-state.json").read_text())
assert generator["status"] == "terminal" and generator["exit_code"] == 0
assert len(generator["generated"]) == 81
generation_run = Path(inputs.get("semantic_generation_run", str(run)))
assert sha((generation_run / "generate-parser").read_bytes()) == generator["generator_binary_sha256"]

for name, value in generator["generated"].items():
    assert sha(Path(name).read_bytes()) == value, name

for item in generator["steps"]:
    assert item["exit_code"] == 0
    assert sha(Path(item["log"]).read_bytes()) == item["log_sha256"]

all_programs = {}

for mode in ["Debug", "ReleaseSafe"]:
    generated = json.loads((run / (mode + "-generation.json")).read_text())
    executed = json.loads((run / (mode + "-execution.json")).read_text())
    assert generated["status"] == executed["status"] == "terminal"
    assert generated["exit_code"] == executed["exit_code"] == 0
    assert generated["compile_exit"] == generated["signature_exit"] == 0
    assert sha(Path(generated["compile_log"]).read_bytes()) == generated["compile_log_sha256"]
    assert sha((run / mode / "compile-product-transfer").read_bytes()) == generated["binary_sha256"]
    assert sha(Path(generated["options"]).read_bytes()) == generated["options_sha256"]
    assert list(modes) == [item["name"] for item in generated["programs"]]

    for name, value in generated["external"].items():
        assert sha(Path(name).read_bytes()) == value

    all_programs[mode] = {}
    for item in generated["programs"]:
        assert item["exit_code"] == 0
        log = Path(item["log"]).read_bytes()
        assert sha(log) == item["log_sha256"]
        archive = doc / "日志" / (mode + "-" + Path(item["log"]).name)
        if archive.exists():
            assert archive.read_bytes() == log, archive
        assert (item["name"] + ": " + str(modes[item["name"]]) + " transferred slots") in log.decode()
        for key in ["source", "types"]:
            assert sha(Path(item[key]).read_bytes()) == item[key + "_sha256"]
            archive = doc / "生成源码" / (Path(item[key]).name + ".txt")
            if archive.exists():
                assert archive.read_bytes() == Path(item[key]).read_bytes(), archive

        source = Path(item["source"]).read_text()
        assert source.count(".fromOwnedSlice") == modes[item["name"]]
        assert "pub fn execute" in source
        all_programs[mode][item["name"]] = (item["source_sha256"], item["types_sha256"])

    assert len(executed["executions"]) == 11
    total = 0

    for item in executed["executions"]:
        assert item["compile_exit"] == item["signature_exit"] == item["exit_code"] == 0
        assert sha(Path(item["binary"]).read_bytes()) == item["binary_sha256"]
        assert sha(Path(item["compile_log"]).read_bytes()) == item["compile_log_sha256"]
        log = Path(item["log"]).read_bytes()
        assert sha(log) == item["log_sha256"]
        archive = doc / "日志" / (mode + "-" + Path(item["log"]).name)
        if archive.exists():
            assert archive.read_bytes() == log, archive
        checks = re.findall(r"All (\d+) tests passed\.", log.decode())
        assert len(checks) == 1
        expected = 1 if item["entry"] == "capacity_test.zig" else 5
        assert int(checks[0]) == expected
        total += expected

    assert total == 47

assert all_programs["Debug"] == all_programs["ReleaseSafe"]
fixtures = root / "packages/test/tests/rx/runtime/product_transfer/fixtures"
for phase in ["首轮", "接口声明复验", "首次转移观察", "容量常量复验"]:
    archived = doc / phase
    original = json.loads((archived / "执行输入.json").read_text())
    for name in inputs["formal"]:
        overlay = archived / "草稿" / name
        reconstructed = overlay if overlay.exists() else doc / "草稿" / name
        assert sha(reconstructed.read_bytes()) == original["packages"][name], (phase, name)

maximum = 0

for path in fixtures.rglob("*.zx"):
    data = path.read_bytes()
    assert b"\r" not in data
    lines = data.count(b"\n") + (not data.endswith(b"\n"))
    assert lines <= 120, path
    maximum = max(maximum, lines)

for path in doc.rglob("*.md"):
    assert len(path.read_text().split("\n")) < 1000, path

print("PASS:", len(inputs["packages"]), "frozen inputs; 81 regenerated compiler modules; nine RX programs identical across host modes; 47 checks per mode in 22 actual binaries; maximum ZX lines", maximum)
