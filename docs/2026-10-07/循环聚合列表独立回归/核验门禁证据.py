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
assert len(manifest["inputs"]) == 20

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

expected = {"stack": 1, "nested": 1, "two_lanes": 2, "bounds": 1, "old_list": 0, "call": 0, "escaping": 0, "consumer": 1}
artifacts = {}

for label in ("Debug", "ReleaseSafe"):
    evidence = read(label + "执行结果.json")
    assert evidence["source"] == manifest["source"]
    assert (evidence["actual_passed"], evidence["actual_leaves"], evidence["cached_test_leaves"]) == (102, 16, 0)
    log = DOC / (label + "原始日志.txt")
    assert digest(log) == evidence["log_sha256"]
    text = log.read_text()
    assert "Build Summary: 78/78 steps succeeded; 102/102 tests passed" in text
    leaves = re.findall(r"run test (aggregate-loop-[\w-]+) (\d+) pass \((\d+) total\)", text)
    assert len(leaves) == 16 and sum(int(count) for name, count, total in leaves) == 102
    assert not re.search(r"run test[^\n]*?(?<!\S)cached(?:\s|$)", text)
    assert digest(pathlib.Path(evidence["emitter"])) == evidence["emitter_sha256"]
    assert len(evidence["artifacts"]) == 32 and len(evidence["shapes"]) == 16

    for item in evidence["artifacts"]:
        assert digest(DOC / item["path"]) == item["sha256"]
        assert digest(pathlib.Path(item["cache_path"])) == item["sha256"]
        artifacts[(label, item["mode"], item["route"], item["kind"])] = item["sha256"]

    for shape in evidence["shapes"]:
        assert shape["value_buffers"] == shape["deinit"] == expected[shape["mode"]]
        assert set(shape["imports"]) == ({"std", "choose", "zxc_abi"} if shape["mode"] == "consumer" else {"std", "zxc_abi"})

for key, sha in artifacts.items():
    assert artifacts[("ReleaseSafe",) + key[1:]] == artifacts[("Debug",) + key[1:]]

adjacent = read("相邻Debug执行结果.json")
assert adjacent["source"] == manifest["source"] and adjacent["actual_passed"] == 66 and adjacent["cached_test_leaves"] == 0
assert digest(DOC / "相邻Debug原始日志.txt") == adjacent["log_sha256"]
assert digest(pathlib.Path(adjacent["zig_archive"])) == adjacent["zig_archive_sha256"]

print("verified: 20 frozen inputs; Debug/Safe 102 actual each; adjacent 66; 64 generated artifacts; preserved existing changes")
