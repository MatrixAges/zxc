pub const File = struct { path: []const u8, source: []const u8 };

pub const files = [_]File{
    .{ .path = "api.zig", .source = @embedFile("api.zig") },
};
