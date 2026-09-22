const h = @import("../../helpers.zig");

test "operators u32: add" {
    try h.analyzeCase("export type Input = { left: u32; right: u32; }; export type Output = u32; export default function (in: Input): Output { return in.left + in.right; }", null);
}

test "operators u32: subtract" {
    try h.analyzeCase("export type Input = { left: u32; right: u32; }; export type Output = u32; export default function (in: Input): Output { return in.left - in.right; }", null);
}

test "operators u32: multiply" {
    try h.analyzeCase("export type Input = { left: u32; right: u32; }; export type Output = u32; export default function (in: Input): Output { return in.left * in.right; }", null);
}

test "operators u32: divide" {
    try h.analyzeCase("export type Input = { left: u32; right: u32; }; export type Output = u32; export default function (in: Input): Output { return in.left / in.right; }", null);
}

test "operators u32: remainder" {
    try h.analyzeCase("export type Input = { left: u32; right: u32; }; export type Output = u32; export default function (in: Input): Output { return in.left % in.right; }", null);
}

test "operators u32: equal" {
    try h.analyzeCase("export type Input = { left: u32; right: u32; }; export type Output = bool; export default function (in: Input): Output { return in.left == in.right; }", null);
}

test "operators u32: not_equal" {
    try h.analyzeCase("export type Input = { left: u32; right: u32; }; export type Output = bool; export default function (in: Input): Output { return in.left != in.right; }", null);
}

test "operators u32: less" {
    try h.analyzeCase("export type Input = { left: u32; right: u32; }; export type Output = bool; export default function (in: Input): Output { return in.left < in.right; }", null);
}

test "operators u32: less_equal" {
    try h.analyzeCase("export type Input = { left: u32; right: u32; }; export type Output = bool; export default function (in: Input): Output { return in.left <= in.right; }", null);
}

test "operators u32: greater" {
    try h.analyzeCase("export type Input = { left: u32; right: u32; }; export type Output = bool; export default function (in: Input): Output { return in.left > in.right; }", null);
}

test "operators u32: greater_equal" {
    try h.analyzeCase("export type Input = { left: u32; right: u32; }; export type Output = bool; export default function (in: Input): Output { return in.left >= in.right; }", null);
}
