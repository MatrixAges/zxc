const std = @import("std");
const rx = @import("rx");
const analysis = @import("rx_analysis");
const compiler = @import("compiler");

fn check(order: [3]usize) !void {
    const texts = [_][]const u8{
        @embedFile("fixtures/main.rx"),
        @embedFile("fixtures/bridge.rx"),
        @embedFile("fixtures/identity.rx"),
    };

    const names = [_][]const u8{ "main.rx", "bridge.rx", "identity.rx" };
    var parsed: [3]rx.XmlResult = undefined;
    var count: usize = 0;

    defer for (parsed[0..count]) |*item| item.deinit();

    for (texts, &parsed) |text, *item| {
        item.* = try rx.parseXml(std.testing.allocator, text);
        count += 1;

        try std.testing.expect(item.value == .node);
    }

    var sources: [3]rx.ModuleSource = undefined;

    for (order, &sources) |index, *source| source.* = .{ .path = names[index], .node = parsed[index].value.node };

    var result = try analysis.project.infer(std.testing.allocator, .{
        .entry = "main.rx",
        .modules = &sources,
        .sources = &.{.{ .path = "number.zx", .source = @embedFile("fixtures/number.zx") }},
    });

    defer result.deinit();

    if (result.value == .diagnostic) {
        const issue = result.value.diagnostic;

        std.debug.print("{s}:{d}:{d}: {s}: {s}\n", .{ issue.path, issue.location.line, issue.location.column, issue.code, issue.message });

        return error.UnexpectedDiagnostic;
    }

    const contract = result.value.contract;

    try std.testing.expectEqualDeep(compiler.ir.Type{ .scalar = .u64 }, contract.types.get(contract.input_type));
    try std.testing.expectEqualDeep(compiler.ir.Type{ .scalar = .u64 }, contract.types.get(contract.output_type));
    try std.testing.expect(contract.program.functions.len > 0);
    try std.testing.expect(try compiler.validateIr(std.testing.allocator, contract.program) == null);
}

test "RX project registration main bridge identity" {
    try check(.{ 0, 1, 2 });
}

test "RX project registration main identity bridge" {
    try check(.{ 0, 2, 1 });
}

test "RX project registration bridge main identity" {
    try check(.{ 1, 0, 2 });
}

test "RX project registration bridge identity main" {
    try check(.{ 1, 2, 0 });
}

test "RX project registration identity main bridge" {
    try check(.{ 2, 0, 1 });
}

test "RX project registration identity bridge main" {
    try check(.{ 2, 1, 0 });
}
