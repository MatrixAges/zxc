const std = @import("std");
const allocation_testing = @import("allocation_testing");
const h = @import("check.zig");

const sibling = h.Case{
    .source = "<Module><Parallel><Call fn='number_first' in={1}/><Call fn='number_second' in={$ctx.number_first}/></Parallel><Return value={$ctx.number_second}/></Module>",
    .expected = .{ .marker = "$ctx.number_first", .last = true },
};

const duplicate = h.Case{
    .source = "<Module><Parallel><Call fn='number' in={1}/><Call fn='number' in={2}/></Parallel><Return value={1}/></Module>",
    .expected = .{ .marker = "number'", .last = true, .message = "Parallel result binding paths must not overlap" },
};

test "RX parallel sibling input cannot read earlier sibling output" {
    try h.run(sibling);
}

test "RX parallel sibling input cannot read later sibling output" {
    try h.run(.{
        .source = "<Module><Parallel><Call fn='number_first' in={$ctx.number_later}/><Call fn='number_later' in={1}/></Parallel><Return value={1}/></Module>",
        .expected = .{ .marker = "$ctx.number_later" },
    });
}

test "RX parallel rejects identical output bindings" {
    try h.run(duplicate);
}

test "RX parallel reports conflicting middle output before unrelated final output" {
    try h.run(.{
        .source = "<!--中文-->\n<Module>\n  <Parallel>\n    <Call fn='number' in={1}/>\n    <Call fn='number' in={2}/>\n    <Call fn='number_other' in={3}/>\n  </Parallel>\n  <Return value={1}/>\n</Module>",
        .expected = .{ .marker = "number'", .last = true, .message = "Parallel result binding paths must not overlap" },
    });
}

test "RX parallel rejects dotted result name after valid name" {
    try h.run(.{
        .source = "<Module><Parallel><Call fn='number' in={1}/><Call fn='number.child' in={2}/></Parallel><Return value={1}/></Module>",
        .expected = .{ .marker = "number.child", .message = "result name must be one identifier" },
    });
}

test "RX parallel rejects dotted result name before valid name" {
    try h.run(.{
        .source = "<Module><Parallel><Call fn='number.child' in={1}/><Call fn='number' in={2}/></Parallel><Return value={1}/></Module>",
        .expected = .{ .marker = "number.child", .message = "result name must be one identifier" },
    });
}

test "RX parallel accepts distinct paths with shared textual prefix" {
    try h.run(.{ .source = "<Module><Parallel><Call fn='a' in={1}/><Call fn='ab' in={2}/></Parallel><Return value={$ctx.a + $ctx.ab}/></Module>" });
}

test "RX parallel accepts independent names with common prefix" {
    try h.run(.{ .source = "<Module><Parallel><Call fn='group_a' in={1}/><Call fn='group_b' in={2}/></Parallel><Return value={$ctx.group_a + $ctx.group_b}/></Module>" });
}

test "RX parallel rejects replacing a prior sequential result" {
    try h.run(.{
        .source = "<Module><Call fn='number' in={1}/><Parallel><Call fn='number' in={2}/></Parallel><Return value={1}/></Module>",
        .expected = .{ .marker = "number'", .last = true, .message = "flow result paths must not overlap" },
    });
}

test "RX parallel siblings can both read a prior sequential result" {
    try h.run(.{ .source = "<Module><Call fn='number_base' in={1}/><Parallel><Call fn='number_left' in={$ctx.number_base}/><Call fn='number_right' in={$ctx.number_base}/></Parallel><Return value={$ctx.number_left + $ctx.number_right}/></Module>" });
}

test "RX sequential consumer can read all joined parallel results" {
    try h.run(.{ .source = "<Module><Parallel><Call fn='number_left' in={1}/><Call fn='number_right' in={2}/></Parallel><Call fn='number_total' in={$ctx.number_left + $ctx.number_right}/><Return value={$ctx.number_total}/></Module>" });
}

test "RX later parallel group can read previously joined outputs" {
    try h.run(.{ .source = "<Module><Parallel><Call fn='number_first' in={1}/></Parallel><Parallel><Call fn='number_second' in={$ctx.number_first}/></Parallel><Return value={$ctx.number_second}/></Module>" });
}

test "RX parallel group inside Task cannot leak bindings outside Task" {
    try h.run(.{
        .source = "<Module><Task name='work'><Parallel><Call fn='number_local' in={1}/></Parallel></Task><Return value={$ctx.number_local}/></Module>",
        .expected = .{ .marker = "$ctx.number_local", .last = true },
    });
}

test "RX parallel group inside Switch cannot leak bindings outside branch" {
    try h.run(.{
        .source = "<Module><Switch on={true}><Case value={true}><Parallel><Call fn='number_local' in={1}/></Parallel></Case></Switch><Return value={$ctx.number_local}/></Module>",
        .expected = .{ .marker = "$ctx.number_local", .last = true },
    });
}

test "RX parallel group may return its result inside Task" {
    try h.run(.{ .source = "<Module><Task name='work'><Parallel><Call fn='number_local' in={1}/></Parallel><Return value={$ctx.number_local}/></Task></Module>" });
}

test "RX parallel group accepts unused pure call results" {
    try h.run(.{ .source = "<Module><Parallel><Call fn='number_first' in={1}/><Call fn='number_second' in={2}/></Parallel></Module>", .output = .void });
}

test "RX parallel keeps input-like result name inside ctx" {
    try h.run(.{
        .source = "<Module><Parallel><Call fn='$in_value' in={1}/></Parallel></Module>",
        .output = .void,
    });
}

test "RX parallel keeps Store-like result name inside ctx" {
    try h.run(.{
        .source = "<Module><Parallel><Call fn='store_value' in={1}/></Parallel></Module>",
        .output = .void,
    });
}

test "RX parallel sibling diagnostic cleans allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.allocated, .{sibling});
}

test "RX parallel overlap diagnostic cleans allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.allocated, .{duplicate});
}

test "RX parallel independent success cleans allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.allocated, .{h.Case{ .source = "<Module><Parallel><Call fn='number_left' in={1}/><Call fn='number_right' in={2}/></Parallel><Return value={$ctx.number_left + $ctx.number_right}/></Module>" }});
}

test "RX Call reserves task for the Task result namespace" {
    try h.run(.{
        .source = "<Module><Call fn='task' in={1}/></Module>",
        .expected = .{ .marker = "task'" },
    });
}
