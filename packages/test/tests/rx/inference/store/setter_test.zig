const h = @import("check.zig");

test "RX Store setter rejects empty" {
    try h.run(.{ .source = "<Module><Store from='state' as='jobs'/><Call fn='write' in={1} setter={[]}/></Module>", .code = "capability", .marker = "[]" });
}

test "RX Store setter rejects nonlist" {
    try h.run(.{ .source = "<Module><Store from='state' as='jobs'/><Call fn='write' in={1} setter={store.jobs.counter}/></Module>", .code = "capability", .marker = "store.jobs.counter" });
}

test "RX Store setter rejects namespace" {
    try h.run(.{ .source = "<Module><Store from='state' as='jobs'/><Call fn='write' in={1} setter={[store.jobs]}/></Module>", .code = "capability", .marker = "store.jobs" });
}

test "RX Store setter rejects field" {
    try h.run(.{ .source = "<Module><Store from='state' as='jobs'/><Call fn='write' in={1} setter={[store.jobs.counter.value]}/></Module>", .code = "capability", .marker = "store.jobs.counter.value" });
}

test "RX Store setter rejects unknown" {
    try h.run(.{ .source = "<Module><Store from='state' as='jobs'/><Call fn='write' in={1} setter={[store.jobs.missing]}/></Module>", .code = "capability", .marker = "store.jobs.missing" });
}

test "RX Store setter rejects duplicate" {
    try h.run(.{ .source = "<Module><Store from='state' as='jobs'/><Call fn='write' in={1} setter={[store.jobs.counter, store.jobs.counter]}/></Module>", .code = "capability", .marker = "[store.jobs.counter" });
}

test "RX Store setter permits one complete Object" {
    try h.run(.{ .source = "<Module><Store from='state' as='jobs'/><Call fn='write' in={1} setter={[store.jobs.counter]} out='ctx.value'/><Return value={ctx.value}/></Module>", .slots = 1 });
}
