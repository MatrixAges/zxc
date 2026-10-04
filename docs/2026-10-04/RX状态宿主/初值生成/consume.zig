const std = @import("std");

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const state_0 = try @import("initial_0").execute(init.arena, {});

    std.debug.print("{s}={s}\n", .{ "store.state.store.rx:counter", try std.json.Stringify.valueAlloc(allocator, state_0, .{}) });

    const state_1 = try @import("initial_1").execute(init.arena, {});

    std.debug.print("{s}={s}\n", .{ "store.state.store.rx:settings", try std.json.Stringify.valueAlloc(allocator, state_1, .{}) });

    const state_2 = try @import("initial_2").execute(init.arena, {});

    std.debug.print("{s}={s}\n", .{ "store.other.store.rx:counter", try std.json.Stringify.valueAlloc(allocator, state_2, .{}) });
}
