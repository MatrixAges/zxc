const std = @import("std");
const compiler = @import("compiler");
const f = @import("record_fixture");
const artifact = compiler.project.artifact;

test "extract rejects diagnostic analysis" {
    var analysis = try compiler.project.analyze(std.testing.allocator, &.{.{ .path = "main.zx", .source = "export type Input = \n" }}, .{ .entry = "main.zx" });

    defer analysis.deinit();

    try std.testing.expectError(error.InvalidAnalysis, artifact.extract(std.testing.allocator, &analysis, 0));
}

test "extract rejects out of range module index" {
    var analysis = try f.analyze(std.testing.allocator);

    defer analysis.deinit();

    try std.testing.expectError(error.InvalidModule, artifact.extract(std.testing.allocator, &analysis, analysis.modules.len));
}

test "extract rejects invalid complete IR before copying" {
    var analysis = try f.analyze(std.testing.allocator);

    defer analysis.deinit();

    analysis.value.ir.version = 0;

    try std.testing.expectError(error.InvalidIr, artifact.extract(std.testing.allocator, &analysis, 0));
}

test "referenced enum requires a nominal declaration origin" {
    var analysis = try f.analyze(std.testing.allocator);

    defer analysis.deinit();

    analysis.nominal_types = .{};

    try std.testing.expectError(error.MissingNominalOrigin, artifact.extract(std.testing.allocator, &analysis, 0));
}

test "unreferenced enum without origin does not block a scalar helper" {
    var analysis = try f.analyze(std.testing.allocator);

    defer analysis.deinit();

    analysis.nominal_types = .{};

    var result = try artifact.extract(std.testing.allocator, &analysis, 1);

    defer result.deinit();

    try std.testing.expectEqual(@as(usize, 0), result.value.nominal_types.count());
}

test "duplicate origin for a referenced enum is rejected" {
    var analysis = try f.analyze(std.testing.allocator);

    defer analysis.deinit();

    inline for (@typeInfo(@TypeOf(analysis.nominal_types)).@"struct".field_names) |name| {
        const column = @field(analysis.nominal_types, name);

        @field(analysis.nominal_types, name) = try analysis.arena.allocator().dupe(@TypeOf(column[0]), &.{ column[0], column[0] });
    }

    try std.testing.expectError(error.InvalidModule, artifact.extract(std.testing.allocator, &analysis, 0));
}
