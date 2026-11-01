const h = @import("check.zig");

test "RX Store rejects inline callback capturing getter" {
    try h.run(.{ .source = "<Module><Store from='state' as='jobs'/><Call fn='list' in={map([1], x => store.jobs.counter.value)}/><Return value={$ctx.list}/></Module>", .code = "unsupported", .marker = "map(" });
}

test "RX Store rejects nested inline callback after outer getter" {
    try h.run(.{ .source = "<Module><Store from='state' as='jobs'/><Call fn='pair' in={{current: store.jobs.counter.value, mapped: map([1], x => store.jobs.counter.value)}}/><Return value={$ctx.pair}/></Module>", .code = "unsupported", .marker = "map(" });
}

test "RX Store rejects inline callback on getter receiver" {
    try h.run(.{ .source = "<Module><Store from='state' as='jobs'/><Call fn='list' in={map(store.jobs.counter.history, x => x + 1)}/><Return value={$ctx.list}/></Module>", .code = "unsupported", .marker = "map(" });
}

test "RX Store rejects inline callback with local store parameter" {
    try h.run(.{ .source = "<Module><Store from='state' as='jobs'/><Call fn='list' in={map([{jobs: {counter: {value: 7}}}], store => store.jobs.counter.value)}/><Return value={$ctx.list}/></Module>", .code = "unsupported", .marker = "map(" });
}

test "RX Store rejects nested inline callback with local store parameter" {
    try h.run(.{ .source = "<Module><Store from='state' as='jobs'/><Call fn='pair' in={{current: store.jobs.counter.value, mapped: map([{jobs: {counter: {value: 7}}}], store => store.jobs.counter.value)}}/><Return value={$ctx.pair}/></Module>", .code = "unsupported", .marker = "map(" });
}
