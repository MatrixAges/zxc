const std = @import("std");
const manifest = @import("../../package/manifest.zig");

pub fn format(allocator: std.mem.Allocator, source: []const u8) ![]u8 {
    const fields = try @import("../../package/manifest/layout.zig").collect(allocator, source);

    defer allocator.free(fields);

    const formatted = try @import("lint").configuration.yaml.format(allocator, source, fields);

    errdefer allocator.free(formatted);

    var original = try manifest.parse(allocator, source);

    defer original.deinit();

    var updated = try manifest.parse(allocator, formatted);

    defer updated.deinit();

    if (original.value != .data or updated.value != .data) return error.ConfigurationSemanticsChanged;

    const before = try std.json.Stringify.valueAlloc(allocator, original.value.data, .{});

    defer allocator.free(before);

    const after = try std.json.Stringify.valueAlloc(allocator, updated.value.data, .{});

    defer allocator.free(after);

    if (!std.mem.eql(u8, before, after)) return error.ConfigurationSemanticsChanged;

    return formatted;
}
