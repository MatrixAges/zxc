const std = @import("std");
const ir = @import("zx").ir;
const Self = @This();
const data = @import("nominal_data");
pub const Origin = data.Origin;
pub const Item = data.Item;
pub const Table = data.Table;
pub const Storage = data.Storage;

allocator: std.mem.Allocator,
items: Storage = .{},
pub fn append(self: *Self, types: ir.TypeTable, first: usize, origin: Origin) std.mem.Allocator.Error!void {
    try @import("../analysis/semantic/produce.zig").append(self.allocator, &self.items, types, first, origin);
}

pub fn same(left: Origin, right: Origin) bool {
    if (std.meta.activeTag(left) != std.meta.activeTag(right)) return false;

    return switch (left) {
        .source => |path| std.mem.eql(u8, path, right.source),
        .native => |name| std.mem.eql(u8, name, right.native),
        .external => |entry| std.mem.eql(u8, entry.module, right.external.module) and std.mem.eql(u8, entry.member, right.external.member),
    };
}

pub fn seed(self: *Self, types: ir.TypeTable, values: Table) (std.mem.Allocator.Error || error{InvalidNominalTypes})!void {
    if (!try @import("../analysis/semantic/origins.zig").valid(types, values)) return error.InvalidNominalTypes;

    for (0..values.count()) |index| {
        const item = values.at(index);

        try self.items.append(self.allocator, .{
            .type_id = item.type_id,
            .origin = try data.copy(self.allocator, item.origin),
            .name = types.at(@backingInt(item.type_id)).nominalName().?,
        });
    }
}
