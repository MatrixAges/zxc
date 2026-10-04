const std = @import("std");
const program = @import("program");
const abi = @import("zxc_abi");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);

    defer arena.deinit();

    const settings = abi.zx_type_12{ .mode = .Second };
    const context = program.zx_context{ .context_0 = &settings };
    const output = try program.execute(&arena, {}, context);

    std.debug.print("Context output: {s}\n", .{@tagName(output)});
}
