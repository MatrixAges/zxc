const h = @import("../../helpers.zig");

test "operators i32: add" {
    try h.analyzeCase("export type Input = { left: i32; right: i32; }; export type Output = i32; export default function (in: Input): Output { return in.left + in.right; }", null);
}

test "operators i32: subtract" {
    try h.analyzeCase("export type Input = { left: i32; right: i32; }; export type Output = i32; export default function (in: Input): Output { return in.left - in.right; }", null);
}

test "operators i32: multiply" {
    try h.analyzeCase("export type Input = { left: i32; right: i32; }; export type Output = i32; export default function (in: Input): Output { return in.left * in.right; }", null);
}

test "operators i32: divide" {
    try h.analyzeCase("export type Input = { left: i32; right: i32; }; export type Output = i32; export default function (in: Input): Output { return in.left / in.right; }", null);
}

test "operators i32: remainder" {
    try h.analyzeCase("export type Input = { left: i32; right: i32; }; export type Output = i32; export default function (in: Input): Output { return in.left % in.right; }", null);
}

test "operators i32: equal" {
    try h.analyzeCase("export type Input = { left: i32; right: i32; }; export type Output = bool; export default function (in: Input): Output { return in.left == in.right; }", null);
}

test "operators i32: not_equal" {
    try h.analyzeCase("export type Input = { left: i32; right: i32; }; export type Output = bool; export default function (in: Input): Output { return in.left != in.right; }", null);
}

test "operators i32: less" {
    try h.analyzeCase("export type Input = { left: i32; right: i32; }; export type Output = bool; export default function (in: Input): Output { return in.left < in.right; }", null);
}

test "operators i32: less_equal" {
    try h.analyzeCase("export type Input = { left: i32; right: i32; }; export type Output = bool; export default function (in: Input): Output { return in.left <= in.right; }", null);
}

test "operators i32: greater" {
    try h.analyzeCase("export type Input = { left: i32; right: i32; }; export type Output = bool; export default function (in: Input): Output { return in.left > in.right; }", null);
}

test "operators i32: greater_equal" {
    try h.analyzeCase("export type Input = { left: i32; right: i32; }; export type Output = bool; export default function (in: Input): Output { return in.left >= in.right; }", null);
}
