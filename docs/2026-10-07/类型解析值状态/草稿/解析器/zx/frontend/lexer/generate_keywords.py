import json
from pathlib import Path

root = Path(__file__).parent
keywords = json.loads((root / "keywords.json").read_text())
words = keywords + json.loads((root / "contextual_words.json").read_text())
prefixes = sorted({word[:length] for word in words for length in range(1, len(word) + 1)})
states = {prefix: index + 2 for index, prefix in enumerate(prefixes)}
states[""] = 0


def symbol(word):
    if word == "_":
        return "Underscore"

    if word[0].isupper():
        return "Upper" + word

    return word[0].upper() + word[1:]


def writeSource(path, lines):
    source = "\n".join(lines)

    if len(source.splitlines()) > 120:
        raise ValueError(f"ZX source exceeds 120 lines: {path}")

    path.write_text(source)


def children(prefix):
    return sorted({word[len(prefix)] for word in words if word.startswith(prefix) and len(word) > len(prefix)})


def groupName(letter):
    return "upper_" + letter.lower() if letter.isupper() else letter


def transition(prefix):
    lines = [f"        case {states[prefix]}: return match {{"]

    for byte in children(prefix):
        lines.append(f"            in.byte == {ord(byte)} => {states[prefix + byte]},")

    return lines + ["            _ => 1", "        }"]


members = ["Root", "Dead"] + [symbol(word) for word in sorted(set(words))]
writeSource(root / "keyword_model.zx", ["export enum Keyword {", "    " + ",\n    ".join(members), "}", ""])

groups = {}

for prefix in prefixes:
    groups.setdefault(prefix[0], []).append(prefix)

header = [
    "export type Input = { state: u64, byte: u8 }",
    "",
    "export type Output = u64",
    "",
    "export default function (in: Input): Output {",
    "    switch (in.state) {",
]
footer = ["        default: return 1", "    }", "}", ""]
directory = root / "keyword_transition"
directory.mkdir(exist_ok=True)
outputs = {"root.zx"}
writeSource(directory / "root.zx", header + transition("") + footer)

for letter, values in groups.items():
    if not any(children(prefix) for prefix in values):
        continue

    path = directory / (groupName(letter) + ".zx")
    lines = list(header)

    for prefix in values:
        if children(prefix):
            lines.extend(transition(prefix))

    writeSource(path, lines + footer)
    outputs.add(path.name)

for path in directory.glob("*.zx"):
    if path.name not in outputs:
        path.unlink()

selected = [(letter, values) for letter, values in groups.items() if groupName(letter) + ".zx" in outputs]
partitions = {"a_m": [(letter, values) for letter, values in selected if letter <= "m"], "n_w": [(letter, values) for letter, values in selected if letter > "m"]}

for partition, entries in partitions.items():
    source = []

    for letter, _ in entries:
        name = "upper" + letter if letter.isupper() else letter
        source.append(f'import {name} from "./{groupName(letter)}"')

    source.extend(["", *header[:-1]])

    for letter, values in entries:
        name = "upper" + letter if letter.isupper() else letter
        source.extend([
            f"    if (in.state >= {states[values[0]]} && in.state <= {states[values[-1]]}) {{",
            f"        return {name}(in)",
            "    }",
            "",
        ])

    writeSource(directory / (partition + ".zx"), source + ["    return 1", "}", ""])

boundary = max(states[prefix] for _, values in partitions["a_m"] for prefix in values)
source = [
    'import root from "./keyword_transition/root"',
    'import aM from "./keyword_transition/a_m"',
    'import nW from "./keyword_transition/n_w"',
    "", *header[:-1],
    "    if (in.state == 0) {", "        return root(in)", "    }", "",
    f"    return in.state <= {boundary} ? aM(in) : nW(in)", "}", "",
]
writeSource(root / "keyword_transition.zx", source)

source = [
    'import { Keyword } from "./keyword_model"', "",
    "export type Input = u64", "", "export type Output = Keyword", "",
    "export default function (in: Input): Output {", "    switch (in) {",
    "        case 0: return Keyword.Root",
]

for word in sorted(set(words)):
    source.append(f"        case {states[word]}: return Keyword.{symbol(word)}")

writeSource(root / "keyword_value.zx", source + ["        default: return Keyword.Dead", "    }", "}", ""])

predicate = " ||\n    ".join(f"in == Keyword.{symbol(word)}" for word in keywords)
header = '''import { Keyword } from "./keyword_model"

export type Input = Keyword

export type Output = bool

export default function (in: Input): Output {
  return '''

writeSource(root / "is_keyword.zx", [header + predicate, "}", ""])
