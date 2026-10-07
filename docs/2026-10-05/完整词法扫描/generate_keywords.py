import json
from pathlib import Path

root = Path(__file__).parent
words = json.loads((root / "keywords.json").read_text())
prefixes = sorted({word[:length] for word in words for length in range(1, len(word) + 1)})


def symbol(prefix):
    return prefix[0].upper() + prefix[1:] if prefix else "Root"


members = ["Root", "Dead"] + [symbol(prefix) for prefix in prefixes]
(root / "keyword_model.zx").write_text("export enum Keyword {\n  " + ",\n  ".join(members) + "\n}\n")

def writeSource(path, lines):
    source = "\n".join(lines)

    if len(source.splitlines()) > 120:
        raise ValueError(f"ZX source exceeds 120 lines: {path}")

    path.write_text(source)


groups = {}

for prefix in [""] + prefixes:
    children = sorted({word[len(prefix)] for word in words if word.startswith(prefix) and len(word) > len(prefix)})

    if children:
        groups.setdefault(prefix[0] if prefix else "root", []).append((prefix, children))

header = [
    "", "export type Input = { keyword: Keyword, byte: u8 }", "",
    "export type Output = Keyword", "",
    "export default function (in: Input): Output {", "  switch (in.keyword) {",
]
footer = ["    default: return Keyword.Dead", "  }", "}", ""]
directory = root / "keyword_transition"
directory.mkdir(exist_ok=True)
source = ['import { Keyword } from "./keyword_model.zx"']

for name, entries in groups.items():
    source.append(f'import {name} from "./keyword_transition/{name}.zx"')
    fragment = ['import { Keyword } from "../keyword_model.zx"'] + header

    for prefix, children in entries:
        fragment.append(f"    case Keyword.{symbol(prefix)}: return match {{")

        for byte in children:
            fragment.append(f"      in.byte == {ord(byte)} => Keyword.{symbol(prefix + byte)},")

        fragment.extend(["      _ => Keyword.Dead", "    }"])

    writeSource(directory / (name + ".zx"), fragment + footer)

source.extend(header)

for name, entries in groups.items():
    for prefix, _ in entries:
        source.append(f"    case Keyword.{symbol(prefix)}: return {name}(in)")

writeSource(root / "keyword_transition.zx", source + footer)

predicate = " ||\n    ".join(f"in == Keyword.{symbol(word)}" for word in words)
header = '''import { Keyword } from "./keyword_model.zx"

export type Input = Keyword

export type Output = bool

export default function (in: Input): Output {
  return '''

(root / "is_keyword.zx").write_text(header + predicate + "\n}\n")
