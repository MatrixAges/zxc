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


members = ["Root", "Dead"] + [symbol(prefix) for prefix in prefixes]
(root / "keyword_model.zx").write_text("export enum Keyword {\n  " + ",\n  ".join(members) + "\n}\n")

source = [
    'import { Keyword } from "./keyword_model.zx"',
    "",
    "export type Input = { keyword: Keyword, byte: u8 }",
    "",
    "export type Output = Keyword",
    "",
    "export default function (in: Input): Output {",
    "  switch (in.keyword) {",
]

for prefix in [""] + prefixes:
    children = sorted({word[len(prefix)] for word in words if word.startswith(prefix) and len(word) > len(prefix)})

    if not children:
        continue

    source.append(f"    case Keyword.{symbol(prefix)}: return match {{")

    for byte in children:
        source.append(f"      in.byte == {ord(byte)} => Keyword.{symbol(prefix + byte)},")

    source.extend(["      _ => Keyword.Dead", "    }"])

source.extend(["    default: return Keyword.Dead", "  }", "}", ""])
(root / "keyword_transition.zx").write_text("\n".join(source))

predicate = " ||\n    ".join(f"in == Keyword.{symbol(word)}" for word in keywords)
header = '''import { Keyword } from "./keyword_model.zx"

export type Input = Keyword

export type Output = bool

export default function (in: Input): Output {
  return '''

(root / "is_keyword.zx").write_text(header + predicate + "\n}\n")
