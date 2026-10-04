const std = @import("std");
const ir = @import("zx").ir;
const Self = @This();

pub const Origin = union(enum) {
    source: []const u8,
    native: []const u8,
    external: struct { importer: []const u8, binding: []const u8, member: []const u8 },
};

pub const Item = struct { type_id: ir.TypeId, origin: Origin, name: []const u8 };

allocator: std.mem.Allocator,
items: std.ArrayList(Item) = .empty,
pub fn append(self: *Self, types: []const ir.Type, first: usize, origin: Origin) std.mem.Allocator.Error!void {
    for (types[first..], first..) |item, index| {
        if (item != .enumeration) continue;

        try self.items.append(self.allocator, .{
            .type_id = @enumFromInt(index),
            .origin = try self.copy(origin),
            .name = item.enumeration.name,
        });
    }
}

fn copy(self: *Self, origin: Origin) std.mem.Allocator.Error!Origin {
    return switch (origin) {
        .source => |path| .{ .source = try self.allocator.dupe(u8, path) },
        .native => |specifier| .{ .native = try self.allocator.dupe(u8, specifier) },
        .external => |entry| .{ .external = .{
            .importer = try self.allocator.dupe(u8, entry.importer),
            .binding = try self.allocator.dupe(u8, entry.binding),
            .member = try self.allocator.dupe(u8, entry.member),
        } },
    };
}

pub fn same(left: Origin, right: Origin) bool {
    if (std.meta.activeTag(left) != std.meta.activeTag(right)) return false;

    return switch (left) {
        .source => |path| std.mem.eql(u8, path, right.source),
        .native => |name| std.mem.eql(u8, name, right.native),
        .external => |entry| std.mem.eql(u8, entry.importer, right.external.importer) and std.mem.eql(u8, entry.binding, right.external.binding) and std.mem.eql(u8, entry.member, right.external.member),
    };
}

pub fn seed(self: *Self, types: []const ir.Type, values: []const Item) (std.mem.Allocator.Error || error{InvalidNominalTypes})!void {
    for (values, 0..) |item, index| {
        const id = @intFromEnum(item.type_id);

        if (id >= types.len or types[id] != .enumeration) return error.InvalidNominalTypes;
        if (!std.mem.eql(u8, types[id].enumeration.name, item.name)) return error.InvalidNominalTypes;

        for (values[0..index]) |previous| {
            if (previous.type_id == item.type_id) return error.InvalidNominalTypes;
            if (same(previous.origin, item.origin) and std.mem.eql(u8, previous.name, item.name)) return error.InvalidNominalTypes;
        }
    }

    for (values) |item| try self.items.append(self.allocator, .{
        .type_id = item.type_id,
        .origin = try self.copy(item.origin),
        .name = types[@intFromEnum(item.type_id)].enumeration.name,
    });
}
