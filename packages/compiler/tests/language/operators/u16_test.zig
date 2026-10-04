const h = @import("../../helpers.zig");

test "operators u16: add" {
    try h.analyzeCase("export type Input = { left: u16\n right: u16 }\n export type Output = u16\n export default function (in: Input): Output { return in.left + in.right }", null);
}

test "operators u16: subtract" {
    try h.analyzeCase("export type Input = { left: u16\n right: u16 }\n export type Output = u16\n export default function (in: Input): Output { return in.left - in.right }", null);
}

test "operators u16: multiply" {
    try h.analyzeCase("export type Input = { left: u16\n right: u16 }\n export type Output = u16\n export default function (in: Input): Output { return in.left * in.right }", null);
}

test "operators u16: divide" {
    try h.analyzeCase("export type Input = { left: u16\n right: u16 }\n export type Output = u16\n export default function (in: Input): Output { return in.left / in.right }", null);
}

test "operators u16: remainder" {
    try h.analyzeCase("export type Input = { left: u16\n right: u16 }\n export type Output = u16\n export default function (in: Input): Output { return in.left % in.right }", null);
}

test "operators u16: equal" {
    try h.analyzeCase("export type Input = { left: u16\n right: u16 }\n export type Output = bool\n export default function (in: Input): Output { return in.left == in.right }", null);
}

test "operators u16: not_equal" {
    try h.analyzeCase("export type Input = { left: u16\n right: u16 }\n export type Output = bool\n export default function (in: Input): Output { return in.left != in.right }", null);
}

test "operators u16: less" {
    try h.analyzeCase("export type Input = { left: u16\n right: u16 }\n export type Output = bool\n export default function (in: Input): Output { return in.left < in.right }", null);
}

test "operators u16: less_equal" {
    try h.analyzeCase("export type Input = { left: u16\n right: u16 }\n export type Output = bool\n export default function (in: Input): Output { return in.left <= in.right }", null);
}

test "operators u16: greater" {
    try h.analyzeCase("export type Input = { left: u16\n right: u16 }\n export type Output = bool\n export default function (in: Input): Output { return in.left > in.right }", null);
}

test "operators u16: greater_equal" {
    try h.analyzeCase("export type Input = { left: u16\n right: u16 }\n export type Output = bool\n export default function (in: Input): Output { return in.left >= in.right }", null);
}
