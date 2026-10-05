const h = @import("check.zig");

test "RX Store normalized aliases share one slot" {
    try h.run(.{ .source = "<Module><Store from='state' as='jobs'/><Store from='./state.store.rx' as='other'/><Call fn='write' in={1} setter={[store.jobs.counter]}/><Call fn='read' in={store.other.counter.value}/><Return value={$ctx.read}/></Module>", .slots = 1 });
}

test "RX Store default namespace uses Store name" {
    try h.run(.{ .source = "<Module><Store from='state'/><Call fn='read' in={store.counter_state.counter.value}/><Return value={$ctx.read}/></Module>", .slots = 1 });
}

test "RX Store missing definition" {
    try h.run(.{ .source = "<Module><Store from='missing' as='jobs'/></Module>", .code = "capability", .marker = "missing" });
}

test "RX Store invalid namespace identifier" {
    try h.run(.{ .source = "<Module><Store from='state' as='bad.name'/></Module>", .code = "capability", .marker = "bad.name" });
}

test "RX Store duplicate explicit namespace" {
    try h.run(.{ .source = "<Module><Store from='state' as='jobs'/><Store from='./state.store.rx' as='jobs'/></Module>", .code = "context", .marker = "jobs", .last = true });
}

test "RX Store same display name needs aliases" {
    try h.run(.{ .source = "<Module><Store from='state'/><Store from='other'/></Module>", .code = "capability", .marker = "other", .other_store = true });
}

test "RX Store different paths remain distinct slots" {
    try h.run(.{ .source = "<Module><Store from='state' as='left'/><Store from='other' as='right'/><Call fn='read' in={store.left.counter.value}/><Call fn='read_other' in={store.right.counter.value}/><Return value={{left: $ctx.read, right: $ctx.read_other}}/></Module>", .slots = 2, .other_store = true });
}
