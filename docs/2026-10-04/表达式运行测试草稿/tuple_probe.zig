const std = @import("std");
const Pair = struct { u64, u64 };

noinline fn evaluate(input: *const Pair) u64 {
    return input[1] * 10 + input[0];
}

noinline fn compare(right: u64, left: u64) void {
    const inferred = evaluate(&.{ right, left });
    const input: Pair = .{ right, left };
    const typed = evaluate(&input);

    std.debug.print("inferred={d}, typed={d}\n", .{ inferred, typed });
}

pub fn main() void {
    compare(3, 7);
    compare(7, 3);
}
