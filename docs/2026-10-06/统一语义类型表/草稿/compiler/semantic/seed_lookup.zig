const std = @import("std");
const ir = @import("zx").ir;
const Value = @import("lookup.zig").Value;

pub fn find(table: ir.TypeTable, value: Value) ?ir.TypeId {
    for (0..table.count()) |index| {
        const item = table.at(index);

        const matches = switch (value) {
            .scalar => |scalar| item == .scalar and item.scalar == scalar,
            .enumeration, .native_reference => false,
            .object => |fields| item == .object and equalFields(item.object, fields),
            .optional => |child| item == .optional and item.optional == child,
            .list => |child| item == .list and item.list == child,
            .task => |task| item == .task and item.task.result == task.result and item.task.errors == task.errors,
            .tuple => |children| item == .tuple and equalChildren(item.tuple, children),
            .error_set => |names| item == .error_set and equalNames(item.error_set, names),
        };

        if (matches) return @fromBackingInt(@intCast(index));
    }

    return null;
}

fn equalChildren(left: ir.TypeIds, right: []const ir.TypeId) bool {
    if (left.len != right.len) return false;

    for (right, 0..) |child, index| {
        if (left.at(index) != child) return false;
    }

    return true;
}

fn equalNames(left: []const []const u8, right: []const []const u8) bool {
    if (left.len != right.len) return false;

    for (left, right) |a, b| {
        if (!std.mem.eql(u8, a, b)) return false;
    }

    return true;
}

fn equalFields(left: ir.TypeFields, right: ir.TypeFields) bool {
    return std.mem.eql(u32, left.types, right.types) and equalNames(left.names, right.names);
}
