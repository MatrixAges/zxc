const h = @import("check.zig");

test "RX Store callback cannot capture getter" {
    try h.run(.{ .source = "<Module><Store from='state' as='jobs'/><Call fn='list' in='[1].map(x => store.jobs.counter.value)' out='ctx.value'/><Return value='ctx.value'/></Module>", .code = "name", .marker = "store.jobs.counter.value" });
}

test "RX Store callback cannot capture an outer authorized getter" {
    try h.run(.{ .source = "<Module><Store from='state' as='jobs'/><Call fn='pair' in='{current: store.jobs.counter.value, mapped: [1].map(x => store.jobs.counter.value)}' out='ctx.value'/><Return value='ctx.value'/></Module>", .code = "name", .marker = "store.jobs.counter.value", .last = true });
}

test "RX Store getter receiver permits independent callback" {
    try h.run(.{ .source = "<Module><Store from='state' as='jobs'/><Call fn='list' in='store.jobs.counter.history.map(x => x + 1)' out='ctx.value'/><Return value='ctx.value'/></Module>", .slots = 1 });
}

test "RX Store callback local store name remains local" {
    try h.run(.{ .source = "<Module><Store from='state' as='jobs'/><Call fn='list' in='[{jobs: {counter: {value: 7}}}].map(store => store.jobs.counter.value)' out='ctx.value'/><Return value='ctx.value'/></Module>" });
}

test "RX Store outer getter does not override local store parameter" {
    try h.run(.{ .source = "<Module><Store from='state' as='jobs'/><Call fn='pair' in='{current: store.jobs.counter.value, mapped: [{jobs: {counter: {value: 7}}}].map(store => store.jobs.counter.value)}' out='ctx.value'/><Return value='ctx.value'/></Module>", .slots = 1 });
}
