const f = @import("fixture.zig");

pub const case: f.Case = .{
    .declaration = "export declare function apply(input: u64): u64\n" ++
        "export declare function unknown(input: u64): u64 throws\n" ++
        "export declare function empty(input: u64): u64 throws {}\n" ++
        "export declare function finite(input: u64): u64 throws { ZetaFailure, AlphaFailure }\n" ++
        "export declare function allocating(allocator, input: u64): u64 throws { OutOfMemory }\n" ++
        "export declare function reading(io, input: u64): u64 concurrent\n" ++
        "export declare function spawning(process, input: u64): u64 throws { ProcessFailure }\n" ++
        "export declare function expanded(left: u64, right: u64): u64\n",
    .members = &.{
        .{ .name = "apply" },
        .{ .name = "unknown", .fallible = true },
        .{ .name = "empty", .fallible = true, .errors = &.{} },
        .{ .name = "finite", .fallible = true, .errors = &.{ "ZetaFailure", "AlphaFailure" } },
        .{ .name = "allocating", .allocating = true, .fallible = true, .errors = &.{"OutOfMemory"} },
        .{ .name = "reading", .io = true, .concurrent = true },
        .{ .name = "spawning", .process = true, .fallible = true, .errors = &.{"ProcessFailure"} },
        .{ .name = "expanded", .expanded = true },
    },
};
