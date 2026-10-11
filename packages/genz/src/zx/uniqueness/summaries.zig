const std = @import("std");
const ir = @import("zx").ir;
const Level = @import("level.zig").Level;
const Slots = @import("slots.zig");
const Self = @This();

/// Per function: what every caller guarantees about each input list slot, what every return guarantees about each
/// output list slot, the list types the output can hold, and the list types the function may write in place.
/// `inputs` and `outputs` hold the properties some update downstream of each slot wants, so a growth copy pays off.
input: [][]Level,
output: [][]Level,
inputs: [][]Level,
outputs: [][]Level,
holds: [][]const ir.TypeId,
mutates: [][]const ir.TypeId,
pub fn create(allocator: std.mem.Allocator, program: ir.Program, slots: Slots) std.mem.Allocator.Error!Self {
    const count = program.functions.count();
    const input = try allocator.alloc([]Level, count);
    const output = try allocator.alloc([]Level, count);
    const holds = try allocator.alloc([]const ir.TypeId, count);
    const inputs = try allocator.alloc([]Level, count);
    const outputs = try allocator.alloc([]Level, count);

    for (0..count) |index| {
        const function = program.functions.at(index);

        input[index] = try allocator.alloc(Level, slots.count(function.input_type));
        output[index] = try allocator.alloc(Level, slots.count(function.output_type));

        @memset(input[index], if (function.external == null) .all else .none);
        @memset(output[index], if (function.external == null) .all else .none);

        holds[index] = try lists(allocator, slots, function.output_type);
        inputs[index] = try allocator.alloc(Level, input[index].len);
        outputs[index] = try allocator.alloc(Level, output[index].len);

        @memset(inputs[index], .none);
        @memset(outputs[index], .none);
    }

    return .{ .input = input, .output = output, .inputs = inputs, .outputs = outputs, .holds = holds, .mutates = try mutated(allocator, program) };
}

pub fn mayHold(self: Self, function: ir.FunctionId, list: ir.TypeId) bool {
    return std.mem.indexOfScalar(ir.TypeId, self.holds[@backingInt(function)], list) != null;
}

pub fn mayMutate(self: Self, function: ir.FunctionId, list: ir.TypeId) bool {
    return std.mem.indexOfScalar(ir.TypeId, self.mutates[@backingInt(function)], list) != null;
}

/// Optimistic facts for every body; inputs stay unknown unless every caller is a known call site.
pub fn reset(self: Self, program: ir.Program, known: []const bool) void {
    for (self.input, self.output, known, 0..) |input, output, callers, index| {
        const internal = program.functions.at(index).external == null;

        @memset(input, if (internal and callers) .all else .none);
        @memset(output, if (internal) .all else .none);
    }
}

pub fn clear(self: Self) void {
    for (self.input) |values| @memset(values, .none);
    for (self.output) |values| @memset(values, .none);
}

fn lists(allocator: std.mem.Allocator, slots: Slots, type_id: ir.TypeId) std.mem.Allocator.Error![]const ir.TypeId {
    var result: std.ArrayList(ir.TypeId) = .empty;

    for (0..slots.count(type_id)) |slot| {
        const list = slots.listType(type_id, @intCast(slot));

        if (std.mem.indexOfScalar(ir.TypeId, result.items, list) == null) try result.append(allocator, list);
    }

    return result.items;
}

/// List types written in place by a function's own updates or by any function it calls, closed over the call graph.
fn mutated(allocator: std.mem.Allocator, program: ir.Program) std.mem.Allocator.Error![][]const ir.TypeId {
    const count = program.functions.count();
    const own = try allocator.alloc(std.ArrayList(ir.TypeId), count);
    const callees = try allocator.alloc(std.ArrayList(ir.FunctionId), count);

    for (0..count) |index| {
        const function = program.functions.at(index);

        own[index] = .empty;
        callees[index] = .empty;

        for (0..function.expressions.count()) |expression| {
            const target = switch (function.expressions.get(@fromBackingInt(@intCast(expression))).value) {
                .list_operation => |operation| switch (operation.kind) {
                    .sort, .reverse, .pop => operation.target,
                    else => continue,
                },
                .list_update => |update| update.target,
                .call => |invocation| {
                    try callees[index].append(allocator, invocation.function);

                    continue;
                },
                else => continue,
            };
            const list = function.expressions.get(target).type_id;

            if (std.mem.indexOfScalar(ir.TypeId, own[index].items, list) == null) try own[index].append(allocator, list);
        }
    }

    var changed = true;

    while (changed) {
        changed = false;

        for (0..count) |index| for (callees[index].items) |callee| {
            for (own[@backingInt(callee)].items) |list| {
                if (std.mem.indexOfScalar(ir.TypeId, own[index].items, list) != null) continue;

                try own[index].append(allocator, list);
                changed = true;
            }
        };
    }

    const result = try allocator.alloc([]const ir.TypeId, count);

    for (own, result) |values, *target| target.* = values.items;

    return result;
}
