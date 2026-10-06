import json
from pathlib import Path

root = Path(__file__).resolve().parents[3]
doc = Path(__file__).resolve().parent
maximum = 2**64 - 1


def save(relative, text):
    target = root / relative
    target.parent.mkdir(parents=True, exist_ok=True)
    target.write_text(text)

    draft = doc / "草稿" / relative
    draft.parent.mkdir(parents=True, exist_ok=True)
    draft.write_text(text)


def rows_text(rows):
    return "".join(json.dumps(row, ensure_ascii=False, separators=(",", ":")) + "\n" for row in rows)


def source(element, composed=False, lazy=False):
    header = "export type Item = { tag: i64, payload: [bool, string], optional: i64?, children: i64[] }\n\n" if element == "Item" else ""
    fields = f"items: {element}[], start: u64, count: u64, other: {element}[]"
    if lazy:
        fields += ", extract: bool"
    result = f"remaining: {element}[], removed: {element}[], original: {element}[], remaining_length: u64, removed_length: u64"
    body = ""
    if lazy:
        body += "  if (!in.extract) {\n    return { remaining: in.items, removed: [], original: in.items, remaining_length: in.items.length, removed_length: 0 }\n  }\n\n"
    body += "  const owned = in.items.map(item => item)\n\n"
    if composed:
        body += "  const [next, deleted] = owned.splice(in.start, in.count, in.other)\n  const [remaining, _] = next.reverse()\n  const [removed, _] = deleted.reverse()\n\n"
    else:
        body += "  const [remaining, removed] = owned.splice(in.start, in.count, in.other)\n\n"
    body += "  const remaining_length = remaining.length\n  const removed_length = removed.length\n\n  return { remaining, removed, original: in.items, remaining_length, removed_length }\n"
    return header + f"export type Input = {{ {fields} }}\n\nexport type Output = {{ {result} }}\n\nexport default function (in: Input): Output {{\n{body}}}\n"


samples = {
    "integer": [0, -7, 7, -9223372036854775808, 9223372036854775807],
    "text": ["", "a", "中文", "é", "🙂", "\u0000"],
    "products": [{"tag": n, "payload": [n % 2 == 0, ["", "中文", "🙂"][n % 3]], "optional": None if n % 2 else n, "children": list(range(n % 4))} for n in range(5)],
    "tuples": [[n, n % 2 == 0, ["", "中文", "🙂"][n % 3]] for n in range(5)],
}
registrations = []
counts = {}
for kind, element in [("integer", "i64"), ("text", "string"), ("products", "Item"), ("tuples", "[i64, bool, string]"), ("composed", "i64"), ("lazy", "i64")]:
    pool = samples.get(kind, samples["integer"])
    inputs = [[], pool[:1], pool[:3], pool, [pool[1]] * 4, [pool[n % len(pool)] for n in range(17)]]
    replacements = [[], pool[-1:], pool[1:3]]
    rows = []
    seen = set()
    for items in inputs:
        length = len(items)
        ranges = [(start, count) for start in range(length + 1) for count in range(length - start + 1)] if length <= 6 else [(0, 0), (0, length), (1, length - 2), (length, 0), (length - 1, 1)]
        ranges += [(length + 1, 0), (0, length + 1), (length, 1), (maximum, 0), (0, maximum), (maximum, maximum), (1, maximum)]
        for start, count in ranges:
            for other in replacements:
                for extract in ([True, False] if kind == "lazy" else [True]):
                    incoming = {"items": items, "start": start, "count": count, "other": other}
                    if kind == "lazy":
                        incoming["extract"] = extract
                    key = json.dumps(incoming, sort_keys=True)
                    if key in seen:
                        continue
                    seen.add(key)
                    if not extract:
                        remaining, removed = items, []
                    elif start > length or count > length - start:
                        rows.append({"id": f"built_ins/list/range_extract/{kind}/{len(rows):04d}", "input": incoming, "expected": {"error": "IndexOutOfBounds"}})
                        continue
                    else:
                        removed = items[start:start + count]
                        remaining = items[:start] + other + items[start + count:]
                        if kind == "composed":
                            remaining, removed = remaining[::-1], removed[::-1]
                    value = {"remaining": remaining, "removed": removed, "original": items, "remaining_length": len(remaining), "removed_length": len(removed)}
                    rows.append({"id": f"built_ins/list/range_extract/{kind}/{len(rows):04d}", "input": incoming, "expected": {"value": value}})
    relative = f"packages/test/tests/built_ins/list/range_extract/{kind}/cases"
    save(relative + ".zx", source(element, kind == "composed", kind == "lazy"))
    save(relative + ".jsonl", rows_text(rows))
    registrations.append({"name": "list-range-" + kind, "path": f"built_ins/list/range_extract/{kind}/cases", "kind": "collections"})
    counts[kind] = {"total": len(rows), "errors": sum("error" in row["expected"] for row in rows)}

frontend = []

def front(name, start="in.start", count="in.count", other="in.other", fields="start: u64, count: u64, other: i64[]", diagnostic=None, operation=None):
    call = operation or f"owned.splice({start}, {count}, {other})"
    text = f"export type Input = {{ items: i64[], {fields} }}\n\nexport type Output = [i64[], i64[]]\n\nexport default function (in: Input): Output {{\n  const owned = in.items.map(item => item)\n\n  return {call}\n}}\n"
    frontend.append({"id": "language/types/list_range/" + name, "source": text, "phase": "analyze", "diagnostic": diagnostic})

front("dynamic_u64")
front("zero_empty", "0", "0", "[]")
front("length_empty", "owned.length", "0", "[]")
front("maximum_literal", str(maximum), "0", "[]")
for position in ["start", "count"]:
    for name, value in [("boolean", "true"), ("string", '\"0\"'), ("fraction", "1.5"), ("negative", "-1"), ("null", "null")]:
        front(position + "_" + name, start=value if position == "start" else "in.start", count=value if position == "count" else "in.count", diagnostic="type_mismatch")
    for typename in ["i64", "f64", "u64?"]:
        fields = f"start: {typename if position == 'start' else 'u64'}, count: {typename if position == 'count' else 'u64'}, other: i64[]"
        front(position + "_" + typename.replace("?", "_optional"), fields=fields, diagnostic="type_mismatch")
front("replacement_text", other='[\"x\"]', diagnostic="type_mismatch")
front("replacement_scalar", other="1", diagnostic="type_mismatch")
front("arity_two", operation="owned.splice(in.start, in.count)", diagnostic="type_mismatch")
front("arity_four", operation="owned.splice(in.start, in.count, in.other, [])", diagnostic="type_mismatch")
front("slice_method", operation="owned.slice(in.start, in.count)", diagnostic="name")
front("clone_method", operation="owned.clone()", diagnostic="unsupported")
save("packages/test/tests/language/types/list_range/cases.jsonl", rows_text(frontend))

catalog = root / "packages/test/suites.json"
text = catalog.read_text()
parsed = json.loads(text)
assert all(row["name"] not in {item["name"] for item in parsed["runtime"]} for row in registrations)
marker = '        {\n            "name": "' + parsed["runtime"][-1]["name"]
start = text.index(marker)
end = text.index("\n        }", start) + len("\n        }")
addition = ",\n" + ",\n".join("        " + json.dumps(row, ensure_ascii=False, indent=4).replace("\n", "\n        ") for row in registrations)
text = text[:end] + addition + text[end:]
marker = '        "' + parsed["frontend"][-1] + '"'
text = text.replace(marker, marker + ',\n        "language/types/list_range/cases"', 1)
save("packages/test/suites.json", text)

runtime = root / "packages/test/build/runtime.zig"
text = runtime.read_text().replace('    const string_index_step =', '    const list_range_step = b.step("test-list-range", "Execute strict dynamic list ranges and preserve caller values");\n    const string_index_step =', 1)
text = text.replace('        if (std.mem.startsWith(u8, suite.path, "built_ins/string/index/"))', '        if (std.mem.startsWith(u8, suite.path, "built_ins/list/range_extract/")) list_range_step.dependOn(&run.step);\n        if (std.mem.startsWith(u8, suite.path, "built_ins/string/index/"))', 1)
save("packages/test/build/runtime.zig", text)
(doc / "用例计数.json").write_text(json.dumps({"runtime": counts, "frontend": len(frontend)}, ensure_ascii=False, indent=2) + "\n")
print(json.dumps({"runtime": counts, "frontend": len(frontend)}))
