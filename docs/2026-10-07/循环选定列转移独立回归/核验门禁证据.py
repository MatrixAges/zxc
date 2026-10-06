import hashlib
import json
import pathlib
import re
import subprocess

DOC = pathlib.Path(__file__).resolve().parent
ROOT = DOC.parents[2]


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def read(name):
    return json.loads((DOC / name).read_text())


manifest = read("输入清单.json")
frozen = pathlib.Path(manifest["cwd"]).parents[1]
assert subprocess.check_output(["git", "-C", str(frozen), "rev-parse", "HEAD"]).decode().strip() == manifest["source"]
assert len(manifest["inputs"]) == 21

committed = read("提交输入清单.json")
assert committed["source"] == manifest["source"]
assert {item["path"] for item in committed["inputs"]} == {item["path"] for item in manifest["inputs"]}

for item in manifest["inputs"]:
    assert digest(frozen / item["path"]) == item["sha256"], item["path"]

for item in committed["inputs"]:
    assert digest(ROOT / item["path"]) == item["sha256"], item["path"]
    before = (frozen / item["path"]).read_bytes()
    after = (ROOT / item["path"]).read_bytes()
    assert [line for line in before.splitlines() if line.strip()] == [line for line in after.splitlines() if line.strip()], item["path"]

for item in read("原有修改清单.json"):
    assert digest(ROOT / item["path"]) == item["sha256"], item["path"]

expected = {"mixed": 1, "direct": 1, "borrowed": 1, "shrink": 1, "nested": 1, "dual": 2, "leaves": 3, "consumer": 1, "fallback": 0}
artifacts = {}

for label in ("Debug", "ReleaseSafe"):
    evidence = read(label + "执行结果.json")
    assert evidence["source"] == manifest["source"]
    assert (evidence["actual_passed"], evidence["actual_leaves"], evidence["cached_test_leaves"]) == (124, 18, 0)
    log = DOC / (label + "原始日志.txt")
    assert digest(log) == evidence["log_sha256"]
    text = log.read_text()
    assert "Build Summary: 85/85 steps succeeded; 124/124 tests passed" in text
    leaves = re.findall(r"run test (loop-columns-[\w-]+) (\d+) pass \((\d+) total\)", text)
    assert len(leaves) == 18 and sum(int(count) for name, count, total in leaves) == 124
    assert not re.search(r"run test[^\n]*?(?<!\S)cached(?:\s|$)", text)
    assert digest(pathlib.Path(evidence["emitter"])) == evidence["emitter_sha256"]
    assert len(evidence["artifacts"]) == 36 and len(evidence["shapes"]) == 18

    for item in evidence["artifacts"]:
        assert digest(DOC / item["path"]) == item["sha256"]
        assert digest(pathlib.Path(item["cache_path"])) == item["sha256"]
        artifacts[(label, item["mode"], item["route"], item["kind"])] = item["sha256"]

    for shape in evidence["shapes"]:
        mode = shape["mode"]
        assert shape["value_buffers"] == (0 if mode == "fallback" else 1)
        assert shape["transfers"] == shape["error_cleanup"] == expected[mode]
        assert shape["deinit"] == (0 if mode == "fallback" else 4 if mode in ("dual", "leaves") else 3)
        assert set(shape["imports"]) == ({"std", "choose", "zxc_abi"} if shape["mode"] == "consumer" else {"std", "zxc_abi"})

for key, sha in artifacts.items():
    assert artifacts[("ReleaseSafe",) + key[1:]] == artifacts[("Debug",) + key[1:]]

adjacent = read("相邻Debug执行结果.json")
assert adjacent["source"] == manifest["source"] and adjacent["actual_passed"] == 102 and adjacent["cached_test_leaves"] == 0
assert digest(DOC / "相邻Debug原始日志.txt") == adjacent["log_sha256"]

print("verified: 21 frozen inputs; Debug/Safe 124 actual each; adjacent 102; 72 generated artifacts; preserved existing changes")
