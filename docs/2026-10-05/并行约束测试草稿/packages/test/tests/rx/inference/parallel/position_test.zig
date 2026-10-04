const h = @import("check.zig");

test "RX parallel overlap position ignores trailing no-output call" {
    try h.run(.{
        .source = "<Module><Parallel><Call fn='number' in='1' out='ctx.value'/><Call fn='number' in='2' out='ctx.value'/><Call fn='number' in='3'/></Parallel><Return value='1'/></Module>",
        .expected = .{ .marker = "ctx.value", .last = true, .message = "Parallel result binding paths must not overlap" },
    });
}

test "RX parallel child overlap retains original file and conflicting attribute" {
    try h.run(.{
        .source = "<!--不同长度的父模块-->\n<Module><Call service='child.rx' in='1' out='ctx.value'/><Return value='ctx.value'/></Module>",
        .modules = &.{.{ .path = "child.rx", .text = "<!--子模块-->\n<Module>\n<Parallel>\n  <Call fn='number' in='$in' out='ctx.value'/>\n  <Call fn='number' in='$in' out='ctx.value'/>\n  <Call fn='number' in='$in' out='ctx.other'/>\n</Parallel>\n<Return value='1'/>\n</Module>" }},
        .expected = .{ .marker = "ctx.value", .last = true, .path = "child.rx", .message = "Parallel result binding paths must not overlap" },
    });
}

test "RX parallel child sibling dependency retains original file and input location" {
    try h.run(.{
        .source = "<!--父模块-->\n<Module><Call service='child.rx' in='1' out='ctx.value'/><Return value='ctx.value'/></Module>",
        .modules = &.{.{ .path = "child.rx", .text = "<!--子模块-->\n<Module>\n<Parallel>\n  <Call fn='number' in='$in' out='ctx.first'/>\n  <Call fn='number' in='ctx.first' out='ctx.second'/>\n</Parallel>\n<Return value='ctx.second'/>\n</Module>" }},
        .expected = .{ .marker = "ctx.first", .last = true, .path = "child.rx" },
    });
}

test "RX parallel encoded conflicting output points into original XML" {
    try h.run(.{
        .source = "<!--偏移-->\r\n<Module><Parallel><Call fn='number' in='1' out='ctx.value'/><Call fn='number' in='2' out='ctx.&#118;alue'/><Call fn='number' in='3' out='ctx.other'/></Parallel><Return value='1'/></Module>",
        .expected = .{ .marker = "ctx.&#118;alue", .message = "Parallel result binding paths must not overlap" },
    });
}

test "RX parallel conflicting Task output retains its own attribute position" {
    try h.run(.{
        .source = "<Module><Parallel><Task name='first' out='ctx.value'><Return value='1'/></Task><Task name='second' out='ctx.value'><Return value='2'/></Task><Call fn='number' in='3' out='ctx.other'/></Parallel><Return value='1'/></Module>",
        .expected = .{ .marker = "ctx.value", .last = true, .message = "Parallel result binding paths must not overlap" },
    });
}

test "RX parallel Task output conflicting with Call points at Task attribute" {
    try h.run(.{
        .source = "<Module><Parallel><Call fn='number' in='1' out='ctx.value'/><Task name='work' out='ctx.value'><Return value='2'/></Task><Call fn='number' in='3'/></Parallel><Return value='1'/></Module>",
        .expected = .{ .marker = "ctx.value", .last = true, .message = "Parallel result binding paths must not overlap" },
    });
}

test "RX parallel Call output conflicting with Task points at Call attribute" {
    try h.run(.{
        .source = "<Module><Parallel><Task name='work' out='ctx.value'><Return value='1'/></Task><Call fn='number' in='2' out='ctx.value'/><Call fn='number' in='3' out='ctx.other'/></Parallel><Return value='1'/></Module>",
        .expected = .{ .marker = "ctx.value", .last = true, .message = "Parallel result binding paths must not overlap" },
    });
}
