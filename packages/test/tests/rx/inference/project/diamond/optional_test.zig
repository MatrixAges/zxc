const std = @import("std");
const rx = @import("rx");
const analysis = @import("rx_analysis");
const compiler = @import("compiler");

fn field(types: []const compiler.ir.Type, id: compiler.ir.TypeId, name: []const u8, optional: bool) !void {
    const object = types[@intFromEnum(id)];

    try std.testing.expect(object == .object);
    try std.testing.expectEqual(@as(usize, 2), object.object.len);

    for (object.object) |item| {
        if (!std.mem.eql(u8, item.name, name)) continue;

        var value = types[@intFromEnum(item.type_id)];

        if (optional) {
            try std.testing.expect(value == .optional);
            value = types[@intFromEnum(value.optional)];
        }

        try std.testing.expectEqualDeep(compiler.ir.Type{ .scalar = .u64 }, value);

        return;
    }

    return error.MissingField;
}

fn check(reverse_calls: bool, reverse_modules: bool) !void {
    const texts = [_][]const u8{
        if (reverse_calls) @embedFile("fixtures/main_reverse.rx") else @embedFile("fixtures/main_forward.rx"),
        @embedFile("fixtures/forwarder.rx"),
        @embedFile("fixtures/forwarder.rx"),
        @embedFile("fixtures/identity.rx"),
    };
    const names = [_][]const u8{ "main.rx", "left.rx", "right.rx", "identity.rx" };
    var parsed: [4]rx.XmlResult = undefined;
    var count: usize = 0;

    defer for (parsed[0..count]) |*item| item.deinit();

    for (texts, &parsed) |text, *item| {
        item.* = try rx.parseXml(std.testing.allocator, text);
        count += 1;

        try std.testing.expect(item.value == .node);
    }

    var sources: [4]rx.ModuleSource = undefined;

    for (0..4) |index| {
        const target = if (reverse_modules) 3 - index else index;
        sources[target] = .{ .path = names[index], .node = parsed[index].value.node };
    }

    var result = try analysis.project.infer(std.testing.allocator, .{
        .entry = "main.rx",
        .modules = &sources,
        .sources = &.{
            .{ .path = "number.zx", .source = @embedFile("fixtures/number.zx") },
            .{ .path = "optional.zx", .source = @embedFile("fixtures/optional.zx") },
        },
    });

    defer result.deinit();

    if (result.value == .diagnostic) {
        const issue = result.value.diagnostic;
        std.debug.print("{s}:{d}:{d}: {s}: {s}\n", .{ issue.path, issue.location.line, issue.location.column, issue.code, issue.message });

        return error.UnexpectedDiagnostic;
    }

    const contract = result.value.contract;

    try field(contract.types, contract.input_type, "number", false);
    try field(contract.types, contract.input_type, "maybe", true);
    try field(contract.types, contract.output_type, "left", true);
    try field(contract.types, contract.output_type, "right", true);
    try std.testing.expect(try compiler.validateIr(std.testing.allocator, contract.program) == null);
}

test "RX diamond required caller first with forward registration" {
    try check(false, false);
}

test "RX diamond optional caller first with forward registration" {
    try check(true, false);
}

test "RX diamond required caller first with reverse registration" {
    try check(false, true);
}

test "RX diamond optional caller first with reverse registration" {
    try check(true, true);
}
