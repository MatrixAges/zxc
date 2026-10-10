const std = @import("std");
const f = @import("fixture.zig");
const check = @import("check.zig");

test "empty dynamic payload preserves scalar zero and checked imports" {
    try check.run(.{ .depth = 0, .width = 0 });
}

test "wide object frontier retains repeated references and source field order" {
    for ([_]usize{ 1, 17, 65 }) |width| try check.run(.{ .depth = 17, .width = width });
}

test "shared dependency chains preserve optional list tuple and object transitions" {
    for ([_]usize{ 1, 2, 3, 4, 17, 65, 129, 255 }) |depth| try check.run(.{ .depth = depth, .width = 1 });
}

test "mixed dependency frontiers preserve distinct growth boundaries" {
    for ([_]usize{ 0, 1, 17, 65 }) |depth| {
        for ([_]usize{ 0, 1, 17, 65 }) |width| try check.run(.{ .depth = depth, .width = width });
    }
}

test "extracted graph remains owned after both source and analysis arenas are released" {
    try check.detached(.{ .depth = 65, .width = 65 });
}

test "releasing one extracted graph preserves the second independent result" {
    try check.independent(.{ .depth = 17, .width = 65 });
}

test "module dependency depth limit remains explicit before graph extraction" {
    var sources = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer sources.deinit();

    var result = try f.compiler.project.analyze(std.testing.allocator, try @import("source.zig").create(sources.allocator(), .{ .depth = 257, .width = 1 }), .{ .entry = "main.zx", .root_dir = "/project" });

    defer result.deinit();

    try std.testing.expect(result.value == .diagnostic);
    try std.testing.expectEqual(.module, result.value.diagnostic.code);
    try std.testing.expectEqualStrings("module dependency depth exceeds 256", result.value.diagnostic.message);
    try std.testing.expectEqual(@as(usize, 0), result.value.diagnostic.span.start);
    try std.testing.expectEqual(@as(usize, 0), result.value.diagnostic.span.end);
}
