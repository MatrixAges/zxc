const std = @import("std");
const allocation_testing = @import("allocation_testing");
const h = @import("check.zig");

test "fresh RX result transfers to owned ZX" {
    try h.run(.{
        .source = "<Module><Call fn='list' in={$in}/><Call fn='consume' in={$ctx.list}/><Return value={$ctx.consume.length}/></Module>",
    });
}

test "RX input remains borrowed" {
    try h.run(.{
        .source = "<Module><Call fn='consume' in={$in}/><Return value={$ctx.consume.length}/></Module>",
    });
}

test "RX rejects inline map before owned transfer" {
    try h.run(.{
        .source = "<Module><Call fn='list' in={$in}/><Call fn='consume' in={$in.map(item => item)}/><Return value={$ctx.consume.length}/></Module>",
        .expected = .{ .code = "unsupported", .marker = "$in.map" },
    });
}

test "result can transfer through two new bindings" {
    try h.run(.{
        .source = "<Module><Call fn='list' in={$in}/><Call fn='consume' in={$ctx.list}/><Call fn='consume_next' in={$ctx.consume}/><Return value={$ctx.consume_next.length}/></Module>",
    });
}

test "discarded owned call still consumes input" {
    try h.run(.{
        .source = "<Module><Call fn='list' in={$in}/><Call fn='consume' in={$ctx.list}/><Return value={$ctx.list.length}/></Module>",
    });
}

test "old binding cannot transfer twice" {
    try h.run(.{
        .source = "<Module><Call fn='list' in={$in}/><Call fn='consume' in={$ctx.list}/><Call fn='consume_next' in={$ctx.list}/><Return value={$ctx.consume_next.length}/></Module>",
    });
}

test "parallel independent owners can transfer" {
    try h.run(.{
        .source = "<Module><Call fn='list' in={$in}/><Call fn='list_other' in={$in}/><Parallel><Call fn='consume' in={$ctx.list}/><Call fn='consume_right' in={$ctx.list_other}/></Parallel><Return value={$ctx.consume.length + $ctx.consume_right.length}/></Module>",
    });
}

test "parallel cannot transfer same owner twice" {
    try h.run(.{
        .source = "<Module><Call fn='list' in={$in}/><Parallel><Call fn='consume' in={$ctx.list}/><Call fn='consume_right' in={$ctx.list}/></Parallel><Return value={$ctx.consume.length + $ctx.consume_right.length}/></Module>",
    });
}

test "parallel single transfer consumes parent binding" {
    try h.run(.{
        .source = "<Module><Call fn='list' in={$in}/><Parallel><Call fn='consume' in={$ctx.list}/></Parallel><Return value={$ctx.list.length}/></Module>",
    });
}

test "parallel direct call can read borrowed input" {
    try h.run(.{
        .source = "<Module><Parallel><Call fn='consume' in={$in}/></Parallel><Return value={$ctx.consume.length}/></Module>",
    });
}

test "Task can read shared captured owner" {
    try h.run(.{
        .source = "<Module><Call fn='list' in={$in}/><Parallel><Task name='result'><Call fn='consume' in={$ctx.list}/><Return value={$ctx.consume.length}/></Task></Parallel><Return value={$ctx.task.result}/></Module>",
    });
}

test "Task can consume branch-local owner" {
    try h.run(.{
        .source = "<Module><Parallel><Task name='result'><Call fn='list' in={$in}/><Call fn='consume' in={$ctx.list}/><Return value={$ctx.consume.length}/></Task></Parallel><Return value={$ctx.task.result}/></Module>",
    });
}

test "Task local transferred result does not consume borrowed outer input" {
    try h.run(.{
        .source = "<Module><Parallel><Task name='result'><Call fn='list' in={$in}/><Call fn='consume' in={$ctx.list}/><Return value={$ctx.consume.length}/></Task></Parallel><Return value={$ctx.task.result + $in.length}/></Module>",
    });
}

test "Store getter cannot transfer to owned function" {
    try h.run(.{
        .source = "<Module><Store from='state' as='jobs'/><Call fn='consume' in={store.jobs.counter.value}/><Return value={$ctx.consume.length}/></Module>",
        .store = true,
        .store_source = "<Store name='lists' version={1}><Object name='counter'><Field name='value' type='u64[]' value={[3]}/></Object></Store>",
    });
}

test "copied Store getter can transfer" {
    try h.run(.{
        .source = "<Module><Store from='state' as='jobs'/><Call fn='list' in={store.jobs.counter.value}/><Call fn='consume' in={$ctx.list}/><Return value={$ctx.consume.length}/></Module>",
        .store = true,
        .store_source = "<Store name='lists' version={1}><Object name='counter'><Field name='value' type='u64[]' value={[3]}/></Object></Store>",
        .slots = 1,
    });
}

test "published Store value cannot later transfer" {
    try h.run(.{
        .source = "<Module><Store from='state' as='jobs'/><Call fn='list' in={$in}/><Call fn='write_list' in={$ctx.list} setter={[store.jobs.counter]}/><Call fn='consume' in={$ctx.list}/><Return value={$ctx.consume.length}/></Module>",
        .store = true,
        .store_source = "<Store name='lists' version={1}><Object name='counter'><Field name='value' type='u64[]' value={[3]}/></Object></Store>",
    });
}

test "owned new result can be published to Store" {
    try h.run(.{
        .source = "<Module><Store from='state' as='jobs'/><Call fn='list' in={$in}/><Call fn='consume' in={$ctx.list}/><Call fn='write_list' in={$ctx.consume} setter={[store.jobs.counter]}/><Return value={$ctx.write_list}/></Module>",
        .store = true,
        .store_source = "<Store name='lists' version={1}><Object name='counter'><Field name='value' type='u64[]' value={[3]}/></Object></Store>",
        .slots = 1,
    });
}

test "parallel independent transfer allocation failures release analysis" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.allocated, .{h.Case{
        .source = "<Module><Call fn='list' in={$in}/><Call fn='list_other' in={$in}/><Parallel><Call fn='consume' in={$ctx.list}/><Call fn='consume_right' in={$ctx.list_other}/></Parallel><Return value={$ctx.consume.length + $ctx.consume_right.length}/></Module>",
    }});
}

test "parallel shared input allocation failures release analysis" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.allocated, .{h.Case{
        .source = "<Module><Call fn='list' in={$in}/><Parallel><Call fn='consume' in={$ctx.list}/><Call fn='consume_right' in={$ctx.list}/></Parallel><Return value={$ctx.consume.length + $ctx.consume_right.length}/></Module>",
    }});
}

test "Task local transfer allocation failures release analysis" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.allocated, .{h.Case{
        .source = "<Module><Parallel><Task name='result'><Call fn='list' in={$in}/><Call fn='consume' in={$ctx.list}/><Return value={$ctx.consume.length}/></Task></Parallel><Return value={$ctx.task.result}/></Module>",
    }});
}

comptime {
    _ = @import("compiled.zig");
}

test "parallel borrowed worker allows later immutable call of same list" {
    try h.run(.{
        .source = "<Module><Call fn='list' in={$in}/><Parallel><Call fn='list_read' in={$ctx.list}/><Call fn='consume_right' in={$ctx.list}/></Parallel><Return value={$ctx.list_read.length + $ctx.consume_right.length}/></Module>",
    });
}

test "parallel owned transfer allows later borrowed worker on same list" {
    try h.run(.{
        .source = "<Module><Call fn='list' in={$in}/><Parallel><Call fn='consume' in={$ctx.list}/><Call fn='list_read' in={$ctx.list}/></Parallel><Return value={$ctx.consume.length + $ctx.list_read.length}/></Module>",
    });
}
