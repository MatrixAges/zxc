const std = @import("std");
const rx = @import("rx");

fn check(source: []const u8, allowed: bool) !void {
    var parsed = try rx.parseXml(std.testing.allocator, source);

    defer parsed.deinit();

    try std.testing.expect(parsed.value == .node);

    var single = try rx.validate(std.testing.allocator, "main.rx", parsed.value.node);

    defer single.deinit();

    var modules = try rx.validateModules(std.testing.allocator, &.{.{ .path = "main.rx", .node = parsed.value.node }});

    defer modules.deinit();

    if (allowed) {
        try std.testing.expect(single.value == .data);
        try std.testing.expect(modules.value == .data);

        return;
    }

    try std.testing.expect(single.value == .diagnostic);
    try std.testing.expect(modules.value == .diagnostic);
    try std.testing.expectEqual(@as(usize, 0), modules.value.diagnostic.source_index);

    const offset = std.mem.indexOf(u8, source, "ctx.value").?;
    const issues = [_]rx.Diagnostic{ single.value.diagnostic, modules.value.diagnostic.issue };

    for (issues) |issue| {
        try std.testing.expectEqual(.invalid_attribute, issue.code);
        try std.testing.expectEqualStrings("Task", issue.element);
        try std.testing.expectEqual(offset, issue.location.offset);
        try std.testing.expectEqualStrings("This attribute requires a braced expression", issue.message);
    }
}

test "RX single and collection schemas reject quoted ordinary Task output" {
    try check("<Module><Task name='work' out='ctx.value'><Return value={1}/></Task></Module>", false);
}

test "RX single and collection schemas reject quoted Switch Task output" {
    try check("<Module><Switch on={true}><Case value={true}><Task name='work' out='ctx.value'><Return value={1}/></Task></Case></Switch></Module>", false);
}

test "RX single and collection schemas reject quoted direct Parallel Task output" {
    try check("<Module><Parallel><Task name='work' out='ctx.value'><Return value={1}/></Task></Parallel></Module>", false);
}

test "RX single and collection schemas reject quoted nested Parallel Task output" {
    try check("<Module><Task name='outer'><Parallel><Task name='work' out='ctx.value'><Return value={1}/></Task></Parallel></Task></Module>", false);
}

test "RX structural schemas accept braced Task output in every placement" {
    try check("<Module><Task name='work' out={1}><Call fn='number' in={1}/></Task></Module>", true);
    try check("<Module><Switch on={true}><Case value={true}><Task name='work' out={1}><Call fn='number' in={1}/></Task></Case></Switch></Module>", true);
    try check("<Module><Parallel><Task name='work' out={1}><Call fn='number' in={1}/></Task></Parallel></Module>", true);
    try check("<Module><Task name='outer'><Parallel><Task name='work' out={1}><Call fn='number' in={1}/></Task></Parallel></Task></Module>", true);
}
