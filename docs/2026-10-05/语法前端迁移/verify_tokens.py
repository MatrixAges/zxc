import hashlib
import json
from pathlib import Path
import subprocess
import sys
import tempfile


baseline = json.loads(Path(sys.argv[1]).read_text())
reference, scan, legacy = sys.argv[2:5]
root = Path("packages/compiler/src/zx/frontend/lexer")
words = json.loads((root / "keywords.json").read_text()) + json.loads((root / "contextual_words.json").read_text())
prefixes = {word[:length] for word in words for length in range(1, len(word) + 1)}
punctuation = dict(zip(
    ["{", "}", "(", ")", "[", "]", ":", ";", ",", ".", "?", "+", "-", "*", "/", "%", "<", ">", "=", "!", "&", "|", "=>", "==", "!=", "<=", ">=", "??", "&&", "||", "..."],
    ["OpenBrace", "CloseBrace", "OpenParen", "CloseParen", "OpenBracket", "CloseBracket", "Colon", "Semicolon", "Comma", "Dot", "Question", "Plus", "Minus", "Star", "Slash", "Percent", "Less", "Greater", "Assign", "Not", "Ampersand", "Pipe", "Arrow", "Equal", "NotEqual", "LessEqual", "GreaterEqual", "Coalesce", "And", "Or", "Spread"]
))
catalog = {}

for path in Path("packages/test/tests/language/lexical").rglob("*.jsonl"):
    for line in path.read_text().splitlines():
        case = json.loads(line)

        if "source_hex" in case:
            catalog[case["id"]] = bytes.fromhex(case["source_hex"])
        elif "source" in case:
            catalog[case["id"]] = case["source"].encode()

sources = {}

for record in baseline["records"]:
    name = record["source"]
    source = Path(name).read_bytes() if Path(name).is_file() else catalog[name]

    if hashlib.sha256(source).hexdigest() != record["sha256"]:
        raise RuntimeError(f"Source changed: {name}")

    sources[name] = source

for path in sorted(root.rglob("*.zx")):
    sources[str(path)] = path.read_bytes()

records = []

with tempfile.TemporaryDirectory(prefix="zxc-parser-token-") as temporary:
    path = Path(temporary) / "source.zx"

    for name, source in sources.items():
        path.write_bytes(source)
        expected = json.loads(subprocess.check_output([reference, str(path)]))
        argument = json.dumps(list(source))
        actual = json.loads(subprocess.check_output([scan, argument]))
        compatible = json.loads(subprocess.check_output([legacy, argument]))
        projected = {**actual, "tokens": [{"kind": token["kind"].lower(), "span": token["span"]} for token in actual["tokens"]]}
        failures = []

        if projected != expected or compatible != expected:
            failures.append("legacy output differs")

        previous_end = 0

        for token_index, token in enumerate(actual["tokens"]):
            start, end = token["span"]["start"], token["span"]["end"]
            spelling = source[start:end].decode()
            gap = source[previous_end:start]
            word = "Root"

            if token["kind"] in ("Identifier", "Keyword"):
                word = "Dead"

                if spelling in prefixes:
                    word = "Underscore" if spelling == "_" else "Upper" + spelling if spelling[0].isupper() else spelling[0].upper() + spelling[1:]

            metadata = {
                "word": word,
                "symbol": punctuation[spelling] if token["kind"] == "Punctuation" else "None",
                "line_break": token_index != 0 and (b"\r" in gap or b"\n" in gap),
                "dollar": token["kind"] == "Identifier" and spelling.startswith("$")
            }

            if any(token[key] != value for key, value in metadata.items()):
                failures.append({"span": token["span"], "expected": metadata, "actual": token})

            previous_end = end

        records.append({"source": name, "sha256": hashlib.sha256(source).hexdigest(), "tokens": len(actual["tokens"]), "failures": failures})

result = {
    "count": len(records),
    "tokens": sum(record["tokens"] for record in records),
    "failure_count": sum(bool(record["failures"]) for record in records),
    "records": records
}
Path(sys.argv[5]).write_text(json.dumps(result, ensure_ascii=False, indent=2) + "\n")
print(json.dumps({key: value for key, value in result.items() if key != "records"}))

if result["failure_count"]:
    raise SystemExit(1)
