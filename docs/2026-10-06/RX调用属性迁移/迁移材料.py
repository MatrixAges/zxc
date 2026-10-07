import argparse
import ast
import html
import json
import re
from pathlib import Path


def value_end(text, start):
    quote = text[start]

    if quote in "\"'`":
        index = start + 1

        while index < len(text):
            if text[index] == "\\":
                index += 2
            elif text[index] == quote:
                return index + 1
            else:
                index += 1

        return len(text)

    if quote == "{":
        depth = 1
        index = start + 1

        while index < len(text) and depth:
            if text.startswith("/*", index):
                end = text.find("*/", index + 2)
                index = len(text) if end < 0 else end + 2
            elif text.startswith("//", index):
                end = text.find("\n", index + 2)
                index = len(text) if end < 0 else end
            elif text[index] in "\"'`":
                index = value_end(text, index)
            else:
                depth += (text[index] == "{") - (text[index] == "}")
                index += 1

        return index

    match = re.match(r"[^\s>]+", text[start:])

    return start + len(match.group()) if match else start


def tags(text):
    index = 0

    while index < len(text):
        start = text.find("<", index)

        if start < 0:
            return

        if text.startswith("<!--", start):
            end = text.find("-->", start + 4)
            index = len(text) if end < 0 else end + 3
            continue

        match = re.match(r"</?([A-Za-z][\w.-]*)\b", text[start:])

        if not match:
            index = start + 1
            continue

        cursor = start + match.end()
        attributes = []

        while cursor < len(text) and text[cursor] != ">":
            attr = re.match(r"\s+([A-Za-z_$][\w.$:-]*)\s*=\s*", text[cursor:])

            if not attr:
                cursor += 1
                continue

            attr_start = cursor
            key_start = cursor + attr.start(1)
            key_end = cursor + attr.end(1)
            val_start = cursor + attr.end()
            val_end = value_end(text, val_start)
            attributes.append({
                "key": attr.group(1), "start": attr_start,
                "key_start": key_start, "key_end": key_end,
                "value_start": val_start, "value_end": val_end,
                "raw": text[val_start:val_end],
            })
            cursor = val_end

        index = min(cursor + 1, len(text))
        yield {"name": match.group(1), "start": start, "end": index, "attrs": attributes}


def result_name(raw):
    encoded = raw[1:-1]
    decoded = html.unescape(encoded)
    path = decoded[4:] if decoded.startswith("ctx.") else decoded
    valid = re.fullmatch(r"[A-Za-z_$][A-Za-z0-9_]*(?:\.[A-Za-z_$][A-Za-z0-9_]*)*", path)

    if valid:
        name = path.replace(".", "_")
        encoded_name = encoded[4:] if encoded.startswith("ctx.") else encoded
        encoded_name = encoded_name.replace(".", "_")
    else:
        name = path
        encoded_name = encoded[4:] if encoded.startswith("ctx.") else encoded

    return decoded, name, raw[0] + encoded_name + raw[-1]


def expression(text, bindings):
    keys = [key for key, value in bindings.items() if key != value]

    if not keys:
        return text

    pattern = re.compile(r"(?<![A-Za-z0-9_$.])(" + "|".join(re.escape(key) for key in sorted(keys, key=len, reverse=True)) + r")(?![A-Za-z0-9_$])")
    output = []
    index = 0

    while index < len(text):
        if text[index] in "\"'":
            end = value_end(text, index)
            output.append(text[index:end])
            index = end
        elif text[index] == "`":
            output.append("`")
            index += 1

            while index < len(text):
                if text[index] == "\\":
                    output.append(text[index:index + 2])
                    index += 2
                elif text.startswith("${", index):
                    end = value_end(text, index + 1)
                    output.append("${" + expression(text[index + 2:end - 1], bindings) + "}")
                    index = end
                elif text[index] == "`":
                    output.append("`")
                    index += 1
                    break
                else:
                    output.append(text[index])
                    index += 1
        else:
            end = index

            while end < len(text) and text[end] not in "\"'`":
                end += 1

            def reference(match):
                before = text[:index + match.start()].rstrip()
                after = text[index + match.end():].lstrip()

                if after.startswith(":") and before.endswith(("{", ",")):
                    return match.group(1)

                if after.startswith("=>"):
                    return match.group(1)

                return bindings[match.group(1)]

            output.append(pattern.sub(reference, text[index:end]))
            index = end

    return "".join(output)


def migrate_xml(text, preserve_out=False):
    nodes = list(tags(text))
    replacements = []
    bindings = {}

    for node in nodes:
        if node["name"] not in {"Call", "Task"}:
            continue

        attrs = {attr["key"]: attr for attr in node["attrs"]}

        if node["name"] == "Call" and "args" in attrs:
            attr = attrs["args"]
            replacements.append((attr["key_start"], attr["key_end"], "in"))

        if "out" not in attrs or preserve_out:
            continue

        out = attrs["out"]

        if not out["raw"].startswith(("'", '"')):
            continue

        old, name, raw = result_name(out["raw"])
        bindings[old] = "ctx." + name

        if node["name"] == "Task":
            if "name" not in attrs:
                continue

            attr = attrs["name"]
            replacements.append((attr["value_start"], attr["value_end"], raw))
            replacements.append((out["start"], out["value_end"], ""))
        else:
            replacements.append((out["key_start"], out["key_end"], "name"))
            replacements.append((out["value_start"], out["value_end"], raw))

    for node in nodes:
        for attr in node["attrs"]:
            if attr["raw"].startswith("{"):
                updated = expression(attr["raw"], bindings)

                if updated != attr["raw"]:
                    replacements.append((attr["value_start"], attr["value_end"], updated))

    for start, end, value in sorted(replacements, reverse=True):
        text = text[:start] + value + text[end:]

    return text, bindings


def quoted(text, zig=False):
    output = ['"']

    for char in text:
        if char == '"':
            output.append('\\"')
        elif char == "\\":
            output.append("\\\\")
        elif char == "\n":
            output.append("\\n")
        elif char == "\r":
            output.append("\\r")
        elif char == "\t":
            output.append("\\t")
        elif ord(char) < 32:
            output.append(f"\\x{ord(char):02x}" if zig else f"\\u{ord(char):04x}")
        else:
            output.append(char)

    output.append('"')

    return "".join(output)


def migrate_strings(text, zig, preserve_out):
    pattern = re.compile(r'"(?:\\.|[^"\\])*"' if zig else r'"(?:\\.|[^"\\])*"|\'(?:\\.|[^\'\\])*\'|`(?:\\.|[^`\\])*`', re.DOTALL)
    replacements = []

    for match in pattern.finditer(text):
        raw = match.group()

        if "<Call" not in raw and "<Task" not in raw:
            continue

        try:
            value = raw[1:-1] if raw.startswith("`") else ast.literal_eval(raw)
        except (SyntaxError, ValueError):
            continue

        updated, _ = migrate_xml(value, preserve_out)

        if updated == value:
            continue

        serialized = "`" + updated + "`" if raw.startswith("`") else quoted(updated, zig)
        replacements.append((match.start(), match.end(), serialized))

    for start, end, value in reversed(replacements):
        text = text[:start] + value + text[end:]

    return text


def migrate_json(value):
    if isinstance(value, str) and ("<Call" in value or "<Task" in value):
        return migrate_xml(value)[0]

    if isinstance(value, list):
        return [migrate_json(item) for item in value]

    if isinstance(value, dict):
        return {key: migrate_json(item) for key, item in value.items()}

    return value


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", type=Path, default=Path.cwd())
    parser.add_argument("--apply", action="store_true")
    args = parser.parse_args()
    report = []

    for path in sorted((args.root / "packages/test/tests").rglob("*")):
        if not path.is_file() or path.suffix not in {".rx", ".zig", ".ts", ".json"}:
            continue

        relative = path.relative_to(args.root).as_posix()

        if relative.startswith(("packages/test/tests/formatting/rx/", "packages/test/tests/expressions/xml/")):
            continue

        original = path.read_text()

        if "<Call" not in original and "<Task" not in original:
            continue

        preserve_out = relative.endswith(("rx/inference/parallel/schema_test.zig", "rx/attributes/schema_test.zig"))

        if path.suffix == ".rx":
            updated, _ = migrate_xml(original, preserve_out)
        elif path.suffix == ".json":
            updated = json.dumps(migrate_json(json.loads(original)), ensure_ascii=False, indent=2) + "\n"
        else:
            updated = migrate_strings(original, path.suffix == ".zig", preserve_out)

        if updated == original:
            continue

        report.append(relative)

        if args.apply:
            path.write_text(updated)

    print(json.dumps({"apply": args.apply, "files": report}, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
