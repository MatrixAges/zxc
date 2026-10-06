const std = @import("std");
const ir = @import("zx").ir;
const Self = @This();
pub const Origin = @import("nominal_origins/model.zig").Origin;
pub const Item = @import("nominal_origins/model.zig").Item;
pub const Table = @import("nominal_origins/table.zig");
pub const Storage = @import("nominal_origins/storage.zig");

allocator: std.mem.Allocator,
items: Storage = .{},
pub fn append(self: *Self, types: ir.TypeTable, first: usize, origin: Origin) std.mem.Allocator.Error!void {
    for (first..types.count()) |index| {
        const item = types.at(index);
        const name = item.nominalName() orelse continue;

        try self.items.append(self.allocator, .{
            .type_id = @fromBackingInt(@intCast(index)),
            .origin = try self.copy(origin),
            .name = name,
        });
    }
}

fn copy(self: *Self, origin: Origin) std.mem.Allocator.Error!Origin {
    return switch (origin) {
        .source => |path| .{ .source = try self.allocator.dupe(u8, path) },
        .native => |specifier| .{ .native = try self.allocator.dupe(u8, specifier) },
        .external => |entry| .{ .external = .{
            .module = try self.allocator.dupe(u8, entry.module),
            .member = try self.allocator.dupe(u8, entry.member),
        } },
    };
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
            .origin = try self.copy(item.origin),
            .name = types.at(@backingInt(item.type_id)).nominalName().?,
        });
    }
}
