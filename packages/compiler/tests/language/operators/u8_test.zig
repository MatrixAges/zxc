const h = @import("../../helpers.zig");

test "operators u8: add" {
    try h.analyzeCase("export type Input = { left: u8; right: u8; }; export type Output = u8; export default function (in: Input): Output { return in.left + in.right; }", null);
}

test "operators u8: subtract" {
    try h.analyzeCase("export type Input = { left: u8; right: u8; }; export type Output = u8; export default function (in: Input): Output { return in.left - in.right; }", null);
}

test "operators u8: multiply" {
    try h.analyzeCase("export type Input = { left: u8; right: u8; }; export type Output = u8; export default function (in: Input): Output { return in.left * in.right; }", null);
}

test "operators u8: divide" {
    try h.analyzeCase("export type Input = { left: u8; right: u8; }; export type Output = u8; export default function (in: Input): Output { return in.left / in.right; }", null);
}

test "operators u8: remainder" {
    try h.analyzeCase("export type Input = { left: u8; right: u8; }; export type Output = u8; export default function (in: Input): Output { return in.left % in.right; }", null);
}

test "operators u8: equal" {
    try h.analyzeCase("export type Input = { left: u8; right: u8; }; export type Output = bool; export default function (in: Input): Output { return in.left == in.right; }", null);
}

test "operators u8: not_equal" {
    try h.analyzeCase("export type Input = { left: u8; right: u8; }; export type Output = bool; export default function (in: Input): Output { return in.left != in.right; }", null);
}

test "operators u8: less" {
    try h.analyzeCase("export type Input = { left: u8; right: u8; }; export type Output = bool; export default function (in: Input): Output { return in.left < in.right; }", null);
}

test "operators u8: less_equal" {
    try h.analyzeCase("export type Input = { left: u8; right: u8; }; export type Output = bool; export default function (in: Input): Output { return in.left <= in.right; }", null);
}

test "operators u8: greater" {
    try h.analyzeCase("export type Input = { left: u8; right: u8; }; export type Output = bool; export default function (in: Input): Output { return in.left > in.right; }", null);
}

test "operators u8: greater_equal" {
    try h.analyzeCase("export type Input = { left: u8; right: u8; }; export type Output = bool; export default function (in: Input): Output { return in.left >= in.right; }", null);
}
