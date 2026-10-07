const h = @import("../helpers.zig");

test "negative analyze: numeric if condition" {
    try h.analyzeCase("export type Input = u64\n export type Output = u64\n export default function (in: Input): Output { if (in) { return 1 } return 0 }", .type_mismatch);
}

test "negative analyze: missing return path" {
    try h.analyzeCase("export type Input = bool\n export type Output = u64\n export default function (in: Input): Output { if (in) { return 1 } }", .return_path);
}

test "negative analyze: bare return needs void" {
    try h.analyzeCase("export type Input = u64\n export type Output = u64\n export default function (in: Input): Output { return }", .type_mismatch);
}

test "negative analyze: value returned as void" {
    try h.analyzeCase("export type Input = void\n export type Output = void\n export default function (in: Input): Output { return 1 }", .type_mismatch);
}

test "negative analyze: unreachable after return" {
    try h.analyzeCase("export type Input = u64\n export type Output = u64\n export default function (in: Input): Output { return in\n const value = 1 }", .return_path);
}

test "negative analyze: duplicate local" {
    try h.analyzeCase("export type Input = u64\n export type Output = u64\n export default function (in: Input): Output { const value = 1\n const value = 2\n return value }", .name);
}

test "negative analyze: unknown name" {
    try h.analyzeCase("export type Input = u64\n export type Output = u64\n export default function (in: Input): Output { return absent }", .name);
}

test "negative analyze: branch local cannot escape" {
    try h.analyzeCase("export type Input = bool\n export type Output = u64\n export default function (in: Input): Output { if (in) { const local = 1 } return local }", .name);
}

test "negative analyze: annotation mismatch" {
    try h.analyzeCase("export type Input = u64\n export type Output = u64\n export default function (in: Input): Output { const value: bool = 1\n return in }", .type_mismatch);
}

test "negative analyze: object unknown field" {
    try h.analyzeCase("export type Input = void\n export type Output = { value?: u64 }\n export default function (in: Input): Output { return { extra: 1 } }", .name);
}

test "negative analyze: object missing required field" {
    try h.analyzeCase("export type Input = void\n export type Output = { value: u64 }\n export default function (in: Input): Output { return {} }", .type_mismatch);
}

test "negative analyze: invalid spread operand" {
    try h.analyzeCase("export type Input = u64\n export type Output = { value: u64 }\n export default function (in: Input): Output { return { ...in } }", .type_mismatch);
}

test "negative analyze: mixed list elements" {
    try h.analyzeCase("export type Input = void\n export type Output = u64[]\n export default function (in: Input): Output { return [1, true] }", .type_mismatch);
}

test "negative analyze: noninteger index" {
    try h.analyzeCase("export type Input = u64[]\n export type Output = u64\n export default function (in: Input): Output { return in[true] }", .type_mismatch);
}

test "negative analyze: unknown object member" {
    try h.analyzeCase("export type Input = { value: u64 }\n export type Output = u64\n export default function (in: Input): Output { return in.missing }", .name);
}

test "negative analyze: scalar length" {
    try h.analyzeCase("export type Input = u64\n export type Output = u64\n export default function (in: Input): Output { return in.length }", .type_mismatch);
}

test "negative analyze: null requires optional" {
    try h.analyzeCase("export type Input = void\n export type Output = u64\n export default function (in: Input): Output { return null }", .type_mismatch);
}

test "negative analyze: coalesce requires optional" {
    try h.analyzeCase("export type Input = u64\n export type Output = u64\n export default function (in: Input): Output { return in ?? 1 }", .type_mismatch);
}

test "negative analyze: conditional branches must agree" {
    try h.analyzeCase("export type Input = bool\n export type Output = u64\n export default function (in: Input): Output { return in ? 1 : false }", .type_mismatch);
}

test "negative analyze: map argument arity" {
    try h.analyzeCase("export type Input = u64[]\n export type Output = u64[]\n export default function (in: Input): Output { return in.map() }", .type_mismatch);
}

test "negative analyze: map requires lambda" {
    try h.analyzeCase("export type Input = u64[]\n export type Output = u64[]\n export default function (in: Input): Output { return in.map(1) }", .type_mismatch);
}

test "negative analyze: map parameter arity" {
    try h.analyzeCase("export type Input = u64[]\n export type Output = u64[]\n export default function (in: Input): Output { return in.map((left, right) => left) }", .type_mismatch);
}

test "negative analyze: filter predicate bool" {
    try h.analyzeCase("export type Input = u64[]\n export type Output = u64[]\n export default function (in: Input): Output { return in.filter(item => item) }", .type_mismatch);
}

test "negative analyze: reduce requires initial" {
    try h.analyzeCase("export type Input = u64[]\n export type Output = u64\n export default function (in: Input): Output { return in.reduce((sum, item) => sum + item) }", .type_mismatch);
}

test "negative analyze: clone remains unsupported with arguments" {
    try h.analyzeCase("export type Input = u64[]\n export type Output = u64[]\n export default function (in: Input): Output { return in.clone(1) }", .unsupported);
}

test "negative analyze: push element mismatch" {
    try h.analyzeCase("export type Input = void\n export type Output = u64[]\n export default function (in: Input): Output { const values = [1]\n const [next, _] = values.push(true)\n return next }", .type_mismatch);
}

test "negative analyze: pop no arguments" {
    try h.analyzeCase("export type Input = void\n export type Output = u64[]\n export default function (in: Input): Output { const values = [1]\n const [next, _] = values.pop(1)\n return next }", .type_mismatch);
}

test "negative analyze: void tuple slot discarded" {
    try h.analyzeCase("export type Input = void\n export type Output = u64[]\n export default function (in: Input): Output { const values = [1]\n const [next, result] = values.push(2)\n return next }", .type_mismatch);
}

test "negative analyze: concat element type" {
    try h.analyzeCase("export type Input = void\n export type Output = u64[]\n export default function (in: Input): Output { const values = [1]\n const [next, _] = values.concat([true])\n return next }", .type_mismatch);
}

test "negative analyze: splice argument arity" {
    try h.analyzeCase("export type Input = void\n export type Output = u64[]\n export default function (in: Input): Output { const values = [1]\n const [next, _] = values.splice(0)\n return next }", .type_mismatch);
}

test "negative analyze: switch label type" {
    try h.analyzeCase("export type Input = u64\n export type Output = u64\n export default function (in: Input): Output { switch (in) { case true: return 1\n default: return 0 } }", .type_mismatch);
}
