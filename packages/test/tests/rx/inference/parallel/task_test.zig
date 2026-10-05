const h = @import("check.zig");

test "RX parallel Task output joins with direct Call output" {
    try h.run(.{ .source = "<Module><Parallel><Task name='left'><Return value={1}/></Task><Call fn='number' in={2}/></Parallel><Return value={$ctx.task.left + $ctx.number}/></Module>" });
}

test "RX parallel Task captures prior sequential result" {
    try h.run(.{ .source = "<Module><Call fn='number' in={7}/><Parallel><Task name='result'><Return value={$ctx.number + 1}/></Task></Parallel><Return value={$ctx.task.result}/></Module>" });
}

test "RX parallel sibling Tasks may use the same private binding name" {
    try h.run(.{ .source = "<Module><Parallel><Task name='left'><Call fn='number' in={1}/><Return value={$ctx.number}/></Task><Task name='right'><Call fn='number' in={2}/><Return value={$ctx.number}/></Task></Parallel><Return value={$ctx.task.left + $ctx.task.right}/></Module>" });
}

test "RX parallel Task private result cannot escape without explicit output" {
    try h.run(.{
        .source = "<Module><Parallel><Task name='work'><Call fn='number' in={1}/><Return value={$ctx.number}/></Task></Parallel><Return value={$ctx.number}/></Module>",
        .expected = .{ .marker = "$ctx.number", .last = true },
    });
}

test "RX parallel Task cannot capture output from sibling Call" {
    try h.run(.{
        .source = "<Module><Parallel><Call fn='number' in={1}/><Task name='result'><Return value={$ctx.number}/></Task></Parallel><Return value={1}/></Module>",
        .expected = .{ .marker = "$ctx.number", .last = true },
    });
}

test "RX parallel Call cannot read output from sibling Task" {
    try h.run(.{
        .source = "<Module><Parallel><Task name='sibling'><Return value={1}/></Task><Call fn='number' in={$ctx.task.sibling}/></Parallel><Return value={1}/></Module>",
        .expected = .{ .marker = "$ctx.task.sibling", .last = true },
    });
}

test "RX parallel Task cannot capture output from sibling Task" {
    try h.run(.{
        .source = "<Module><Parallel><Task name='sibling'><Return value={1}/></Task><Task name='result'><Return value={$ctx.task.sibling}/></Task></Parallel><Return value={1}/></Module>",
        .expected = .{ .marker = "$ctx.task.sibling", .last = true },
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
        .source = "<Module><Store from='state' as='jobs'/><Parallel><Task name='result'><Call fn='number' in={store.jobs.counter.value}/><Return value={$ctx.number}/></Task></Parallel><Return value={$ctx.task.result}/></Module>",
        .store = true,
        .expected = .{ .code = "unsupported", .marker = "<Task", .message = "pure computation without Store access or native external calls" },
    });
}

test "RX parallel Task accepts captured parent Store snapshot" {
    try h.run(.{
        .source = "<Module><Store from='state' as='jobs'/><Call fn='number' in={store.jobs.counter.value}/><Parallel><Task name='result'><Return value={$ctx.number}/></Task></Parallel><Return value={$ctx.task.result}/></Module>",
        .store = true,
        .slots = 1,
    });
}

test "RX ordinary sequential Task rejects simultaneous out and Return" {
    try h.run(.{
        .source = "<Module><Task name='value' out={1}><Return value={1}/></Task></Module>",
        .expected = .{ .code = "return_path", .marker = "1}", .message = "Task.out and Return cannot both define the same task output" },
    });
}

test "RX Task inside Switch rejects simultaneous out and Return" {
    try h.run(.{
        .source = "<Module><Switch on={true}><Case value={true}><Task name='value' out={1}><Return value={1}/></Task></Case><Default><Return value={2}/></Default></Switch></Module>",
        .expected = .{ .code = "return_path", .marker = "1}", .message = "Task.out and Return cannot both define the same task output" },
    });
}

test "RX parallel Task without Return cannot expose void output" {
    try h.run(.{
        .source = "<Module><Parallel><Task name='value'><Call fn='number' in={1}/></Task><Call fn='number_other' in={2}/></Parallel><Return value={$ctx.task.value}/></Module>",
        .expected = .{ .code = "name", .marker = "$ctx.task.value" },
    });
}

test "RX parallel Task without Return is valid when output is omitted" {
    try h.run(.{ .source = "<Module><Parallel><Task name='work'><Call fn='number' in={1}/></Task><Call fn='number_other' in={2}/></Parallel><Return value={$ctx.number_other}/></Module>" });
}

test "RX parallel nonvoid Task requires return on every path" {
    try h.run(.{
        .source = "<Module><Parallel><Task name='value'><Switch on={$in}><Case value={true}><Return value={1}/></Case></Switch></Task></Parallel><Return value={$ctx.task.value}/></Module>",
        .expected = .{ .code = "return_path", .marker = "<Task", .message = "every Parallel Task path must return its output" },
    });
}

test "RX parallel nonvoid Task permits exhaustive returning branches" {
    try h.run(.{ .source = "<Module><Parallel><Task name='value'><Switch on={$in}><Case value={true}><Return value={1}/></Case><Default><Return value={2}/></Default></Switch></Task></Parallel><Return value={$ctx.task.value}/></Module>" });
}
