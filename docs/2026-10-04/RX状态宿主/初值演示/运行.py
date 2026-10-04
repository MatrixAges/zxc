import hashlib
import json
import subprocess
from pathlib import Path

base = Path(__file__).resolve().parent.parent
project = base / "初值项目"
output = base / "初值生成"
generator = base / "初值演示/zig-out/bin/store-initializers"


def generate():
    result = subprocess.run(
        [str(generator), str(project / "sources.json"), str(output)],
        text=True, capture_output=True, check=True,
    )
    print(result.stderr, end="")
    return result.stderr


def hashes():
    return {
        path.name: hashlib.sha256(path.read_bytes()).hexdigest()
        for path in sorted(output.glob("*.zig"))
        if path.name != "consume.zig"
    }


first = generate()
original = hashes()
repeat = generate()
source = project / "state.store.rx"
text = source.read_text()

try:
    source.write_text(text.replace('value="3"', 'value="17"', 1))
    changed = generate()
    modified = hashes()
finally:
    source.write_text(text)
    restored = generate()

metadata = json.loads((output / "initializers.json").read_text())
lines = [
    'const std = @import("std");',
    'pub fn main(init: std.process.Init) !void {',
    '    const allocator = init.arena.allocator();',
]
command = ["zig", "build-exe"]

for index, item in enumerate(metadata):
    command += ["--dep", f"initial_{index}"]
    identity = json.dumps(item["identity"], ensure_ascii=False)
    lines += [
        f'    const state_{index} = try @import("initial_{index}").execute(init.arena, {{}});',
        f'    std.debug.print("{{s}}={{s}}\\n", .{{ {identity}, try std.json.Stringify.valueAlloc(allocator, state_{index}, .{{}}) }});',
    ]

lines += ["}"]
(output / "consume.zig").write_text("\n".join(lines) + "\n")
command += ["-Mroot=" + str(output / "consume.zig")]

for index, item in enumerate(metadata):
    command += ["--dep", "zxc_abi", f"-Minitial_{index}=" + str(output / (item["module_name"] + ".zig"))]

command += ["-Mzxc_abi=" + str(output / "types.zig"), "-femit-bin=" + str(output / "consume")]
subprocess.run(command, check=True)
result = subprocess.run([str(output / "consume")], text=True, capture_output=True, check=True)
print(result.stdout + result.stderr, end="")
record = {
    "exit_code": result.returncode,
    "output": result.stdout + result.stderr,
    "cache": {"first": first, "repeat": repeat, "changed": changed, "restored": restored},
    "changed_sources": [name for name in original if original[name] != modified[name]],
    "restored_sources_match": original == hashes(),
    "binary_sha256": hashlib.sha256((output / "consume").read_bytes()).hexdigest(),
    "initializers": metadata,
}
(output / "运行结果.json").write_text(json.dumps(record, ensure_ascii=False, indent=2) + "\n")
