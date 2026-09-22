const h = @import("../../helpers.zig");

test "operators reject bool: add" {
    try h.analyzeCase("export type Input = { left: bool; right: bool; }; export type Output = bool; export default function (in: Input): Output { return in.left + in.right; }", .type_mismatch);
}

test "operators reject bool: subtract" {
    try h.analyzeCase("export type Input = { left: bool; right: bool; }; export type Output = bool; export default function (in: Input): Output { return in.left - in.right; }", .type_mismatch);
}

test "operators reject bool: multiply" {
    try h.analyzeCase("export type Input = { left: bool; right: bool; }; export type Output = bool; export default function (in: Input): Output { return in.left * in.right; }", .type_mismatch);
}

test "operators reject bool: divide" {
    try h.analyzeCase("export type Input = { left: bool; right: bool; }; export type Output = bool; export default function (in: Input): Output { return in.left / in.right; }", .type_mismatch);
}

test "operators reject bool: remainder" {
    try h.analyzeCase("export type Input = { left: bool; right: bool; }; export type Output = bool; export default function (in: Input): Output { return in.left % in.right; }", .type_mismatch);
}

test "operators reject string: add" {
    try h.analyzeCase("export type Input = { left: string; right: string; }; export type Output = string; export default function (in: Input): Output { return in.left + in.right; }", .type_mismatch);
}

test "operators reject string: subtract" {
    try h.analyzeCase("export type Input = { left: string; right: string; }; export type Output = string; export default function (in: Input): Output { return in.left - in.right; }", .type_mismatch);
}

test "operators reject string: multiply" {
    try h.analyzeCase("export type Input = { left: string; right: string; }; export type Output = string; export default function (in: Input): Output { return in.left * in.right; }", .type_mismatch);
}

test "operators reject string: divide" {
    try h.analyzeCase("export type Input = { left: string; right: string; }; export type Output = string; export default function (in: Input): Output { return in.left / in.right; }", .type_mismatch);
}

test "operators reject string: remainder" {
    try h.analyzeCase("export type Input = { left: string; right: string; }; export type Output = string; export default function (in: Input): Output { return in.left % in.right; }", .type_mismatch);
}

test "operators reject u64[]: add" {
    try h.analyzeCase("export type Input = { left: u64[]; right: u64[]; }; export type Output = u64[]; export default function (in: Input): Output { return in.left + in.right; }", .type_mismatch);
}

test "operators reject u64[]: subtract" {
    try h.analyzeCase("export type Input = { left: u64[]; right: u64[]; }; export type Output = u64[]; export default function (in: Input): Output { return in.left - in.right; }", .type_mismatch);
}

test "operators reject u64[]: multiply" {
    try h.analyzeCase("export type Input = { left: u64[]; right: u64[]; }; export type Output = u64[]; export default function (in: Input): Output { return in.left * in.right; }", .type_mismatch);
}

test "operators reject u64[]: divide" {
    try h.analyzeCase("export type Input = { left: u64[]; right: u64[]; }; export type Output = u64[]; export default function (in: Input): Output { return in.left / in.right; }", .type_mismatch);
}

test "operators reject u64[]: remainder" {
    try h.analyzeCase("export type Input = { left: u64[]; right: u64[]; }; export type Output = u64[]; export default function (in: Input): Output { return in.left % in.right; }", .type_mismatch);
}

test "operators reject mixed u8 u16: add" {
    try h.analyzeCase("export type Input = { left: u8; right: u16; }; export type Output = u8; export default function (in: Input): Output { return in.left + in.right; }", .type_mismatch);
}

test "operators reject mixed u8 u16: less" {
    try h.analyzeCase("export type Input = { left: u8; right: u16; }; export type Output = bool; export default function (in: Input): Output { return in.left < in.right; }", .type_mismatch);
}

test "operators reject mixed u32 u64: add" {
    try h.analyzeCase("export type Input = { left: u32; right: u64; }; export type Output = u32; export default function (in: Input): Output { return in.left + in.right; }", .type_mismatch);
}

test "operators reject mixed u32 u64: less" {
    try h.analyzeCase("export type Input = { left: u32; right: u64; }; export type Output = bool; export default function (in: Input): Output { return in.left < in.right; }", .type_mismatch);
}

test "operators reject mixed i32 i64: add" {
    try h.analyzeCase("export type Input = { left: i32; right: i64; }; export type Output = i32; export default function (in: Input): Output { return in.left + in.right; }", .type_mismatch);
}

test "operators reject mixed i32 i64: less" {
    try h.analyzeCase("export type Input = { left: i32; right: i64; }; export type Output = bool; export default function (in: Input): Output { return in.left < in.right; }", .type_mismatch);
}

test "operators reject mixed i64 u64: add" {
    try h.analyzeCase("export type Input = { left: i64; right: u64; }; export type Output = i64; export default function (in: Input): Output { return in.left + in.right; }", .type_mismatch);
}

test "operators reject mixed i64 u64: less" {
    try h.analyzeCase("export type Input = { left: i64; right: u64; }; export type Output = bool; export default function (in: Input): Output { return in.left < in.right; }", .type_mismatch);
}

test "operators reject mixed f32 f64: add" {
    try h.analyzeCase("export type Input = { left: f32; right: f64; }; export type Output = f32; export default function (in: Input): Output { return in.left + in.right; }", .type_mismatch);
}

test "operators reject mixed f32 f64: less" {
    try h.analyzeCase("export type Input = { left: f32; right: f64; }; export type Output = bool; export default function (in: Input): Output { return in.left < in.right; }", .type_mismatch);
}

test "operators reject mixed u64 f64: add" {
    try h.analyzeCase("export type Input = { left: u64; right: f64; }; export type Output = u64; export default function (in: Input): Output { return in.left + in.right; }", .type_mismatch);
}

test "operators reject mixed u64 f64: less" {
    try h.analyzeCase("export type Input = { left: u64; right: f64; }; export type Output = bool; export default function (in: Input): Output { return in.left < in.right; }", .type_mismatch);
}
