from pathlib import Path
import hashlib
import json
import re
import shlex
import sys

snapshot = Path(sys.argv[1]).resolve()
doc = Path(__file__).resolve().parent
baseline = json.loads((doc / "开始基线.json").read_text())


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


for item in baseline["inputs"]:
    assert digest(snapshot / item["path"]) == item["sha256"], item["path"]

first = json.loads((doc / "首轮/开始基线.json").read_text())
first_snapshot = Path(json.loads((doc / "首轮/源快照.json").read_text())["path"])

for item in first["inputs"]:
    assert digest(first_snapshot / item["path"]) == item["sha256"], item["path"]

old = {item["path"]: item["sha256"] for item in first["inputs"]}
changed = {item["path"] for item in baseline["inputs"] if item["sha256"] != old[item["path"]]}
assert changed == {"packages/test/build/native_modules.zig", "packages/test/tests/native/modules/fixture.zig"}

expected = {}

for kind in ["structure", "declarations", "bindings", "exports"]:
    source = snapshot / f"packages/test/tests/native/modules/{kind}_test.zig"
    expected["native-modules-" + kind] = re.findall(r'^test "([^"]+)"', source.read_text(), re.MULTILINE)

assert {name: len(ids) for name, ids in expected.items()} == {"native-modules-structure": 13, "native-modules-declarations": 9, "native-modules-bindings": 13, "native-modules-exports": 24}

for mode in ["Debug", "ReleaseSafe"]:
    for group in ["新门禁", "原门禁"]:
        evidence = json.loads((doc / f"{group}{mode}证据.json").read_text())

        assert evidence["passed"] and evidence["exit_code"] == 0 and not evidence["errors"]
        assert evidence["source_commit"] == baseline["source_commit"]
        assert evidence["packages_tree"] == baseline["packages_tree"]
        assert digest(doc / evidence["log"]) == evidence["log_sha256"]

        for item in evidence["artifacts"]:
            assert digest(doc / item["saved"]) == item["sha256"]
            assert digest(Path(item["executed_source"])) == item["sha256"]

        for item in evidence["logged_zig_test_binaries"]:
            assert digest(Path(item["path"])) == item["sha256"]

        if group == "新门禁":
            assert evidence["steps_passed"] == evidence["steps_total"] == 30
            assert evidence["tests_passed"] == evidence["tests_total"] == 59
            assert len(evidence["formal_parser_options"]) == 4
            assert {Path(item["path"]).name for item in evidence["logged_zig_test_binaries"]} == set(expected)
            compiled = {}

            for item in evidence["commands"]:
                args = shlex.split(item["command"])
                if len(args) < 2 or args[1] != "test":
                    continue
                name = args[args.index("--name") + 1]
                source_path = Path(next(arg.split("=", 1)[1] for arg in args if arg.startswith("-Mroot=")))
                source = source_path if source_path.is_absolute() else snapshot / "packages/test" / source_path
                compiled[name] = re.findall(r'^test "([^"]+)"', source.read_text(), re.MULTILINE)

            assert compiled == expected

            for option in evidence["formal_parser_options"]:
                assert option["generated_parser"] and digest(Path(option["path"])) == option["sha256"]

print("PASS: exact frozen inputs, unchanged assertions after import correction, all 118 new checks and original gates")
