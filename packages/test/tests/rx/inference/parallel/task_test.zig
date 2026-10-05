const h = @import("check.zig");

test "RX parallel Task output joins with direct Call output" {
    try h.run(.{ .source = "<Module><Parallel><Task name='work' out='ctx.left'><Return value={1}/></Task><Call fn='number' in={2} out='ctx.right'/></Parallel><Return value={ctx.left + ctx.right}/></Module>" });
}

test "RX parallel Task captures prior sequential result" {
    try h.run(.{ .source = "<Module><Call fn='number' in={7} out='ctx.base'/><Parallel><Task name='work' out='ctx.result'><Return value={ctx.base + 1}/></Task></Parallel><Return value={ctx.result}/></Module>" });
}

test "RX parallel sibling Tasks may use the same private binding name" {
    try h.run(.{ .source = "<Module><Parallel><Task name='left' out='ctx.left'><Call fn='number' in={1} out='local.value'/><Return value={local.value}/></Task><Task name='right' out='ctx.right'><Call fn='number' in={2} out='local.value'/><Return value={local.value}/></Task></Parallel><Return value={ctx.left + ctx.right}/></Module>" });
}

test "RX parallel Task private result cannot escape without explicit output" {
    try h.run(.{
        .source = "<Module><Parallel><Task name='work'><Call fn='number' in={1} out='local.value'/><Return value={local.value}/></Task></Parallel><Return value={local.value}/></Module>",
        .expected = .{ .marker = "local.value", .last = true },
    });
}

test "RX parallel Task cannot capture output from sibling Call" {
    try h.run(.{
        .source = "<Module><Parallel><Call fn='number' in={1} out='ctx.sibling'/><Task name='work' out='ctx.result'><Return value={ctx.sibling}/></Task></Parallel><Return value={1}/></Module>",
        .expected = .{ .marker = "ctx.sibling", .last = true },
    });
}

test "RX parallel Call cannot read output from sibling Task" {
    try h.run(.{
        .source = "<Module><Parallel><Task name='work' out='ctx.sibling'><Return value={1}/></Task><Call fn='number' in={ctx.sibling} out='ctx.result'/></Parallel><Return value={1}/></Module>",
        .expected = .{ .marker = "ctx.sibling", .last = true },
    });
}

test "RX parallel Task cannot capture output from sibling Task" {
    try h.run(.{
        .source = "<Module><Parallel><Task name='left' out='ctx.sibling'><Return value={1}/></Task><Task name='right' out='ctx.result'><Return value={ctx.sibling}/></Task></Parallel><Return value={1}/></Module>",
        .expected = .{ .marker = "ctx.sibling", .last = true },
    });
}

test "RX parallel no-output Task still rejects native effect" {
    try h.run(.{
        .source = "<Module><Parallel><Task name='work'><Call fn='native' in={1}/></Task></Parallel></Module>",
        .expected = .{ .code = "unsupported", .marker = "<Task", .message = "pure computation without Store access or native external calls" },
    });
}

test "RX parallel Task rejects Store read inside worker input expression" {
    try h.run(.{
        .source = "<Module><Store from='state' as='jobs'/><Parallel><Task name='work' out='ctx.result'><Call fn='number' in={store.jobs.counter.value} out='local.value'/><Return value={local.value}/></Task></Parallel><Return value={ctx.result}/></Module>",
        .store = true,
        .expected = .{ .code = "unsupported", .marker = "<Task", .message = "pure computation without Store access or native external calls" },
    });
}

test "RX parallel Task accepts captured parent Store snapshot" {
    try h.run(.{
        .source = "<Module><Store from='state' as='jobs'/><Call fn='number' in={store.jobs.counter.value} out='ctx.snapshot'/><Parallel><Task name='work' out='ctx.result'><Return value={ctx.snapshot}/></Task></Parallel><Return value={ctx.result}/></Module>",
        .store = true,
        .slots = 1,
    });
}

test "RX ordinary sequential Task rejects output attribute" {
    try h.run(.{
        .source = "<Module><Task name='work' out='ctx.value'><Return value={1}/></Task></Module>",
        .expected = .{ .code = "invalid_attribute", .marker = "out=", .message = "only available on direct Parallel branches" },
    });
}

test "RX Task inside Switch remains sequential and rejects output attribute" {
    try h.run(.{
        .source = "<Module><Switch on={true}><Case value={true}><Task name='work' out='ctx.value'><Return value={1}/></Task></Case><Default><Return value={2}/></Default></Switch></Module>",
        .expected = .{ .code = "invalid_attribute", .marker = "out=", .message = "only available on direct Parallel branches" },
    });
}

test "RX parallel Task without Return cannot expose void output" {
    try h.run(.{
        .source = "<Module><Parallel><Task name='work' out='ctx.value'><Call fn='number' in={1}/></Task><Call fn='number' in={2} out='ctx.other'/></Parallel><Return value={ctx.other}/></Module>",
        .expected = .{ .code = "type_mismatch", .marker = "ctx.value", .message = "void call or task results cannot be bound" },
    });
}

test "RX parallel Task without Return is valid when output is omitted" {
    try h.run(.{ .source = "<Module><Parallel><Task name='work'><Call fn='number' in={1}/></Task><Call fn='number' in={2} out='ctx.other'/></Parallel><Return value={ctx.other}/></Module>" });
}

test "RX parallel nonvoid Task requires return on every path" {
    try h.run(.{
        .source = "<Module><Parallel><Task name='work' out='ctx.value'><Switch on={$in}><Case value={true}><Return value={1}/></Case></Switch></Task></Parallel><Return value={ctx.value}/></Module>",
        .expected = .{ .code = "return_path", .marker = "<Task", .message = "every Parallel Task path must return its output" },
    });
}

test "RX parallel nonvoid Task permits exhaustive returning branches" {
    try h.run(.{ .source = "<Module><Parallel><Task name='work' out='ctx.value'><Switch on={$in}><Case value={true}><Return value={1}/></Case><Default><Return value={2}/></Default></Switch></Task></Parallel><Return value={ctx.value}/></Module>" });
}
