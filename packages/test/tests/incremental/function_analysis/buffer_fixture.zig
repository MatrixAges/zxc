const std = @import("std");
const f = @import("fixture.zig");
const ir = f.ir;
const list_id: u32 = std.meta.tags(ir.Scalar).len;
const nested_id = list_id + 1;
const outer: ir.TypeId = @fromBackingInt(nested_id + 1);
const span = @import("zx").Span{ .start = 0, .end = 0 };

pub fn program(allocator: std.mem.Allocator) !ir.Program {
    var types: ir.TypeStorage = .{};

    for (std.meta.tags(ir.Scalar)) |item| try types.append(allocator, .{ .scalar = item });
    try types.append(allocator, .{ .list = @fromBackingInt(@backingInt(ir.Scalar.u64)) });
    try types.append(allocator, .{ .object = .{ .names = &.{"items"}, .types = &.{list_id}, .len = 1 } });
    try types.append(allocator, .{ .object = .{ .names = &.{"nested"}, .types = &.{nested_id}, .len = 1 } });

    const symbols = try ir.SymbolTable.fromValues(allocator, &.{.{ .name = "in", .type_id = outer, .span = span, .ownership = .borrowed }});
    const reference: ir.Expression = .{ .type_id = outer, .span = span, .value = .{ .reference = @fromBackingInt(0) } };

    const leaf: ir.Function = .{
        .file_name = "identity.zx",
        .input_type = outer,
        .output_type = outer,
        .symbols = symbols,
        .expressions = try ir.ExpressionTable.fromValues(allocator, &.{reference}),
        .body = try ir.ControlBody.fromValues(allocator, &.{.{ .result = @fromBackingInt(0) }}),
    };

    const value: ir.Program = .{
        .file_name = "main.zx",
        .types = try types.finish(allocator),
        .input_type = outer,
        .output_type = outer,
        .symbols = symbols,
        .expressions = try ir.ExpressionTable.fromValues(allocator, &.{ reference, .{
            .type_id = outer,
            .span = span,
            .value = .{ .call = .{ .function = @fromBackingInt(0), .argument = @fromBackingInt(0) } },
        } }),
        .body = try ir.ControlBody.fromValues(allocator, &.{.{ .result = @fromBackingInt(1) }}),
        .functions = try ir.FunctionTable.fromValues(allocator, &.{leaf}),
    };

    try std.testing.expect(value.types.validStructure());
    try std.testing.expect(value.functions.validStructure());
    try std.testing.expect(value.expressions.validStructure());
    try std.testing.expect(try value.body.validStructure(allocator));
    try std.testing.expect(leaf.expressions.validStructure());
    try std.testing.expect(try leaf.body.validStructure(allocator));

    return value;
}

pub fn owned(allocator: std.mem.Allocator, value: ir.Program) !void {
    var summary = try f.checks.summary.create(allocator, value);

    defer summary.deinit();

    const basis = summary.value.basis;
    const slots = &basis.slots;

    try std.testing.expectEqual(@as(u32, 1), slots.count(outer));
    try std.testing.expectEqual(@as(u32, 0), slots.member(outer, 0).offset);
    try std.testing.expectEqual(@as(ir.TypeId, @fromBackingInt(nested_id)), slots.member(outer, 0).type_id);
    try std.testing.expectEqual(@as(u32, 0), slots.member(@fromBackingInt(nested_id), 0).offset);
    try std.testing.expectEqual(@as(ir.TypeId, @fromBackingInt(list_id)), slots.listType(outer, 0));

    const path = try slots.path(summary.arena.allocator(), outer, 0);

    try std.testing.expectEqualSlices(u32, &.{ 0, 0 }, path);
    try std.testing.expectEqualSlices(bool, &.{true}, basis.flow.held[0]);
    try std.testing.expectEqualSlices(bool, &.{false}, basis.flow.written[0]);
    try std.testing.expectEqual(@as(usize, 1), summary.value.uniqueness.functions.len);
    try std.testing.expectEqual(@as(usize, 1), summary.value.uniqueness.functions[0].flags.len);
    try std.testing.expectEqual(@as(usize, 2), summary.value.uniqueness.entry.flags.len);
    for (summary.value.uniqueness.functions[0].flags) |flags| try std.testing.expectEqual(f.checks.summary.Uniqueness.Flags{}, flags);
    for (summary.value.uniqueness.entry.flags) |flags| try std.testing.expectEqual(f.checks.summary.Uniqueness.Flags{}, flags);
    try std.testing.expectEqual(@as(usize, 0), summary.value.uniqueness.functions[0].renewalCount());
    try std.testing.expectEqual(@as(usize, 0), summary.value.uniqueness.entry.renewalCount());
}
