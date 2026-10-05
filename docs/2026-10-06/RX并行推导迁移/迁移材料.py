import ast
import html
import importlib.util
import re
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

number_targets = {
    "first": "number_first", "second": "number_second", "later": "number_later",
    "other": "number_other", "base": "number_base", "left": "number_left",
    "right": "number_right", "total": "number_total", "local": "number_local",
    "a": "a", "ab": "ab", "group_a": "group_a", "group_b": "group_b",
    "$in_value": "$in_value", "store_value": "store_value", "task": "task",
    "value.child": "number.child",
}


def convert_block(block, relative):
    pattern = re.compile(r'"(?:\\.|[^"\\])*"', re.DOTALL)
    updates = []
    bindings = {"ctx": "$ctx"}
    renamed = False

    for match in pattern.finditer(block):
        value = ast.literal_eval(match.group())

        if "<Module" not in value:
            continue

        replacements = []

        for node in scanner.tags(value):
            if node["name"] != "Call":
                continue

            attrs = {attr["key"]: attr for attr in node["attrs"]}
            alias = attrs.get("name")
            target = attrs.get("fn") or attrs.get("service") or attrs.get("module")

            if target is None or alias is None:
                continue

            renamed = True

            old = html.unescape(alias["raw"][1:-1])
            original = html.unescape(target["raw"][1:-1])
            name = migration.target_name(target["raw"])
            updated_target = original

            if relative in ["scope_test.zig", "position_test.zig"] and original == "number":
                updated_target = number_targets.get(old, "number")

                if relative == "position_test.zig" and "may share a result name" in block and old == "value":
                    updated_target = "value"

                name = updated_target

            if relative == "owned_input/root.zig":
                if original == "consume" and old == "last":
                    updated_target = "consume_next"
                elif original == "consume" and old == "right":
                    updated_target = "consume_right"
                elif original == "list" and old == "other":
                    updated_target = "list_other"
                elif original == "list" and old in ["left", "right"]:
                    updated_target = "list_read"

                name = updated_target

            if relative == "task_test.zig" and original == "number" and old == "other":
                updated_target = "number_other"
                name = updated_target

            if relative == "owned_input/compiled.zig" and old in ["left", "right"]:
                updated_target = "owned/consume_" + old
                name = "consume_" + old

            if updated_target != original:
                replacements.append((target["value_start"], target["value_end"], "'" + updated_target + "'"))

            for prefix in ["ctx.", "$ctx."]:
                bindings[prefix + old] = "$ctx." + name

        for start, end, text in sorted(replacements, reverse=True):
            value = value[:start] + text + value[end:]

        updated = migration.convert_xml(value)
        updates.append((match.start(), match.end(), scanner.quoted(updated, True)))

    if not renamed:
        return block

    for start, end, text in reversed(updates):
        block = block[:start] + text + block[end:]

    def marker(match):
        value = ast.literal_eval(match.group(2))
        updated = scanner.expression(value, bindings)

        if relative in ["scope_test.zig", "position_test.zig"]:
            updated = {"value'": "number'", "value.child": "number.child", "task'": "task'"}.get(updated, updated)

        return match.group(1) + scanner.quoted(updated, True)

    return re.sub(r'(\.marker\s*=\s*)("(?:\\.|[^"\\])*")', marker, block)


base = root / "packages/test/tests/rx/inference/parallel"

for relative in [
    "scope_test.zig", "position_test.zig", "task_test.zig",
    "capability_test.zig", "capture_ownership_test.zig",
    "owned_input/root.zig", "owned_input/compiled.zig",
]:
    path = base / relative
    source = path.read_text()

    if relative == "position_test.zig":
        source = source.replace("fn='number' in={2} name='&#118;alue'", "fn='&#110;umber' in={2} name='value'")
        source = source.replace('"&#118;alue"', '"&#110;umber"')

    sections = re.split(r'(?=^test |^const \w+ = h\.Case)', source, flags=re.MULTILINE)
    path.write_text("".join(convert_block(section, relative) for section in sections))
