const std = @import("std");
const ir = @import("zx").ir;
const Slots = @import("slots.zig");
const Self = @This();

/// What every body analysis of a program reads and none writes: the list slots of each type, the list types each
/// function's output can hold, and the list types each function may write in place. They depend only on the types and
/// function bodies, so one basis serves the whole program and every entry body later analyzed against it.
slots: Slots,
holds: []const []const ir.TypeId,
mutates: []const []const ir.TypeId,
pub fn create(allocator: std.mem.Allocator, program: ir.Program) std.mem.Allocator.Error!Self {
    const slots = try Slots.init(allocator, program.types);
    const holds = try allocator.alloc([]const ir.TypeId, program.functions.count());
    // Functions share output types, so each type's lists are found once.
    const found = try allocator.alloc(?[]const ir.TypeId, program.types.count());

    defer allocator.free(found);

    @memset(found, null);

    for (holds, 0..) |*target, index| {
        const output = program.functions.at(index).output_type;
        const known = &found[@backingInt(output)];

        if (known.* == null) known.* = try lists(allocator, slots, output);

        target.* = known.*.?;
    }

    return .{ .slots = slots, .holds = holds, .mutates = try mutated(allocator, program) };
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

        for (function.expressions.kinds, 0..) |kind, expression| {
            if (function.expressions.callee(expression)) |callee| {
                try callees[index].append(allocator, callee);

                continue;
            }

            if (kind != .ListOperation and kind != .ListUpdate) continue;

            const target = switch (function.expressions.at(expression).value) {
                .list_operation => |operation| switch (operation.kind) {
                    .sort, .reverse, .pop => operation.target,
                    else => continue,
                },
                .list_update => |update| update.target,
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
