from pathlib import Path
import shutil


doc = Path(__file__).resolve().parent
main = doc.parents[2]
draft = doc / "草稿/packages/test"
directory = draft / "tests/rx/runtime/product_transfer"
fixtures = directory / "fixtures"


def write(name, text):
    path = fixtures / name
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(text)
    if path.suffix == ".zx":
        assert "\r" not in text and text.count("\n") <= 120


write("model.zx", '''export type DataInput = { left: i64[], right: i64[], count: u64, delta: i64, enabled: bool, left_index: u64, right_index: u64, marker: u64 }

export type Columns = { left: i64[], right: i64[] }

export type State = { columns: Columns, round: u64, count: u64, delta: i64, enabled: bool, left_index: u64, right_index: u64, marker: u64 }

export type NestedState = { product: [Columns, u64], round: u64, count: u64, delta: i64, enabled: bool, left_index: u64, right_index: u64 }
''')

metadata = "round: 0, count: in.count, delta: in.delta, enabled: in.enabled, left_index: in.left_index, right_index: in.right_index"
for name in ["independent", "shared", "borrowed", "branch", "nested"]:
    declarations = {
        "independent": "    const left = in.left.map(item => item)\n    const right = in.right.map(item => item)\n",
        "nested": "    const left = in.left.map(item => item)\n    const right = in.right.map(item => item)\n",
        "shared": "    const left = in.left.map(item => item)\n    const right = left\n",
        "borrowed": "    const left = in.left\n    const right = in.right\n",
        "branch": "    const left = in.left.map(item => item)\n    const right = in.enabled ? in.right.map(item => item) : left\n",
    }[name]
    output = "NestedState" if name == "nested" else "State"
    fields = "product: [{ left, right }, in.marker]" if name == "nested" else "columns: { left, right }"
    suffix = "" if name == "nested" else ", marker: in.marker"
    write("factories/" + name + ".zx", f'''import type {{ DataInput, {output} }} from "../model"

export type Input = DataInput

export type Output = {output}

export default function (in: Input): Output {{
{declarations}
    return {{ {fields}, {metadata}{suffix} }}
}}
''')

for name in ["columns", "nested", "growth"]:
    output = "NestedState" if name == "nested" else "State"
    path = "state.product[0]" if name == "nested" else "state.columns"
    left = f"{path}.left = {path}.left.push(state.delta)[0]" if name == "growth" else f"{path}.left[state.left_index] += state.delta"
    write("steps/" + name + ".zx", f'''import type {{ {output} }} from "../model"

export type Input = {output}

export type Output = {output}

export default function (in: Input): Output {{
    return loop(in, {{
        while: state => state.round < state.count,
        next: state => {{
            if (state.enabled) {{
                {left}
                {path}.right[state.right_index] -= state.delta
            }}
            state.round += 1
        }}
    }})
}}
''')

for name in ["object", "nested", "retained_target", "retained_parent", "duplicate"]:
    argument = "$ctx.create" if name != "duplicate" else "{ ...$ctx.create, columns: { left: $ctx.create.columns.left, right: $ctx.create.columns.left } }"
    columns = "$ctx.patch.product[0]" if name == "nested" else "$ctx.patch.columns"
    marker = "$ctx.patch.product[1]" if name == "nested" else "$ctx.patch.marker"
    before = "$ctx.create.columns" if name == "retained_parent" else "{ left: $ctx.create.columns.left, right: $in.right }" if name == "retained_target" else "{ left: $in.left, right: $in.right }"
    write("entries/" + name + ".rx", f'''<Module>
    <Call fn="factories/create" in={{$in}} />
    <Call fn="steps/patch" in={{{argument}}} />

    <Return value={{{{ columns: {columns}, before: {before}, original: {{ left: $in.left, right: $in.right }}, marker: {marker}, rounds: $ctx.patch.round }}}} />
</Module>
''')

helper = main / "packages/test/tests/collections/nested_buffer/compile.zig"
print("created", len(list(fixtures.rglob("*.zx"))), "ZX and", len(list(fixtures.rglob("*.rx"))), "RX fixtures")
