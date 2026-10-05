const h = @import("check.zig");

test "RX Store Call input getter" {
    try h.run(.{ .source = "<Module><Store from='state' as='jobs'/><Call fn='read' in={store.jobs.counter.value}/><Return value={$ctx.read}/></Module>", .slots = 1 });
}

test "RX Store Return cannot access getter" {
    try h.run(.{ .source = "<Module><Store from='state' as='jobs'/><Return value={store.jobs.counter.value}/></Module>", .code = "name", .marker = "store.jobs.counter.value" });
}

test "RX Store Switch cannot access getter" {
    try h.run(.{ .source = "<Module><Store from='state' as='jobs'/><Switch on={store.jobs.counter.value}><Case value={0}><Return value={1}/></Case><Default><Return value={2}/></Default></Switch></Module>", .code = "name", .marker = "store.jobs.counter.value" });
}

test "RX Store Call getter does not leak into Return" {
    try h.run(.{ .source = "<Module><Store from='state' as='jobs'/><Call fn='read' in={store.jobs.counter.value}/><Return value={store.jobs.counter.value}/></Module>", .code = "name", .marker = "store.jobs.counter.value", .last = true });
}

test "RX Store-like result name is isolated in context" {
    try h.run(.{ .source = "<Module><Store from='state' as='jobs'/><Call fn='store' in={1}/><Call fn='read' in={$ctx.store + store.jobs.counter.value}/><Return value={$ctx.read}/></Module>", .slots = 1 });
}

test "RX Store result rejects dotted filename segments" {
    try h.run(.{ .source = "<Module><Store from='state' as='jobs'/><Call fn='store.jobs.zx' in={1}/></Module>", .code = "name", .marker = "store.jobs" });
}

test "RX Store result rejects multiple dotted filename segments" {
    try h.run(.{ .source = "<Module><Store from='state' as='jobs'/><Call fn='store.jobs.counter.zx' in={1}/></Module>", .code = "name", .marker = "store.jobs.counter" });
}

test "RX Store result allows similar namespace prefix" {
    try h.run(.{ .source = "<Module><Store from='state' as='jobs'/><Call fn='storehouse_value' in={1}/><Return value={$ctx.storehouse_value}/></Module>" });
}
