const h = @import("../../helpers.zig");

test "operators f32: add" {
    try h.analyzeCase("export type Input = { left: f32\n right: f32 }\n export type Output = f32\n export default function (in: Input): Output { return in.left + in.right }", null);
}

test "operators f32: subtract" {
    try h.analyzeCase("export type Input = { left: f32\n right: f32 }\n export type Output = f32\n export default function (in: Input): Output { return in.left - in.right }", null);
}

test "operators f32: multiply" {
    try h.analyzeCase("export type Input = { left: f32\n right: f32 }\n export type Output = f32\n export default function (in: Input): Output { return in.left * in.right }", null);
}

test "operators f32: divide" {
    try h.analyzeCase("export type Input = { left: f32\n right: f32 }\n export type Output = f32\n export default function (in: Input): Output { return in.left / in.right }", null);
}

test "operators f32: remainder" {
    try h.analyzeCase("export type Input = { left: f32\n right: f32 }\n export type Output = f32\n export default function (in: Input): Output { return in.left % in.right }", null);
}

test "operators f32: equal" {
    try h.analyzeCase("export type Input = { left: f32\n right: f32 }\n export type Output = bool\n export default function (in: Input): Output { return in.left == in.right }", null);
}

test "operators f32: not_equal" {
    try h.analyzeCase("export type Input = { left: f32\n right: f32 }\n export type Output = bool\n export default function (in: Input): Output { return in.left != in.right }", null);
}

test "operators f32: less" {
    try h.analyzeCase("export type Input = { left: f32\n right: f32 }\n export type Output = bool\n export default function (in: Input): Output { return in.left < in.right }", null);
}

test "operators f32: less_equal" {
    try h.analyzeCase("export type Input = { left: f32\n right: f32 }\n export type Output = bool\n export default function (in: Input): Output { return in.left <= in.right }", null);
}

test "operators f32: greater" {
    try h.analyzeCase("export type Input = { left: f32\n right: f32 }\n export type Output = bool\n export default function (in: Input): Output { return in.left > in.right }", null);
}

test "operators f32: greater_equal" {
    try h.analyzeCase("export type Input = { left: f32\n right: f32 }\n export type Output = bool\n export default function (in: Input): Output { return in.left >= in.right }", null);
}
