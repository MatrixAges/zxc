const std = @import("std");
const f = @import("fixture.zig");
const ir = f.compiler.ir;

pub const Mode = enum { missing, extra, renamed, guard };

pub fn apply(value: *f.compiler.library.Result, mode: Mode) !void {
    const allocator = value.arena.allocator();
    const types = try allocator.dupe(ir.Type, value.program.types);
    const functions = try allocator.dupe(ir.Function, value.program.functions);

    value.program.types = types;
    value.program.functions = functions;
    var changed: usize = 0;
    value.program.expressions = try expressions(allocator, types, value.program.expressions, mode, &changed);

    for (functions) |*function| {
        function.expressions = try expressions(allocator, types, function.expressions, mode, &changed);
    }

    try std.testing.expectEqual(@as(usize, 1), changed);
}

fn expressions(allocator: std.mem.Allocator, types: []ir.Type, original: []const ir.Expression, mode: Mode, changed: *usize) ![]const ir.Expression {
    const values = try allocator.dupe(ir.Expression, original);

    for (values) |*value| {
        if (mode == .guard) {
            if (value.value != .binary or value.value.binary.operator != .equal) continue;

            value.value.binary.operator = .not_equal;
            changed.* += 1;
        } else {
            if (value.value != .capture) continue;

            const slots = types[@intFromEnum(value.type_id)].tuple;
            const optional = types[@intFromEnum(slots[0])].optional;
            const errors = &types[@intFromEnum(optional)];

            try std.testing.expectEqual(@as(usize, 2), errors.error_set.len);

            errors.* = .{ .error_set = switch (mode) {
                .missing => &.{"AlphaFailure"},
                .extra => &.{ "AlphaFailure", "ExtraFailure", "ZetaFailure" },
                .renamed => &.{ "AlphaFailure", "OtherFailure" },
                .guard => unreachable,
            } };

            changed.* += 1;
        }
    }

    return values;
}

pub fn envelope(allocator: std.mem.Allocator, value: *const f.compiler.library.Result) ![]u8 {
    const payload = try std.json.Stringify.valueAlloc(allocator, .{
        .ir_version = value.program.version,
        .program = value.program,
        .exports = value.exports,
        .nominal_types = value.nominal_types,
        .store_initializers = value.store_initializers,
    }, .{});

    defer allocator.free(payload);

    var digest: [32]u8 = undefined;

    std.crypto.hash.sha2.Sha256.hash(payload, &digest, .{});

    return std.fmt.allocPrint(allocator, "zxc.library.v2\n{s}\n{s}", .{ std.fmt.bytesToHex(digest, .lower), payload });
}
