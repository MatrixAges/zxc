const h = @import("check.zig");

test "RX Store rejects inline callback capturing getter" {
    try h.run(.{ .source = "<Module><Store from='state' as='jobs'/><Call fn='list' in={[1].map(x => store.jobs.counter.value)}/><Return value={$ctx.list}/></Module>", .code = "unsupported", .marker = "[1].map" });
}

test "RX Store rejects nested inline callback after outer getter" {
    try h.run(.{ .source = "<Module><Store from='state' as='jobs'/><Call fn='pair' in={{current: store.jobs.counter.value, mapped: [1].map(x => store.jobs.counter.value)}}/><Return value={$ctx.pair}/></Module>", .code = "unsupported", .marker = "[1].map" });
}

test "RX Store rejects inline callback on getter receiver" {
    try h.run(.{ .source = "<Module><Store from='state' as='jobs'/><Call fn='list' in={store.jobs.counter.history.map(x => x + 1)}/><Return value={$ctx.list}/></Module>", .code = "unsupported", .marker = "store.jobs.counter.history.map" });
}

test "RX Store rejects inline callback with local store parameter" {
    try h.run(.{ .source = "<Module><Store from='state' as='jobs'/><Call fn='list' in={[{jobs: {counter: {value: 7}}}].map(store => store.jobs.counter.value)}/><Return value={$ctx.list}/></Module>", .code = "unsupported", .marker = "[{jobs:" });
}

test "RX Store rejects nested inline callback with local store parameter" {
    try h.run(.{ .source = "<Module><Store from='state' as='jobs'/><Call fn='pair' in={{current: store.jobs.counter.value, mapped: [{jobs: {counter: {value: 7}}}].map(store => store.jobs.counter.value)}}/><Return value={$ctx.pair}/></Module>", .code = "unsupported", .marker = "[{jobs:" });
}
