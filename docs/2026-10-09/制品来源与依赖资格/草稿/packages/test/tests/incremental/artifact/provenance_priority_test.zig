const std = @import("std");
const h = @import("provenance/check.zig");
const f = h.f;

fn missing(mode: enum { only, path, compiled }) !void {
    var analysis = try f.analyze(f.orders[0]);

    defer analysis.deinit();

    var selected = try f.index(analysis, f.main_path);

    if (mode == .path) selected = try h.mutation.source(&analysis, .entry_path);
    if (mode == .compiled) try h.mutation.compiled(&analysis, selected, 0);

    analysis.nominal_types = .{};

    try h.rejected(&analysis, selected, if (mode == .only) error.MissingNominalOrigin else error.InvalidModule);
}

test "legal source and dependency gates expose a required missing nominal origin" {
    try missing(.only);
}

test "entry source mismatch precedes missing nominal origin planning" {
    try missing(.path);
}

test "compiled dependency precedes missing nominal origin planning" {
    try missing(.compiled);
}

test "invalid complete IR precedes compiled dependency qualification" {
    var analysis = try f.analyze(f.orders[0]);

    defer analysis.deinit();

    const selected = try f.index(analysis, f.main_path);

    try h.mutation.compiled(&analysis, selected, 0);

    analysis.value.ir.version = 0;

    try std.testing.expectError(error.InvalidIr, f.artifact.extract(std.testing.allocator, &analysis, selected));
}

test "out of range module selection precedes invalid complete IR validation" {
    var analysis = try f.analyze(f.orders[0]);

    defer analysis.deinit();

    analysis.value.ir.version = 0;

    try std.testing.expectError(error.InvalidModule, f.artifact.extract(std.testing.allocator, &analysis, analysis.modules.len));
}

test "diagnostic analysis precedes out of range module selection" {
    var analysis = try f.compiler.project.analyze(std.testing.allocator, &.{.{ .path = "bad.zx", .source = "export type Input =\n" }}, .{ .entry = "bad.zx" });

    defer analysis.deinit();

    try std.testing.expect(analysis.value == .diagnostic);
    try std.testing.expectError(error.InvalidAnalysis, f.artifact.extract(std.testing.allocator, &analysis, std.math.maxInt(usize)));
}
