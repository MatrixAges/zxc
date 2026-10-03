const std = @import("std");
const plugins = @import("runtime").plugins;
const paths = @import("paths");
const Library = plugins.Library(paths.good);
const Input = struct { maybe: ?bool, values: []const i64, text: []const u8, count: u64 };

fn value() Input {
    return .{ .maybe = true, .values = &.{ std.math.minInt(i64), 0, std.math.maxInt(i64) }, .text = "文件🌱\x00\"\\", .count = std.math.maxInt(u64) };
}

test "plugin loads lazily and owns nested output across later calls" {
    try std.testing.expect(!Library.isLoaded());

    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const input = value();
    const first = try Library.invoke(Input, arena.allocator(), "echo", input);

    try std.testing.expect(Library.isLoaded());
    try std.testing.expectEqualDeep(input, first);
    try std.testing.expect(first.text.ptr != input.text.ptr);
    try std.testing.expect(first.values.ptr != input.values.ptr);

    const second_input = Input{ .maybe = null, .values = &.{}, .text = "changed", .count = 0 };
    const second = try Library.invoke(Input, arena.allocator(), "echo", second_input);

    try std.testing.expectEqualDeep(second_input, second);
    try std.testing.expectEqualDeep(input, first);
}

test "plugin checks method and schema before invocation" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    try std.testing.expectError(error.PluginMethodNotFound, Library.invoke(u64, arena.allocator(), "missing", @as(u32, 0)));
    try std.testing.expectError(error.PluginSchemaMismatch, Library.invoke(u64, arena.allocator(), "raw", @as(u64, 0)));
    try std.testing.expectError(error.PluginSchemaMismatch, Library.invoke(u32, arena.allocator(), "raw", @as(u32, 0)));
}

test "plugin concatenates output chunks and rejects exact protocol failures" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const allocator = arena.allocator();

    try std.testing.expectEqual(@as(u64, 12), try Library.invoke(u64, allocator, "raw", @as(u32, 0)));
    try std.testing.expectError(error.UnexpectedEndOfInput, Library.invoke(u64, allocator, "raw", @as(u32, 1)));
    try std.testing.expectError(error.InvalidPluginValue, Library.invoke(u64, allocator, "raw", @as(u32, 2)));
    try std.testing.expectError(error.PluginCallFailed, Library.invoke(u64, allocator, "raw", @as(u32, 3)));
    try std.testing.expectError(error.PluginOutputTooLarge, Library.invoke(u64, allocator, "raw", @as(u32, 4)));
    try std.testing.expectError(error.UnexpectedEndOfInput, Library.invoke(u64, allocator, "raw", @as(u32, 5)));
    try std.testing.expectError(error.PluginCallFailed, Library.invoke(u64, allocator, "raw", @as(u32, 6)));
    try std.testing.expectError(error.InvalidCharacter, Library.invoke(u64, allocator, "raw", @as(u32, 7)));
    try std.testing.expectError(error.Overflow, Library.invoke(u64, allocator, "raw", @as(u32, 8)));
    try std.testing.expectEqual(@as(u64, 9007199254740993), try Library.invoke(u64, allocator, "raw", @as(u32, 9)));
}

test "plugin rejects incompatible descriptors and retains failure" {
    inline for (.{
        .{ paths.version, error.PluginAbiMismatch },
        .{ paths.size, error.PluginAbiMismatch },
        .{ paths.flags, error.PluginCapabilitiesMismatch },
        .{ paths.empty, error.PluginMethodTableInvalid },
        .{ paths.large, error.PluginMethodTableInvalid },
        .{ paths.duplicate, error.PluginMethodTableInvalid },
        .{ paths.empty_name, error.PluginMethodTableInvalid },
        .{ paths.no_entry, error.PluginEntryNotFound },
    }) |case| {
        const Invalid = plugins.Library(case[0]);

        try std.testing.expect(!Invalid.isLoaded());
        try std.testing.expectError(case[1], Invalid.invoke(u64, std.testing.allocator, "raw", @as(u32, 0)));
        try std.testing.expect(!Invalid.isLoaded());
        try std.testing.expectError(case[1], Invalid.invoke(u64, std.testing.allocator, "raw", @as(u32, 0)));
    }
}

test "plugin host allocation failures release arena allocations" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, checkAllocation, .{});
}

fn checkAllocation(allocator: std.mem.Allocator) !void {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const output = try Library.invoke(Input, arena.allocator(), "echo", value());

    try std.testing.expectEqualDeep(value(), output);
}
