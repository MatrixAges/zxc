pub const File = struct { path: []const u8, source: []const u8 };

pub const files = [_]File{
    .{ .path = "root.zig", .source = @embedFile("root.zig") },
    .{ .path = "api.zig", .source = @embedFile("api.zig") },
    .{ .path = "value.zig", .source = @embedFile("value.zig") },
    .{ .path = "read.zig", .source = @embedFile("read.zig") },
    .{ .path = "write.zig", .source = @embedFile("write.zig") },
};
