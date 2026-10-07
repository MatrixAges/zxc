const h = @import("../helpers.zig");

test "lexical positive: comments and CRLF" {
    try h.analyzeCase("// header\r\nexport/*middle*/type Input = u64\r\nexport type Output = u64\r\nexport default function (in: Input): Output { return in }// eof", null);
}

test "lexical positive: keyword prefixes" {
    try h.analyzeCase("export type Input = u64\n export type Output = u64\n export default function (in: Input): Output { const constellation = in\n const return_value = constellation\n return return_value }", null);
}

test "lexical positive: decimal exponent and separator" {
    try h.analyzeCase("export type Input = void\n export type Output = [f32, f64, u64]\n export default function (in: Input): Output { return [1.25e+2, 2.5E-1, 1_000] }", null);
}

test "lexical positive: UTF8 strings" {
    try h.analyzeCase("export type Input = void\n export type Output = string\n export default function (in: Input): Output { return \"中文🌱\" }", null);
}

test "lexical negative: invalid UTF8" {
    try h.parseInvalid("\xff", .lexical);
}

test "lexical negative: unsupported escape" {
    try h.parseInvalid("export type Input = void\n export type Output = string\n export default function (in: Input): Output { return \"\\q\" }", .lexical);
}

test "lexical negative: unescaped newline" {
    try h.parseInvalid("export type Input = void\n export type Output = string\n export default function (in: Input): Output { return \"a\nb\" }", .lexical);
}
