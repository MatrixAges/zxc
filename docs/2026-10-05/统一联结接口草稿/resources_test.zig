const std = @import("std");
const f = @import("fixture.zig");
const compiler = f.compiler;

test "library owns export names paths and programs after analyses are released" {
    var name = [_]u8{ 'r', 'u', 'n' };
    var result = block: {
        var left = try f.analyze("call.zx", f.function);
        defer left.deinit();
        var right = try f.analyze("types.zx", f.declaration);
        defer right.deinit();

        break :block try compiler.library.link(std.testing.allocator, &.{ .{ .name = &name, .analysis = &left }, .{ .name = "types", .analysis = &right } });
    };
    defer result.deinit();
    @memset(&name, 'x');

    try std.testing.expectEqualStrings("run", result.exports[0].name);
    try std.testing.expectEqualStrings("/project/call.zx", result.exports[0].path);
    try std.testing.expectEqualStrings("Mode", result.exports[1].types[0].name);

    for (0..2) |index| {
        var analysis = compiler.AnalysisResult{ .arena = std.heap.ArenaAllocator.init(std.testing.allocator), .value = .{ .ir = try result.module(index) }, .nominal_types = result.nominal_types };
        defer analysis.deinit();
        try std.testing.expect(try compiler.validateIr(std.testing.allocator, analysis.value.ir) == null);

        var emitted = try compiler.zig.emitModules(std.testing.allocator, &analysis);
        defer emitted.deinit();
        try std.testing.expect(emitted.entry.source.len > 0);
        try std.testing.expect(emitted.types.len > 0);
    }
}

fn allocation(allocator: std.mem.Allocator, analysis: *const compiler.AnalysisResult, duplicate: bool) !void {
    const inputs = [_]compiler.library.Input{ .{ .name = "first", .analysis = analysis }, .{ .name = if (duplicate) "first" else "second", .analysis = analysis } };

    if (duplicate) {
        const result = compiler.library.link(allocator, &inputs);
        if (result) |value| {
            var unexpected = value;
            unexpected.deinit();
            return error.ExpectedDuplicateExport;
        } else |err| {
            if (err == error.OutOfMemory) return err;
            try std.testing.expectEqual(error.DuplicateExport, err);
        }
    } else {
        var result = try compiler.library.link(allocator, &inputs);
        defer result.deinit();
        try std.testing.expectEqual(@as(usize, 2), result.exports.len);
        try std.testing.expect(result.exports[0].function != result.exports[1].function);
    }
}

test "library successful shared source linkage releases every failed allocation" {
    var analysis = try f.analyze("call.zx", f.function);
    defer analysis.deinit();
    try std.testing.checkAllAllocationFailures(std.testing.allocator, allocation, .{ &analysis, false });
}

test "library duplicate export rejection releases partial linkage" {
    var analysis = try f.analyze("call.zx", f.function);
    defer analysis.deinit();
    try std.testing.checkAllAllocationFailures(std.testing.allocator, allocation, .{ &analysis, true });
}

test "library rejects empty input and invalid public name bytes" {
    try std.testing.expectError(error.InvalidModule, compiler.library.link(std.testing.allocator, &.{}));
    var analysis = try f.analyze("call.zx", f.function);
    defer analysis.deinit();

    for ([_][]const u8{ "", "bad\x00name", "bad\xffname" }) |name| {
        try std.testing.expectError(error.InvalidModule, compiler.library.link(std.testing.allocator, &.{.{ .name = name, .analysis = &analysis }}));
    }
}

test "library rejects actual frontend diagnostic results" {
    var analysis = try compiler.project.analyze(std.testing.allocator, &.{.{ .path = "invalid.zx", .source = "not valid zx" }}, .{ .entry = "invalid.zx", .root_dir = "/project" });
    defer analysis.deinit();
    try std.testing.expect(analysis.value == .diagnostic);
    try std.testing.expectError(error.InvalidAnalysis, compiler.library.link(std.testing.allocator, &.{.{ .name = "invalid", .analysis = &analysis }}));
}
