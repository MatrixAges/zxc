const std = @import("std");
const ir = @import("zx").ir;
const Flow = @import("flow.zig");
const Memo = @import("memo.zig");
const Slots = @import("slots.zig");
const Self = @This();

/// What every body analysis of a program reads and none writes: the list slots of each type, and which input slots
/// each function's output can hold and its updates may write in place. They depend only on the types and function
/// bodies, so one basis serves the whole program and every entry body later analyzed against it.
slots: Slots,
flow: Flow,
/// The content of each function body, hashed when `memo` keeps analyses across programs; empty otherwise.
contents: []const [32]u8 = &.{},
/// The digest of the type table, taken with `contents`.
types: [32]u8 = @splat(0),
pub fn create(allocator: std.mem.Allocator, program: ir.Program, memo: ?*Memo) std.mem.Allocator.Error!Self {
    const slots = try Slots.init(allocator, program.types);
    const kept = if (memo) |value| if (value.persistent) value else null else null;
    const contents = if (kept != null) try @import("identity.zig").contents(allocator, program) else &.{};
    const types: [32]u8 = if (kept != null) @import("identity.zig").types(program.types) else @splat(0);

    return .{ .slots = slots, .flow = try .create(allocator, program, slots, contents, types, kept), .contents = contents, .types = types };
}

pub fn lists(allocator: std.mem.Allocator, slots: Slots, type_id: ir.TypeId) std.mem.Allocator.Error![]const ir.TypeId {
    var result: std.ArrayList(ir.TypeId) = .empty;

    for (0..slots.count(type_id)) |slot| {
        const list = slots.listType(type_id, @intCast(slot));

        if (std.mem.indexOfScalar(ir.TypeId, result.items, list) == null) try result.append(allocator, list);
    }

    return result.items;
}

/// A splice from the front hands its removed prefix back in the target's buffer, retracting the frontier as a pop does.
pub fn prefix(expressions: ir.ExpressionTable, operation: anytype) bool {
    if (operation.kind != .splice) return false;

    const start = expressions.get(operation.arguments[0]).value;

    return start == .integer and start.integer == 0;
}
