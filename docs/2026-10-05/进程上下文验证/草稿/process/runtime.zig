const std = @import("std");
const program = @import("program");
const options = @import("options");
const f = @import("fixture.zig");

fn invoke(arena: *std.heap.ArenaAllocator, key: []const u8, io: std.Io, process: std.process.Init.Minimal) !program.Output {
    if (comptime options.io and options.process) return program.execute(arena, key, io, process);
    if (comptime options.io) return program.execute(arena, key, io);
    if (comptime options.process) return program.execute(arena, key, process);

    return program.execute(arena, key);
}

fn check(allocator: std.mem.Allocator, key: []const u8, expected: ?[]const u8) !void {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const process = try f.context(&.{ "host-name", "", "参数 🌿" }, &.{ "KEY=first", "EMPTY=" });
    var path: f.Path = .{};
    var vtable: std.Io.VTable = undefined;
    const output = try invoke(&arena, key, path.io(&vtable), process);

    try std.testing.expectEqual(@as(usize, if (options.io) 1 else 0), path.calls);
    try std.testing.expectEqualStrings(if (options.io) path.value else if (options.process) "no-io" else "pure", output.cwd);
    try std.testing.expectEqual(@as(usize, if (options.process) 3 else 0), output.argv.len);

    if (options.process) {
        try std.testing.expectEqualStrings("host-name", output.argv[0]);
        try std.testing.expectEqualStrings("", output.argv[1]);
        try std.testing.expectEqualStrings("参数 🌿", output.argv[2]);
    }

    if (options.process and expected != null) {
        try std.testing.expectEqualStrings(expected.?, output.env.?);
    } else try std.testing.expect(output.env == null);
}

test "generated process and IO metadata match independent capability requirements" {
    try std.testing.expectEqual(options.io, program.requires_io);
    try std.testing.expectEqual(options.process, program.requires_process);
}

test "generated capability signature forwards controlled host data" {
    try check(f.allocator, "KEY", "first");
}

test "generated getEnv preserves an empty value" {
    try check(f.allocator, "EMPTY", "");
}

test "generated getEnv preserves a missing value" {
    try check(f.allocator, "MISSING", null);
}

test "generated capability chain releases allocation failures" {
    try std.testing.checkAllAllocationFailures(f.allocator, check, .{ @as([]const u8, "KEY"), @as(?[]const u8, "first") });
}

test "generated IO failures remain scoped to IO dependent entries" {
    var arena = std.heap.ArenaAllocator.init(f.allocator);

    defer arena.deinit();

    var path: f.Path = .{ .failure = true };
    var vtable: std.Io.VTable = undefined;
    const process = try f.context(&.{}, &.{});
    const result = invoke(&arena, "KEY", path.io(&vtable), process);

    if (options.io) {
        try std.testing.expectError(error.Canceled, result);
    } else _ = try result;
}

test "generated input key is validated only by process dependent entries" {
    var arena = std.heap.ArenaAllocator.init(f.allocator);

    defer arena.deinit();

    var path: f.Path = .{};
    var vtable: std.Io.VTable = undefined;
    const process = try f.context(&.{}, &.{});
    const result = invoke(&arena, "BAD=KEY", path.io(&vtable), process);

    if (options.process) {
        try std.testing.expectError(error.InvalidEnvironmentKey, result);
    } else _ = try result;
}

test "generated entry switches context without altering prior results" {
    var arena = std.heap.ArenaAllocator.init(f.allocator);

    defer arena.deinit();

    var path: f.Path = .{ .value = "/first" };
    var vtable: std.Io.VTable = undefined;
    const first = try invoke(&arena, "KEY", path.io(&vtable), try f.context(&.{"first"}, &.{"KEY=one"}));

    path.value = "/second";

    const second = try invoke(&arena, "KEY", path.io(&vtable), try f.context(&.{"second"}, &.{"KEY=two"}));

    if (options.process) {
        try std.testing.expectEqualStrings("first", first.argv[0]);
        try std.testing.expectEqualStrings("one", first.env.?);
        try std.testing.expectEqualStrings("second", second.argv[0]);
        try std.testing.expectEqualStrings("two", second.env.?);
    }

    if (options.io) {
        try std.testing.expectEqualStrings("/first", first.cwd);
        try std.testing.expectEqualStrings("/second", second.cwd);
    }
}
