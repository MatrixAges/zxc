const std = @import("std");
const zx = @import("zx");
const Function = @import("../function.zig");
const Level = @import("../level.zig").Level;
const levels = @import("levels.zig");
const settlement = @import("generated_uniqueness_function_settlement");

pub fn settle(function: *Function, changed: *std.ArrayList(usize), passed: *std.ArrayList(Function.Contribution), values: []Level) std.mem.Allocator.Error!void {
    const Parameter = @typeInfo(@TypeOf(settlement.executeValue)).@"fn".param_types[1].?;
    const indirect = @typeInfo(Parameter) == .pointer;
    const Input = if (indirect) std.meta.Child(Parameter) else Parameter;
    var borrowed: levels.Borrowed = undefined;

    try borrowed.init(function);

    const input: Input = .{
        .context = if (@typeInfo(@FieldType(Input, "context")) == .pointer) &borrowed.descriptor else borrowed.context,
        .repeated = @ptrCast(function.order.repeated),
        .operations = @ptrCast(function.operations),
        .inputs = @ptrCast(&function.summaries.input),
        .deferred = function.deferred,
        .results = @ptrCast(function.order.results),
        .count = values.len,
    };

    const result = settlement.executeValue(function.allocator, if (indirect) &input else input) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => std.debug.panic("function settlement failed: {s}", .{@errorName(err)}),
    };

    function.evaluation = .{ .known = result.state.known, .carried = result.state.carried, .reads = result.state.reads };

    try levels.publish(function);
    try append(function, changed, passed, result);
    for (result.levels, values) |value, *target| target.* = levels.level(value);
}

fn append(function: *Function, changed: *std.ArrayList(usize), passed: *std.ArrayList(Function.Contribution), result: anytype) std.mem.Allocator.Error!void {
    comptime {
        std.debug.assert(@sizeOf(Level) == @sizeOf(u8));
        std.debug.assert(@alignOf(Level) == @alignOf(u8));
    }

    for (result.passed) |entry| {
        comptime std.debug.assert(@sizeOf(std.meta.Child(@TypeOf(entry.levels))) == @sizeOf(Level));

        for (entry.levels) |value| _ = levels.level(value);
        try passed.append(function.allocator, .{ .callee = entry.callee, .levels = @ptrCast(entry.levels) });
    }

    for (result.changed) |index| try changed.append(function.allocator, index);
}
