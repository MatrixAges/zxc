const std = @import("std");
const f = @import("fixture.zig");
const ir = f.compiler.ir;

pub const Mode = enum { missing, extra, renamed, guard };

pub fn apply(value: *f.compiler.library.Result, mode: Mode) !void {
    const allocator = value.arena.allocator();
    const functions = try allocator.dupe(ir.Function, value.program.functions);
    value.program.functions = functions;
    var changed: usize = 0;
    value.program.expressions = try expressions(allocator, &value.program.types, value.program.expressions, mode, &changed);

    for (functions) |*function| {
        function.expressions = try expressions(allocator, &value.program.types, function.expressions, mode, &changed);
    }

    try std.testing.expectEqual(@as(usize, 1), changed);
}

fn expressions(allocator: std.mem.Allocator, types: *ir.TypeTable, original: []const ir.Expression, mode: Mode, changed: *usize) ![]const ir.Expression {
    const values = try allocator.dupe(ir.Expression, original);

    for (values) |*value| {
        if (mode == .guard) {
            if (value.value != .binary or value.value.binary.operator != .equal) continue;

            value.value.binary.operator = .not_equal;
            changed.* += 1;
        } else {
            if (value.value != .capture) continue;

            const slots = types.get(value.type_id).tuple;
            const optional = types.get(slots.at(0)).optional;
            const errors = types.get(optional);

            try std.testing.expectEqual(@as(usize, 2), errors.error_set.len);

            try replaceErrors(allocator, types, optional, switch (mode) {
                .missing => &.{"AlphaFailure"},
                .extra => &.{ "AlphaFailure", "ExtraFailure", "ZetaFailure" },
                .renamed => &.{ "AlphaFailure", "OtherFailure" },
                .guard => unreachable,
            });

            changed.* += 1;
        }
    }

    return values;
}

fn replaceErrors(allocator: std.mem.Allocator, types: *ir.TypeTable, id: ir.TypeId, members: []const []const u8) !void {
    const index = @backingInt(id);
    const start = types.first[index];
    const count = types.second[index];
    const names = try allocator.alloc([]const u8, types.names.len - count + members.len);
    const first = try allocator.dupe(u32, types.first);
    const second = try allocator.dupe(u32, types.second);

    @memcpy(names[0..start], types.names[0..start]);
    @memcpy(names[start..][0..members.len], members);
    @memcpy(names[start + members.len ..], types.names[start + count ..]);

    for (index + 1..types.count()) |position| {
        const value = types.at(position);

        if (value == .error_set or value == .enumeration) first[position] = @intCast(first[position] - count + members.len);
    }

    second[index] = @intCast(members.len);
    types.first = first;
    types.second = second;
    types.names = names;
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
