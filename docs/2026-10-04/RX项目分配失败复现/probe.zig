const std = @import("std");
const rx = @import("rx");
const analysis = @import("analysis");
const compiler = @import("compiler");
const Mode = enum { success, conflict, cycle };

fn check(allocator: std.mem.Allocator, mode: Mode) !void {
    const main = switch (mode) {
        .success => @embedFile("main.rx"),
        .conflict => "<Module><Call service='./identity.rx' in='1'/><Call service='./identity.rx' in='\"text\"'/></Module>",
        .cycle => "<Module><Call service='./bridge.rx' in='$in'/></Module>",
    };
    const bridge = if (mode == .cycle) "<Module><Call service='./main.rx' in='$in'/></Module>" else @embedFile("bridge.rx");
    const texts = [_][]const u8{ main, bridge, @embedFile("identity.rx") };
    const names = [_][]const u8{ "main.rx", "bridge.rx", "identity.rx" };
    var parsed: [3]rx.XmlResult = undefined;
    var count: usize = 0;

    defer for (parsed[0..count]) |*item| item.deinit();

    for (texts, &parsed) |text, *item| {
        item.* = try rx.parseXml(allocator, text);
        count += 1;

        try std.testing.expect(item.value == .node);
    }

    var sources: [3]rx.ModuleSource = undefined;

    for (names, parsed, &sources) |name, item, *source| source.* = .{ .path = name, .node = item.value.node };

    var result = try analysis.project.infer(allocator, .{
        .entry = "main.rx",
        .modules = &sources,
        .sources = &.{.{ .path = "number.zx", .source = @embedFile("number.zx") }},
    });

    defer result.deinit();

    if (mode != .success) {
        try std.testing.expect(result.value == .diagnostic);
        try std.testing.expectEqualStrings(if (mode == .cycle) "context" else "type_mismatch", result.value.diagnostic.code);

        if (mode == .cycle) {
            try std.testing.expectEqualStrings("bridge.rx", result.value.diagnostic.path);
            try std.testing.expect(std.mem.indexOf(u8, result.value.diagnostic.message, "circular") != null);
        }

        return;
    }

    if (result.value == .diagnostic) {
        std.debug.print("{s}: {s}\n", .{ result.value.diagnostic.code, result.value.diagnostic.message });

        return error.UnexpectedDiagnostic;
    }

    const contract = result.value.contract;

    try std.testing.expectEqualDeep(compiler.ir.Type{ .scalar = .u64 }, contract.types[@intFromEnum(contract.input_type)]);
    try std.testing.expectEqualDeep(compiler.ir.Type{ .scalar = .u64 }, contract.types[@intFromEnum(contract.output_type)]);
    try std.testing.expect(try compiler.validateIr(allocator, contract.program) == null);
}

test "RX project successful chain allocation failures" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, check, .{Mode.success});
}

test "RX project shared service conflict allocation failures" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, check, .{Mode.conflict});
}

test "RX project circular dependency allocation failures" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, check, .{Mode.cycle});
}
