const std = @import("std");
const zx_type_11 = struct { i32, };
const zx_type_12 = struct { i32, i32, };
pub const Input = i32;
pub const Output = i32;

fn function_0(allocator: ((std).mem).Allocator, in: i32) anyerror!i32 {
    @setRuntimeSafety(true);

    _ = allocator;

    return (in + @as(i32, 1));
}

fn function_1(allocator: ((std).mem).Allocator, in: i32) anyerror!i32 {
    @setRuntimeSafety(true);

    return (try function_0(allocator, in));
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: i32) anyerror!i32 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();
    const value_1: i32 = (try function_1(allocator, in));

    return value_1;
}

