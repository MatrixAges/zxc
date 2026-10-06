const std = @import("std");
const program = @import("program");
const Input = std.meta.Child(program.Input);
const Cell = std.meta.Child(std.meta.Child(@FieldType(Input, "seed")));

pub fn main(init: std.process.Init) !void {
    const args = try init.minimal.args.toSlice(init.arena.allocator());
    const count = try std.fmt.parseInt(usize, args[1], 10);
    var cells: [17]Cell = undefined;
    var pointers: [17]*const Cell = undefined;

    for (&cells, &pointers, 0..) |*cell, *pointer, index| {
        cell.* = .{ .value = @intCast(index * 5 + 3), .label = "same" };
        pointer.* = cell;
    }

    const steps = try init.arena.allocator().alloc(u64, count);

    for (steps, 0..) |*item, index| item.* = @intCast((index * 7 + 3) % 11);

    var tracked = std.testing.FailingAllocator.init(std.heap.page_allocator, .{ .resize_fail_index = 0 });
    var arena = std.heap.ArenaAllocator.init(tracked.allocator());

    defer arena.deinit();

    const result = try program.execute(&arena, &.{ .seed = &pointers, .steps = steps, .label = "caller" });

    if (result.count != count or result.values.len != cells.len + count) return error.UnexpectedResult;

    std.debug.print("{{\"count\":{d},\"allocated_bytes\":{d},\"capacity\":{d}}}\n", .{ count, tracked.allocated_bytes, arena.queryCapacity() });
}
