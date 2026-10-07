const std = @import("std");
const f = @import("fixture.zig");
const compiler = f.compiler;

const Task = struct {
    tag: std.meta.Tag(compiler.ir.Type) = .scalar,
    scalar: compiler.ir.Scalar = .u64,
    errors: []const []const u8 = &.{},
    captures: []const []const u8 = &.{"in"},
};

fn task(case: f.Case, expected: Task) !void {
    var result = try f.analyze(std.testing.allocator, case);

    defer result.deinit();

    if (result.value == .diagnostic) std.debug.print("unexpected diagnostic: {s}\n", .{result.value.diagnostic.message});
    try std.testing.expect(result.value == .ir);

    const program = result.value.ir;

    try std.testing.expect(try compiler.validateIr(std.testing.allocator, program) == null);

    var count: usize = 0;

    for (program.expressions) |expression| {
        if (expression.value != .task) continue;

        count += 1;
        const value = expression.value.task;
        const target = program.typeOf(expression.type_id).task;
        const payload = program.typeOf(target.result);

        try std.testing.expectEqual(program.expression(value.body).type_id, target.result);
        try std.testing.expectEqual(expected.tag, std.meta.activeTag(payload));
        if (payload == .scalar) try std.testing.expectEqual(expected.scalar, payload.scalar);
        try f.expectErrors(program.typeOf(target.errors).error_set, expected.errors);
        try std.testing.expectEqual(expected.captures.len, value.captures.len);

        for (value.captures, expected.captures) |symbol, name| {
            try std.testing.expectEqualStrings(name, program.symbols.at(@backingInt(symbol)).name);
        }
    }

    try std.testing.expectEqual(@as(usize, 1), count);
}

fn capture(case: f.Case, expected: []const []const u8) !void {
    var result = try f.analyze(std.testing.allocator, case);

    defer result.deinit();

    if (result.value == .diagnostic) std.debug.print("unexpected diagnostic: {s}\n", .{result.value.diagnostic.message});
    try std.testing.expect(result.value == .ir);

    const program = result.value.ir;

    try std.testing.expect(try compiler.validateIr(std.testing.allocator, program) == null);

    var count: usize = 0;

    for (program.expressions) |expression| {
        if (expression.value != .capture) continue;

        count += 1;
        const slots = program.typeOf(expression.type_id).tuple;

        try f.expectErrors(program.typeOf(program.typeOf(slots.at(0)).optional).error_set, expected);
    }

    try std.testing.expectEqual(@as(usize, 1), count);
}

test "scalar task stores its result type finite empty errors and input capture" {
    try task(.{ .body = "const work = async (in + 1)\nreturn await work" }, .{});
}

test "task capture deduplicates repeated references to the same input" {
    try task(.{ .body = "const work = async (in + in)\nreturn await work" }, .{});
}

test "task literal has no outer symbol capture" {
    try task(.{ .body = "return await async 7" }, .{ .captures = &.{} });
}

test "task captures local bindings in first reference order" {
    try task(.{ .body = "const left = in + 1\nconst right = in + 2\nconst work = async (right + left + right)\nreturn await work" }, .{ .captures = &.{ "right", "left" } });
}

test "native task stores the declared finite error set" {
    try task(.{ .body = "const work = async native.apply(in)\nreturn await work" }, .{ .errors = &.{"NativeFailure"} });
}

test "optional native task preserves its optional result payload" {
    try task(.{ .body = "return await async native.apply(in)", .output = "u64?", .declaration = "export declare function apply(input: u64): u64? throws { NativeFailure } concurrent\n" }, .{ .tag = .optional, .errors = &.{"NativeFailure"} });
}

test "void native task keeps void payload and its finite error" {
    try task(.{ .body = "const work = async native.effect(in)\nawait work\nreturn in" }, .{ .scalar = .void, .errors = &.{"EffectFailure"} });
}

test "task includes list allocation and native operand errors" {
    try task(.{ .body = "return await async [native.apply(in), in]", .output = "u64[]" }, .{ .tag = .list, .errors = &.{ "NativeFailure", "OutOfMemory" } });
}

test "try await catches the task error set rather than creation effects" {
    try capture(.{ .body = "const work = async native.apply(in)\nconst [err, res] = try await work\nreturn res ?? 0" }, &.{"NativeFailure"});
}

test "try parallel unions branch startup and result allocation errors" {
    try capture(.{ .body = "const [err, res] = try parallel({ first: () => native.apply(in), second: () => native.other(in) })\nreturn in" }, &.{ "ConcurrencyUnavailable", "NativeFailure", "OtherFailure", "OutOfMemory" });
}

test "try all void parallel excludes result allocation error" {
    try capture(.{ .body = "const [err, _] = try parallel({ first: () => native.effect(in), second: () => native.effect(in) })\nreturn in" }, &.{ "ConcurrencyUnavailable", "EffectFailure" });
}

test "parallel preserves source branch order and maps canonical fields by name" {
    var result = try f.analyze(std.testing.allocator, .{ .body = "const values = parallel({ zeta: () => in + 1, effect: () => native.effect(in), alpha: () => in + 2 })\nreturn values.alpha + values.zeta" });

    defer result.deinit();

    if (result.value == .diagnostic) std.debug.print("unexpected diagnostic: {s}\n", .{result.value.diagnostic.message});

    try std.testing.expect(result.value == .ir);

    const program = result.value.ir;

    try std.testing.expect(try compiler.validateIr(std.testing.allocator, program) == null);

    var count: usize = 0;

    for (program.expressions) |expression| {
        if (expression.value != .parallel) continue;

        count += 1;
        const fields = program.typeOf(expression.type_id).object;
        const branches = expression.value.parallel;

        try std.testing.expectEqual(@as(usize, 2), fields.len);
        try std.testing.expectEqual(@as(usize, 3), branches.len);
        try std.testing.expectEqualStrings("zeta", fields.at(branches[0].field.?).name);
        try std.testing.expectEqual(@as(?u32, null), branches[1].field);
        try std.testing.expectEqualStrings("alpha", fields.at(branches[2].field.?).name);
        try std.testing.expect(@backingInt(branches[0].task) < @backingInt(branches[1].task));
        try std.testing.expect(@backingInt(branches[1].task) < @backingInt(branches[2].task));
    }

    try std.testing.expectEqual(@as(usize, 1), count);
}
