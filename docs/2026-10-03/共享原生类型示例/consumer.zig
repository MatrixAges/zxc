const std = @import("std");
const program = @import("program");
const abi = @import("zxc_abi").native.@"zig:transport";

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);

    defer arena.deinit();

    const first: abi.Item = &.{ .value = 17 };
    const second: abi.Item = &.{ .value = 29 };
    const items = [_]abi.Item{ first, second };
    const pair: abi.Pair = &.{ first, second };
    const input: abi.Packet = &.{ .items = &items, .pair = pair };
    const output = try program.execute(&arena, input);

    if (output != input or output.items.ptr != input.items.ptr or output.pair != input.pair) return error.ReferenceChanged;
    if (output.items[1] != second or output.pair[0] != first) return error.ElementReferenceChanged;
    if (arena.queryCapacity() != 0) return error.UnexpectedAllocation;

    std.debug.print("object, tuple, array and element references preserved; arena capacity: {d}\n", .{arena.queryCapacity()});
}
