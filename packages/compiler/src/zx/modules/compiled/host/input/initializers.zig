const std = @import("std");
const Initializer = @import("../../../compiled.zig").StoreInitializer;

pub fn columns(comptime Target: type, allocator: std.mem.Allocator, initializers: []const Initializer) std.mem.Allocator.Error!Target {
    const identities = try allocator.alloc([]const u8, initializers.len);
    const versions = try allocator.alloc(u32, initializers.len);
    const functions = try allocator.alloc(u32, initializers.len);

    for (initializers, 0..) |item, index| {
        identities[index] = item.identity;
        versions[index] = item.schema_version;
        functions[index] = @backingInt(item.function);
    }

    return .{ .identities = identities, .versions = versions, .functions = functions };
}
