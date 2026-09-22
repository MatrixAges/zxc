const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Types = @import("types.zig");
const Analyzer = @import("analyzer.zig");

pub fn isFloat(id: ir.TypeId) bool {
    return id == Types.scalarId(.f32) or id == Types.scalarId(.f64);
}

pub fn isInteger(id: ir.TypeId) bool {
    return @intFromEnum(id) >= @intFromEnum(Types.scalarId(.u8)) and @intFromEnum(id) <= @intFromEnum(Types.scalarId(.i64));
}

pub fn isSigned(id: ir.TypeId) bool {
    return id == Types.scalarId(.i32) or id == Types.scalarId(.i64);
}

pub fn literal(analyzer: *Analyzer, text: []const u8, span: zx.Span, expected: ?ir.TypeId, negative: bool) zx.Error!ir.ExprId {
    const floating = std.mem.indexOfAny(u8, text, ".eE") != null;
    const type_id = expected orelse Types.scalarId(if (floating) .f64 else if (negative) .i64 else .u64);

    if (!isFloat(type_id) and !isInteger(type_id)) return analyzer.reporter.fail(.type_mismatch, span, "a numeric literal requires a numeric type");

    for (text, 0..) |byte, index| {
        if (byte == '_' and (index == 0 or index + 1 == text.len or !std.ascii.isDigit(text[index - 1]) or !std.ascii.isDigit(text[index + 1]))) {
            return analyzer.reporter.fail(.lexical, span, "digit separators must occur between digits");
        }
    }

    var clean: std.ArrayList(u8) = .empty;

    for (text) |byte| {
        if (byte != '_') try clean.append(analyzer.allocator, byte);
    }

    if (isFloat(type_id)) {
        var value: f64 = switch (type_id) {
            Types.scalarId(.f32) => std.fmt.parseFloat(f32, clean.items) catch return analyzer.reporter.fail(.type_mismatch, span, "invalid floating-point literal"),
            else => std.fmt.parseFloat(f64, clean.items) catch return analyzer.reporter.fail(.type_mismatch, span, "invalid floating-point literal"),
        };

        if (negative) value = -value;
        if (!std.math.isFinite(value)) return analyzer.reporter.fail(.type_mismatch, span, "floating-point literal is outside the target range");

        if (!floating) {
            const exact = std.fmt.parseInt(u1024, clean.items, 10) catch return analyzer.reporter.fail(.type_mismatch, span, "integer literal is outside the floating-point range");
            const significant_bits = 1024 - @clz(exact);
            const precision: u11 = if (type_id == Types.scalarId(.f32)) 24 else 53;

            if (significant_bits > precision and @ctz(exact) < significant_bits - precision) return analyzer.reporter.fail(.type_mismatch, span, "integer literal cannot be represented exactly by its floating-point type");
        }

        return analyzer.append(.{ .span = span, .type_id = type_id, .value = .{ .float = value } });
    }

    if (floating) return analyzer.reporter.fail(.type_mismatch, span, "floating-point literals cannot be implicitly converted to integers");

    const value = std.fmt.parseInt(u64, clean.items, 10) catch return analyzer.reporter.fail(.type_mismatch, span, "integer literal is outside the supported range");
    const scalar = analyzer.types.items.items[@intFromEnum(type_id)].scalar;

    const maximum: u64 = switch (scalar) {
        .u8 => std.math.maxInt(u8),
        .u16 => std.math.maxInt(u16),
        .u32 => std.math.maxInt(u32),
        .u64 => std.math.maxInt(u64),
        .i32 => @as(u64, std.math.maxInt(i32)) + @intFromBool(negative),
        .i64 => @as(u64, std.math.maxInt(i64)) + @intFromBool(negative),
        else => unreachable,
    };

    if (value > maximum or (negative and !isSigned(type_id))) return analyzer.reporter.fail(.type_mismatch, span, "integer literal does not fit its type");

    return analyzer.append(.{ .span = span, .type_id = type_id, .value = if (negative) .{ .negative_integer = value } else .{ .integer = value } });
}
