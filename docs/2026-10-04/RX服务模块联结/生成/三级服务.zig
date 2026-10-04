const std = @import("std");
const zx_type_11 = struct { u64, };
const zx_type_12 = struct { u64, u64, };
const zx_type_13 = struct { u64, u64, u64, };
pub const Input = u64;
pub const Output = u64;

fn function_0(allocator: ((std).mem).Allocator, in: u64) anyerror!u64 {
    @setRuntimeSafety(true);

    _ = allocator;

    return in;
}

fn function_1(allocator: ((std).mem).Allocator, in: u64) anyerror!u64 {
    @setRuntimeSafety(true);

    _ = allocator;

    return in;
}

fn function_2(allocator: ((std).mem).Allocator, in: u64) anyerror!u64 {
    @setRuntimeSafety(true);

    const value_1: u64 = (try function_1(allocator, in));

    return value_1;
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: u64) anyerror!u64 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();
    const value_1: u64 = (try function_0(allocator, in));
    const value_2: u64 = (try function_2(allocator, value_1));

    return value_2;
}

