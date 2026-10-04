const std = @import("std");
const identity = @import("identity");
const alias = @import("alias");
const workflow = @import("workflow");
const toggle = @import("toggle");
const types = @import("types");

test "published ZX RX and same-source public aliases execute independently" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();

    for ([_]u8{ 0, 1, 127, 255 }) |value| {
        try std.testing.expectEqual(value, try identity.execute(&arena, value));
        try std.testing.expectEqual(value, try alias.execute(&arena, value));
        try std.testing.expectEqual(value, try workflow.execute(&arena, value));
    }
}

test "published separate boolean module keeps its own public signature" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();

    try std.testing.expectEqual(true, try toggle.execute(&arena, false));
    try std.testing.expectEqual(false, try toggle.execute(&arena, true));
}

test "published type-only module exposes interface without execution entry" {
    const payload: std.meta.Child(types.Payload) = .{ .value = 255, .enabled = true };

    try std.testing.expectEqual(@as(u8, 255), payload.value);
    try std.testing.expect(payload.enabled);
    try std.testing.expect(!@hasDecl(types, "execute"));
}
