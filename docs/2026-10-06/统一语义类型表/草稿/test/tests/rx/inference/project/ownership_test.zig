const std = @import("std");
const rx = @import("rx");
const analysis = @import("rx_analysis");
const output = @import("../ownership/output.zig");

fn check(main_source: []const u8, expected: output.Shape) !void {
    const texts = [_][]const u8{
        main_source,
        "<Module><Call fn='make' in={$in}/><Return value={$ctx.make}/></Module>",
        "<Module><Call fn='make' in={$in}/><Return value={$ctx.make}/></Module>",
        "<Module><Call fn='borrowed' in={$in}/><Return value={$ctx.borrowed}/></Module>",
        "<Module><Call module='./owned.rx' in={$in}/><Return value={$ctx.owned}/></Module>",
    };

    const names = [_][]const u8{ "main.rx", "owned.rx", "owned_other.rx", "borrowed.rx", "relay.rx" };
    var parsed: [5]rx.XmlResult = undefined;
    var count: usize = 0;

    defer for (parsed[0..count]) |*item| item.deinit();

    for (texts, &parsed) |text, *item| {
        item.* = try rx.parseXml(std.testing.allocator, text);
        count += 1;

        try std.testing.expect(item.value == .node);
    }

    var sources: [5]rx.ModuleSource = undefined;

    for (names, parsed, &sources) |name, item, *source| source.* = .{ .path = name, .node = item.value.node };

    var result = try analysis.project.infer(std.testing.allocator, .{
        .entry = "main.rx",
        .modules = &sources,
        .sources = &.{
            .{ .path = "pop_values.zx", .source = @import("rx_collection_fixtures").pop_values },
            .{ .path = "pop_other.zx", .source = @import("rx_collection_fixtures").pop_values },
            .{ .path = "make.zx", .source = @embedFile("../ownership/fixtures/make.zx") },
            .{ .path = "borrowed.zx", .source = @embedFile("../ownership/fixtures/borrowed.zx") },
        },
    });

    defer result.deinit();

    if (result.value == .diagnostic) {
        const issue = result.value.diagnostic;

        std.debug.print("{s}:{d}:{d}: {s}: {s}\n", .{ issue.path, issue.location.line, issue.location.column, issue.code, issue.message });

        return error.UnexpectedDiagnostic;
    }

    try output.check(result.value.contract.program, expected);
}

test "RX module owned result supports immutable pop" {
    try check("<Module><Call module='./owned.rx' in={$in}/><Call fn='pop_values' in={$ctx.owned}/><Return value={$ctx.pop_values}/></Module>", .pop);
}

test "RX module borrowed result supports immutable pop" {
    try check("<Module><Call module='./borrowed.rx' in={$in}/><Call fn='pop_values' in={$ctx.borrowed}/><Return value={$ctx.pop_values}/></Module>", .pop);
}

test "RX module independent results support immutable pop" {
    try check("<Module><Call module='./owned.rx' in={$in}/><Call module='./owned_other.rx' in={$in}/><Call fn='pop_values' in={$ctx.owned}/><Call fn='pop_other' in={$ctx.owned_other}/><Return value={{left: $ctx.pop_values, right: $ctx.pop_other}}/></Module>", .{ .fields = &.{ .{ .name = "left", .kind = .pop }, .{ .name = "right", .kind = .pop } } });
}

test "RX module same input supports repeated immutable pop" {
    try check("<Module><Call module='./owned.rx' in={$in}/><Call fn='pop_values' in={$ctx.owned}/><Call fn='pop_other' in={$ctx.owned}/><Return value={{first: $ctx.pop_values, second: $ctx.pop_other}}/></Module>", .{ .fields = &.{ .{ .name = "first", .kind = .pop }, .{ .name = "second", .kind = .pop } } });
}

test "RX module immutable pop preserves a borrowed alias" {
    try check("<Module><Call module='./owned.rx' in={$in}/><Call module='./borrowed.rx' in={$ctx.owned}/><Call fn='pop_values' in={$ctx.owned}/><Return value={{changed: $ctx.pop_values, alias: $ctx.borrowed}}/></Module>", .{ .fields = &.{ .{ .name = "alias", .kind = .list }, .{ .name = "changed", .kind = .pop } } });
}

test "RX module relayed result supports immutable pop" {
    try check("<Module><Call module='./relay.rx' in={$in}/><Call fn='pop_values' in={$ctx.relay}/><Return value={$ctx.pop_values}/></Module>", .pop);
}
