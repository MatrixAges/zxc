const std = @import("std");
const h = @import("check.zig");

test "RX automatic contract scalar allocation failures" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, h.runAllocated, .{h.Case{
        .source = "<Module><Call fn='number' in={$in} out='ctx.value'/><Return value={ctx.value}/></Module>",
        .input = .u64,
        .output = .u64,
        .calls = 1,
        .returned = true,
    }});
}

test "RX automatic contract nested allocation failures" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, h.runAllocated, .{h.Case{
        .source = "<Module><Call fn='number' in={$in.user.id} out='ctx.value'/><Return value={ctx.value}/></Module>",
        .input = .u64,
        .input_path = &.{ "user", "id" },
        .output = .u64,
        .calls = 1,
        .returned = true,
    }});
}

test "RX automatic contract sequential allocation failures" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, h.runAllocated, .{h.Case{
        .source = "<Module><Call fn='text' in={$in} out='ctx.text'/><Call fn='length' in={ctx.text} out='ctx.size'/><Return value={ctx.size}/></Module>",
        .input = .string,
        .output = .u64,
        .calls = 2,
        .returned = true,
    }});
}

test "RX automatic contract diagnostic allocation failures" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, h.runAllocated, .{h.Case{
        .source = "<Module><Call fn='number' in={$in}/><Call fn='text' in={$in}/></Module>",
        .code = "type_mismatch",
    }});
}
