const h = @import("../../helpers.zig");

test "operators reject bool: add" {
    try h.analyzeCase("export type Input = { left: bool\n right: bool }\n export type Output = bool\n export default function (in: Input): Output { return in.left + in.right }", .type_mismatch);
}

test "operators reject bool: subtract" {
    try h.analyzeCase("export type Input = { left: bool\n right: bool }\n export type Output = bool\n export default function (in: Input): Output { return in.left - in.right }", .type_mismatch);
}

test "operators reject bool: multiply" {
    try h.analyzeCase("export type Input = { left: bool\n right: bool }\n export type Output = bool\n export default function (in: Input): Output { return in.left * in.right }", .type_mismatch);
}

test "operators reject bool: divide" {
    try h.analyzeCase("export type Input = { left: bool\n right: bool }\n export type Output = bool\n export default function (in: Input): Output { return in.left / in.right }", .type_mismatch);
}

test "operators reject bool: remainder" {
    try h.analyzeCase("export type Input = { left: bool\n right: bool }\n export type Output = bool\n export default function (in: Input): Output { return in.left % in.right }", .type_mismatch);
}

test "operators reject string: add" {
    try h.analyzeCase("export type Input = { left: string\n right: string }\n export type Output = string\n export default function (in: Input): Output { return in.left + in.right }", .type_mismatch);
}

test "operators reject string: subtract" {
    try h.analyzeCase("export type Input = { left: string\n right: string }\n export type Output = string\n export default function (in: Input): Output { return in.left - in.right }", .type_mismatch);
}

test "operators reject string: multiply" {
    try h.analyzeCase("export type Input = { left: string\n right: string }\n export type Output = string\n export default function (in: Input): Output { return in.left * in.right }", .type_mismatch);
}

test "operators reject string: divide" {
    try h.analyzeCase("export type Input = { left: string\n right: string }\n export type Output = string\n export default function (in: Input): Output { return in.left / in.right }", .type_mismatch);
}

test "operators reject string: remainder" {
    try h.analyzeCase("export type Input = { left: string\n right: string }\n export type Output = string\n export default function (in: Input): Output { return in.left % in.right }", .type_mismatch);
}

test "operators reject u64[]: add" {
    try h.analyzeCase("export type Input = { left: u64[]\n right: u64[] }\n export type Output = u64[]\n export default function (in: Input): Output { return in.left + in.right }", .type_mismatch);
}

test "operators reject u64[]: subtract" {
    try h.analyzeCase("export type Input = { left: u64[]\n right: u64[] }\n export type Output = u64[]\n export default function (in: Input): Output { return in.left - in.right }", .type_mismatch);
}

test "operators reject u64[]: multiply" {
    try h.analyzeCase("export type Input = { left: u64[]\n right: u64[] }\n export type Output = u64[]\n export default function (in: Input): Output { return in.left * in.right }", .type_mismatch);
}

test "operators reject u64[]: divide" {
    try h.analyzeCase("export type Input = { left: u64[]\n right: u64[] }\n export type Output = u64[]\n export default function (in: Input): Output { return in.left / in.right }", .type_mismatch);
}

test "operators reject u64[]: remainder" {
    try h.analyzeCase("export type Input = { left: u64[]\n right: u64[] }\n export type Output = u64[]\n export default function (in: Input): Output { return in.left % in.right }", .type_mismatch);
}

test "operators reject mixed u8 u16: add" {
    try h.analyzeCase("export type Input = { left: u8\n right: u16 }\n export type Output = u8\n export default function (in: Input): Output { return in.left + in.right }", .type_mismatch);
}

test "operators reject mixed u8 u16: less" {
    try h.analyzeCase("export type Input = { left: u8\n right: u16 }\n export type Output = bool\n export default function (in: Input): Output { return in.left < in.right }", .type_mismatch);
}

test "operators reject mixed u32 u64: add" {
    try h.analyzeCase("export type Input = { left: u32\n right: u64 }\n export type Output = u32\n export default function (in: Input): Output { return in.left + in.right }", .type_mismatch);
}

test "operators reject mixed u32 u64: less" {
    try h.analyzeCase("export type Input = { left: u32\n right: u64 }\n export type Output = bool\n export default function (in: Input): Output { return in.left < in.right }", .type_mismatch);
}

test "operators reject mixed i32 i64: add" {
    try h.analyzeCase("export type Input = { left: i32\n right: i64 }\n export type Output = i32\n export default function (in: Input): Output { return in.left + in.right }", .type_mismatch);
}

test "operators reject mixed i32 i64: less" {
    try h.analyzeCase("export type Input = { left: i32\n right: i64 }\n export type Output = bool\n export default function (in: Input): Output { return in.left < in.right }", .type_mismatch);
}

test "operators reject mixed i64 u64: add" {
    try h.analyzeCase("export type Input = { left: i64\n right: u64 }\n export type Output = i64\n export default function (in: Input): Output { return in.left + in.right }", .type_mismatch);
}

test "operators reject mixed i64 u64: less" {
    try h.analyzeCase("export type Input = { left: i64\n right: u64 }\n export type Output = bool\n export default function (in: Input): Output { return in.left < in.right }", .type_mismatch);
}

test "operators reject mixed f32 f64: add" {
    try h.analyzeCase("export type Input = { left: f32\n right: f64 }\n export type Output = f32\n export default function (in: Input): Output { return in.left + in.right }", .type_mismatch);
}

test "operators reject mixed f32 f64: less" {
    try h.analyzeCase("export type Input = { left: f32\n right: f64 }\n export type Output = bool\n export default function (in: Input): Output { return in.left < in.right }", .type_mismatch);
}

test "operators reject mixed u64 f64: add" {
    try h.analyzeCase("export type Input = { left: u64\n right: f64 }\n export type Output = u64\n export default function (in: Input): Output { return in.left + in.right }", .type_mismatch);
}

test "operators reject mixed u64 f64: less" {
    try h.analyzeCase("export type Input = { left: u64\n right: f64 }\n export type Output = bool\n export default function (in: Input): Output { return in.left < in.right }", .type_mismatch);
}
