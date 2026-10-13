const std = @import("std");
const generated = @import("generated");

fn call(left: anytype, right: @TypeOf(left)) generated.Output {
    var storage: [256]u8 = undefined;
    var fixed = std.heap.FixedBufferAllocator.init(&storage);

    return generated.executeIn(fixed.allocator(), &.{
        .left = &.{
            .path = left.path,
            .type_only = left.kind == .type_only,
            .start = left.span.start,
        },
        .right = &.{
            .path = right.path,
            .type_only = right.kind == .type_only,
            .start = right.span.start,
        },
    }) catch unreachable;
}

pub fn sameGroup(left: anytype, right: @TypeOf(left)) bool {
    return call(left, right).same_group;
}

pub fn lessThan(_: void, left: anytype, right: @TypeOf(left)) bool {
    return call(left, right).less_than;
}
