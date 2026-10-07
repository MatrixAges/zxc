const std = @import("std");
const ir = @import("zx").ir;
const input = @import("ownership_input.zig");

export fn instantiate(source: *const ir.Program) void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);

    defer arena.deinit();

    _ = input.execute(&arena, source.*) catch return;
}
