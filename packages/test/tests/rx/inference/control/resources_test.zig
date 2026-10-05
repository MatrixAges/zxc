const std = @import("std");
const allocation_testing = @import("allocation_testing");
const rx = @import("rx");
const analysis = @import("rx_analysis");
const compiler = @import("compiler");
const Mode = enum { success, scope, duplicate };

fn check(allocator: std.mem.Allocator, mode: Mode) !void {
    const source = switch (mode) {
        .success => "<Module><Call fn=\"./helper.zx\" in={$in.value}/><Switch on={$in.enabled}><Case value={true}><Call fn=\"./inner.zx\" in={$ctx.helper}/><Return value={$ctx.inner}/></Case><Case value={false}><Call fn=\"./inner.zx\" in={$ctx.helper}/><Return value={$ctx.inner}/></Case></Switch></Module>",
        .scope => "<Module><Call fn=\"./helper.zx\" in={$in.value}/><Task name=\"t\"><Call fn=\"./inner.zx\" in={$ctx.helper}/></Task><Return value={$ctx.inner}/></Module>",
        .duplicate => "<Module><Switch on={\"x\"}><Case value={\"x\"}><Return value={1}/></Case><Case value={\"x\"}><Return value={2}/></Case><Default><Return value={3}/></Default></Switch></Module>",
    };

    var parsed = try rx.parseXml(allocator, source);

    defer parsed.deinit();

    try std.testing.expect(parsed.value == .node);

    var result = try analysis.project.infer(allocator, .{
        .entry = "main.rx",
        .modules = &.{.{ .path = "main.rx", .node = parsed.value.node }},
        .sources = &.{
            .{ .path = "helper.zx", .source = @embedFile("../project/fixtures/number.zx") },
            .{ .path = "inner.zx", .source = @embedFile("../project/fixtures/number.zx") },
        },
    });

    defer result.deinit();

    if (mode == .success) {
        try std.testing.expect(result.value == .contract);
        try std.testing.expect(try compiler.validateIr(allocator, result.value.contract.program) == null);
    } else {
        try std.testing.expect(result.value == .diagnostic);
        try std.testing.expectEqualStrings(if (mode == .scope) "name" else "context", result.value.diagnostic.code);
        try std.testing.expectEqualStrings("main.rx", result.value.diagnostic.path);
    }
}

test "RX control success allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, check, .{Mode.success});
}

test "RX control scope allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, check, .{Mode.scope});
}

test "RX control duplicate allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, check, .{Mode.duplicate});
}
