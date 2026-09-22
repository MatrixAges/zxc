const h = @import("../../helpers.zig");

test "operators i64: add" {
    try h.analyzeCase("export type Input = { left: i64; right: i64; }; export type Output = i64; export default function (in: Input): Output { return in.left + in.right; }", null);
}

test "operators i64: subtract" {
    try h.analyzeCase("export type Input = { left: i64; right: i64; }; export type Output = i64; export default function (in: Input): Output { return in.left - in.right; }", null);
}

test "operators i64: multiply" {
    try h.analyzeCase("export type Input = { left: i64; right: i64; }; export type Output = i64; export default function (in: Input): Output { return in.left * in.right; }", null);
}

test "operators i64: divide" {
    try h.analyzeCase("export type Input = { left: i64; right: i64; }; export type Output = i64; export default function (in: Input): Output { return in.left / in.right; }", null);
}

test "operators i64: remainder" {
    try h.analyzeCase("export type Input = { left: i64; right: i64; }; export type Output = i64; export default function (in: Input): Output { return in.left % in.right; }", null);
}

test "operators i64: equal" {
    try h.analyzeCase("export type Input = { left: i64; right: i64; }; export type Output = bool; export default function (in: Input): Output { return in.left == in.right; }", null);
}

test "operators i64: not_equal" {
    try h.analyzeCase("export type Input = { left: i64; right: i64; }; export type Output = bool; export default function (in: Input): Output { return in.left != in.right; }", null);
}

test "operators i64: less" {
    try h.analyzeCase("export type Input = { left: i64; right: i64; }; export type Output = bool; export default function (in: Input): Output { return in.left < in.right; }", null);
}

test "operators i64: less_equal" {
    try h.analyzeCase("export type Input = { left: i64; right: i64; }; export type Output = bool; export default function (in: Input): Output { return in.left <= in.right; }", null);
}

test "operators i64: greater" {
    try h.analyzeCase("export type Input = { left: i64; right: i64; }; export type Output = bool; export default function (in: Input): Output { return in.left > in.right; }", null);
}

test "operators i64: greater_equal" {
    try h.analyzeCase("export type Input = { left: i64; right: i64; }; export type Output = bool; export default function (in: Input): Output { return in.left >= in.right; }", null);
}
