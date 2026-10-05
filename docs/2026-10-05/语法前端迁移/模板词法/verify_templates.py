import hashlib
import json
from pathlib import Path
import subprocess
import sys
import tempfile


sources = {str(path): path.read_bytes() for path in sorted(Path("packages").rglob("*.zx")) if "node_modules" not in path.parts}

for path in sorted(Path("packages/test/tests/language").rglob("*.jsonl")):
    if "template" not in str(path) and "lexical" not in str(path):
        continue

    for line in path.read_text().splitlines():
        case = json.loads(line)

        if "source_hex" in case:
            sources[str(path) + ":" + case["id"]] = bytes.fromhex(case["source_hex"])
        elif "source" in case:
            sources[str(path) + ":" + case["id"]] = case["source"].encode()


def project(lexed):
    return {**lexed, "tokens": [{"kind": token["kind"].lower(), "span": token["span"]} for token in lexed["tokens"]]}


def check_ids(lexed, ids, templates):
    assert len(ids) == len(lexed["tokens"]), "token template length"

    for token, index in zip(lexed["tokens"], ids):
        if token["kind"] == "Template":
            assert index > 0 and templates[index - 1]["span"] == token["span"], "token template reference"
        else:
            assert index == 0, "non-template reference"


records = []

with tempfile.TemporaryDirectory(prefix="zxc-template-existing-") as directory:
    source_path = Path(directory) / "source.zx"

    for name, source in sources.items():
        source_path.write_bytes(source)
        result = json.loads(subprocess.check_output([sys.argv[1], str(source_path)]))
        expected, actual = result["expected"], result["actual"]
        failure = ""

        try:
            assert project(actual["lexed"]) == expected["lexed"], "root lexical result"
            check_ids(actual["lexed"], actual["token_templates"], actual["templates"])
            assert len(actual["templates"]) == len(expected["templates"]), "template count"
            assert len(actual["interpolations"]) == len(expected["interpolations"]), "interpolation count"
            seen = set()

            for want, got in zip(expected["templates"], actual["templates"]):
                assert want["span"] == got["span"], "template span"
                parts = []
                head = got["head"]

                while head:
                    assert head not in seen, "part ownership/cycle"
                    seen.add(head)
                    part = actual["parts"][head - 1]
                    parts.append({"kind": part["kind"], "span": part["span"]})

                    if part["kind"] == "Expression":
                        assert part["interpolation"] > 0, "expression reference"
                        assert actual["interpolations"][part["interpolation"] - 1]["span"] == part["span"], "expression span reference"
                    else:
                        assert part["interpolation"] == 0, "text reference"

                    head = part["previous"]

                assert len(parts) == got["count"], "part count"
                assert list(reversed(parts)) == want["parts"], "template parts"

            assert len(seen) == len(actual["parts"]), "unreachable parts"

            for want, got in zip(expected["interpolations"], actual["interpolations"]):
                assert want["span"] == got["span"], "interpolation span"
                assert project(got["lexed"]) == want["lexed"], "interpolation lexical result"
                check_ids(got["lexed"], got["token_templates"], actual["templates"])
                start, end = got["span"]["start"], got["span"]["end"]
                metadata = json.loads(subprocess.check_output([sys.argv[3], json.dumps(list(source[start:end]))]))

                for token in metadata["tokens"]:
                    token["span"]["start"] += start
                    token["span"]["end"] += start

                for comment in metadata["comments"]:
                    comment["start"] += start
                    comment["end"] += start

                if metadata["diagnostic"]["message"]:
                    metadata["diagnostic"]["start"] += start
                    metadata["diagnostic"]["end"] += start

                assert metadata == got["lexed"], "interpolation metadata"

        except (AssertionError, IndexError) as error:
            failure = str(error)
            Path(sys.argv[2]).with_suffix(".failure.json").write_text(json.dumps({"source": name, **result}, ensure_ascii=False, indent=2) + "\n")

        records.append({"source": name, "sha256": hashlib.sha256(source).hexdigest(), "templates": len(actual["templates"]), "interpolations": len(actual["interpolations"]), "failure": failure})

result = {"sources": len(records), "templates": sum(item["templates"] for item in records), "interpolations": sum(item["interpolations"] for item in records), "failures": sum(bool(item["failure"]) for item in records), "records": records}
Path(sys.argv[2]).write_text(json.dumps(result, ensure_ascii=False, indent=2) + "\n")
print(json.dumps({key: value for key, value in result.items() if key != "records"}))

if result["failures"]:
    raise SystemExit(1)
