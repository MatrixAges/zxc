const std = @import("std");
const h = @import("check.zig");

test "fresh RX result transfers to owned ZX" {
    try h.run(.{
        .source = "<Module><Call fn='list' in={$in} out='saved'/><Call fn='consume' in={saved} out='next'/><Return value={next.length}/></Module>",
    });
}

test "RX input remains borrowed" {
    try h.run(.{
        .source = "<Module><Call fn='consume' in={$in} out='next'/><Return value={next.length}/></Module>",
        .expected = .{ .code = "ownership", .marker = "$in", .last = false },
    });
}

test "fresh inline map can transfer" {
    try h.run(.{
        .source = "<Module><Call fn='list' in={$in} out='saved'/><Call fn='consume' in={$in.map(item => item)} out='next'/><Return value={next.length}/></Module>",
    });
}

test "result can transfer through two new bindings" {
    try h.run(.{
        .source = "<Module><Call fn='list' in={$in} out='saved'/><Call fn='consume' in={saved} out='next'/><Call fn='consume' in={next} out='last'/><Return value={last.length}/></Module>",
    });
}

test "discarded owned call still consumes input" {
    try h.run(.{
        .source = "<Module><Call fn='list' in={$in} out='saved'/><Call fn='consume' in={saved}/><Return value={saved.length}/></Module>",
        .expected = .{ .code = "ownership", .marker = "saved.length", .last = true },
    });
}

test "old binding cannot transfer twice" {
    try h.run(.{
        .source = "<Module><Call fn='list' in={$in} out='saved'/><Call fn='consume' in={saved} out='next'/><Call fn='consume' in={saved} out='last'/><Return value={last.length}/></Module>",
        .expected = .{ .code = "ownership", .marker = "saved", .last = true },
    });
}

test "parallel independent owners can transfer" {
    try h.run(.{
        .source = "<Module><Call fn='list' in={$in} out='saved'/><Call fn='list' in={$in} out='other'/><Parallel><Call fn='consume' in={saved} out='left'/><Call fn='consume' in={other} out='right'/></Parallel><Return value={left.length + right.length}/></Module>",
    });
}

test "parallel cannot transfer same owner twice" {
    try h.run(.{
        .source = "<Module><Call fn='list' in={$in} out='saved'/><Parallel><Call fn='consume' in={saved} out='left'/><Call fn='consume' in={saved} out='right'/></Parallel><Return value={left.length + right.length}/></Module>",
        .expected = .{ .code = "ownership", .marker = "saved", .last = true },
    });
}

test "parallel single transfer consumes parent binding" {
    try h.run(.{
        .source = "<Module><Call fn='list' in={$in} out='saved'/><Parallel><Call fn='consume' in={saved} out='left'/></Parallel><Return value={saved.length}/></Module>",
        .expected = .{ .code = "ownership", .marker = "saved.length", .last = true },
    });
}

test "parallel direct call cannot consume borrowed input" {
    try h.run(.{
        .source = "<Module><Parallel><Call fn='consume' in={$in} out='left'/></Parallel><Return value={left.length}/></Module>",
        .expected = .{ .code = "ownership", .marker = "$in", .last = false },
    });
}

test "Task cannot consume shared captured owner" {
    try h.run(.{
        .source = "<Module><Call fn='list' in={$in} out='saved'/><Parallel><Task name='work' out='result'><Call fn='consume' in={saved} out='next'/><Return value={next.length}/></Task></Parallel><Return value={result}/></Module>",
        .expected = .{ .code = "ownership", .marker = "<Task", .last = false },
    });
}

test "Task can consume branch-local owner" {
    try h.run(.{
        .source = "<Module><Parallel><Task name='work' out='result'><Call fn='list' in={$in} out='local'/><Call fn='consume' in={local} out='next'/><Return value={next.length}/></Task></Parallel><Return value={result}/></Module>",
    });
}

test "Task local transferred result does not consume borrowed outer input" {
    try h.run(.{
        .source = "<Module><Parallel><Task name='work' out='result'><Call fn='list' in={$in} out='local'/><Call fn='consume' in={local} out='next'/><Return value={next.length}/></Task></Parallel><Return value={result + $in.length}/></Module>",
    });
}

test "Store getter cannot transfer to owned function" {
    try h.run(.{
        .source = "<Module><Store from='state' as='jobs'/><Call fn='consume' in={store.jobs.counter.value} out='next'/><Return value={next.length}/></Module>",
        .store = true,
        .store_source = "<Store name='lists' version={1}><Object name='counter'><Field name='value' type='u64[]' value={[3]}/></Object></Store>",
        .expected = .{ .code = "ownership", .marker = "store.jobs.counter.value", .last = false },
    });
}

test "copied Store getter can transfer" {
    try h.run(.{
        .source = "<Module><Store from='state' as='jobs'/><Call fn='list' in={store.jobs.counter.value} out='local'/><Call fn='consume' in={local} out='next'/><Return value={next.length}/></Module>",
        .store = true,
        .store_source = "<Store name='lists' version={1}><Object name='counter'><Field name='value' type='u64[]' value={[3]}/></Object></Store>",
        .slots = 1,
    });
}

test "published Store value cannot later transfer" {
    try h.run(.{
        .source = "<Module><Store from='state' as='jobs'/><Call fn='list' in={$in} out='saved'/><Call fn='write_list' in={saved} setter={[store.jobs.counter]} out='length'/><Call fn='consume' in={saved} out='next'/><Return value={next.length}/></Module>",
        .store = true,
        .store_source = "<Store name='lists' version={1}><Object name='counter'><Field name='value' type='u64[]' value={[3]}/></Object></Store>",
        .expected = .{ .code = "ownership", .marker = "saved", .last = true },
    });
}

test "owned new result can be published to Store" {
    try h.run(.{
        .source = "<Module><Store from='state' as='jobs'/><Call fn='list' in={$in} out='saved'/><Call fn='consume' in={saved} out='next'/><Call fn='write_list' in={next} setter={[store.jobs.counter]} out='length'/><Return value={length}/></Module>",
        .store = true,
        .store_source = "<Store name='lists' version={1}><Object name='counter'><Field name='value' type='u64[]' value={[3]}/></Object></Store>",
        .slots = 1,
    });
}

test "parallel independent transfer allocation failures release analysis" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, h.allocated, .{h.Case{
        .source = "<Module><Call fn='list' in={$in} out='saved'/><Call fn='list' in={$in} out='other'/><Parallel><Call fn='consume' in={saved} out='left'/><Call fn='consume' in={other} out='right'/></Parallel><Return value={left.length + right.length}/></Module>",
    }});
}

test "parallel duplicate rejection allocation failures release analysis" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, h.allocated, .{h.Case{
        .source = "<Module><Call fn='list' in={$in} out='saved'/><Parallel><Call fn='consume' in={saved} out='left'/><Call fn='consume' in={saved} out='right'/></Parallel><Return value={left.length + right.length}/></Module>",
        .expected = .{ .code = "ownership", .marker = "saved", .last = true },
    }});
}

test "Task local transfer allocation failures release analysis" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, h.allocated, .{h.Case{
        .source = "<Module><Parallel><Task name='work' out='result'><Call fn='list' in={$in} out='local'/><Call fn='consume' in={local} out='next'/><Return value={next.length}/></Task></Parallel><Return value={result}/></Module>",
    }});
}

comptime {
    _ = @import("compiled.zig");
}

test "parallel borrowed worker prevents later owned transfer of same list" {
    try h.run(.{
        .source = "<Module><Call fn='list' in={$in} out='saved'/><Parallel><Call fn='list' in={saved} out='left'/><Call fn='consume' in={saved} out='right'/></Parallel><Return value={left.length + right.length}/></Module>",
        .expected = .{ .code = "ownership", .marker = "saved", .last = true },
    });
}

test "parallel owned transfer prevents later borrowed worker on same list" {
    try h.run(.{
        .source = "<Module><Call fn='list' in={$in} out='saved'/><Parallel><Call fn='consume' in={saved} out='left'/><Call fn='list' in={saved} out='right'/></Parallel><Return value={left.length + right.length}/></Module>",
        .expected = .{ .code = "ownership", .marker = "saved", .last = true },
    });
}
