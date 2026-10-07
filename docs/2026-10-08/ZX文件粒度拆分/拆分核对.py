import hashlib
import json
import re
import subprocess
from pathlib import Path

root = Path(__file__).resolve().parents[3]
base = "d2a20ccf"
lexer = "packages/compiler/src/zx/frontend/lexer"


def original(path):
    return subprocess.check_output(["git", "show", base + ":" + path], cwd=root).decode()


def source(path):
    return (root / path).read_bytes().decode()


def write(name, value):
    Path(__file__).with_name(name).write_text(json.dumps(value, ensure_ascii=False, indent=2) + "\n")


tracked = subprocess.check_output(["git", "ls-files", "-z", "--", "*.zx"], cwd=root).decode().split("\0")
untracked = subprocess.check_output(["git", "ls-files", "--others", "--exclude-standard", "-z", "--", "*.zx"], cwd=root).decode().split("\0")
counts = {name: len(source(name).splitlines()) for name in set(tracked + untracked) if name and (root / name).is_file()}
violations = {name: count for name, count in counts.items() if count > 120}
assert not violations, violations

old_model = original(lexer + "/keyword_model.zx")
members = [member.strip() for member in old_model.split("{", 1)[1].split("}", 1)[0].split(",") if member.strip()]
ids = {name: index for index, name in enumerate(members)}
old_files = subprocess.check_output(["git", "ls-tree", "-r", "--name-only", base, "--", lexer + "/keyword_transition"], cwd=root).decode().splitlines()
old_files.append(lexer + "/keyword_transition.zx")
old_edges = {}

for path in old_files:
    for match in re.finditer(r"case Keyword\.(\w+): return match \{(.*?)\n\s*}", original(path), re.S):
        old_edges[ids[match[1]]] = {int(byte): ids[target] for byte, target in re.findall(r"in.byte == (\d+) => Keyword\.(\w+)", match[2])}

new_edges = {}

for path in (root / lexer / "keyword_transition").glob("*.zx"):
    entries = {}

    for match in re.finditer(r"case (\d+): return match \{(.*?)\n\s*}", path.read_text(), re.S):
        entries[int(match[1])] = {int(byte): int(target) for byte, target in re.findall(r"in.byte == (\d+) => (\d+)", match[2])}

    new_edges[path.stem] = entries

entry = source(lexer + "/keyword_transition.zx")
boundary = int(re.search(r"in.state <= (\d+)", entry)[1])
partitions = {}

for name in ["a_m", "n_w"]:
    text = source(lexer + "/keyword_transition/" + name + ".zx")
    imports = dict(re.findall(r'import (\w+) from "\./([^"]+)"', text))
    partitions[name] = [(int(low), int(high), imports[target]) for low, high, target in re.findall(r"in.state >= (\d+) && in.state <= (\d+)\) \{\s*return (\w+)\(in\)", text)]

for state in range(len(members)):
    selected = "root" if state == 0 else None

    if selected is None:
        selected = next((target for low, high, target in partitions["a_m" if state <= boundary else "n_w"] if low <= state <= high), None)

    for byte in range(256):
        before = old_edges.get(state, {}).get(byte, 1)
        after = new_edges.get(selected, {}).get(state, {}).get(byte, 1)
        assert before == after, (state, byte, before, after)

terminals = {int(state): name for state, name in re.findall(r"case (\d+): return Keyword\.(\w+)", source(lexer + "/keyword_value.zx"))}
words = json.loads(source(lexer + "/keywords.json")) + json.loads(source(lexer + "/contextual_words.json"))

for word in words:
    name = "Underscore" if word == "_" else "Upper" + word if word[0].isupper() else word[0].upper() + word[1:]
    assert terminals[ids[name]] == name

numeric = "packages/test/tests/language/lexical/numeric/decimal_original/cases"
old_paths = subprocess.check_output(["git", "ls-tree", "-r", "--name-only", base, "--", numeric], cwd=root).decode().splitlines()
pattern = r"case (\d+):\s+return ([^\s;]+)"
before = sorted(item for path in old_paths if path.endswith(".zx") for item in re.findall(pattern, original(path)))
after = sorted(item for path in (root / numeric).rglob("*.zx") for item in re.findall(pattern, path.read_text()))
assert before == after

fs = "packages/compiler/standard/interfaces/fs.d.zx"
fragments = next(module["fragments"] for module in json.loads(source("packages/compiler/standard/modules.json")) if module["specifier"] == "std:fs")
assembled = source(fs) + "\n" + "\n".join(source("packages/compiler/standard/" + name) for name in fragments) + "\n"
assert re.sub(r"\s+", "", assembled) == re.sub(r"\s+", "", original(fs))

catalogs = subprocess.check_output(["git", "diff", "--name-only", base, "--", "packages/test/**/*.jsonl"], cwd=root).decode().splitlines()
assert not catalogs, catalogs

write("静态核对结果.json", {
    "基线": base,
    "ZX文件数": len(counts),
    "最大行数": max(counts.values()),
    "超过120行": violations,
    "原始超限数": 49,
    "关键字旧新自动机": {"状态数": len(members), "逐状态逐字节转换核对数": len(members) * 256, "终结词数": len(words), "转换一致": True, "元数据调整": "非终结前缀统一发布 Dead，终结词保留原符号名"},
    "十进制原始编号及字面量": {"分支数": len(before), "逐项一致": True},
    "标准fs组合": {"接口声明及顺序一致": True, "sha256": hashlib.sha256(assembled.encode()).hexdigest()},
    "测试目录与预期JSONL变更": catalogs,
})
print("ZX line limits, DFA transitions, literal branches, fs declarations and existing catalogs verified")
