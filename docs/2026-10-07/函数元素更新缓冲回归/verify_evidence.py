from pathlib import Path
import hashlib
import json
import re


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    directory = Path(__file__).resolve().parent
    root = directory.parents[2]
    frozen = json.loads((directory / "输入冻结.json").read_text())
    evidence = json.loads((directory / "执行证据.json").read_text())

    for item in frozen["paths"]:
        assert digest(root / item["path"]) == item["sha256"], item["path"]
        assert digest(directory / "草稿" / item["path"]) == item["sha256"], item["path"]

    for log in evidence["logs"]:
        assert digest(directory / log["path"]) == log["sha256"]

    expected_names = {
        f"function-updates-{mode}-{route}"
        for mode in ["flat", "branch", "chain", "captured", "duplicate", "fallback", "mixed"]
        for route in ["source", "library"]
    }

    for optimize in ["Debug", "ReleaseSafe"]:
        rows = [row for row in evidence["records"] if row["optimize"] == optimize]

        assert len(rows) == 14
        assert {row["name"] for row in rows} == expected_names
        assert sum(row["tests"] for row in rows) == 276
        assert "71/71 steps succeeded; 276/276 tests passed" in (directory / "日志" / f"{optimize}.txt").read_text()

        for row in rows:
            binary = Path(row["binary_path"])

            if binary.exists():
                assert digest(binary) == row["binary_sha256"]

            assert row["exit_code"] == 0
            replay = directory / row["replay_path"]

            assert digest(replay) == row["replay_sha256"]
            assert f"All {row['tests']} tests passed." in replay.read_text()

            for generated in row["generated"]:
                assert digest(directory / generated["saved_path"]) == generated["sha256"]

        mixed = (directory / "生成物" / optimize / "function-updates-mixed-source.zig.txt").read_text()

        assert re.search(r"function_\d+_buffered\([^\n]*\.lane_0 = null, \.lane_1 = \.\{", mixed)

    mutant = json.loads((directory / "反例" / "执行.json").read_text())

    assert mutant["exit_code"] != 0
    assert digest(directory / "反例" / "错误增量.zig.txt") == mutant["source_sha256"]
    assert digest(directory / "反例" / "拒绝日志.txt") == mutant["log_sha256"]
    assert "TestExpectedEqual" in (directory / "反例" / "拒绝日志.txt").read_text()

    print(json.dumps({"formal_paths": len(frozen["paths"]), "binary_records": 28, "checks": 552, "mutant_rejected": True}))


if __name__ == "__main__":
    main()
