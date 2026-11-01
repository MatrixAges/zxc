const std = @import("std");
const Binding = @import("function_import.zig");
pub const specifier = "std:utils";

pub const Operation = enum {
    pick,
    omit,
    identity,
    isNil,
    isNotNil,
    head,
    last,
    take,
    takeRight,
    drop,
    dropRight,
    sum,
    min,
    max,
    clamp,
    inRange,
    map,
    reduce,
};

pub const exports: [std.enums.values(Operation).len]Binding = blk: {
    var result: [std.enums.values(Operation).len]Binding = undefined;

    for (std.enums.values(Operation), 0..) |field, index| {
        result[index] = .{ .name = @tagName(field), .intrinsic = field };
    }

    break :blk result;
};
