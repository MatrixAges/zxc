import json
import pathlib
import subprocess
import sys

base = pathlib.Path(__file__).resolve().parent
fixtures = pathlib.Path("/Users/xiewendao/.codex/worktrees/callback-capture-borrow-conformance/zxc/packages/test/tests/collections/context_borrow")
zig = "/Users/xiewendao/.local/share/zig/zig-x86_64-macos-0.17.0/zig"
measurement = pathlib.Path("/Users/xiewendao/Documents/MatrixAges/zxc/docs/2026-10-09/集合上下文借用与库消费/容量观察/measurement.zig")
results = []

def execute(command, directory, label):
    (directory / (label + "命令.json")).write_text(json.dumps(command, ensure_ascii=False, indent=2))
    result = subprocess.run(command, cwd=directory, capture_output=True, text=True)
    (directory / (label + ".txt")).write_text(result.stdout + result.stderr)
    return result.returncode

def run(kind, method, route, measure=False):
    directory = base / "上下文修复复核" / (kind + "-" + method + "-" + route)
    directory.mkdir(parents=True, exist_ok=True)
    source = fixtures / "fixtures" / kind
    status = execute(["/tmp/zxc-capture-generator", str(source / (method + ".zx")), str(source / "host.d.zx"), route, str(directory)], directory, "生成")
    if status:
        return {"case": directory.name, "generate": status}

    (directory / "options.zig").write_text('pub const method: []const u8 = "' + method + '";\npub const kind: enum { list, object, nested } = .' + kind + ';\n')
    modules = json.loads((directory / "modules.json").read_text())
    native = json.loads((directory / "native.json").read_text())[0]
    by_name = {m["name"]: m for m in modules}
    needed = set()
    pending = ["program"]
    while pending:
        name = pending.pop()
        if name in needed or name == native["import_name"]:
            continue
        needed.add(name)
        pending.extend(by_name[name]["imports"])

    command = [zig, "test", "-ODebug", "--dep", "program", "--dep", "host=" + native["import_name"], "--dep", "options", "--dep", "oracle"]
    if measure:
        command += ["--dep", "fixture"]
    command += ["-Mroot=" + str(measurement if measure else fixtures / "root.zig")]
    for module in modules:
        if module["name"] not in needed:
            continue
        command += ["-ODebug", "--dep", "zxc_abi"]
        for name in module["imports"]:
            command += ["--dep", name]
        command += ["-M" + module["name"] + "=" + str(directory / (module["name"] + ".zig"))]
    abi = native["import_name"] + "_abi" if native["identity"] else "zxc_abi"
    command += ["-ODebug", "--dep", "options", "--dep", "zxc_abi=" + abi, "-M" + native["import_name"] + "=" + str(fixtures / "host.zig")]
    if native["identity"]:
        command += ["-ODebug", "--dep", "zxc_abi_canonical=zxc_abi", "-M" + abi + "=" + str(directory / (abi + ".zig"))]
    command += ["-ODebug", "-Moracle=" + str(fixtures.parent / "context_effects/oracle.zig"), "-ODebug", "-Moptions=" + str(directory / "options.zig"), "-ODebug", "-Mzxc_abi=" + str(directory / "types.zig")]
    if measure:
        command += ["-ODebug", "--dep", "program", "--dep", "options", "-Mfixture=" + str(fixtures / "fixture.zig")]
    binary = "/tmp/zxc-context-" + directory.name + ("-measure" if measure else "")
    label = "容量" if measure else "专项"
    command += ["--test-no-exec", "-femit-bin=" + binary]
    status = execute(command, directory, label + "编译")
    if status:
        return {"case": directory.name, "measure": measure, "compile": status}
    subprocess.run(["codesign", "--force", "--sign", "-", binary], capture_output=True, check=True)
    status = execute([binary], directory, label + "运行")
    return {"case": directory.name, "measure": measure, "run": status}

cases = [("object", "every", route, True) for route in ("source", "library")] if "--measure" in sys.argv else [(kind, method, route, False) for kind in ("list", "object", "nested") for method in ("every", "some", "map", "filter") for route in ("source", "library")]
for case in cases:
    result = run(*case)
    results.append(result)
    print(result, flush=True)
    (base / ("上下文容量结果.json" if "--measure" in sys.argv else "上下文专项结果.json")).write_text(json.dumps(results, ensure_ascii=False, indent=2))
