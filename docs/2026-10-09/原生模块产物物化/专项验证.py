import json
import subprocess
from pathlib import Path

out = Path("docs/2026-10-09/原生模块产物物化")
previous = Path("docs/2026-10-09/节点引用列重映射")
base = json.loads((previous / "专项编译参数.json").read_text())
base["command"] = [item.replace("docs/2026-10-09/产物规划宿主接入/生成", "docs/2026-10-09/原生模块产物物化/生成") for item in base["command"]]
results = []

for name in ["mixed", "mixed-resources", "cache-roundtrip", "native-link", "library-native"]:
    suffix = "命令.json" if name == "library-native" else "编译命令.json"
    reference = json.loads((previous / (name + suffix)).read_text())
    root = next(item for item in reference["command"] if item.startswith("-Mroot="))
    executable = "/tmp/zxc-native-materialize-" + name
    command = [root if item.startswith("-Mroot=") else "-femit-bin=" + executable if item.startswith("-femit-bin=") else item for item in base["command"]]
    (out / (name + "命令.json")).write_text(json.dumps({"cwd": base["cwd"], "command": command}, ensure_ascii=False, indent=2))
    compiled = subprocess.run(command, cwd=base["cwd"], capture_output=True, text=True)
    (out / (name + "编译.txt")).write_text(compiled.stdout + compiled.stderr)

    if compiled.returncode:
        results.append({"name": name, "compile": compiled.returncode})
        print(name, compiled.stderr[-4000:], flush=True)
        break

    subprocess.run(["codesign", "--force", "--sign", "-", executable], check=True, capture_output=True)
    checked = subprocess.run([executable], cwd=base["cwd"], capture_output=True, text=True)
    (out / (name + "运行.txt")).write_text(checked.stdout + checked.stderr)
    results.append({"name": name, "run": checked.returncode, "log": checked.stdout + checked.stderr})
    print(name, checked.returncode, (checked.stdout + checked.stderr)[-200:], flush=True)

    if checked.returncode:
        break

(out / "专项结果.json").write_text(json.dumps(results, ensure_ascii=False, indent=2))
