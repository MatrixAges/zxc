import hashlib
import json
import pathlib
import re
import subprocess
import sys

DOC = pathlib.Path(__file__).resolve().parent
MODES = {"mixed": 7, "direct": 7, "borrowed": 7, "shrink": 7, "nested": 7, "dual": 7, "leaves": 6, "consumer": 7, "fallback": 7}


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def collect(label, cache):
    log = DOC / (label + "原始日志.txt")
    text = log.read_text()
    summary = re.search(r"Build Summary: (\d+)/(\d+) steps succeeded; (\d+)/(\d+) tests passed", text)
    assert summary and tuple(map(int, summary.groups())) == (85, 85, 124, 124)
    leaves = re.findall(r"run test (loop-columns-[\w-]+) (\d+) pass \((\d+) total\)", text)
    expected = {"loop-columns-" + mode + "-" + route: count for mode, count in MODES.items() for route in ("source", "library")}
    assert len(leaves) == 18 and {name: int(count) for name, count, total in leaves} == expected
    assert all(count == total for name, count, total in leaves)
    assert not re.search(r"run test[^\n]*?(?<!\S)cached(?:\s|$)", text)

    executables = list((cache / "o").glob("*/compile-loop-columns"))
    assert len(executables) == 1
    tool = executables[0]
    artifacts = []
    shapes = []
    outputs = {name: list((cache / "o").glob("*/" + name)) for name in ("source.zig", "source_abi.zig", "library.zig", "library_abi.zig")}

    for mode in MODES:
        folder = DOC / "生成产物" / label / mode
        folder.mkdir(parents=True, exist_ok=True)
        names = ["source.zig", "source_abi.zig", "library.zig", "library_abi.zig"]
        paths = [folder / (name + ".txt") for name in names]
        result = subprocess.run([str(tool), mode] + [str(path) for path in paths], capture_output=True, check=True)
        assert not result.stdout and not result.stderr

        mode_cache = None

        for name, path in zip(names, paths):
            sha = digest(path)
            matches = [candidate for candidate in outputs[name] if digest(candidate) == sha]
            if mode_cache is not None:
                matches = [candidate for candidate in matches if candidate.parent == mode_cache]

            assert len(matches) == 1, (mode, name, matches)
            mode_cache = matches[0].parent
            artifacts.append({"mode": mode, "route": name.split("_")[0].split(".")[0], "kind": "abi" if "abi" in name else "program", "path": str(path.relative_to(DOC)), "cache_path": str(matches[0]), "sha256": sha, "bytes": path.stat().st_size})

        for route in ("source", "library"):
            source = (folder / (route + ".zig.txt")).read_text()
            execute = source[source.index("pub fn execute("):]
            buffers = re.findall(r"\.ArrayList\((state_type_\d+)\)", execute)
            definitions = {name: fields.strip() for name, fields in re.findall(r"const (state_type_\d+) = struct \{([^{}]*)\};", execute, re.S)}
            assert all(name in definitions for name in buffers)
            shapes.append({"mode": mode, "route": route, "value_buffers": len(buffers), "deinit": execute.count(").deinit(allocator)"), "transfers": execute.count(").toOwnedSlice(allocator)"), "error_cleanup": execute.count("errdefer (allocator).free(state_owned_"), "buffer_fields": [definitions[name] for name in buffers], "imports": re.findall(r'@import\("([^\"]+)"\)', source), "formal_shape_gate": "shape.zig passed before artifact write"})

    result = {"source": json.loads((DOC / "输入清单.json").read_text())["source"], "mode": label, "cache": str(cache), "log_sha256": digest(log), "steps": 85, "actual_passed": 124, "actual_leaves": 18, "cached_test_leaves": 0, "leaf_results": [{"name": name, "passed": int(count)} for name, count, total in leaves], "emitter": str(tool), "emitter_sha256": digest(tool), "artifacts": artifacts, "shapes": shapes}
    (DOC / (label + "执行结果.json")).write_text(json.dumps(result, ensure_ascii=False, indent=2) + "\n")
    print(label, "124 actual tests; 36 byte-matched artifacts")


if __name__ == "__main__":
    collect(sys.argv[1], pathlib.Path(sys.argv[2]))
