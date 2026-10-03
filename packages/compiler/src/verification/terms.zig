const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
pub const Value = union(enum) { scalar: []const u8, fields: []const Value };
pub const Evaluation = struct { value: Value, safe: []const u8 = "true" };
pub const Integer = struct { width: u16, signed: bool };

pub fn integer(target: ir.Type) ?Integer {
    if (target != .scalar) return null;

    return switch (target.scalar) {
        .u8 => .{ .width = 8, .signed = false },
        .u16 => .{ .width = 16, .signed = false },
        .u32 => .{ .width = 32, .signed = false },
        .u64 => .{ .width = 64, .signed = false },
        .i32 => .{ .width = 32, .signed = true },
        .i64 => .{ .width = 64, .signed = true },
        else => null,
    };
}

pub fn unary(allocator: std.mem.Allocator, operator: []const u8, value: []const u8) zx.Error![]const u8 {
    return std.fmt.allocPrint(allocator, "({s} {s})", .{ operator, value });
}

pub fn binary(allocator: std.mem.Allocator, operator: []const u8, left: []const u8, right: []const u8) zx.Error![]const u8 {
    if (std.mem.eql(u8, operator, "and")) {
        if (std.mem.eql(u8, left, "false") or std.mem.eql(u8, right, "false")) return "false";
        if (std.mem.eql(u8, left, "true")) return right;
        if (std.mem.eql(u8, right, "true")) return left;
    }

    return std.fmt.allocPrint(allocator, "({s} {s} {s})", .{ operator, left, right });
}

pub fn choose(allocator: std.mem.Allocator, condition: []const u8, yes: []const u8, no: []const u8) zx.Error![]const u8 {
    return std.fmt.allocPrint(allocator, "(ite {s} {s} {s})", .{ condition, yes, no });
}

pub fn select(allocator: std.mem.Allocator, condition: []const u8, yes: Value, no: Value) zx.Error!Value {
    if (yes == .scalar and no == .scalar) return .{ .scalar = try choose(allocator, condition, yes.scalar, no.scalar) };
    if (yes != .fields or no != .fields or yes.fields.len != no.fields.len) return error.InvalidSource;

    const fields = try allocator.alloc(Value, yes.fields.len);

    for (fields, yes.fields, no.fields) |*field, left, right| field.* = try select(allocator, condition, left, right);

    return .{ .fields = fields };
}

pub fn constant(allocator: std.mem.Allocator, value: u64, width: u16) zx.Error![]const u8 {
    return std.fmt.allocPrint(allocator, "(_ bv{d} {d})", .{ value, width });
}
