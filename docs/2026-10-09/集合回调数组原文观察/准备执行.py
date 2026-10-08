from pathlib import Path
import hashlib
import json
import shutil
import subprocess


doc = Path(__file__).resolve().parent
main = doc.parents[2]
root = Path("/Users/xiewendao/.codex/worktrees/callback-array-observations-conformance/zxc")
upstream = Path("/Users/xiewendao/.codex/conformance/upstream/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd")
run = Path("/Users/xiewendao/.codex/conformance/callback-array-observations-6b0cbb6b8/r1")
assert not run.exists()
run.mkdir(parents=True)
sha = lambda data: hashlib.sha256(data).hexdigest()
lock = json.loads((root / "packages/test/upstream/lock.json").read_text())
assert lock["revision"] == "7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd"
archive = upstream.parent / (lock["revision"] + ".tar.gz")
assert sha(archive.read_bytes()) == lock["archive_sha256"]
index = {}
reviewed = set()

for path in (root / "packages/test/upstream/index").glob("*.jsonl"):
    for line in path.read_text().split("\n"):
        if line:
            item = json.loads(line)
            index[item["path"]] = item

for path in (root / "packages/test/upstream/reviews").rglob("*.jsonl"):
    for line in path.read_text().split("\n"):
        if line:
            reviewed.add(json.loads(line)["path"])

rows = []
originals = []
contract = "packages/core/IR契约.md#所有权与集合回调"

for method, number in [("map", 19), ("filter", 20), ("every", 16), ("some", 17)]:
    name = f"test/built-ins/Array/prototype/{method}/15.4.4.{number}-5-3.js"
    case = f"built_ins/list/callbacks/{method}/context/context_true/single"
    value = [True] if method == "map" else [1] if method == "filter" else True
    rows.append({"path": name, "sha256": sha((upstream / name).read_bytes()), "status": "adapted", "reason": "保留原输入 [1]、数组对象自有字段 res=true、回调读取 this.res 以及完整原结果观察；外层 res=false 不参与预期。把仅被观察的自有字段投影为静态对象上下文 context.res，明确省略未使用 val/idx/obj；不声称支持 Array 动态属性、JS this 绑定或数组对象品牌。原生完整输出值同时验证长度与元素。", "contract": contract, "cases": [case], "assertions": [{"case": case, "field": "value", "expected": value}]})

name = "test/built-ins/Array/prototype/filter/15.4.4.20-5-27.js"
case = "built_ins/list/callbacks/filter/constant_false/single"
rows.append({"path": name, "sha256": sha((upstream / name).read_bytes()), "status": "adapted", "reason": "保留原输入 [11] 和过滤结果容器类别；无副作用空函数的固定 undefined 判定沿用显式 false 谓词映射。Array.isArray 的类别观察映射为静态 i64[]、实际 program.Output 的 Zig slice/i64 类型断言，以及真实执行的完整空列表比较；证据位于 tests/collections/filter_result_kind/result_test.zig，不依赖 JSON 包装或恒 true 品牌函数。不声称实现动态 Array.isArray、void 回调或零形参协议。", "contract": contract, "cases": [case], "assertions": [{"case": case, "field": "value", "expected": []}]})

for item in rows:
    assert item["path"] not in reviewed
    assert item["sha256"] == index[item["path"]]["sha256"]
    path = doc / "原文" / (Path(item["path"]).parent.name + "-" + Path(item["path"]).name + ".txt")
    path.parent.mkdir(exist_ok=True)
    shutil.copyfile(upstream / item["path"], path)
    originals.append({"path": item["path"], "sha256": item["sha256"], "saved": str(path.relative_to(doc))})

shutil.copyfile(upstream / "LICENSE", doc / "原文/LICENSE.txt")
(doc / "原文身份.json").write_text(json.dumps(originals, ensure_ascii=False, indent=4) + "\n")
data_name = "packages/test/src/data/callback_array_observations.jsonl"
data = doc / "草稿" / data_name
data.parent.mkdir(parents=True, exist_ok=True)
data.write_text("".join(json.dumps(item, ensure_ascii=True, separators=(",", ":")) + "\n" for item in rows))

for path in (doc / "草稿").rglob("*"):
    if path.is_file():
        name = path.relative_to(doc / "草稿")
        (root / name).parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(path, root / name)

build = root / "packages/test/build.zig"
text = build.read_text()
needle = '    test_step.dependOn(@import("build/predicates.zig").add(b, compiler, target, optimize));'
assert text.count(needle) == 1
text = text.replace(needle, needle + '\n    test_step.dependOn(@import("build/filter_result_kind.zig").add(b, compiler, target, optimize));')
needle = '"src/generate_callback_contexts.ts"'
assert text.count(needle) == 2
text = text.replace(needle + ",", needle + ', "src/generate_callback_array_observations.ts",', 1)
needle = '        if (std.mem.eql(u8, script, "src/generate_callback_contexts.ts")) check.addFileInput(b.path("src/data/callback_contexts.jsonl"));'
assert text.count(needle) == 1
text = text.replace(needle, needle + '\n        if (std.mem.eql(u8, script, "src/generate_callback_array_observations.ts")) check.addFileInput(b.path("src/data/callback_array_observations.jsonl"));')
build.write_text(text)

for target in [root / "node_modules", root / "packages/test/node_modules"]:
    if not target.exists():
        target.symlink_to(main / target.relative_to(root), target_is_directory=True)

subprocess.run(["node", "src/generate_callback_array_observations.ts"], cwd=root / "packages/test", check=True)
formal = sorted([str(path.relative_to(doc / "草稿")) for path in (doc / "草稿").rglob("*") if path.is_file()] + ["packages/test/build.zig", "packages/test/upstream/reviews/built_ins/array/callback_array_observations.jsonl"])
subprocess.run(["node", "scripts/format.mjs", *[name for name in formal if name.endswith(".zig")]], cwd=root, check=True)
subprocess.run(["node", str(main / "node_modules/prettier/bin/prettier.cjs"), "--write", "packages/test/src/generate_callback_array_observations.ts"], cwd=root, check=True, stdout=subprocess.DEVNULL)
subprocess.run(["node", "src/generate_callback_array_observations.ts", "--check"], cwd=root / "packages/test", check=True)

for name in formal:
    target = doc / "草稿" / name
    target.parent.mkdir(parents=True, exist_ok=True)
    shutil.copyfile(root / name, target)

previous = json.loads((main / "docs/2026-10-09/RX产品缓冲转移边界/执行输入.json").read_text())
old_run = "/Users/xiewendao/.codex/conformance/product-transfer-1cd5896ff/r1"
command = [arg if arg.startswith("-M") else arg.replace(old_run, str(run)) for arg in previous["generator_compile"]]
(run / "generated").mkdir()
outputs = [Path(arg).name for arg in previous["generator_run"][2:-1]]
files = subprocess.check_output(["git", "ls-files", "-z", "--", "packages"], cwd=root).decode().strip("\0").split("\0")
inputs = {"root": str(root), "run": str(run), "source_commit": subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=root, text=True).strip(), "formal": formal, "tools": previous["tools"], "zig": previous["zig"], "entitlements": previous["entitlements"], "external_inputs": previous["external_inputs"], "generator_compile": command, "generator_run": [str(run / "generate-parser"), "../compiler/src", *[str(run / "generated" / name) for name in outputs], "../lint/src/naming"], "test_templates": previous["test_templates"], "packages": {name: sha((root / name).read_bytes()) for name in sorted(set(files + formal))}, "upstream_lock": lock}
(doc / "执行输入.json").write_text(json.dumps(inputs, ensure_ascii=False, indent=4) + "\n")
(doc / "正式路径.json").write_text(json.dumps(formal, indent=4) + "\n")
print("prepared", len(formal), "formal paths and", len(inputs["packages"]), "frozen inputs")
