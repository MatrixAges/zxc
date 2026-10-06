const std = @import("std");
const compiler = @import("compiler");
const h = @import("check.zig");

test "RX Task shared owned capture may escape through distinct borrowed records" {
    try h.run(.{ .source = "<Module><Call fn='list' in={$in}/><Parallel><Task name='left'><Return value={{items: $ctx.list}}/></Task><Task name='right'><Return value={{items: $ctx.list}}/></Task></Parallel><Return value={$ctx.task.left.items.length + $ctx.task.right.items.length}/></Module>" });
}

test "RX Task shared owned capture may escape through nested borrowed lists" {
    try h.run(.{ .source = "<Module><Call fn='list' in={$in}/><Parallel><Task name='left'><Return value={[$ctx.list]}/></Task><Task name='right'><Return value={[$ctx.list]}/></Task></Parallel><Return value={$ctx.task.left[0].length + $ctx.task.right[0].length}/></Module>" });
}

test "RX parent can read owned value frozen by Task capture" {
    try h.run(.{
        .source = "<Module><Call fn='list' in={$in}/><Parallel><Task name='value'><Return value={$ctx.list}/></Task></Parallel><Call fn='consume' in={$ctx.list}/><Return value={$ctx.consume.length}/></Module>",
        .extra_sources = &.{.{ .path = "consume.zx", .source = @embedFile("owned_input/consume.zx") }},
    });
}

test "RX Task can read its borrowed capture" {
    try h.run(.{
        .source = "<Module><Call fn='list' in={$in}/><Parallel><Task name='value'><Call fn='consume' in={$ctx.list}/><Return value={$ctx.consume.length}/></Task></Parallel><Return value={1}/></Module>",
        .extra_sources = &.{.{ .path = "consume.zx", .source = @embedFile("owned_input/consume.zx") }},
    });
}

test "RX aggregate return allows sharing one value across two object fields" {
    try h.run(.{
        .source = "<Module><Call fn='list' in={$in}/><Return value={{left: $ctx.list, right: $ctx.list}}/></Module>",
        .check_output = expectObjectOutput,
    });
}

test "RX aggregate return allows sharing one value across two list elements" {
    try h.run(.{
        .source = "<Module><Call fn='list' in={$in}/><Return value={[$ctx.list, $ctx.list]}/></Module>",
        .check_output = expectListOutput,
    });
}

fn expectObjectOutput(types: compiler.ir.TypeTable, id: compiler.ir.TypeId) !void {
    const output = types.get(id);

    try std.testing.expect(output == .object);
    try std.testing.expectEqual(2, output.object.len);

    for ([_][]const u8{ "left", "right" }, 0..) |name, index| {
        const field = output.object.at(index);

        try std.testing.expectEqualStrings(name, field.name);
        try expectU64List(types, field.type_id);
    }
}

fn expectListOutput(types: compiler.ir.TypeTable, id: compiler.ir.TypeId) !void {
    const output = types.get(id);

    try std.testing.expect(output == .list);
    try expectU64List(types, output.list);
}

fn expectU64List(types: compiler.ir.TypeTable, id: compiler.ir.TypeId) !void {
    const output = types.get(id);

    try std.testing.expect(output == .list);
    try std.testing.expectEqualDeep(compiler.ir.Type{ .scalar = .u64 }, types.get(output.list));
}

test "RX scalar-returning Store call freezes aggregate argument published by setter" {
    try h.run(.{
        .source = "<Module><Store from='state' as='jobs'/><Call fn='list' in={$in}/><Call fn='write_list' in={$ctx.list} setter={[store.jobs.counter]}/><Call fn='consume' in={$ctx.list}/><Return value={$ctx.consume.length}/></Module>",
        .store = true,
        .slots = 1,
        .store_source = "<Store name='lists' version={1}><Object name='counter'><Field name='value' type='u64[]' value={[3]}/></Object></Store>",
        .extra_sources = &.{.{ .path = "consume.zx", .source = @embedFile("owned_input/consume.zx") }},
    });
}

test "RX scalar-returning Store call preserves read access to published argument" {
    try h.run(.{
        .source = "<Module><Store from='state' as='jobs'/><Call fn='list' in={$in}/><Call fn='write_list' in={$ctx.list} setter={[store.jobs.counter]}/><Return value={$ctx.list.length + $ctx.write_list}/></Module>",
        .store = true,
        .slots = 1,
        .store_source = "<Store name='lists' version={1}><Object name='counter'><Field name='value' type='u64[]' value={[3]}/></Object></Store>",
    });
}
