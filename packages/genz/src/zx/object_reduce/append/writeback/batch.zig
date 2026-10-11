const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../../../node.zig");
const Lower = @import("../../../lower.zig");
const aggregate = @import("../../../aggregate.zig");
pub const Change = struct { path: []const u32, value: node.ExpressionId, started: node.ExpressionId };

const Result = struct { value: node.ExpressionId, started: ?node.ExpressionId };

pub fn apply(lowering: *Lower, body: *std.ArrayList(node.Statement), type_id: ir.TypeId, state: node.ExpressionId, changes: []const Change) Lower.Error!void {
    if (changes.len == 0) return;

    const result = try layout(lowering, body, type_id, state, changes);

    try body.append(lowering.allocator, .{ .branch = .{
        .condition = result.started.?,
        .yes = try lowering.builder.statements(&.{.{ .assignment = .{ .target = state, .value = result.value } }}),
        .no = .{},
    } });
}

fn layout(lowering: *Lower, body: *std.ArrayList(node.Statement), type_id: ir.TypeId, source: node.ExpressionId, changes: []const Change) Lower.Error!Result {
    if (changes[0].path.len == 0) {
        std.debug.assert(changes.len == 1);

        return .{ .value = changes[0].value, .started = changes[0].started };
    }

    var started: ?node.ExpressionId = null;

    const value = switch (lowering.program.typeOf(type_id)) {
        .object => |fields| blk: {
            const values = try lowering.allocator.alloc(node.Field, fields.len);

            for (values, 0..) |*output, index| {
                const field = fields.at(index);
                const existing = try lowering.field(source, field.name);
                const result = try child(lowering, body, field.type_id, existing, changes, index);
                output.* = .{ .name = field.name, .value = result.value };
                started = try combine(lowering, started, result.started);
            }

            break :blk try lowering.builder.expression(.{ .object = .{ .type_expr = lowering.layouts[@backingInt(type_id)], .fields = values } });
        },
        .tuple => |items| blk: {
            const values = try lowering.allocator.alloc(node.ExpressionId, items.len);

            for (values, 0..) |*output, index| {
                const existing = try lowering.field(source, try std.fmt.allocPrint(lowering.allocator, "{d}", .{index}));
                const result = try child(lowering, body, items.at(index), existing, changes, index);
                output.* = result.value;
                started = try combine(lowering, started, result.started);
            }

            break :blk try @import("../../../state_value/origin.zig").tuple(lowering, type_id, try lowering.builder.expression(.{ .tuple = values }));
        },
        else => unreachable,
    };

    return .{ .value = value, .started = try aggregate.bind(lowering, body, started.?) };
}

fn child(lowering: *Lower, body: *std.ArrayList(node.Statement), type_id: ir.TypeId, source: node.ExpressionId, changes: []const Change, index: usize) Lower.Error!Result {
    var selected: std.ArrayList(Change) = .empty;

    for (changes) |change| {
        if (change.path[0] != index) continue;
        try selected.append(lowering.allocator, .{ .path = change.path[1..], .value = change.value, .started = change.started });
    }

    if (selected.items.len == 0) return .{ .value = source, .started = null };

    const result = try layout(lowering, body, type_id, source, selected.items);
    const value = if (selected.items[0].path.len == 0) result.value else try lowering.construct(type_id, result.value);
    const chosen = try lowering.builder.expression(.{ .conditional = .{ .condition = result.started.?, .yes = value, .no = source } });

    return .{ .value = try aggregate.bind(lowering, body, chosen), .started = result.started };
}

fn combine(lowering: *Lower, left: ?node.ExpressionId, right: ?node.ExpressionId) Lower.Error!?node.ExpressionId {
    const next = right orelse return left;
    const previous = left orelse return next;

    return try lowering.builder.expression(.{ .binary = .{ .operator = .logical_or, .left = previous, .right = next } });
}
