import json
import re
import subprocess
from pathlib import Path
from xml.parsers import expat

from 迁移属性 import migrate


def fragment(text, formatted):
    prefix = b"<Migration>"
    encoded = prefix + text.encode() + b"</Migration>"
    output, count = migrate(encoded, formatted)
    return output[len(prefix):-len(b"</Migration>")].decode(), count


def rewrite(source):
    index = 0
    stack = []
    edits = []
    skipped = []
    count = 0

    while index < len(source):
        if source.startswith("//", index):
            end = source.find("\n", index)
            index = len(source) if end < 0 else end + 1
            continue
        if source.startswith("/*", index):
            end = source.find("*/", index + 2)
            index = len(source) if end < 0 else end + 2
            continue

        if source.startswith("\\\\", index):
            start = index
            lines = []
            indents = []
            while True:
                end = source.find("\n", index)
                if end < 0:
                    end = len(source)
                lines.append(source[index + 2:end])
                following = re.match(r"([ \t]*)\\\\", source[end + 1:])
                if following is None:
                    break
                indents.append(following[1])
                index = end + 1 + len(following[1])
            value = "\n".join(lines)
            if "<" in value:
                try:
                    output, changed = fragment(value, any(item.endswith(("allocPrint", ".print")) for item in stack))
                    if changed:
                        new_lines = output.split("\n")
                        if len(new_lines) != len(lines):
                            skipped.append({"offset": start, "reason": "multiline count changed"})
                        else:
                            replacement = "\\\\" + new_lines[0]
                            for indent, line in zip(indents, new_lines[1:]):
                                replacement += "\n" + indent + "\\\\" + line
                            edits.append((start, end, replacement))
                            count += changed
                except expat.ExpatError:
                    skipped.append({"offset": start, "reason": "non-XML or partial multiline text"})
            index = end
            continue

        if source[index] == '"':
            start = index
            index += 1
            while index < len(source) and source[index] != '"':
                index += 2 if source[index] == "\\" else 1
            index += 1
            literal = source[start:index]
            if "<" not in literal:
                continue
            try:
                value = json.loads(literal)
                output, changed = fragment(value, any(item.endswith(("allocPrint", ".print")) for item in stack))
                if changed:
                    edits.append((start, index, json.dumps(output, ensure_ascii=False)))
                    count += changed
            except (json.JSONDecodeError, expat.ExpatError):
                skipped.append({"offset": start, "reason": "non-JSON Zig literal or partial XML"})
            continue

        if source[index] == "(":
            name = re.search(r"([\w.]+)\s*$", source[:index])
            stack.append(name[1] if name else "")
        elif source[index] == ")" and stack:
            stack.pop()
        index += 1

    for start, end, replacement in reversed(edits):
        source = source[:start] + replacement + source[end:]
    return source, count, skipped


def main():
    paths = subprocess.check_output(["git", "ls-files", "-z"]).split(b"\0")
    changes = []
    skipped = []
    for raw in paths:
        name = raw.decode()
        if not name.endswith(".zig") or not any(name.startswith(prefix) for prefix in ("packages/compiler/tests/", "packages/test/tests/", "packages/cli/tests/")):
            continue
        path = Path(name)
        source = path.read_text()
        if "<" not in source:
            continue
        output, count, misses = rewrite(source)
        if count:
            path.write_text(output)
            changes.append({"path": name, "attributes": count})
        if misses:
            skipped.append({"path": name, "items": misses})
    report = {"changes": changes, "skipped": skipped}
    Path(__file__).with_name("内嵌迁移记录.json").write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n")
    print("files:", len(changes), "attributes:", sum(item["attributes"] for item in changes), "review:", len(skipped))


if __name__ == "__main__":
    main()
