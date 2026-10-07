const h = @import("../helpers.zig");

test "negative parse: unterminated block comment" {
    try h.parseInvalid("/* missing", .lexical);
}

test "negative parse: unterminated string" {
    try h.parseInvalid("export type Input = u64\n export type Output = string\n export default function (in: Input): Output { return \"missing; } }", .lexical);
}

test "negative parse: illegal token" {
    try h.parseInvalid("export type Input = u64\n export type Output = u64\n export default function (in: Input): Output { return ^ }", .lexical);
}

test "negative parse: missing declaration semicolon" {
    try h.parseInvalid("export type Value = u64", .syntax);
}

test "negative parse: missing list separator" {
    try h.parseInvalid("export type Input = u64\n export type Output = u64[]\n export default function (in: Input): Output { return [1 2] }", .syntax);
}

test "negative parse: missing object colon" {
    try h.parseInvalid("export type Input = u64\n export type Output = { value: u64 }\n export default function (in: Input): Output { return { value 1 } }", .syntax);
}

test "negative parse: missing return semicolon" {
    try h.parseInvalid("export type Input = u64\n export type Output = u64\n export default function (in: Input): Output { return in }", .syntax);
}

test "negative parse: missing closing parenthesis" {
    try h.parseInvalid("export type Input = u64\n export type Output = u64\n export default function (in: Input): Output { return (in + 1 }", .syntax);
}

test "negative parse: missing conditional colon" {
    try h.parseInvalid("export type Input = u64\n export type Output = u64\n export default function (in: Input): Output { return true ? 1 2 }", .syntax);
}

test "negative parse: const without binding" {
    try h.parseInvalid("export type Input = u64\n export type Output = u64\n export default function (in: Input): Output { const = 1\n return in }", .syntax);
}

test "negative parse: let binding" {
    try h.parseInvalid("export type Input = u64\n export type Output = u64\n export default function (in: Input): Output { let value = 1\n return value }", .syntax);
}

test "negative parse: var binding" {
    try h.parseInvalid("export type Input = u64\n export type Output = u64\n export default function (in: Input): Output { var value = 1\n return value }", .syntax);
}

test "negative parse: while statement" {
    try h.parseInvalid("export type Input = u64\n export type Output = u64\n export default function (in: Input): Output { while (true) {} return in }", .syntax);
}

test "negative parse: for statement" {
    try h.parseInvalid("export type Input = u64\n export type Output = u64\n export default function (in: Input): Output { for (\n\n) {} return in }", .syntax);
}

test "negative parse: throw statement" {
    try h.parseInvalid("export type Input = u64\n export type Output = u64\n export default function (in: Input): Output { throw in }", .syntax);
}

test "negative parse: increment expression" {
    try h.parseInvalid("export type Input = u64\n export type Output = u64\n export default function (in: Input): Output { return in++ }", .syntax);
}

test "negative parse: compound assignment" {
    try h.parseInvalid("export type Input = u64\n export type Output = u64\n export default function (in: Input): Output { in += 1\n return in }", .syntax);
}

test "negative parse: ordinary field mutation" {
    try h.parseInvalid("export type Input = { value: u64 }\n export type Output = u64\n export default function (in: Input): Output { in.value = 1\n return in.value }", .syntax);
}

test "negative parse: block lambda" {
    try h.parseInvalid("export type Input = u64[]\n export type Output = u64[]\n export default function (in: Input): Output { return in.map(item => { return item }) }", .syntax);
}

test "negative parse: trailing executable tokens" {
    try h.parseInvalid("export type Input = u64\n export type Output = u64\n export default function (in: Input): Output { return in } const extra = 1\n", .contract);
}
