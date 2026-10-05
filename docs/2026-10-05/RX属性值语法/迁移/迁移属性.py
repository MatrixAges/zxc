import argparse
import json
import re
import subprocess
from pathlib import Path
from xml.parsers import expat


VALUE_ATTRIBUTES = {
    "Call": {"in", "setter"},
    "Return": {"value"},
    "Switch": {"on"},
    "Case": {"value"},
    "Emit": {"value"},
    "Field": {"value"},
    "Store": {"version"},
    "Gateway": {"max_header_bytes", "max_body_bytes"},
}

ATTRIBUTE = re.compile(rb"([A-Za-z_][\w:.-]*)\s*=\s*([\"'])(.*?)\2", re.S)


def migrate(source, formatted=False):
    parser = expat.ParserCreate()
    edits = []

    def element(tag, attributes):
        names = VALUE_ATTRIBUTES.get(tag, set())
        if not names:
            return

        start = parser.CurrentByteIndex
        end = start
        quote = None

        while end < len(source):
            byte = source[end]
            if quote is not None:
                if byte == quote:
                    quote = None
            elif byte in (34, 39):
                quote = byte
            elif byte == 62:
                break
            end += 1

        for match in ATTRIBUTE.finditer(source, start, end):
            name = match[1].decode("ascii")
            if name not in names:
                continue

            value = attributes[name].encode("utf-8")
            left, right = (b"{{", b"}}") if formatted else (b"{", b"}")
            edits.append((match.start(2), match.end(), left + value + right))

    parser.StartElementHandler = element
    parser.Parse(source, True)

    for start, end, replacement in reversed(edits):
        source = source[:start] + replacement + source[end:]

    return source, len(edits)


def main():
    arguments = argparse.ArgumentParser()
    arguments.add_argument("--apply", action="store_true")
    arguments.add_argument("--prefix", default="")
    args = arguments.parse_args()

    paths = subprocess.check_output(["git", "ls-files", "-z"]).split(b"\0")
    dirty = set(subprocess.check_output(["git", "diff", "--name-only", "-z"]).split(b"\0"))
    dirty.update(subprocess.check_output(["git", "diff", "--cached", "--name-only", "-z"]).split(b"\0"))
    changed = []
    skipped = []

    for raw_path in paths:
        if not raw_path.endswith(b".rx"):
            continue

        path = Path(raw_path.decode())
        if not str(path).startswith(args.prefix):
            continue
        if raw_path in dirty:
            skipped.append({"path": str(path), "reason": "existing change"})
            continue

        try:
            output, count = migrate(path.read_bytes())
        except expat.ExpatError as error:
            skipped.append({"path": str(path), "reason": str(error)})
            continue

        if count:
            changed.append({"path": str(path), "attributes": count})
            if args.apply:
                path.write_bytes(output)

    report = {"applied": args.apply, "files": len(changed), "attributes": sum(item["attributes"] for item in changed), "changed": changed, "skipped": skipped}
    target = Path(__file__).with_name("迁移记录.json" if args.apply else "迁移预览.json")
    target.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n")
    print(json.dumps({key: value for key, value in report.items() if key not in {"changed", "skipped"}}, ensure_ascii=False))
    print("skipped:", len(skipped))


if __name__ == "__main__":
    main()
