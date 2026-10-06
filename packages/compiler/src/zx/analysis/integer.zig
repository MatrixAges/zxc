const std = @import("std");

pub fn parse(allocator: std.mem.Allocator, source: []const u8) std.mem.Allocator.Error!?u64 {
    if (@import("parser_options").generated_parser) {
        var storage: [0]u8 = undefined;
        var fixed = std.heap.FixedBufferAllocator.init(&storage);
        var arena = std.heap.ArenaAllocator.init(fixed.allocator());

        defer arena.deinit();

        return @import("generated_integer").execute(&arena, source) catch unreachable;
    }

    var clean: std.ArrayList(u8) = .empty;

    defer clean.deinit(allocator);

    for (source) |byte| if (byte != '_') try clean.append(allocator, byte);

    return std.fmt.parseInt(u64, clean.items, 10) catch null;
}
