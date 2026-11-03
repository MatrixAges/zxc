const std = @import("std");
const Level = @import("../level.zig").Level;
const generated = @import("generated_uniqueness_level");
const predicate = @import("generated_uniqueness_level_lacks");
const Input = @typeInfo(@TypeOf(generated.executeValue)).@"fn".param_types[1].?;
const Value = @FieldType(Input, "left");
const states = 1 << @bitSizeOf(Level);
pub const join = binary("Join");
pub const meet = binary("Meet");
pub const lacks = missing();
pub const materialized = copies();
pub const written = writes();

pub fn constant(comptime operation: []const u8) Level {
    return evaluate(operation, @bitCast(@as(u3, 0)), @bitCast(@as(u3, 0)), false);
}

fn source(comptime T: type, value: Level) T {
    return .{ .headered = value.headered, .unique = value.unique, .deferred = value.deferred };
}

fn evaluate(comptime operation: []const u8, left: Level, right: Level, linear: bool) Level {
    var memory = std.heap.FixedBufferAllocator.init(&.{});
    const input = Input{ .operation = @field(@FieldType(Input, "operation"), operation), .left = source(Value, left), .right = source(Value, right), .linear = linear };
    const value = generated.executeValue(memory.allocator(), input) catch |err| @compileError(@errorName(err));

    return .{ .headered = value.headered, .unique = value.unique, .deferred = value.deferred };
}

fn binary(comptime operation: []const u8) [states][states]Level {
    @setEvalBranchQuota(1000000);

    var values: [states][states]Level = undefined;

    for (&values, 0..) |*row, left| for (row, 0..) |*value, right| {
        value.* = evaluate(operation, @bitCast(@as(u3, @intCast(left))), @bitCast(@as(u3, @intCast(right))), false);
    };

    return values;
}

fn missing() [states][states]bool {
    @setEvalBranchQuota(1000000);

    var values: [states][states]bool = undefined;

    for (&values, 0..) |*row, left| for (row, 0..) |*value, right| {
        const Raw = std.meta.Child(@FieldType(std.meta.Child(predicate.Input), "left"));
        const a = source(Raw, @bitCast(@as(u3, @intCast(left))));
        const b = source(Raw, @bitCast(@as(u3, @intCast(right))));
        var memory = std.heap.FixedBufferAllocator.init(&.{});
        value.* = predicate.executeIn(memory.allocator(), &.{ .left = &a, .right = &b }) catch |err| @compileError(@errorName(err));
    };

    return values;
}

fn copies() [states][2][2]Level {
    @setEvalBranchQuota(1000000);

    var values: [states][2][2]Level = undefined;

    for (&values, 0..) |*row, left| for (row, 0..) |*options, unique| for (options, 0..) |*value, linear| {
        value.* = evaluate("Materialized", @bitCast(@as(u3, @intCast(left))), .{ .headered = false, .unique = unique != 0 }, linear != 0);
    };

    return values;
}

fn writes() [states]Level {
    @setEvalBranchQuota(1000000);

    var values: [states]Level = undefined;

    for (&values, 0..) |*value, left| value.* = evaluate("Written", @bitCast(@as(u3, @intCast(left))), @bitCast(@as(u3, 0)), false);

    return values;
}
