const h = @import("check.zig");

test "RX parallel overlap position ignores trailing unrelated call" {
    try h.run(.{
        .source = "<Module><Parallel><Call fn='number' in={1}/><Call fn='number' in={2}/><Call fn='number_other' in={3}/></Parallel><Return value={1}/></Module>",
        .expected = .{ .marker = "number'", .last = true, .message = "Parallel result binding paths must not overlap" },
    });
}

test "RX parallel child overlap retains original file and conflicting attribute" {
    try h.run(.{
        .source = "<!--不同长度的父模块-->\n<Module><Call module='child.rx' in={1}/><Return value={$ctx.child}/></Module>",
        .modules = &.{.{ .path = "child.rx", .text = "<!--子模块-->\n<Module>\n<Parallel>\n  <Call fn='number' in={$in}/>\n  <Call fn='number' in={$in}/>\n  <Call fn='number_other' in={$in}/>\n</Parallel>\n<Return value={1}/>\n</Module>" }},
        .expected = .{ .marker = "number'", .last = true, .path = "child.rx", .message = "Parallel result binding paths must not overlap" },
    });
}

test "RX parallel child sibling dependency retains original file and input location" {
    try h.run(.{
        .source = "<!--父模块-->\n<Module><Call module='child.rx' in={1}/><Return value={$ctx.child}/></Module>",
        .modules = &.{.{ .path = "child.rx", .text = "<!--子模块-->\n<Module>\n<Parallel>\n  <Call fn='number_first' in={$in}/>\n  <Call fn='number_second' in={$ctx.number_first}/>\n</Parallel>\n<Return value={$ctx.number_second}/>\n</Module>" }},
        .expected = .{ .marker = "$ctx.number_first", .last = true, .path = "child.rx" },
    });
}

test "RX parallel encoded conflicting output points into original XML" {
    try h.run(.{
        .source = "<!--偏移-->\r\n<Module><Parallel><Call fn='number' in={1}/><Call fn='&#110;umber' in={2}/><Call fn='number_other' in={3}/></Parallel><Return value={1}/></Module>",
        .expected = .{ .marker = "&#110;umber", .message = "Parallel result binding paths must not overlap" },
    });
}

test "RX parallel conflicting Task output retains its own attribute position" {
    try h.run(.{
        .source = "<Module><Parallel><Task name='value'><Return value={1}/></Task><Task name='value'><Return value={2}/></Task><Call fn='number_other' in={3}/></Parallel><Return value={1}/></Module>",
        .expected = .{ .marker = "value'", .last = true, .message = "Parallel result binding paths must not overlap" },
    });
}

test "RX parallel Task and Call may share a result name" {
    try h.run(.{
        .source = "<Module><Parallel><Call fn='value' in={1}/><Task name='value'><Return value={2}/></Task><Call fn='number' in={3}/></Parallel><Return value={$ctx.value + $ctx.task.value}/></Module>",
    });
}

test "RX parallel Call and Task may share a result name" {
    try h.run(.{
        .source = "<Module><Parallel><Task name='value'><Return value={1}/></Task><Call fn='value' in={2}/><Call fn='number_other' in={3}/></Parallel><Return value={$ctx.value + $ctx.task.value}/></Module>",
    });
}
