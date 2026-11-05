const std = @import("std");
const ir = @import("zx").ir;
const Plan = @import("../topology.zig").Plan;
const Calls = @import("../topology.zig").Calls;

pub fn collect(allocator: std.mem.Allocator, program: ir.Program) std.mem.Allocator.Error!Calls {
    const count = program.functions.count();
    const called = try allocator.alloc([]const u32, count + 1);
    const recursive = try allocator.alloc(bool, count + 1);

    for (called[0..count], 0..) |*row, index| {
        row.* = if (program.functions.native_modules[index] == null)
            try callees(allocator, program.functions.expressions[index].*)

        else
            &.{};
    }

    called[count] = if (program.type_only) &.{} else try callees(allocator, program.expressions);

    for (called, recursive, 0..) |row, *self_call, caller| {
        self_call.* = std.mem.indexOfScalar(u32, row, @intCast(caller)) != null;
    }

    return .{ .callees = called, .recursive = recursive };
}

pub fn build(allocator: std.mem.Allocator, called: []const []const u32, exported: []const ir.FunctionId) std.mem.Allocator.Error!Plan {
    const callers = try allocator.alloc(std.ArrayList(u64), called.len);
    const reverse = try allocator.alloc([]const u64, called.len);
    const known = try allocator.alloc(bool, called.len);

    for (callers) |*row| row.* = .empty;
    for (called, 0..) |row, caller| for (row) |callee| try callers[callee].append(allocator, caller);

    for (callers, reverse, known) |row, *view, *reached| {
        view.* = row.items;
        reached.* = row.items.len != 0;
    }

    for (exported) |id| known[@backingInt(id)] = false;

    return .{ .callers = reverse, .known = known };
}

pub fn callees(allocator: std.mem.Allocator, expressions: ir.ExpressionTable) std.mem.Allocator.Error![]const u32 {
    var result: std.ArrayList(u32) = .empty;

    for (0..expressions.count()) |index| {
        const function = @backingInt(expressions.callee(index) orelse continue);

        if (std.mem.indexOfScalar(u32, result.items, function) == null) try result.append(allocator, function);
    }

    return result.items;
}
