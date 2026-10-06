const std = @import("std");
const rx = @import("rx");
const native = @import("native");
const Row = struct { paths: []const []const u8, owner: ?usize, reference: ?[]const u8 };
const Outcome = union(enum) { path: []const u8, failure: error{ InvalidPath, OutOfMemory } };

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);
    const source = try std.Io.Dir.cwd().readFileAlloc(init.io, args[1], allocator, .unlimited);
    var lines = std.mem.splitScalar(u8, source, '\n');
    var paths: usize = 0;
    var references: usize = 0;

    while (lines.next()) |line| {
        if (line.len == 0) continue;

        const row = try std.json.parseFromSliceLeaky(Row, allocator, line, .{ .ignore_unknown_fields = true });

        for (row.paths) |path| {
            const expected: Outcome = if (native.normalizeModulePath(allocator, path)) |value| .{ .path = value } else |err| .{ .failure = err };
            const actual: Outcome = if (rx.normalizeModulePath(allocator, path)) |value| .{ .path = value } else |err| .{ .failure = err };

            try compare(expected, actual);

            paths += 1;
        }

        if (row.reference) |reference| {
            const owner = row.paths[row.owner.?];
            const expected: Outcome = if (native.resolveModulePath(allocator, owner, reference)) |value| .{ .path = value } else |err| .{ .failure = err };
            const actual: Outcome = if (rx.resolveModulePath(allocator, owner, reference)) |value| .{ .path = value } else |err| .{ .failure = err };

            try compare(expected, actual);

            references += 1;
        }
    }

    var buffer: [4096]u8 = undefined;
    var output = std.Io.File.Writer.initStreaming(.stdout(), init.io, &buffer);

    try std.json.Stringify.value(.{ .paths = paths, .references = references, .failures = 0 }, .{}, &output.interface);
    try output.interface.writeByte('\n');
    try output.interface.flush();
}

fn compare(expected: Outcome, actual: Outcome) !void {
    switch (expected) {
        .failure => |err| if (actual != .failure or err != actual.failure) return error.PathDiagnosticMismatch,
        .path => |path| if (actual != .path or !std.mem.eql(u8, path, actual.path)) return error.PathValueMismatch,
    }
}
