const std = @import("std");
const allocation_testing = @import("allocation_testing");
const h = @import("check.zig");
const pure_message = "require pure functions without Store capabilities or native external calls";

const native_case = h.Case{
    .source = "<Module><Parallel><Call fn='native' in={1} out='ctx.value'/></Parallel><Return value={ctx.value}/></Module>",
    .expected = .{ .code = "unsupported", .marker = "<Call", .message = pure_message },
};

const setter_case = h.Case{
    .source = "<Module><Store from='state' as='jobs'/><Parallel><Call fn='write' in={1} setter={[store.jobs.counter]} out='ctx.value'/></Parallel><Return value={ctx.value}/></Module>",
    .store = true,
    .expected = .{ .code = "unsupported", .marker = "<Call", .message = pure_message },
};

test "RX parallel rejects direct native external call" {
    try h.run(native_case);
}

test "RX parallel rejects native external through ZX import closure" {
    try h.run(.{
        .source = "<Module><Parallel><Call fn='bridge' in={1} out='ctx.value'/></Parallel><Return value={ctx.value}/></Module>",
        .expected = .{ .code = "unsupported", .marker = "<Call", .message = pure_message },
    });
}

test "RX parallel rejects native external through RX service closure" {
    try h.run(.{
        .source = "<Module><Parallel><Call service='child.rx' in={1} out='ctx.value'/></Parallel><Return value={ctx.value}/></Module>",
        .modules = &.{.{ .path = "child.rx", .text = "<Module><Call fn='native' in={$in} out='ctx.value'/><Return value={ctx.value}/></Module>" }},
        .expected = .{ .code = "unsupported", .marker = "<Call", .message = pure_message },
    });
}

test "RX parallel rejects no-output native call" {
    try h.run(.{
        .source = "<Module><Parallel><Call fn='native' in={1}/></Parallel></Module>",
        .expected = .{ .code = "unsupported", .marker = "<Call", .message = pure_message },
    });
}

test "RX parallel ignores unused native import outside reachable calls" {
    try h.run(.{ .source = "<Module><Parallel><Call fn='unused' in={1} out='ctx.value'/></Parallel><Return value={ctx.value}/></Module>" });
}

test "RX sequential native call retains existing capability" {
    try h.run(.{ .source = "<Module><Call fn='native' in={1} out='ctx.value'/><Return value={ctx.value}/></Module>" });
}

test "RX parallel rejects Store setter capability on direct call" {
    try h.run(setter_case);
}

test "RX sequential Store setter retains existing capability" {
    try h.run(.{
        .source = "<Module><Store from='state' as='jobs'/><Call fn='write' in={1} setter={[store.jobs.counter]} out='ctx.value'/><Return value={ctx.value}/></Module>",
        .store = true,
        .slots = 1,
    });
}

test "RX parallel accepts immutable Store snapshot evaluated in parent" {
    try h.run(.{
        .source = "<Module><Store from='state' as='jobs'/><Parallel><Call fn='number' in={store.jobs.counter.value} out='ctx.value'/></Parallel><Return value={ctx.value}/></Module>",
        .store = true,
        .slots = 1,
    });
}

test "RX parallel rejects Store read performed inside service" {
    try h.run(.{
        .source = "<Module><Parallel><Call service='child.rx' in={1} out='ctx.value'/></Parallel><Return value={ctx.value}/></Module>",
        .modules = &.{.{ .path = "child.rx", .text = "<Module><Store from='state' as='jobs'/><Call fn='number' in={store.jobs.counter.value} out='ctx.value'/><Return value={ctx.value}/></Module>" }},
        .store = true,
        .expected = .{ .code = "unsupported", .marker = "<Call", .message = pure_message },
    });
}

test "RX parallel rejects Store write performed inside service" {
    try h.run(.{
        .source = "<Module><Parallel><Call service='child.rx' in={1} out='ctx.value'/></Parallel><Return value={ctx.value}/></Module>",
        .modules = &.{.{ .path = "child.rx", .text = "<Module><Store from='state' as='jobs'/><Call fn='write' in={$in} setter={[store.jobs.counter]} out='ctx.value'/><Return value={ctx.value}/></Module>" }},
        .store = true,
        .expected = .{ .code = "unsupported", .marker = "<Call", .message = pure_message },
    });
}

test "RX parallel native capability diagnostic cleans allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.allocated, .{native_case});
}

test "RX parallel Store capability diagnostic cleans allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.allocated, .{setter_case});
}

test "RX parallel rejects native external through two service levels" {
    try h.run(.{
        .source = "<Module><Parallel><Call service='bridge.rx' in={1} out='ctx.value'/></Parallel><Return value={ctx.value}/></Module>",
        .modules = &.{
            .{ .path = "leaf.rx", .text = "<Module><Call fn='native' in={$in} out='ctx.value'/><Return value={ctx.value}/></Module>" },
            .{ .path = "bridge.rx", .text = "<Module><Call service='leaf.rx' in={$in} out='ctx.value'/><Return value={ctx.value}/></Module>" },
        },
        .expected = .{ .code = "unsupported", .marker = "<Call", .message = pure_message },
    });
}

test "RX parallel capability diagnostic remains in offending child module" {
    try h.run(.{
        .source = "<!--父模块偏移-->\n<Module><Call service='child.rx' in={1} out='ctx.value'/><Return value={ctx.value}/></Module>",
        .modules = &.{.{ .path = "child.rx", .text = "<!--子模块-->\n<Module>\n  <Parallel>\n    <Call fn='native' in={$in} out='ctx.value'/>\n  </Parallel>\n  <Return value={ctx.value}/>\n</Module>" }},
        .expected = .{ .code = "unsupported", .marker = "<Call", .path = "child.rx", .message = pure_message },
    });
}

test "RX parallel accepts pure service with unused Store declaration" {
    try h.run(.{
        .source = "<Module><Parallel><Call service='child.rx' in={1} out='ctx.value'/></Parallel><Return value={ctx.value}/></Module>",
        .modules = &.{.{ .path = "child.rx", .text = "<Module><Store from='state' as='jobs'/><Call fn='number' in={$in} out='ctx.value'/><Return value={ctx.value}/></Module>" }},
        .store = true,
    });
}

test "RX parallel pure service accepts Store snapshot passed by parent" {
    try h.run(.{
        .source = "<Module><Store from='state' as='jobs'/><Parallel><Call service='child.rx' in={store.jobs.counter.value} out='ctx.value'/></Parallel><Return value={ctx.value}/></Module>",
        .modules = &.{.{ .path = "child.rx", .text = "<Module><Call fn='number' in={$in} out='ctx.value'/><Return value={ctx.value}/></Module>" }},
        .store = true,
        .slots = 1,
    });
}

test "RX parallel pure call can consume result of prior sequential native call" {
    try h.run(.{ .source = "<Module><Call fn='native' in={1} out='ctx.base'/><Parallel><Call fn='number' in={ctx.base} out='ctx.value'/></Parallel><Return value={ctx.value}/></Module>" });
}

test "RX sequential native call can consume joined pure result" {
    try h.run(.{ .source = "<Module><Parallel><Call fn='number' in={1} out='ctx.base'/></Parallel><Call fn='native' in={ctx.base} out='ctx.value'/><Return value={ctx.value}/></Module>" });
}
