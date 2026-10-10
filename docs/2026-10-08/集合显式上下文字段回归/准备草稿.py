from pathlib import Path
import hashlib
import json
import subprocess


main = Path(__file__).resolve().parents[3]
doc = Path(__file__).resolve().parent
root = Path("/Users/xiewendao/.codex/worktrees/callback-context-conformance/zxc")
upstream = Path("/Users/xiewendao/.codex/conformance/upstream/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd")
reviews = {}

for path in (main / "packages/test/upstream/reviews").rglob("*.jsonl"):
    for line in path.read_text().split("\n"):
        if line:
            row = json.loads(line)
            reviews[row["path"]] = row

index = {}

for line in (main / "packages/test/upstream/index/built-ins.jsonl").read_text().split("\n"):
    if line:
        row = json.loads(line)
        index[row["path"]] = row

rows = []
originals = []

for method, prefix, value in [("map", "19", [True]), ("filter", "20", [1]), ("every", "16", True), ("some", "17", True)]:
    relative = f"test/built-ins/Array/prototype/{method}/15.4.4.{prefix}-5-2.js"
    path = upstream / relative
    data = path.read_bytes()
    identity = hashlib.sha256(data).hexdigest()
    assert identity == index[relative]["sha256"]
    assert relative not in reviews
    saved = doc / "原文" / method / path.name
    saved.parent.mkdir(parents=True, exist_ok=True)
    saved.write_bytes(data)
    case = f"built_ins/list/callbacks/{method}/context/context_true/single"
    reason = "保留原输入 [1]、对象字段 res=true、回调读取显式传入的对象字段以及原结果断言；外层 res=false 不参与预期。将 this.res 明确适配为 ZX 第二个回调参数 context.res，静态对象替代 new Object 后的字段写入，省略未使用的 val/idx/obj 参数，不声称 JS this 绑定、动态对象或参数协议。完整输出值断言保留并强于原观察。"
    rows.append({"path": relative, "sha256": identity, "status": "adapted", "reason": reason, "contract": "packages/core/IR契约.md#所有权与集合回调", "cases": [case], "assertions": [{"case": case, "field": "value", "expected": value}]})
    originals.append({"path": relative, "sha256": identity, "saved": str(saved.relative_to(doc))})

formal = ["packages/test/build.zig", "packages/test/suites.json", "packages/test/src/generate_callback_contexts.ts", "packages/test/src/data/callback_contexts.jsonl", "packages/test/upstream/reviews/built_ins/array/callback_contexts.jsonl"]

for method in ["map", "filter", "every", "some"]:
    for extension in ["zx", "jsonl"]:
        formal.append(f"packages/test/tests/built_ins/list/callbacks/{method}/context/cases.{extension}")

for relative in ["packages/test/build.zig", "packages/test/suites.json"]:
    destination = doc / "草稿" / relative
    destination.parent.mkdir(parents=True, exist_ok=True)
    destination.write_bytes((root / relative).read_bytes())

build = doc / "草稿/packages/test/build.zig"
text = build.read_text().replace('"src/generate_array_callbacks.ts",', '"src/generate_array_callbacks.ts", "src/generate_callback_contexts.ts",', 1)
line = '        if (std.mem.eql(u8, script, "src/generate_array_callbacks.ts")) check.addFileInput(b.path("src/data/array_callbacks.jsonl"));'
assert line in text
text = text.replace(line, line + '\n        if (std.mem.eql(u8, script, "src/generate_callback_contexts.ts")) check.addFileInput(b.path("src/data/callback_contexts.jsonl"));')
build.write_text(text)

suites = doc / "草稿/packages/test/suites.json"
text = subprocess.check_output(["git", "show", "HEAD:packages/test/suites.json"], cwd=root, text=True)
start = text.index("[", text.index('"runtime":'))
existing, offset = json.JSONDecoder().raw_decode(text[start:])
end = start + offset
added = [{"name": "array-callbacks-context-" + method, "path": f"built_ins/list/callbacks/{method}/context/cases", "kind": "collections"} for method in ["map", "filter", "every", "some"]]
blocks = ["\n".join("        " + line for line in json.dumps(row, indent=4).split("\n")) for row in added]
text = text[:end - 1].rstrip() + ",\n" + ",\n".join(blocks) + "\n    " + text[end - 1:]
assert json.loads(text)["runtime"] == existing + added
suites.write_text(text)

data = doc / "草稿/packages/test/src/data/callback_contexts.jsonl"
data.parent.mkdir(parents=True, exist_ok=True)
data.write_text("".join(json.dumps(row, ensure_ascii=True, separators=(",", ":")) + "\n" for row in rows))

for relative in formal:
    path = doc / "草稿" / relative

    if path.exists():
        destination = root / relative
        destination.parent.mkdir(parents=True, exist_ok=True)
        destination.write_bytes(path.read_bytes())

for relative in ["node_modules", "packages/test/node_modules"]:
    destination = root / relative

    if not destination.exists():
        destination.symlink_to(main / relative, target_is_directory=True)

(doc / "正式路径.json").write_text(json.dumps(formal, ensure_ascii=False, indent=2) + "\n")
(doc / "原文身份.json").write_text(json.dumps(originals, ensure_ascii=False, indent=2) + "\n")
print("drafts prepared", len(formal), "upstream originals", len(originals))
