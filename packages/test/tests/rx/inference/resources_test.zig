const std = @import("std");
const allocation_testing = @import("allocation_testing");
const h = @import("check.zig");

test "RX automatic contract scalar allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.runAllocated, .{h.Case{
        .source = "<Module><Call fn='number' in={$in}/><Return value={$ctx.number}/></Module>",
        .input = .u64,
        .output = .u64,
        .calls = 1,
        .returned = true,
    }});
}

test "RX automatic contract nested allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.runAllocated, .{h.Case{
        .source = "<Module><Call fn='number' in={$in.user.id}/><Return value={$ctx.number}/></Module>",
        .input = .u64,
        .input_path = &.{ "user", "id" },
        .output = .u64,
        .calls = 1,
        .returned = true,
    }});
}

test "RX automatic contract sequential allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.runAllocated, .{h.Case{
        .source = "<Module><Call fn='text' in={$in}/><Call fn='length' in={$ctx.text}/><Return value={$ctx.length}/></Module>",
        .input = .string,
        .output = .u64,
        .calls = 2,
        .returned = true,
    }});
}

test "RX automatic contract diagnostic allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.runAllocated, .{h.Case{
        .source = "<Module><Call fn='number' in={$in}/><Call fn='text' in={$in}/></Module>",
        .code = "type_mismatch",
    }});
}
