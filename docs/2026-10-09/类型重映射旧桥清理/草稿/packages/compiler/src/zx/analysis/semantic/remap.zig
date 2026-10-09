const std = @import("std");
const ir = @import("zx").ir;
const View = @import("remapping/view.zig");
pub const Mapping = View.Mapping;

pub fn value(allocator: std.mem.Allocator, types: ir.TypeTable, index: usize, mapping: Mapping) std.mem.Allocator.Error!ir.TypeValue {
    const source = types.at(index);
    var scalar: [2]u32 = undefined;

    const target = switch (source) {
        .tuple => |children| try allocator.alloc(u32, children.len),
        .object => |fields| try allocator.alloc(u32, fields.len),
        else => &scalar,
    };

    errdefer if (source == .tuple or source == .object) allocator.free(target);
    seed(source, mapping, target);

    return View.borrow(source, target);
}

fn seed(source: ir.Type, mapping: Mapping, target: []u32) void {
    switch (source) {
        .optional, .list => |id| target[0] = @backingInt(mapping.at(@backingInt(id))),
        .task => |task| {
            target[0] = @backingInt(mapping.at(@backingInt(task.result)));
            target[1] = @backingInt(mapping.at(@backingInt(task.errors)));
        },
        .tuple => |children| for (target, 0..) |*item, index| {
            item.* = @backingInt(mapping.at(@backingInt(children.at(index))));
        },
        .object => |fields| for (fields.types, target) |id, *item| {
            item.* = @backingInt(mapping.at(id));
        },
        .scalar, .enumeration, .error_set, .native_reference => {},
    }
}
