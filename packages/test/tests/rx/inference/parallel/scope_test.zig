const std = @import("std");
const allocation_testing = @import("allocation_testing");
const h = @import("check.zig");

const sibling = h.Case{
    .source = "<Module><Parallel><Call fn='number' in={1} out='ctx.first'/><Call fn='number' in={ctx.first} out='ctx.second'/></Parallel><Return value={ctx.second}/></Module>",
    .expected = .{ .marker = "ctx.first", .last = true },
};

const duplicate = h.Case{
    .source = "<Module><Parallel><Call fn='number' in={1} out='ctx.value'/><Call fn='number' in={2} out='ctx.value'/></Parallel><Return value={1}/></Module>",
    .expected = .{ .marker = "ctx.value", .last = true, .message = "Parallel result binding paths must not overlap" },
};

test "RX parallel sibling input cannot read earlier sibling output" {
    try h.run(sibling);
}

test "RX parallel sibling input cannot read later sibling output" {
    try h.run(.{
        .source = "<Module><Parallel><Call fn='number' in={ctx.later} out='ctx.first'/><Call fn='number' in={1} out='ctx.later'/></Parallel><Return value={1}/></Module>",
        .expected = .{ .marker = "ctx.later" },
    });
}

test "RX parallel rejects identical output bindings" {
    try h.run(duplicate);
}

test "RX parallel reports conflicting middle output before unrelated final output" {
    try h.run(.{
        .source = "<!--中文-->\n<Module>\n  <Parallel>\n    <Call fn='number' in={1} out='ctx.value'/>\n    <Call fn='number' in={2} out='ctx.value'/>\n    <Call fn='number' in={3} out='ctx.other'/>\n  </Parallel>\n  <Return value={1}/>\n</Module>",
        .expected = .{ .marker = "ctx.value", .last = true, .message = "Parallel result binding paths must not overlap" },
    });
}

test "RX parallel rejects child output under sibling root" {
    try h.run(.{
        .source = "<Module><Parallel><Call fn='number' in={1} out='ctx.value'/><Call fn='number' in={2} out='ctx.value.child'/></Parallel><Return value={1}/></Module>",
        .expected = .{ .marker = "ctx.value.child", .message = "Parallel result binding paths must not overlap" },
    });
}

test "RX parallel rejects parent output over sibling child" {
    try h.run(.{
        .source = "<Module><Parallel><Call fn='number' in={1} out='ctx.value.child'/><Call fn='number' in={2} out='ctx.value'/></Parallel><Return value={1}/></Module>",
        .expected = .{ .marker = "ctx.value", .last = true, .message = "Parallel result binding paths must not overlap" },
    });
}

test "RX parallel accepts distinct paths with shared textual prefix" {
    try h.run(.{ .source = "<Module><Parallel><Call fn='number' in={1} out='ctx.a'/><Call fn='number' in={2} out='ctx.ab'/></Parallel><Return value={ctx.a + ctx.ab}/></Module>" });
}

test "RX parallel accepts independent child paths under common root" {
    try h.run(.{ .source = "<Module><Parallel><Call fn='number' in={1} out='ctx.group.a'/><Call fn='number' in={2} out='ctx.group.b'/></Parallel><Return value={ctx.group.a + ctx.group.b}/></Module>" });
}

test "RX parallel rejects replacing a prior sequential result" {
    try h.run(.{
        .source = "<Module><Call fn='number' in={1} out='ctx.value'/><Parallel><Call fn='number' in={2} out='ctx.value'/></Parallel><Return value={1}/></Module>",
        .expected = .{ .marker = "ctx.value", .last = true, .message = "flow result binding paths must not overlap" },
    });
}

test "RX parallel siblings can both read a prior sequential result" {
    try h.run(.{ .source = "<Module><Call fn='number' in={1} out='ctx.base'/><Parallel><Call fn='number' in={ctx.base} out='ctx.left'/><Call fn='number' in={ctx.base} out='ctx.right'/></Parallel><Return value={ctx.left + ctx.right}/></Module>" });
}

test "RX sequential consumer can read all joined parallel results" {
    try h.run(.{ .source = "<Module><Parallel><Call fn='number' in={1} out='ctx.left'/><Call fn='number' in={2} out='ctx.right'/></Parallel><Call fn='number' in={ctx.left + ctx.right} out='ctx.total'/><Return value={ctx.total}/></Module>" });
}

test "RX later parallel group can read previously joined outputs" {
    try h.run(.{ .source = "<Module><Parallel><Call fn='number' in={1} out='ctx.first'/></Parallel><Parallel><Call fn='number' in={ctx.first} out='ctx.second'/></Parallel><Return value={ctx.second}/></Module>" });
}

test "RX parallel group inside Task cannot leak bindings outside Task" {
    try h.run(.{
        .source = "<Module><Task name='work'><Parallel><Call fn='number' in={1} out='ctx.local'/></Parallel></Task><Return value={ctx.local}/></Module>",
        .expected = .{ .marker = "ctx.local", .last = true },
    });
}

test "RX parallel group inside Switch cannot leak bindings outside branch" {
    try h.run(.{
        .source = "<Module><Switch on={true}><Case value={true}><Parallel><Call fn='number' in={1} out='ctx.local'/></Parallel></Case></Switch><Return value={ctx.local}/></Module>",
        .expected = .{ .marker = "ctx.local", .last = true },
    });
}

test "RX parallel group may return its result inside Task" {
    try h.run(.{ .source = "<Module><Task name='work'><Parallel><Call fn='number' in={1} out='ctx.local'/></Parallel><Return value={ctx.local}/></Task></Module>" });
}

test "RX parallel group accepts no-output pure calls" {
    try h.run(.{ .source = "<Module><Parallel><Call fn='number' in={1}/><Call fn='number' in={2}/></Parallel></Module>", .output = .void });
}

test "RX parallel rejects output under module input namespace" {
    try h.run(.{
        .source = "<Module><Parallel><Call fn='number' in={1} out='$in.value'/></Parallel></Module>",
        .expected = .{ .marker = "$in.value", .message = "distinct from the module input" },
    });
}

test "RX parallel rejects output under Store namespace" {
    try h.run(.{
        .source = "<Module><Parallel><Call fn='number' in={1} out='store.value'/></Parallel></Module>",
        .expected = .{ .marker = "store.value", .message = "Store namespace" },
    });
}

test "RX parallel sibling diagnostic cleans allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.allocated, .{sibling});
}

test "RX parallel overlap diagnostic cleans allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.allocated, .{duplicate});
}

test "RX parallel independent success cleans allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.allocated, .{h.Case{ .source = "<Module><Parallel><Call fn='number' in={1} out='ctx.left'/><Call fn='number' in={2} out='ctx.right'/></Parallel><Return value={ctx.left + ctx.right}/></Module>" }});
}
