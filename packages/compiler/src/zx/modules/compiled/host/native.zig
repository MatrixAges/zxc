const std = @import("std");
const ir = @import("zx").ir;

pub fn copy(allocator: std.mem.Allocator, source: ir.NativeModule) std.mem.Allocator.Error!ir.NativeModule {
    const names = try strings(allocator, source.types.names);

    return .{
        .specifier = try allocator.dupe(u8, source.specifier),
        .identity = if (source.identity) |identity| try allocator.dupe(u8, identity) else null,
        .import_name = try allocator.dupe(u8, source.import_name),
        .type_namespace = try strings(allocator, source.type_namespace),
        .types = .{ .names = names, .type_ids = try allocator.dupe(u32, source.types.type_ids) },
    };
}

pub fn strings(allocator: std.mem.Allocator, source: []const []const u8) std.mem.Allocator.Error![]const []const u8 {
    const result = try allocator.alloc([]const u8, source.len);

    for (source, result) |text, *owned| owned.* = try allocator.dupe(u8, text);

    return result;
}
