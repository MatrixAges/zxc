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
