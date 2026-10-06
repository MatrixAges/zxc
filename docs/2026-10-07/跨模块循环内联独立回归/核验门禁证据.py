import hashlib
import json
from pathlib import Path
import re
import subprocess


doc = Path(__file__).resolve().parent
root = doc.parents[2]
manifest = json.loads((doc / "输入清单.json").read_text())
previous = json.loads((doc / "追加恢复前输入清单.json").read_text())
fixed = Path(manifest["cwd"]).parents[1]


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


for manifest_file in ["输入清单.json", "最新输入清单.json", "同步输入清单.json"]:
    manifest = json.loads((doc / manifest_file).read_text())
    fixed = Path(manifest["cwd"]).parents[1]
    assert subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=fixed, text=True).strip() == manifest["source"]
    assert subprocess.check_output(["git", "rev-parse", "HEAD^{tree}"], cwd=fixed, text=True).strip() == manifest["source_tree"]
    status = subprocess.check_output(["git", "status", "--porcelain", "-z", "--untracked-files=all"], cwd=fixed).decode().split("\0")
    assert {line[3:] for line in status if line} == {item["path"] for item in manifest["inputs"]}
    assert len(manifest["inputs"]) == 36
    for item in manifest["inputs"]:
        for parent in [root, fixed, doc / "草稿"]:
            assert digest(parent / item["path"]) == item["sha256"], item["path"]

measured = {}
base = json.loads((doc / "输入清单.json").read_text())
latest = json.loads((doc / "最新输入清单.json").read_text())
synced = json.loads((doc / "同步输入清单.json").read_text())
for label, inputs in [("完整Debug", base), ("完整ReleaseSafe", base), ("相邻Debug", previous), ("最新Debug", latest), ("最新ReleaseSafe", latest), ("最新相邻Debug", latest), ("同步Debug", synced), ("同步ReleaseSafe", synced), ("同步相邻Debug", synced)]:
    result = json.loads((doc / (label + "执行结果.json")).read_text())
    text = (doc / (label + "原始日志.txt")).read_text()
    summary = re.search(r"Build Summary: (\d+)/(\d+) steps succeeded; (\d+)/(\d+) tests passed", text)
    leaves = [{"name": item[1], "passes": int(item[2]), "total": int(item[3])} for item in re.finditer(r"\brun test (\S+) (\d+) pass \((\d+) total\)", text)]
    assert result["exit_code"] == 0
    assert result["source"] == inputs["source"] and result["source_tree"] == inputs["source_tree"] and result["inputs"] == inputs["inputs"]
    assert result["cwd"] == inputs["cwd"]
    assert summary and int(summary[1]) == int(summary[2])
    assert int(summary[3]) == int(summary[4]) == sum(item["passes"] for item in leaves)
    assert all(item["passes"] == item["total"] for item in leaves)
    assert not re.search(r"\brun test\b[^\n]*?(?<!\S)cached(?:\s|$)", text)
    if "相邻" not in label:
        assert int(summary[3]) == 123 and len(leaves) == 19
        expected = {"modular-loop-generation": 3}
        for mode in ["simple", "branch", "switch", "chain", "bounds", "effects", "nested", "escaping", "changed"]:
            for route in ["source", "library"]:
                expected["modular-loop-" + mode + "-" + route] = 11 if mode == "effects" else 7 if mode == "bounds" else 6
        assert {item["name"]: item["total"] for item in leaves} == expected
    else:
        assert int(summary[3]) == 2263 and len(leaves) == 40
    measured[label] = {"steps": int(summary[1]), "actual_passes": int(summary[3]), "leaves": leaves, "cached_test_steps": 0, "log_sha256": digest(doc / (label + "原始日志.txt"))}

outputs = json.loads((doc / "产物清单.json").read_text())
assert len(outputs) == 144
for name, item in outputs.items():
    assert digest(doc / name) == item["sha256"]
    assert item["tested_output_paths"] and all(digest(Path(path)) == item["sha256"] for path in item["tested_output_paths"])
for mode in ["simple", "branch", "switch", "chain", "bounds", "effects", "nested", "escaping", "changed"]:
    for name in ["source", "source_abi", "library", "library_abi"]:
        assert digest(doc / "生成产物/完整Debug" / mode / (name + ".txt")) == digest(doc / "生成产物/完整ReleaseSafe" / mode / (name + ".txt"))
    for label in ["完整Debug", "完整ReleaseSafe"]:
        assert digest(doc / "生成产物" / label / mode / "source_abi.txt") == digest(doc / "生成产物" / label / mode / "library_abi.txt")
        for route in ["source", "library"]:
            source = (doc / "生成产物" / label / mode / (route + ".txt")).read_text()
            imports = set(re.findall(r'@import\("([^"\n]+)"\)', source))
            assert imports == ({"std", "zxc_abi", "probe"} if mode == "effects" else {"std", "zxc_abi"})

for mode in ["simple", "branch", "switch", "chain", "bounds", "effects", "nested", "escaping", "changed"]:
    for name in ["source", "source_abi", "library", "library_abi"]:
        assert digest(doc / "生成产物/最新Debug" / mode / (name + ".txt")) == digest(doc / "生成产物/最新ReleaseSafe" / mode / (name + ".txt"))
    for label in ["最新Debug", "最新ReleaseSafe"]:
        assert digest(doc / "生成产物" / label / mode / "source_abi.txt") == digest(doc / "生成产物" / label / mode / "library_abi.txt")
        for route in ["source", "library"]:
            source = (doc / "生成产物" / label / mode / (route + ".txt")).read_text()
            imports = set(re.findall(r'@import\("([^"\n]+)"\)', source))
            assert imports == ({"std", "zxc_abi", "probe"} if mode == "effects" else {"std", "zxc_abi"})

for name, item in json.loads((doc / "追加恢复前产物清单.json").read_text()).items():
    assert digest(doc / name) == item["sha256"]
assert len(json.loads((doc / "生成重放记录.json").read_text())) == 36
assert all(item["exit_code"] == 0 for item in json.loads((doc / "生成重放记录.json").read_text()))
assert digest(doc / "追加恢复前生成检查源码.txt") == next(item["sha256"] for item in previous["inputs"] if item["path"].endswith("generation_test.zig"))
foreign = json.loads((doc / "原有修改清单.json").read_text())
assert len(foreign) == 11 and all(digest(root / item["path"]) == item["sha256"] for item in foreign)
matrix = json.loads((doc / "目录矩阵原始报告.txt").read_text())
assert matrix["catalog_cases"] == 82935 and matrix["unreviewed"] == 50779
result_path = doc / "门禁核对结果.json"
if not result_path.exists() or json.loads(result_path.read_text()) != measured:
    result_path.write_text(json.dumps(measured, ensure_ascii=False, indent=2) + "\n")
print(json.dumps({"source": manifest["source"], "inputs": len(manifest["inputs"]), "per_mode_actual_tests": 123, "adjacent_actual_tests": 2263, "primary_outputs": len(outputs), "case_declarations": 14}, ensure_ascii=False))
