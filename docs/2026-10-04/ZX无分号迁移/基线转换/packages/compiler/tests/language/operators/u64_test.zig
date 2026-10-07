const h = @import("../../helpers.zig");

test "operators u64: add" {
    try h.analyzeCase("export type Input = { left: u64\n right: u64 }\n export type Output = u64\n export default function (in: Input): Output { return in.left + in.right }", null);
}

test "operators u64: subtract" {
    try h.analyzeCase("export type Input = { left: u64\n right: u64 }\n export type Output = u64\n export default function (in: Input): Output { return in.left - in.right }", null);
}

test "operators u64: multiply" {
    try h.analyzeCase("export type Input = { left: u64\n right: u64 }\n export type Output = u64\n export default function (in: Input): Output { return in.left * in.right }", null);
}

test "operators u64: divide" {
    try h.analyzeCase("export type Input = { left: u64\n right: u64 }\n export type Output = u64\n export default function (in: Input): Output { return in.left / in.right }", null);
}

test "operators u64: remainder" {
    try h.analyzeCase("export type Input = { left: u64\n right: u64 }\n export type Output = u64\n export default function (in: Input): Output { return in.left % in.right }", null);
}

test "operators u64: equal" {
    try h.analyzeCase("export type Input = { left: u64\n right: u64 }\n export type Output = bool\n export default function (in: Input): Output { return in.left == in.right }", null);
}

test "operators u64: not_equal" {
    try h.analyzeCase("export type Input = { left: u64\n right: u64 }\n export type Output = bool\n export default function (in: Input): Output { return in.left != in.right }", null);
}

test "operators u64: less" {
    try h.analyzeCase("export type Input = { left: u64\n right: u64 }\n export type Output = bool\n export default function (in: Input): Output { return in.left < in.right }", null);
}

test "operators u64: less_equal" {
    try h.analyzeCase("export type Input = { left: u64\n right: u64 }\n export type Output = bool\n export default function (in: Input): Output { return in.left <= in.right }", null);
}

test "operators u64: greater" {
    try h.analyzeCase("export type Input = { left: u64\n right: u64 }\n export type Output = bool\n export default function (in: Input): Output { return in.left > in.right }", null);
}

test "operators u64: greater_equal" {
    try h.analyzeCase("export type Input = { left: u64\n right: u64 }\n export type Output = bool\n export default function (in: Input): Output { return in.left >= in.right }", null);
}
