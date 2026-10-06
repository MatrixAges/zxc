const std = @import("std");
const zx = @import("zx");
const f = @import("task_fixture");
const compiler = f.compiler;

const Expected = struct {
    operand: std.meta.Tag(@FieldType(compiler.ir.Expression, "value")) = .reference,
    payload: std.meta.Tag(compiler.ir.Type) = .scalar,
    scalar: compiler.ir.Scalar = .u64,
    task_errors: []const []const u8 = &.{"NativeFailure"},
    errors: []const []const u8 = &.{},
};

fn shape(case: f.Case, expected: Expected) !void {
    var result = try f.analyze(std.testing.allocator, case);

    defer result.deinit();

    if (result.value == .diagnostic) std.debug.print("unexpected diagnostic: {s}\n", .{result.value.diagnostic.message});
    try std.testing.expect(result.value == .ir);

    const program = result.value.ir;

    try std.testing.expect(try compiler.validateIr(std.testing.allocator, program) == null);

    const effects = (try zx.error_effects.program(std.testing.allocator, program)).?;

    defer std.testing.allocator.free(effects);

    try f.expectErrors(effects, expected.errors);

    var count: usize = 0;

    for (program.expressions) |expression| {
        if (expression.value != .cancel_task) continue;

        count += 1;
        const operand = program.expression(expression.value.cancel_task);
        const target = program.typeOf(operand.type_id).task;
        const payload = program.typeOf(target.result);

        try std.testing.expectEqual(.void, program.typeOf(expression.type_id).scalar);
        try std.testing.expectEqual(expected.operand, std.meta.activeTag(operand.value));
        try std.testing.expectEqual(expected.payload, std.meta.activeTag(payload));
        if (payload == .scalar) try std.testing.expectEqual(expected.scalar, payload.scalar);
        try f.expectErrors(program.typeOf(target.errors).error_set, expected.task_errors);
    }

    try std.testing.expectEqual(@as(usize, 1), count);
}

test "cancel scalar task returns void without propagating its business errors" {
    try shape(.{ .body = "const work = async native.apply(in)\ncancel work\nreturn in" }, .{});
}

test "cancel optional task keeps its original optional payload metadata" {
    try shape(.{ .body = "const work = async native.apply(in)\ncancel work\nreturn in", .declaration = "export declare function apply(input: u64): u64? throws { NativeFailure } concurrent\n" }, .{ .payload = .optional });
}

test "direct cancel async void has a task operand and no outer task errors" {
    try shape(.{ .body = "cancel async native.effect(in)\nreturn in" }, .{ .operand = .task, .scalar = .void, .task_errors = &.{"EffectFailure"} });
}

test "cancel leaves later native errors in the caller effect set" {
    try shape(.{ .body = "const work = async native.apply(in)\ncancel work\nreturn native.other(in)" }, .{ .errors = &.{"OtherFailure"} });
}
