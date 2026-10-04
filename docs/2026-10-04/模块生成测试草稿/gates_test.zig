const std = @import("std");
const f = @import("fixture.zig");

test "diagnostic analysis cannot generate modules" {
    var analysis = try f.compiler.project.analyze(std.testing.allocator, &.{.{ .path = "main.zx", .source = "export type Input = ;" }}, .{ .entry = "main.zx" });

    defer analysis.deinit();

    try std.testing.expectError(error.InvalidAnalysis, f.compiler.zig.emitModules(std.testing.allocator, &analysis));
}

test "invalid IR cannot generate modules" {
    var analysis = try f.analyze(std.testing.allocator, false);

    defer analysis.deinit();

    analysis.value.ir.version = 0;

    try std.testing.expectError(error.InvalidIr, f.compiler.zig.emitModules(std.testing.allocator, &analysis));
}

test "unverified contracts cannot generate modules" {
    var analysis = try f.compiler.project.analyze(std.testing.allocator, &.{.{
        .path = "main.zx",
        .source = "export type Input = u8; export type Output = u8; export default function (in: Input): Output requires(in < 255) ensures(out > in) { return in + 1; }",
    }}, .{ .entry = "main.zx" });

    defer analysis.deinit();

    try std.testing.expect(analysis.value == .ir);
    try std.testing.expectError(error.UnverifiedContracts, f.compiler.zig.emitModules(std.testing.allocator, &analysis));
}

test "cache hit bundle remains owned after cache and analyses are destroyed" {
    var retained = block: {
        var cache = f.compiler.zig.GenerationCache.init(std.testing.allocator);

        defer cache.deinit();

        var analysis = try f.analyze(std.testing.allocator, false);

        defer analysis.deinit();

        var first = try f.compiler.zig.emitModulesCached(std.testing.allocator, &analysis, &cache);

        defer first.deinit();

        var result = try f.compiler.zig.emitModulesCached(std.testing.allocator, &analysis, &cache);

        errdefer result.deinit();

        var changed = try f.analyze(std.testing.allocator, true);

        defer changed.deinit();

        var replacement = try f.compiler.zig.emitModulesCached(std.testing.allocator, &changed, &cache);

        defer replacement.deinit();

        break :block result;
    };

    defer retained.deinit();

    var analysis = try f.analyze(std.testing.allocator, false);

    defer analysis.deinit();

    var fresh = try f.compiler.zig.emitModules(std.testing.allocator, &analysis);

    defer fresh.deinit();

    try f.same(retained, fresh);
}
