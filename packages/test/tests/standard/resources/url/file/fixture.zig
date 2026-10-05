const std = @import("std");
const url = @import("implementation").url;

const Case = struct {
    operation: enum { from_path, to_path, to_bytes },
    input: []const u8,
    windows: bool,
    cwd: []const u8 = "",
    expected: ?[]const u8 = null,
    @"error": ?[]const u8 = null,
};

pub fn check(source: []const u8) !void {
    const document = try std.json.parseFromSlice(Case, std.testing.allocator, source, .{});

    defer document.deinit();

    try verify(std.testing.allocator, document.value);
    try std.testing.checkAllAllocationFailures(std.testing.allocator, verify, .{document.value});
}

fn verify(allocator: std.mem.Allocator, case: Case) !void {
    const result = convert(allocator, case) catch |err| {
        if (err == error.OutOfMemory or case.@"error" == null) return err;

        return;
    };

    defer allocator.free(result);

    try std.testing.expect(case.@"error" == null);
    try std.testing.expectEqualSlices(u8, case.expected.?, result);
}

fn convert(allocator: std.mem.Allocator, case: Case) ![]const u8 {
    if (case.operation == .from_path) {
        return url.pathToFileUrl(allocator, case.input, case.windows, case.cwd);
    }

    var parsed = try url.parse(allocator, case.input, null);

    defer parsed.deinit();

    return switch (case.operation) {
        .to_path => url.fileUrlToPath(allocator, parsed.value, case.windows),
        .to_bytes => url.fileUrlToBytes(allocator, parsed.value, case.windows),
        .from_path => unreachable,
    };
}
