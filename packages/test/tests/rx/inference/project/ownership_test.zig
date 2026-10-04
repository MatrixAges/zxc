const std = @import("std");
const rx = @import("rx");
const analysis = @import("rx_analysis");
const compiler = @import("compiler");

fn check(main_source: []const u8, accepted: bool) !void {
    const texts = [_][]const u8{
        main_source,
        "<Module><Call fn='make' in='$in' out='ctx.items'/><Return value='ctx.items'/></Module>",
        "<Module><Call fn='borrowed' in='$in' out='ctx.items'/><Return value='ctx.items'/></Module>",
        "<Module><Call service='./owned.rx' in='$in' out='ctx.items'/><Return value='ctx.items'/></Module>",
    };
    const names = [_][]const u8{ "main.rx", "owned.rx", "borrowed.rx", "relay.rx" };
    var parsed: [4]rx.XmlResult = undefined;
    var count: usize = 0;

    defer for (parsed[0..count]) |*item| item.deinit();

    for (texts, &parsed) |text, *item| {
        item.* = try rx.parseXml(std.testing.allocator, text);
        count += 1;

        try std.testing.expect(item.value == .node);
    }

    var sources: [4]rx.ModuleSource = undefined;

    for (names, parsed, &sources) |name, item, *source| source.* = .{ .path = name, .node = item.value.node };

    var result = try analysis.project.infer(std.testing.allocator, .{
        .entry = "main.rx",
        .modules = &sources,
        .sources = &.{
            .{ .path = "make.zx", .source = @embedFile("../ownership/fixtures/make.zx") },
            .{ .path = "borrowed.zx", .source = @embedFile("../ownership/fixtures/borrowed.zx") },
        },
    });

    defer result.deinit();

    if (!accepted) {
        try std.testing.expect(result.value == .diagnostic);
        try std.testing.expectEqualStrings("ownership", result.value.diagnostic.code);
        try std.testing.expectEqualStrings("main.rx", result.value.diagnostic.path);

        return;
    }

    if (result.value == .diagnostic) {
        const issue = result.value.diagnostic;
        std.debug.print("{s}:{d}:{d}: {s}: {s}\n", .{ issue.path, issue.location.line, issue.location.column, issue.code, issue.message });

        return error.UnexpectedDiagnostic;
    }

    try std.testing.expect(try compiler.validateIr(std.testing.allocator, result.value.contract.program) == null);
}

test "RX service owned return can be consumed" {
    try check("<Module><Call service='./owned.rx' in='$in' out='ctx.items'/><Return value='ctx.items.pop()'/></Module>", true);
}

test "RX service borrowed return cannot be consumed" {
    try check("<Module><Call service='./borrowed.rx' in='$in' out='ctx.items'/><Return value='ctx.items.pop()'/></Module>", false);
}

test "RX service independent owned returns can both be consumed" {
    try check("<Module><Call service='./owned.rx' in='$in' out='ctx.left'/><Call service='./owned.rx' in='$in' out='ctx.right'/><Return value='{left: ctx.left.pop(), right: ctx.right.pop()}'/></Module>", true);
}

test "RX service same owner cannot be consumed twice" {
    try check("<Module><Call service='./owned.rx' in='$in' out='ctx.items'/><Return value='{first: ctx.items.pop(), second: ctx.items.pop()}'/></Module>", false);
}

test "RX service borrowed alias prevents consuming original owner" {
    try check("<Module><Call service='./owned.rx' in='$in' out='ctx.items'/><Call service='./borrowed.rx' in='ctx.items' out='ctx.alias'/><Return value='{changed: ctx.items.pop(), alias: ctx.alias}'/></Module>", false);
}

test "RX service owned return remains owned through relay" {
    try check("<Module><Call service='./relay.rx' in='$in' out='ctx.items'/><Return value='ctx.items.pop()'/></Module>", true);
}
