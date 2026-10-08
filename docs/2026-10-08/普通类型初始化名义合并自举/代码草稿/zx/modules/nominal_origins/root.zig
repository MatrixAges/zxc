const std = @import("std");
pub const Origin = @import("model.zig").Origin;
pub const Item = @import("model.zig").Item;
pub const Table = @import("table.zig");
pub const Storage = @import("storage.zig");

pub fn copy(allocator: std.mem.Allocator, origin: Origin) std.mem.Allocator.Error!Origin {
    return switch (origin) {
        .source => |path| .{ .source = try allocator.dupe(u8, path) },
        .native => |specifier| .{ .native = try allocator.dupe(u8, specifier) },
        .external => |entry| external: {
            const module = try allocator.dupe(u8, entry.module);

            errdefer allocator.free(module);

            break :external .{ .external = .{
                .module = module,
                .member = try allocator.dupe(u8, entry.member),
            } };
        },
    };
}
