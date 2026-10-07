from pathlib import Path
import hashlib
import json


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    directory = Path(__file__).resolve().parent
    root = directory.parents[2]
    frozen = json.loads((directory / "输入冻结.json").read_text())

    for item in frozen["paths"]:
        assert digest(root / item["path"]) == item["sha256"], item["path"]
        assert digest(directory / "草稿" / item["path"]) == item["sha256"], item["path"]

    modes = ["flat", "branch", "chain", "captured", "duplicate", "fallback", "mixed", "escape_before", "escape_after", "effects_set", "effects_add", "effects_nested_set", "effects_nested_add"]
    names = {f"function-updates-{mode}-{route}" for mode in modes for route in ["source", "library"]}

    for label in ["Debug", "ReleaseSafe"]:
        evidence = json.loads((directory / (label + "证据.json")).read_text())

        assert evidence["source_commit"] == frozen["source_commit"]
        assert evidence["checks"] == 584
        assert len(evidence["records"]) == 26
        assert {row["name"] for row in evidence["records"]} == names
        assert digest(directory / evidence["log_path"]) == evidence["log_sha256"]
        assert sum(row["tests"] for row in evidence["records"]) == 584

        for row in evidence["records"]:
            name = row["name"]
            expected = 33 if "effects_nested_" in name else 25 if "effects_" in name else 19 if any(mode in name for mode in ["captured", "duplicate", "escape_before", "escape_after"]) else 20

            assert row["tests"] == expected
            assert row["exit_code"] == 0
            assert len(row["generated"]) == (3 if "effects_" in name else 2)
            assert digest(directory / row["replay_path"]) == row["replay_sha256"]
            assert f"All {expected} tests passed." in (directory / row["replay_path"]).read_text()

            for generated in row["generated"]:
                assert digest(directory / generated["path"]) == generated["sha256"]

    for route in ["source", "library"]:
        failure = json.loads((directory / "缺陷证据" / (route + "二进制.json")).read_text())

        assert failure["exit_code"] == 1
        assert digest(directory / "缺陷证据" / (route + "独立复跑.txt")) == failure["log_sha256"]
        assert "21 passed; 0 skipped; 4 failed." in (directory / "缺陷证据" / (route + "独立复跑.txt")).read_text()

    print(json.dumps({"formal_paths": len(frozen["paths"]), "binaries": 52, "checks": 1168, "old_defect_reproduced": True}))


if __name__ == "__main__":
    main()
