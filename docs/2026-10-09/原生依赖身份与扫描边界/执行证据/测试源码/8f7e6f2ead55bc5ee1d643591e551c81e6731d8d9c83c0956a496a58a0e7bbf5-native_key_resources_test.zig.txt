const std = @import("std");
const allocation_testing = @import("allocation_testing");
const h = @import("native_keys/check.zig");
const f = h.f;
const Kind = enum { identified, fallback, missing };
const Context = struct { analysis: *const f.compiler.AnalysisResult, selected: usize, before: []const u8, restored: []const f.Record, keys: []const []const u8 };

fn run(allocator: std.mem.Allocator, context: Context, missing: bool) !void {
    var result = f.artifact.extract(allocator, context.analysis, context.selected) catch |err| {
        try f.unchanged(context.before, context.analysis.*);

        var recovered = context.analysis.*;
        recovered.modules = context.restored;

        try h.accepted(&recovered, context.selected, context.keys);

        if (err == error.OutOfMemory) return err;
        try std.testing.expect(missing);
        try std.testing.expectEqual(error.InvalidModule, err);

        return;
    };

    defer result.deinit();

    try std.testing.expect(!missing);
    try h.module(context.analysis.*, context.selected, result.value, context.keys);
    try f.unchanged(context.before, context.analysis.*);
}

fn sweep(kind: Kind) !void {
    var analysis = try f.analyze(f.orders[0], kind != .fallback);

    defer analysis.deinit();

    var imports = [_]f.Import{ try f.dependency(analysis, f.specifiers[2]), try f.dependency(analysis, f.specifiers[0]), try f.dependency(analysis, f.specifiers[1]) };

    if (kind == .fallback) {
        for (&imports) |*item| item.identity = null;
    }

    const selected = try h.records.types(&analysis, &imports);
    const restored = analysis.modules;

    if (kind == .missing) {
        imports[2].identity = "missing@1";

        try h.records.replace(&analysis, selected, &imports);
    }

    const before = try f.snapshot(analysis);

    defer std.testing.allocator.free(before);

    const context: Context = .{ .analysis = &analysis, .selected = selected, .before = before, .restored = restored, .keys = if (kind == .fallback) &f.specifiers else &f.identities };

    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, run, .{ context, kind == .missing });
}

test "identified native dependency extraction releases every allocation failure and permits retry" {
    try sweep(.identified);
}

test "native specifier fallback releases every allocation failure and permits retry" {
    try sweep(.fallback);
}

test "missing native key after earlier matches releases every allocation failure and permits restored extraction" {
    try sweep(.missing);
}
