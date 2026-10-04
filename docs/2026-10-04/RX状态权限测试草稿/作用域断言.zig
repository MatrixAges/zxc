const h = @import("check.zig");

test "RX Store Call input getter" {
    try h.run(.{ .source = "<Module><Store from='state' as='jobs'/><Call fn='read' in='store.jobs.counter.value' out='ctx.value'/><Return value='ctx.value'/></Module>", .slots = 1 });
}

test "RX Store Return cannot access getter" {
    try h.run(.{ .source = "<Module><Store from='state' as='jobs'/><Return value='store.jobs.counter.value'/></Module>", .code = "name", .marker = "store.jobs.counter.value" });
}

test "RX Store Switch cannot access getter" {
    try h.run(.{ .source = "<Module><Store from='state' as='jobs'/><Switch on='store.jobs.counter.value'><Case value='0'><Return value='1'/></Case><Default><Return value='2'/></Default></Switch></Module>", .code = "name", .marker = "store.jobs.counter.value" });
}

test "RX Store Call getter does not leak into Return" {
    try h.run(.{ .source = "<Module><Store from='state' as='jobs'/><Call fn='read' in='store.jobs.counter.value' out='ctx.value'/><Return value='store.jobs.counter.value'/></Module>", .code = "name", .marker = "store.jobs.counter.value", .last = true });
}

test "RX Store out cannot replace store" {
    try h.run(.{ .source = "<Module><Store from='state' as='jobs'/><Call fn='read' in='1' out='store'/></Module>", .code = "name", .marker = "store" });
}

test "RX Store out cannot replace store.jobs" {
    try h.run(.{ .source = "<Module><Store from='state' as='jobs'/><Call fn='read' in='1' out='store.jobs'/></Module>", .code = "name", .marker = "store.jobs" });
}

test "RX Store out cannot replace store.jobs.counter" {
    try h.run(.{ .source = "<Module><Store from='state' as='jobs'/><Call fn='read' in='1' out='store.jobs.counter'/></Module>", .code = "name", .marker = "store.jobs.counter" });
}

test "RX Store out allows similar namespace prefix" {
    try h.run(.{ .source = "<Module><Store from='state' as='jobs'/><Call fn='read' in='1' out='storehouse.value'/><Return value='storehouse.value'/></Module>" });
}
