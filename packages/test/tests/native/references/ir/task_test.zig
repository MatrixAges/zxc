const std = @import("std");
const frontend = @import("frontend");
const checks = @import("native_ir_checks");
const f = @import("fixture.zig");
const task = @import("task.zig");

fn beforeTask(allocator: std.mem.Allocator, program: f.ir.Program) !void {
    try std.testing.expect(frontend.validateTypes(program.types));

    for (0..program.expressions.count()) |index| {
        try std.testing.expect(checks.expressions.validate(program, index));
    }

    try std.testing.expect(try checks.scopes.validate(allocator, program));
}

fn rejected(mode: task.Mode) !void {
    const allocator = std.testing.allocator;
    var result = try task.analyze(allocator, mode);

    defer result.deinit();

    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const program = try task.apply(arena.allocator(), result.value.ir, mode);

    try beforeTask(allocator, program);
    try std.testing.expect(!try checks.tasks.validate(allocator, program));
    try f.rejected(allocator, program);
}

test "independent task IR permits scalar results and captures beside unused native references" {
    const allocator = std.testing.allocator;

    for ([_]task.Mode{ .result, .capture }) |mode| {
        var result = try task.analyze(allocator, mode);

        defer result.deinit();

        try beforeTask(allocator, result.value.ir);
        try std.testing.expect(try checks.tasks.validate(allocator, result.value.ir));
    }
}

test "independent task IR rejects an optional native reference result without captures" {
    try rejected(.result);
}

test "independent task IR rejects a native reference list capture with scalar result" {
    try rejected(.capture);
}
