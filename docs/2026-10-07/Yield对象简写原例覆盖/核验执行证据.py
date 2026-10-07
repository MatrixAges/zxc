from pathlib import Path
import hashlib
import json
import re
import shlex
import sys

snapshot = Path(sys.argv[1]).resolve()
doc = Path(__file__).resolve().parent


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def verify_inputs(baseline, root):
    for item in baseline["inputs"]:
        assert digest(root / item["path"]) == item["sha256"], item["path"]


baseline = json.loads((doc / "开始基线.json").read_text())
original_snapshot = Path(json.loads((doc / "原对象门禁/执行源快照.json").read_text())["path"])
verify_inputs(baseline, snapshot)
verify_inputs(json.loads((doc / "原对象门禁/开始基线.json").read_text()), original_snapshot)

original = json.loads((doc / "上游原文执行证据.json").read_text())
assert original["observations"] == [{"actual": 1, "expected": 1}]
assert original["exit_code"] == 0

for name, sha in original["hashes"].items():
    assert digest(doc / "上游原文" / (name + ".txt")) == sha

review = json.loads((doc / "审查更新身份.json").read_text())
previous = snapshot / review["review_path"]
published = doc / "代码草稿" / review["review_path"]
assert digest(previous) == review["executed_sha256"]
assert digest(published) == review["published_sha256"]
assert published.read_bytes().startswith(previous.read_bytes())
added = [json.loads(line) for line in published.read_bytes()[len(previous.read_bytes()):].splitlines()]
assert added == [review["record"]]
assert review["after_gate_exit_codes"] == [0, 0, 0, 0]
assert added[0]["sha256"] == original["hashes"]["yield-non-strict-access.js"]

suites = json.loads((snapshot / "packages/test/suites.json").read_text())["runtime"]
catalogs = {}

for suite in suites:
    if not suite["name"].startswith("object-construction-"):
        continue
    path = snapshot / "packages/test/tests" / (suite["path"] + ".jsonl")
    catalogs[suite["name"]] = [json.loads(line)["id"] for line in path.read_text().splitlines()]

yield_path = snapshot / "packages/test/tests/language/expressions/object_construction/identifier_yield.jsonl"
rows = [json.loads(line) for line in yield_path.read_text().splitlines()]
assert [row["input"] for row in rows] == [1, 0, -1, 73, -29, -9223372036854775808, 9223372036854775807]
assert all(row["expected"] == {"value": row["input"]} for row in rows)
assert added[0]["cases"] == [rows[0]["id"]]
assert added[0]["assertions"] == [{"case": rows[0]["id"], "field": "value", "expected": 1}]

for mode in ["Debug", "ReleaseSafe"]:
    for group, count in [("原对象门禁", 53), ("双路径", 20)]:
        evidence = json.loads((doc / f"{group}{mode}证据.json").read_text())
        assert evidence["source_commit"] == baseline["source_commit"]
        assert evidence["packages_tree"] == baseline["packages_tree"]
        assert evidence["passed"] and evidence["tests_passed"] == evidence["tests_total"] == count
        assert digest(doc / evidence["log"]) == evidence["log_sha256"]
        assert len(evidence["formal_parser_options"]) == 1

        for option in evidence["formal_parser_options"]:
            assert option["generated_parser"] and digest(Path(option["path"])) == option["sha256"]

        for item in evidence["artifacts"]:
            assert digest(doc / item["saved"]) == item["sha256"]
            assert digest(Path(item["executed_source"])) == item["sha256"]

        compiled = {}
        for command in evidence["commands"]:
            args = shlex.split(command["command"])
            if len(args) < 2 or args[1] != "test":
                continue
            name = args[args.index("--name") + 1]
            source = Path(next(arg.split("=", 1)[1] for arg in args if arg.startswith("-Mroot=")))
            compiled[name] = re.findall(r'^test "([^"]+)"', source.read_text(), re.MULTILINE)

        expected = catalogs if group == "原对象门禁" else {
            name + "-" + route: ids
            for name, ids in catalogs.items() if name.startswith("object-construction-shorthand-")
            for route in ["source", "library"]
        }
        assert compiled == expected
        assert sum(len(ids) for ids in compiled.values()) == count
        binaries = evidence["logged_zig_test_binaries"]
        assert {Path(item["path"]).name for item in binaries} == set(expected)

        for item in binaries:
            assert digest(Path(item["path"])) == item["sha256"]

before = json.loads((doc / "开始审查统计.json").read_text())
after = json.loads((doc / "目录审查结果.json").read_text())
assert after["catalog_cases"] == before["catalog_cases"] + 7 == 128467
assert after["unreviewed"] == before["unreviewed"] - 1 == 50631
assert after["reviewed"]["adapted"] == before["reviewed"]["adapted"] + 1 == 811
print("PASS: original assertion, frozen inputs, 146 executed native checks, generated parser and one verified adapted review")
