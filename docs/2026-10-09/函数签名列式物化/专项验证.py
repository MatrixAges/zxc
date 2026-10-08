import json
import subprocess
import sys
from pathlib import Path

out = Path("docs/2026-10-09/函数签名列式物化")
base = json.loads((out / "正式依赖专项参数.json").read_text())
groups = {
    "产物": [
        ("extract", "incremental/artifact/extract_test.zig"),
        ("mixed", "incremental/artifact/mixed/extract_test.zig"),
        ("mixed-resources", "incremental/artifact/mixed/resources_test.zig"),
        ("native-link", "incremental/native_link/link_test.zig"),
        ("cache-roundtrip", "incremental/cache_codec/roundtrip_test.zig"),
        ("cache-invalid", "incremental/cache_codec/invalid_test.zig"),
        ("cache-resources", "incremental/cache_codec/resources_test.zig"),
        ("ownership-input", "ownership/input/modules.zig"),
    ],
    "原生": [
        ("native-names", "native/references/ir/name_columns/root_test.zig"),
        ("native-owner", "native/references/ir/owner_test.zig"),
        ("native-boundary", "native/references/ir/boundary_test.zig"),
        ("library-native", "library/imports/native_test.zig"),
    ],
}
results = []
group = sys.argv[1]

for name, source in groups[group]:
    executable = "/tmp/zxc-signature-columns-" + name
    command = ["-Mroot=packages/test/tests/" + source if item.startswith("-Mroot=") else "-femit-bin=" + executable if item.startswith("-femit-bin=") else item for item in base["command"]]

    (out / (name + "命令.json")).write_text(json.dumps({"cwd": base["cwd"], "command": command}, ensure_ascii=False, indent=2))
    compiled = subprocess.run(command, cwd=base["cwd"], capture_output=True, text=True)
    (out / (name + "编译.txt")).write_text(compiled.stdout + compiled.stderr)

    if compiled.returncode:
        results.append({"name": name, "compile": compiled.returncode})
        print(name, compiled.stderr[-5000:], flush=True)
        break

    subprocess.run(["codesign", "--force", "--sign", "-", executable], check=True, capture_output=True)
    checked = subprocess.run([executable], cwd=base["cwd"], capture_output=True, text=True)
    (out / (name + "运行.txt")).write_text(checked.stdout + checked.stderr)
    results.append({"name": name, "run": checked.returncode, "log": checked.stdout + checked.stderr})
    print(name, checked.returncode, (checked.stdout + checked.stderr)[-200:], flush=True)

    if checked.returncode:
        break

(out / (group + "专项结果.json")).write_text(json.dumps(results, ensure_ascii=False, indent=2))
