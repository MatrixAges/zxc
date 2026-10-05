pub const File = @import("napi_resources").File;

pub const files = [_]File{
    .{ .path = "context.zig", .source = @embedFile("context.zig") },
    .{ .path = "task.zig", .source = @embedFile("task.zig") },
    .{ .path = "enqueue.zig", .source = @embedFile("enqueue.zig") },
};
