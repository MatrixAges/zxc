const std = @import("std");
const compiler = @import("compiler");
const fixture = @import("fixture.zig");

fn shape(case: fixture.Case, members: []const []const u8, layers: usize, payload: std.meta.Tag(compiler.ir.Type)) !void {
    var result = try fixture.analyze(std.testing.allocator, case);

    defer result.deinit();

    if (result.value == .diagnostic) std.debug.print("unexpected diagnostic: {s}\n", .{result.value.diagnostic.message});
    try std.testing.expect(result.value == .ir);

    const program = result.value.ir;

    try std.testing.expect(try compiler.validateIr(std.testing.allocator, program) == null);

    var count: usize = 0;

    for (0..program.expressions.count()) |expression_index| {
        const expression = program.expressions.at(expression_index);

        if (expression.value != .capture) continue;

        count += 1;
        const tuple = program.typeOf(expression.type_id);

        try std.testing.expect(tuple == .tuple);
        try std.testing.expectEqual(@as(usize, 2), tuple.tuple.len);

        const errors = program.typeOf(tuple.tuple.at(0));

        try std.testing.expect(errors == .optional);
        try fixture.expectErrors(program.typeOf(errors.optional).error_set, members);

        var value = program.typeOf(tuple.tuple.at(1));
        const original = program.expression(expression.value.capture).type_id;

        try std.testing.expectEqual(original, if (layers == 0) tuple.tuple.at(1) else value.optional);

        for (0..layers) |_| {
            try std.testing.expect(value == .optional);

            value = program.typeOf(value.optional);
        }

        try std.testing.expectEqual(payload, std.meta.activeTag(value));

        if (layers == 0) try std.testing.expectEqual(.void, value.scalar);
    }

    try std.testing.expectEqual(@as(usize, 1), count);
}

test "captured scalar has optional finite errors and optional original result" {
    try shape(.{ .body = "  const [err, res] = try native.apply(in)\n\n  return res ?? 0" }, &.{"NativeFailure"}, 1, .scalar);
}

test "captured optional keeps an inner optional beneath the success wrapper" {
    try shape(.{ .body = "  const [err, res] = try native.apply(in)\n\n  return in", .declaration = "export declare function apply(input: u64): u64? throws { NativeFailure }\n" }, &.{"NativeFailure"}, 2, .scalar);
}

test "captured void keeps a void second slot" {
    try shape(.{ .body = "  const [err, _] = try native.apply(in)\n\n  return in", .declaration = "export declare function apply(input: u64): void throws { NativeFailure }\n" }, &.{"NativeFailure"}, 0, .scalar);
}

test "captured infallible native has an empty finite error set" {
    try shape(.{ .body = "  const [err, res] = try native.apply(in)\n\n  return res ?? 0", .declaration = "export declare function apply(input: u64): u64\n" }, &.{}, 1, .scalar);
}

test "captured empty throws remains an empty finite error set" {
    try shape(.{ .body = "  const [err, res] = try native.apply(in)\n\n  return res ?? 0", .declaration = "export declare function apply(input: u64): u64 throws {}\n" }, &.{}, 1, .scalar);
}

test "captured multiple errors preserve the complete member set" {
    try shape(.{ .body = "  const [err, res] = try native.apply(in)\n\n  return res ?? 0", .declaration = "export declare function apply(input: u64): u64 throws { ZetaFailure, AlphaFailure }\n" }, &.{ "AlphaFailure", "ZetaFailure" }, 1, .scalar);
}

test "captured string keeps its scalar payload type" {
    try shape(.{ .body = "  const [err, res] = try native.apply(in)\n\n  return in", .declaration = "export declare function apply(input: u64): string throws { NativeFailure }\n" }, &.{"NativeFailure"}, 1, .scalar);
}

test "captured list preserves the list beneath its optional" {
    try shape(.{ .body = "  const [err, res] = try native.apply(in)\n\n  return in", .declaration = "export declare function apply(input: u64): u64[] throws { NativeFailure }\n" }, &.{"NativeFailure"}, 1, .list);
}

test "captured index has the built in bounds error" {
    try shape(.{ .input = "u64[]", .body = "  const [err, res] = try in[0]\n\n  return res ?? 0" }, &.{"IndexOutOfBounds"}, 1, .scalar);
}

test "capture unions errors from nested ordinary native calls" {
    try shape(.{ .body = "  const [err, res] = try native.apply(native.other(in))\n\n  return res ?? 0", .declaration = "export declare function apply(input: u64): u64 throws { OuterFailure }\n\nexport declare function other(input: u64): u64 throws { InnerFailure }\n" }, &.{ "InnerFailure", "OuterFailure" }, 1, .scalar);
}

test "capture deduplicates errors shared by nested calls" {
    try shape(.{ .body = "  const [err, res] = try native.apply(native.other(in))\n\n  return res ?? 0", .declaration = "export declare function apply(input: u64): u64 throws { SharedFailure }\n\nexport declare function other(input: u64): u64 throws { SharedFailure }\n" }, &.{"SharedFailure"}, 1, .scalar);
}

test "capture includes list allocation and nested call errors" {
    try shape(.{ .body = "  const [err, res] = try [native.apply(in), in]\n\n  return in" }, &.{ "NativeFailure", "OutOfMemory" }, 1, .list);
}

test "nested capture separates the inner errors from outer tuple allocation" {
    var result = try fixture.analyze(std.testing.allocator, .{ .body = "  const [outerErr, pair] = try (try native.apply(in))\n\n  return in" });

    defer result.deinit();

    try std.testing.expect(result.value == .ir);

    const program = result.value.ir;

    try std.testing.expect(try compiler.validateIr(std.testing.allocator, program) == null);

    var count: usize = 0;

    for (0..program.expressions.count()) |expression_index| {
        const expression = program.expressions.at(expression_index);

        if (expression.value != .capture) continue;

        count += 1;
        const tuple = program.typeOf(expression.type_id).tuple;
        const errors = program.typeOf(program.typeOf(tuple.at(0)).optional).error_set;
        const nested = program.expression(expression.value.capture).value == .capture;

        try fixture.expectErrors(errors, if (nested) &.{"OutOfMemory"} else &.{"NativeFailure"});
    }

    try std.testing.expectEqual(@as(usize, 2), count);
}
