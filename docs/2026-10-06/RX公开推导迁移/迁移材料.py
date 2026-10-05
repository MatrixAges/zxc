import argparse
import ast
import html
import json
import re
import sys
from pathlib import Path

sys.dont_write_bytecode = True
import 标签材料 as scanner


def target_name(raw):
    target = html.unescape(raw[1:-1])
    name = re.split(r"[/\\]", target)[-1]

    for suffix in [".zx", ".rx", ".zig"]:
        if name.endswith(suffix):
            return name[:-len(suffix)]

    return name


def convert_xml(source):
    nodes = list(scanner.tags(source))
    bindings = {"ctx": "$ctx"}
    replacements = []

    for node in nodes:
        if node["name"] != "Call":
            continue

        attrs = {attr["key"]: attr for attr in node["attrs"]}

        if "service" in attrs:
            attr = attrs["service"]
            replacements.append((attr["key_start"], attr["key_end"], "module"))

        if "name" not in attrs:
            continue

        target = attrs.get("fn") or attrs.get("service") or attrs.get("module")

        if target is None or not target["raw"].startswith(("'", '"')):
            raise ValueError("Call.name has no static target")

        attr = attrs["name"]
        old_name = html.unescape(attr["raw"][1:-1])
        replacement = "$ctx." + target_name(target["raw"])

        for prefix in ["ctx.", "$ctx."]:
            key = prefix + old_name

            if key in bindings and bindings[key] != replacement:
                raise ValueError("Different targets share result alias " + key)

            bindings[key] = replacement

        replacements.append((attr["start"], attr["value_end"], ""))

    for node in nodes:
        for attr in node["attrs"]:
            if not attr["raw"].startswith("{"):
                continue

            updated = scanner.expression(attr["raw"], bindings)

            if updated != attr["raw"]:
                replacements.append((attr["value_start"], attr["value_end"], updated))

    for start, end, value in sorted(replacements, reverse=True):
        source = source[:start] + value + source[end:]

    return source


def convert_zig(source):
    pattern = re.compile(r'"(?:\\.|[^"\\])*"', re.DOTALL)
    replacements = []

    for match in pattern.finditer(source):
        raw = match.group()

        if "<Module" not in raw:
            continue

        if re.match(r'\s*,\s*\.unknown_attribute\s*,\s*"(?:name|service|out|args)"', source[match.end():]):
            continue

        try:
            value = ast.literal_eval(raw)
        except (SyntaxError, ValueError):
            continue

        updated = convert_xml(value)

        if updated != value:
            replacements.append((match.start(), match.end(), scanner.quoted(updated, True)))

    for start, end, value in reversed(replacements):
        source = source[:start] + value + source[end:]

    return source


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--apply", action="store_true")
    parser.add_argument("--root", type=Path, default=Path.cwd())
    args = parser.parse_args()
    changed = []
    skipped = []
    roots = [args.root / "packages/test/tests/rx/inference", args.root / "packages/test/tests/rx/text"]

    for root in roots:
        for path in sorted(root.rglob("*")):
            if not path.is_file() or path.suffix not in [".rx", ".zig"]:
                continue

            if "parallel" in path.relative_to(root).parts:
                continue

            original = path.read_text()

            try:
                updated = convert_xml(original) if path.suffix == ".rx" else convert_zig(original)
            except ValueError as error:
                skipped.append({"path": str(path.relative_to(args.root)), "reason": str(error)})
                continue

            if updated == original:
                continue

            changed.append(str(path.relative_to(args.root)))

            if args.apply:
                path.write_text(updated)

    print(json.dumps({"applied": args.apply, "files": changed, "skipped": skipped}, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
