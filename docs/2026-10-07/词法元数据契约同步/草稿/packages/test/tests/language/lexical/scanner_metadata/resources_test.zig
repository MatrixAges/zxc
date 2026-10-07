const std = @import("std");
const f = @import("fixture.zig");
const allocation_testing = @import("allocation_testing");
const templates = @import("templates.zig");

fn run(allocator: std.mem.Allocator, source: []const u8, valid: bool) !void {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const original = try f.scanner.execute(&arena, source);
    const recovered = try f.scanner.execute(&arena, "return");

    try std.testing.expectEqualStrings("", recovered.diagnostic.message);
    try std.testing.expectEqual(@as(usize, 2), recovered.tokens.len);
    try f.expectToken(recovered.tokens[0], .{ .text = "return", .kind = "Keyword", .word = "Return" }, 0, false);
    try f.expectToken(recovered.tokens[1], .{ .text = "", .kind = "Eof" }, 6, false);

    if (valid) {
        try std.testing.expectEqualStrings("", original.diagnostic.message);
        try std.testing.expectEqual(@as(usize, 2), original.tokens.len);
        try f.expectToken(original.tokens[0], .{ .text = source, .kind = "Template" }, 0, false);
        try f.expectToken(original.tokens[1], .{ .text = "", .kind = "Eof" }, source.len, false);
    } else {
        try std.testing.expectEqualStrings("lexical", original.diagnostic.code);
        try std.testing.expectEqualStrings("unterminated comment in template", original.diagnostic.message);
        try std.testing.expectEqual(@as(usize, 0), original.tokens.len);
        try std.testing.expectEqual(@as(usize, 0), original.comments.len);
    }
}

test "nested scanner results survive another scan and clean every allocation failure" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, run, .{ templates.all[7], true });
}

test "malformed interpolation diagnostic survives another scan and cleans every allocation failure" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, run, .{ "`outer${/*\nunterminated", false });
}
