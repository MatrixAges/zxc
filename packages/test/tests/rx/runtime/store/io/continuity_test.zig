const std = @import("std");
const State = @import("zxc_state");
const application = @import("application");
const f = @import("fixture");
const execute = @import("execute.zig");

fn continuity(allocator: std.mem.Allocator) !void {
    var fixture = try f.init();

    defer fixture.deinit();

    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    var state = State{ .arena = &arena };

    defer state.deinit();

    try state.initialize();
    try fixture.write("after", "ok");

    const original = state.value_0;
    const input = try execute.input(&fixture, "data", "after");
    const texts = [_][]const u8{ "first", "", "你好 🌿\x00" };
    var outputs: [texts.len]application.Output = undefined;

    for (texts, &outputs) |text, *output| {
        try fixture.write("data", text);

        output.* = try execute.run(&state, &input, f.io);
    }

    for (texts, outputs, 0..) |text, output, index| {
        try std.testing.expectEqualStrings(text, output.text);
        try std.testing.expectEqual(@as(u64, index + 1), output.count);
    }

    try std.testing.expectEqualStrings("initial", original.text);
    try std.testing.expectEqual(@as(u64, 0), original.count);
    try std.testing.expectEqualStrings(texts[2], state.value_0.text);
    try std.testing.expectEqual(@as(u64, 3), state.value_0.count);
}

test "Store IO State initializes without a host IO argument" {
    var arena = std.heap.ArenaAllocator.init(f.allocator);

    defer arena.deinit();

    var state = State{ .arena = &arena };

    defer state.deinit();

    try state.initialize();

    var request = state.request();

    defer request.deinit();

    try std.testing.expectEqualStrings("initial", state.value_0.text);
    try std.testing.expectEqual(@as(u64, 0), state.value_0.count);
}

test "Store IO Request retains file strings and outputs after request destruction" {
    try continuity(f.allocator);
}

test "Store IO Request continuity cleans every failed allocation" {
    try std.testing.checkAllAllocationFailures(f.allocator, continuity, .{});
}

test "Store IO State releases all retained file buffers on destruction" {
    var debug: std.heap.DebugAllocator(.{ .enable_memory_limit = true }) = .init;

    defer std.testing.expectEqual(.ok, debug.deinit()) catch @panic("leak");

    try continuity(debug.allocator());
    try std.testing.expectEqual(@as(usize, 0), debug.total_requested_bytes);
}

test "Store IO Request finite write sequence retains the first published file" {
    var fixture = try f.init();

    defer fixture.deinit();

    var arena = std.heap.ArenaAllocator.init(f.allocator);

    defer arena.deinit();

    var state = State{ .arena = &arena };

    defer state.deinit();

    try state.initialize();
    try fixture.write("data", "first");

    const input = try execute.input(&fixture, "data", "data");
    const first = try execute.run(&state, &input, f.io);

    for (0..32) |index| {
        const text = try std.fmt.allocPrint(fixture.arena.allocator(), "value-{d}", .{index});

        try fixture.write("data", text);

        const output = try execute.run(&state, &input, f.io);

        try std.testing.expectEqualStrings(text, output.text);
        try std.testing.expectEqual(@as(u64, index + 2), output.count);
    }

    try std.testing.expectEqualStrings("first", first.text);
    try std.testing.expectEqual(@as(u64, 1), first.count);
}

test "Store IO Request does not publish into another live State" {
    var fixture = try f.init();

    defer fixture.deinit();

    var arena = std.heap.ArenaAllocator.init(f.allocator);

    defer arena.deinit();

    var other_arena = std.heap.ArenaAllocator.init(f.allocator);

    defer other_arena.deinit();

    var state = State{ .arena = &arena };
    var other = State{ .arena = &other_arena };

    defer state.deinit();
    defer other.deinit();

    try state.initialize();
    try other.initialize();
    try fixture.write("data", "changed");

    const input = try execute.input(&fixture, "data", "data");

    _ = try execute.run(&state, &input, f.io);

    try std.testing.expectEqualStrings("changed", state.value_0.text);
    try std.testing.expectEqualStrings("initial", other.value_0.text);
    try std.testing.expectEqual(@as(u64, 0), other.value_0.count);
}
