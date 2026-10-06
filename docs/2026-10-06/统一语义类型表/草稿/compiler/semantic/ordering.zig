const std = @import("std");
const View = @import("named_view");

pub fn sort(names: [][]const u8, types: ?[]u32) std.mem.Allocator.Error!void {
    if (types) |items| std.debug.assert(items.len == names.len);

    const data = View{ .names = names, .types = types };

    if (!@import("parser_options").generated_parser) {
        std.sort.pdqContext(0, names.len, data);

        return;
    }

    const generated = @import("generated_name_sort");
    var storage: [0]u8 = undefined;
    var fixed = std.heap.FixedBufferAllocator.init(&storage);
    var arena = std.heap.ArenaAllocator.init(fixed.allocator());

    defer arena.deinit();

    generated.execute(&arena, @ptrCast(&data)) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => unreachable,
    };
}
