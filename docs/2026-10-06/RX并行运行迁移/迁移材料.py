import html
import importlib.util
import json
import sys
from pathlib import Path

sys.dont_write_bytecode = True

root = Path(__file__).resolve().parents[3]
helper_path = root / "docs/2026-10-06/RX公开推导迁移/迁移材料.py"
sys.path.insert(0, str(helper_path.parent))
spec = importlib.util.spec_from_file_location("migration", helper_path)
migration = importlib.util.module_from_spec(spec)
spec.loader.exec_module(migration)
scanner = migration.scanner


def convert(source):
    scopes = [{"name": "root", "bindings": {"ctx": "$ctx"}, "out": []}]
    replacements = []

    def expression(attr, bindings):
        if not attr["raw"].startswith("{"):
            return

        updated = scanner.expression(attr["raw"], bindings)

        if updated != attr["raw"]:
            replacements.append((attr["value_start"], attr["value_end"], updated))

    for node in scanner.tags(source):
        name = node["name"]
        closing = source[node["start"] + 1] == "/"

        if closing:
            if name in ["Module", "Task", "Case", "Default", "Parallel"]:
                scope = scopes.pop()
                assert scope["name"] == name

                for attr in scope["out"]:
                    expression(attr, scope["bindings"])

                if name == "Parallel":
                    scopes[-1]["bindings"].update(scope["bindings"])

            continue

        scoped = name in ["Module", "Task", "Case", "Default", "Parallel"]
        self_closing = source[node["start"]:node["end"]].rstrip().endswith("/>")

        if scoped and not self_closing:
            scopes.append({"name": name, "bindings": scopes[-1]["bindings"].copy(), "out": []})

        attrs = {attr["key"]: attr for attr in node["attrs"]}
        bindings = scopes[-1]["bindings"]

        if name == "Call":
            if "service" in attrs:
                attr = attrs["service"]
                replacements.append((attr["key_start"], attr["key_end"], "module"))

            if "name" in attrs:
                attr = attrs["name"]
                alias = html.unescape(attr["raw"][1:-1])
                target = attrs.get("fn") or attrs.get("service") or attrs.get("module")
                result = "$ctx." + migration.target_name(target["raw"])

                for prefix in ["ctx.", "$ctx."]:
                    bindings[prefix + alias] = result

                replacements.append((attr["start"], attr["value_end"], ""))

        for attr in node["attrs"]:
            if name == "Task" and attr["key"] == "out" and not self_closing:
                scopes[-1]["out"].append(attr)
            else:
                expression(attr, bindings)

    assert len(scopes) == 1

    for start, end, text in sorted(replacements, reverse=True):
        source = source[:start] + text + source[end:]

    return source


base = root / "packages/test/tests/rx/runtime/parallel/fixtures"
changes = {
    "owned/direct.rx": {
        '<Call fn="copy_values" in={$in} name="second"/>': '<Call fn="copy_values_right" in={$in} name="second"/>',
        '<Call fn="consume" in={ctx.second} name="right"/>': '<Call fn="consume_right" in={ctx.second} name="right"/>',
    },
    "owned/module.rx": {
        '<Call fn="copy_values" in={$in} name="second"/>': '<Call fn="copy_values_right" in={$in} name="second"/>',
        '<Call module="owned/consume" in={ctx.first} name="left"/>': '<Call module="owned/consume_left" in={ctx.first} name="left"/>',
        '<Call module="owned/consume" in={ctx.second} name="right"/>': '<Call module="owned/consume_right" in={ctx.second} name="right"/>',
    },
    "input_error.rx": {
        '<Call fn="map_values" in={[$in.missing[0]]} name="right" />': '<Call fn="map_values_right" in={[$in.missing[0]]} name="right" />',
    },
    "thread_direct.rx": {
        '<Call fn="copy_values" in={$in} name="right" />': '<Call fn="copy_values_right" in={$in} name="right" />',
    },
    "task/capture.rx": {
        '<Call fn="map_values" in={$in} name="local_values" />': '<Call fn="map_values_local" in={$in} name="local_values" />',
    },
    "task/borrowed.rx": {
        '<Call fn="map_values" in={ctx.saved} name="local_values" />': '<Call fn="map_values_local" in={ctx.saved} name="local_values" />',
    },
    "task/borrowed_nested.rx": {
        '<Call fn="map_values" in={ctx.saved} name="nested_values" />': '<Call fn="map_values_local" in={ctx.saved} name="nested_values" />',
    },
}
modified = []

for path in sorted(base.rglob("*.rx")):
    original = path.read_text()
    source = original

    if str(path.relative_to(base)) in ["owned/direct.rx", "owned/module.rx", "owned/service.rx"]:
        source = source.replace("{{ctx.left,ctx.right}}", "{{left: ctx.left, right: ctx.right}}")
        source = source.replace("{{ctx.left, ctx.right}}", "{{left: ctx.left, right: ctx.right}}")

    for before, after in changes.get(str(path.relative_to(base)), {}).items():
        source = source.replace(before, after)

    updated = convert(source)

    if updated == original:
        continue

    modified.append(str(path.relative_to(root)))
    path.write_text(updated)

print(json.dumps({"files": modified}, ensure_ascii=False, indent=2))
