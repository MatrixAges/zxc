const std = @import("std");
const zx = @import("zx");
const rules = @import("../scalar.zig");
const Mask = rules.Mask;

pub fn domain(kind: rules.Domain) Mask {
    return switch (kind) {
        .numeric => Mask.initMany(&.{ .u8, .u16, .u32, .u64, .i32, .i64, .f32, .f64 }),
        .signed => Mask.initMany(&.{ .i32, .i64, .f32, .f64 }),
        .floating => Mask.initMany(&.{ .f32, .f64 }),
    };
}

pub fn literal(text: []const u8, negative: bool) rules.Number {
    const floating = std.mem.indexOfAny(u8, text, ".eE") != null;

    return .{
        .allowed = domain(if (floating) .floating else if (negative) .signed else .numeric),
        .fallback = if (floating) .f64 else if (negative) .i64 else .u64,
    };
}

pub fn operator(value: zx.syntax.Operator) rules.Operator {
    return switch (value) {
        .logical_and => .{ .route = .and_value },
        .logical_or => .{ .route = .or_value },
        .coalesce => .{ .route = .coalesce },
        .equal, .not_equal => .{ .route = .compare },
        .less, .less_equal, .greater, .greater_equal => .{ .route = .compare, .allowed = domain(.numeric) },
        else => .{ .route = .arithmetic, .allowed = domain(.numeric) },
    };
}

pub fn restrict(previous: ?Mask, requested: Mask, shape: rules.Shape, scalar: ?zx.ir.Scalar) rules.Restriction {
    const allowed = if (previous) |value| value.intersectWith(requested) else requested;

    const issue: rules.Issue = if (allowed.count() == 0) .empty else switch (shape) {
        .open => .none,
        .scalar => if (allowed.contains(scalar.?)) .none else .operator,
        .concrete => .operator,
        .structure => .structure,
    };

    return .{ .allowed = allowed, .issue = issue };
}

pub fn combine(left: rules.Constraints, right: rules.Constraints) rules.Constraints {
    const allowed = if (left.allowed) |value| if (right.allowed) |other| value.intersectWith(other) else value else right.allowed;
    const fallback = if (left.fallback == null) right.fallback else if (right.fallback == null) left.fallback else if (left.fallback == .f64 or right.fallback == .f64) .f64 else if (left.fallback == .i64 or right.fallback == .i64) .i64 else left.fallback;

    return .{ .allowed = allowed, .fallback = fallback };
}

pub fn default(allowed: ?Mask, fallback: zx.ir.Scalar) ?zx.ir.Scalar {
    const mask = allowed orelse return fallback;

    if (mask.contains(fallback)) return fallback;

    for ([_]zx.ir.Scalar{ .i64, .f64, .i32, .f32, .u64, .u32, .u16, .u8 }) |candidate| {
        if (mask.contains(candidate)) return candidate;
    }

    return null;
}
