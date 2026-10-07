import json
from pathlib import Path

root = Path(__file__).parent
keywords = json.loads((root / "keywords.json").read_text())
words = keywords + json.loads((root / "contextual_words.json").read_text())
prefixes = sorted({word[:length] for word in words for length in range(1, len(word) + 1)})


def symbol(prefix):
    if prefix == "_":
        return "Underscore"

    if prefix and prefix[0].isupper():
        return "Upper" + prefix

    return prefix[0].upper() + prefix[1:] if prefix else "Root"


def writeSource(path, lines):
    source = "\n".join(lines)

    if len(source.splitlines()) > 240:
        raise ValueError(f"ZX source exceeds 240 lines: {path}")

    path.write_text(source)


members = ["Root", "Dead"] + [symbol(prefix) for prefix in prefixes]
writeSource(root / "keyword_model.zx", ["export enum Keyword {", "  " + ",\n  ".join(members), "}", ""])

def children(prefix):
    return sorted({word[len(prefix)] for word in words if word.startswith(prefix) and len(word) > len(prefix)})


def groupName(letter):
    return "upper_" + letter.lower() if letter.isupper() else letter


def transition(prefix):
    lines = [f"        case Keyword.{symbol(prefix)}: return match {{"]

    for byte in children(prefix):
        lines.append(f"            in.byte == {ord(byte)} => Keyword.{symbol(prefix + byte)},")

    return lines + ["            _ => Keyword.Dead", "        }"]


groups = {}

for prefix in prefixes:
    if children(prefix):
        groups.setdefault(prefix[0], []).append(prefix)

header = [
    "",
    "export type Input = { keyword: Keyword, byte: u8 }",
    "",
    "export type Output = Keyword",
    "",
    "export default function (in: Input): Output {",
    "    switch (in.keyword) {",
]
footer = ["        default: return Keyword.Dead", "    }", "}", ""]
directory = root / "keyword_transition"
directory.mkdir(exist_ok=True)
outputs = set()

for letter, members in groups.items():
    path = directory / (groupName(letter) + ".zx")
    lines = ['import { Keyword } from "../keyword_model"'] + header

    for prefix in members:
        lines.extend(transition(prefix))

    writeSource(path, lines + footer)
    outputs.add(path.name)

for path in directory.glob("*.zx"):
    if path.name not in outputs:
        path.unlink()

source = ['import { Keyword } from "./keyword_model"']

for letter in sorted(groups, key=groupName):
    name = "upper" + letter if letter.isupper() else letter
    source.append(f'import {name} from "./keyword_transition/{groupName(letter)}"')

source.extend(header)
source.extend(transition(""))

for letter, members in groups.items():
    name = "upper" + letter if letter.isupper() else letter

    for prefix in members:
        source.append(f"        case Keyword.{symbol(prefix)}: return {name}(in)")

writeSource(root / "keyword_transition.zx", source + footer)

predicate = " ||\n    ".join(f"in == Keyword.{symbol(word)}" for word in keywords)
header = '''import { Keyword } from "./keyword_model"

export type Input = Keyword

export type Output = bool

export default function (in: Input): Output {
  return '''

writeSource(root / "is_keyword.zx", [header + predicate, "}", ""])
