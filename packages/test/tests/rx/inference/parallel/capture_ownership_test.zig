const h = @import("check.zig");

test "RX Task shared owned capture may escape through distinct borrowed records" {
    try h.run(.{ .source = "<Module><Call fn='list' in={$in}/><Parallel><Task name='left'><Return value={{items: $ctx.list}}/></Task><Task name='right'><Return value={{items: $ctx.list}}/></Task></Parallel><Return value={$ctx.task.left.items.length + $ctx.task.right.items.length}/></Module>" });
}

test "RX Task shared owned capture may escape through nested borrowed lists" {
    try h.run(.{ .source = "<Module><Call fn='list' in={$in}/><Parallel><Task name='left'><Return value={[$ctx.list]}/></Task><Task name='right'><Return value={[$ctx.list]}/></Task></Parallel><Return value={$ctx.task.left[0].length + $ctx.task.right[0].length}/></Module>" });
}

test "RX parent cannot consume owned value frozen by Task capture" {
    try h.run(.{
        .source = "<Module><Call fn='list' in={$in}/><Parallel><Task name='value'><Return value={$ctx.list}/></Task></Parallel><Call fn='consume' in={$ctx.list}/><Return value={$ctx.consume.length}/></Module>",
        .expected = .{ .code = "ownership", .marker = "$ctx.list", .last = true, .message = "owned Input requires an owned argument" },
        .extra_sources = &.{.{ .path = "consume.zx", .source = @embedFile("owned_input/consume.zx") }},
    });
}

test "RX Task cannot consume its borrowed capture" {
    try h.run(.{
        .source = "<Module><Call fn='list' in={$in}/><Parallel><Task name='value'><Call fn='consume' in={$ctx.list}/><Return value={$ctx.consume.length}/></Task></Parallel><Return value={1}/></Module>",
        .expected = .{ .code = "ownership", .marker = "<Task", .message = "owned Input requires an owned argument" },
        .extra_sources = &.{.{ .path = "consume.zx", .source = @embedFile("owned_input/consume.zx") }},
    });
}

test "RX aggregate return still rejects moving one owner into two object fields" {
    try h.run(.{
        .source = "<Module><Call fn='list' in={$in}/><Return value={{left: $ctx.list, right: $ctx.list}}/></Module>",
        .expected = .{ .code = "ownership", .marker = "$ctx.list", .last = true, .message = "previous owner was consumed" },
    });
}

test "RX aggregate return still rejects moving one owner into two list elements" {
    try h.run(.{
        .source = "<Module><Call fn='list' in={$in}/><Return value={[$ctx.list, $ctx.list]}/></Module>",
        .expected = .{ .code = "ownership", .marker = "$ctx.list", .last = true, .message = "previous owner was consumed" },
    });
}

test "RX scalar-returning Store call freezes aggregate argument published by setter" {
    try h.run(.{
        .source = "<Module><Store from='state' as='jobs'/><Call fn='list' in={$in}/><Call fn='write_list' in={$ctx.list} setter={[store.jobs.counter]}/><Call fn='consume' in={$ctx.list}/><Return value={$ctx.consume.length}/></Module>",
        .store = true,
        .store_source = "<Store name='lists' version={1}><Object name='counter'><Field name='value' type='u64[]' value={[3]}/></Object></Store>",
        .expected = .{ .code = "ownership", .marker = "$ctx.list", .last = true, .message = "owned Input requires an owned argument" },
        .extra_sources = &.{.{ .path = "consume.zx", .source = @embedFile("owned_input/consume.zx") }},
    });
}

test "RX scalar-returning Store call preserves read access to published argument" {
    try h.run(.{
        .source = "<Module><Store from='state' as='jobs'/><Call fn='list' in={$in}/><Call fn='write_list' in={$ctx.list} setter={[store.jobs.counter]}/><Return value={$ctx.list.length + $ctx.write_list}/></Module>",
        .store = true,
        .slots = 1,
        .store_source = "<Store name='lists' version={1}><Object name='counter'><Field name='value' type='u64[]' value={[3]}/></Object></Store>",
    });
}
