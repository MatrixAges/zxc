const std = @import("std");
const program = @import("program");
const Input = std.meta.Child(program.Input);
const Nested = std.meta.Child(@FieldType(Input, "nested"));

fn run(allocator: std.mem.Allocator, size: usize) !void {
    var values: [257]u64 = undefined;

    for (&values, 0..) |*value, index| value.* = @intCast(index * 7 + 3);

    const before = values;
    const nested: Nested = .{ .items = values[0..size] };
    const input: Input = .{ .nested = &nested };
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const result = try program.execute(&arena, &input);

    try std.testing.expectEqual(&input, result);
    try std.testing.expectEqual(&nested, result.nested);
    try std.testing.expectEqual(nested.items.ptr, result.nested.items.ptr);
    try std.testing.expectEqualSlices(u64, before[0..size], result.nested.items);
    try std.testing.expectEqualSlices(u64, &before, &values);
}

test "split nested entry preserves an empty borrowed list" {
    try run(std.testing.allocator, 0);
}

test "split nested entry preserves populated values input and identity" {
    for ([_]usize{ 1, 17, 257 }) |size| try run(std.testing.allocator, size);
}

test "split nested entry retains earlier results across later inputs" {
    const first_values = [_]u64{ 3, 5, 7 };
    const second_values = [_]u64{ 101, 103 };
    const first_nested: Nested = .{ .items = &first_values };
    const second_nested: Nested = .{ .items = &second_values };
    const first_input: Input = .{ .nested = &first_nested };
    const second_input: Input = .{ .nested = &second_nested };
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const first = try program.execute(&arena, &first_input);
    const second = try program.execute(&arena, &second_input);

    try std.testing.expectEqual(&first_input, first);
    try std.testing.expectEqual(&second_input, second);
    try std.testing.expectEqualSlices(u64, &first_values, first.nested.items);
    try std.testing.expectEqualSlices(u64, &second_values, second.nested.items);
}

test "split nested entry executes with its first allocation forbidden" {
    var tracked = std.testing.FailingAllocator.init(std.testing.allocator, .{ .fail_index = 0 });

    try run(tracked.allocator(), 17);
    try std.testing.expectEqual(@as(usize, 0), tracked.allocated_bytes);
    try std.testing.expect(!tracked.has_induced_failure);
}
