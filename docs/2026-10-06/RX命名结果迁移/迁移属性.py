import re
import sys
from pathlib import Path


def value_end(source, start):
    quote = None
    depth = 0
    index = start

    while index < len(source):
        char = source[index]

        if quote:
            if char == "\\":
                index += 2
                continue
            if char == quote:
                quote = None
                if depth == 0:
                    return index + 1
        elif char in "\"'`":
            quote = char
        elif char == "{":
            depth += 1
        elif char == "}":
            depth -= 1
            if depth == 0:
                return index + 1

        index += 1

    raise ValueError("unterminated attribute")


def migrate(source):
    edits = []

    for tag in re.finditer(r"<(Call|Task)\b", source):
        index = tag.end()
        attributes = {}

        while True:
            attribute = re.match(r"\s+([A-Za-z_][\w-]*)\s*=\s*", source[index:])
            if not attribute:
                break

            start = index + attribute.end()
            if start >= len(source) or source[start] not in "\"'{":
                break

            end = value_end(source, start)
            attributes[attribute[1]] = (index, index + attribute.start(1), start, end)
            index = end

        if tag[1] == "Call" and "in" in attributes:
            _, name_start, _, _ = attributes["in"]
            edits.append((name_start, name_start + 2, "args"))

        if "out" not in attributes:
            continue

        whitespace, name_start, start, end = attributes["out"]
        old = source[start + 1:end - 1]
        if not old.startswith("ctx.") or not re.fullmatch(r"[A-Za-z_][A-Za-z_0-9]*", old[4:]):
            raise ValueError(f"binding requires scope migration: {old}")

        name = old[4:]
        if "name" in attributes:
            _, _, name_value, name_end = attributes["name"]
            edits.append((name_value, name_end, f'"{name}"'))
            edits.append((whitespace, end, ""))
        else:
            edits.append((name_start, end, f'name="{name}"'))

    for start, end, replacement in sorted(edits, reverse=True):
        source = source[:start] + replacement + source[end:]

    return source


if __name__ == "__main__":
    for argument in sys.argv[1:]:
        path = Path(argument)
        original = path.read_text()
        updated = migrate(original)

        if original != updated:
            path.write_text(updated)
            print(path)
