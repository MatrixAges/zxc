const h = @import("check.zig");

test "RX Task shared owned capture may escape through distinct borrowed records" {
    try h.run(.{ .source = "<Module><Call fn='list' in={$in} out='saved'/><Parallel><Task name='left' out='ctx.left'><Return value={{items: saved}}/></Task><Task name='right' out='ctx.right'><Return value={{items: saved}}/></Task></Parallel><Return value={ctx.left.items.length + ctx.right.items.length}/></Module>" });
}

test "RX Task shared owned capture may escape through nested borrowed lists" {
    try h.run(.{ .source = "<Module><Call fn='list' in={$in} out='saved'/><Parallel><Task name='left' out='ctx.left'><Return value={[saved]}/></Task><Task name='right' out='ctx.right'><Return value={[saved]}/></Task></Parallel><Return value={ctx.left[0].length + ctx.right[0].length}/></Module>" });
}

test "RX parent cannot consume owned value frozen by Task capture" {
    try h.run(.{
        .source = "<Module><Call fn='list' in={$in} out='saved'/><Parallel><Task name='work' out='ctx.value'><Return value={saved}/></Task></Parallel><Return value={saved.pop()}/></Module>",
        .expected = .{ .code = "ownership", .marker = "saved", .last = true, .message = "consuming list operations require an owned value" },
    });
}

test "RX Task cannot consume its borrowed capture" {
    try h.run(.{
        .source = "<Module><Call fn='list' in={$in} out='saved'/><Parallel><Task name='work' out='ctx.value'><Return value={saved.pop()}/></Task></Parallel><Return value={1}/></Module>",
        .expected = .{ .code = "ownership", .marker = "<Task", .message = "consuming list operations require an owned value" },
    });
}

test "RX aggregate return still rejects moving one owner into two object fields" {
    try h.run(.{
        .source = "<Module><Call fn='list' in={$in} out='saved'/><Return value={{left: saved, right: saved}}/></Module>",
        .expected = .{ .code = "ownership", .marker = "saved", .last = true, .message = "previous owner was consumed" },
    });
}

test "RX aggregate return still rejects moving one owner into two list elements" {
    try h.run(.{
        .source = "<Module><Call fn='list' in={$in} out='saved'/><Return value={[saved, saved]}/></Module>",
        .expected = .{ .code = "ownership", .marker = "saved", .last = true, .message = "previous owner was consumed" },
    });
}

test "RX scalar-returning Store call freezes aggregate argument published by setter" {
    try h.run(.{
        .source = "<Module><Store from='state' as='jobs'/><Call fn='list' in={$in} out='saved'/><Call fn='write_list' in={saved} setter={[store.jobs.counter]} out='ctx.length'/><Return value={saved.pop()}/></Module>",
        .store = true,
        .store_source = "<Store name='lists' version={1}><Object name='counter'><Field name='value' type='u64[]' value={[3]}/></Object></Store>",
        .expected = .{ .code = "ownership", .marker = "saved", .last = true, .message = "consuming list operations require an owned value" },
    });
}

test "RX scalar-returning Store call preserves read access to published argument" {
    try h.run(.{
        .source = "<Module><Store from='state' as='jobs'/><Call fn='list' in={$in} out='saved'/><Call fn='write_list' in={saved} setter={[store.jobs.counter]} out='ctx.length'/><Return value={saved.length + ctx.length}/></Module>",
        .store = true,
        .slots = 1,
        .store_source = "<Store name='lists' version={1}><Object name='counter'><Field name='value' type='u64[]' value={[3]}/></Object></Store>",
    });
}
