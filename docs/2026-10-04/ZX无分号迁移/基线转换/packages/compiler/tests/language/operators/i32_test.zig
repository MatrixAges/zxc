const h = @import("../../helpers.zig");

test "operators i32: add" {
    try h.analyzeCase("export type Input = { left: i32\n right: i32 }\n export type Output = i32\n export default function (in: Input): Output { return in.left + in.right }", null);
}

test "operators i32: subtract" {
    try h.analyzeCase("export type Input = { left: i32\n right: i32 }\n export type Output = i32\n export default function (in: Input): Output { return in.left - in.right }", null);
}

test "operators i32: multiply" {
    try h.analyzeCase("export type Input = { left: i32\n right: i32 }\n export type Output = i32\n export default function (in: Input): Output { return in.left * in.right }", null);
}

test "operators i32: divide" {
    try h.analyzeCase("export type Input = { left: i32\n right: i32 }\n export type Output = i32\n export default function (in: Input): Output { return in.left / in.right }", null);
}

test "operators i32: remainder" {
    try h.analyzeCase("export type Input = { left: i32\n right: i32 }\n export type Output = i32\n export default function (in: Input): Output { return in.left % in.right }", null);
}

test "operators i32: equal" {
    try h.analyzeCase("export type Input = { left: i32\n right: i32 }\n export type Output = bool\n export default function (in: Input): Output { return in.left == in.right }", null);
}

test "operators i32: not_equal" {
    try h.analyzeCase("export type Input = { left: i32\n right: i32 }\n export type Output = bool\n export default function (in: Input): Output { return in.left != in.right }", null);
}

test "operators i32: less" {
    try h.analyzeCase("export type Input = { left: i32\n right: i32 }\n export type Output = bool\n export default function (in: Input): Output { return in.left < in.right }", null);
}

test "operators i32: less_equal" {
    try h.analyzeCase("export type Input = { left: i32\n right: i32 }\n export type Output = bool\n export default function (in: Input): Output { return in.left <= in.right }", null);
}

test "operators i32: greater" {
    try h.analyzeCase("export type Input = { left: i32\n right: i32 }\n export type Output = bool\n export default function (in: Input): Output { return in.left > in.right }", null);
}

test "operators i32: greater_equal" {
    try h.analyzeCase("export type Input = { left: i32\n right: i32 }\n export type Output = bool\n export default function (in: Input): Output { return in.left >= in.right }", null);
}
