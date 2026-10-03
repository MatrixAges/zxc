const std = @import("std");

pub fn check(comptime program: type, input: program.Input, expected: union(enum) { value: program.Output, failure: anyerror }) !void {
    var input_arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer input_arena.deinit();
    defer arena.deinit();

    const writable = try copyInput(program.Input, input_arena.allocator(), input);
    const actual = program.execute(&arena, writable);

    try std.testing.expectEqualDeep(input, writable);

    switch (expected) {
        .value => |value| try std.testing.expectEqualDeep(value, try actual),
        .failure => |failure| try std.testing.expectError(failure, actual),
    }
}

fn copyInput(comptime T: type, allocator: std.mem.Allocator, input: T) std.mem.Allocator.Error!T {
    switch (@typeInfo(T)) {
        .pointer => |pointer| {
            if (pointer.size == .one) {
                const result = try allocator.create(pointer.child);

                result.* = try copyInput(pointer.child, allocator, input.*);

                return result;
            }

            const result = try allocator.alloc(pointer.child, input.len);

            for (input, 0..) |item, index| result[index] = try copyInput(pointer.child, allocator, item);

            return result;
        },
        .@"struct" => {
            var result = input;

            inline for (std.meta.fields(T)) |field| {
                @field(result, field.name) = try copyInput(field.type, allocator, @field(input, field.name));
            }

            return result;
        },
        .optional => |optional| return if (input) |value| try copyInput(optional.child, allocator, value) else null,
        else => return input,
    }
}
