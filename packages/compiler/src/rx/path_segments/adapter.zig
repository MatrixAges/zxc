const std = @import("std");
const generated = @import("generated_paths");

pub fn normalize(allocator: std.mem.Allocator, path: []const u8) error{ InvalidPath, OutOfMemory }![]const u8 {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const result = generated.execute(&arena, path) catch |err| switch (err) {
        error.OutOfMemory, error.Overflow => return error.OutOfMemory,
    };

    if (!result.valid) return error.InvalidPath;

    var length: usize = if (result.segments.len == 0) 0 else result.segments.len - 1;

    for (result.segments) |segment| length += @intCast(segment.end - segment.start);

    const output = try allocator.alloc(u8, length);
    var offset: usize = 0;

    for (result.segments, 0..) |segment, index| {
        if (index != 0) {
            output[offset] = '/';
            offset += 1;
        }

        const source = path[@intCast(segment.start)..@intCast(segment.end)];

        @memcpy(output[offset..][0..source.len], source);

        offset += source.len;
    }

    return output;
}
