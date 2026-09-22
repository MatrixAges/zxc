const h = @import("../../helpers.zig");

test "operators f64: add" {
    try h.analyzeCase("export type Input = { left: f64; right: f64; }; export type Output = f64; export default function (in: Input): Output { return in.left + in.right; }", null);
}

test "operators f64: subtract" {
    try h.analyzeCase("export type Input = { left: f64; right: f64; }; export type Output = f64; export default function (in: Input): Output { return in.left - in.right; }", null);
}

test "operators f64: multiply" {
    try h.analyzeCase("export type Input = { left: f64; right: f64; }; export type Output = f64; export default function (in: Input): Output { return in.left * in.right; }", null);
}

test "operators f64: divide" {
    try h.analyzeCase("export type Input = { left: f64; right: f64; }; export type Output = f64; export default function (in: Input): Output { return in.left / in.right; }", null);
}

test "operators f64: remainder" {
    try h.analyzeCase("export type Input = { left: f64; right: f64; }; export type Output = f64; export default function (in: Input): Output { return in.left % in.right; }", null);
}

test "operators f64: equal" {
    try h.analyzeCase("export type Input = { left: f64; right: f64; }; export type Output = bool; export default function (in: Input): Output { return in.left == in.right; }", null);
}

test "operators f64: not_equal" {
    try h.analyzeCase("export type Input = { left: f64; right: f64; }; export type Output = bool; export default function (in: Input): Output { return in.left != in.right; }", null);
}

test "operators f64: less" {
    try h.analyzeCase("export type Input = { left: f64; right: f64; }; export type Output = bool; export default function (in: Input): Output { return in.left < in.right; }", null);
}

test "operators f64: less_equal" {
    try h.analyzeCase("export type Input = { left: f64; right: f64; }; export type Output = bool; export default function (in: Input): Output { return in.left <= in.right; }", null);
}

test "operators f64: greater" {
    try h.analyzeCase("export type Input = { left: f64; right: f64; }; export type Output = bool; export default function (in: Input): Output { return in.left > in.right; }", null);
}

test "operators f64: greater_equal" {
    try h.analyzeCase("export type Input = { left: f64; right: f64; }; export type Output = bool; export default function (in: Input): Output { return in.left >= in.right; }", null);
}
