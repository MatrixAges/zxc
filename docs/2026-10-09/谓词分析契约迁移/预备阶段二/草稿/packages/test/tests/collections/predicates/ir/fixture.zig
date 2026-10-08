const std = @import("std");
pub const compiler = @import("compiler");
pub const ir = compiler.ir;
const span: @import("zx").Span = .{ .start = 0, .end = 0 };

fn scalar(value: ir.Scalar) ir.TypeId {
    return @fromBackingInt(@backingInt(value));
}

pub fn program(allocator: std.mem.Allocator, kind: @FieldType(ir.Transform, "kind"), context: bool) !ir.Program {
    var types: ir.TypeStorage = .{};

    for (std.enums.values(ir.Scalar)) |value| try types.append(allocator, .{ .scalar = value });

    const list: ir.TypeId = @fromBackingInt(@intCast(types.count()));

    try types.append(allocator, .{ .list = scalar(.i64) });

    const symbols = try ir.SymbolTable.fromValues(allocator, &.{
        .{ .name = "in", .type_id = list, .span = span, .ownership = .borrowed },
        .{ .name = "item", .type_id = scalar(.i64), .span = span },
        .{ .name = "context", .type_id = scalar(.bool), .span = span },
    });

    const expressions = try ir.ExpressionTable.fromValues(allocator, &.{
        .{ .type_id = list, .span = span, .value = .{ .reference = @fromBackingInt(0) } },
        .{ .type_id = scalar(.bool), .span = span, .value = .{ .boolean = true } },
        .{ .type_id = scalar(.bool), .span = span, .value = .{ .boolean = false } },
        .{ .type_id = scalar(.bool), .span = span, .value = .{ .transform = .{
            .kind = kind,
            .target = @fromBackingInt(0),
            .parameters = if (context) &.{ @fromBackingInt(1), @fromBackingInt(2) } else &.{@fromBackingInt(1)},
            .body = @fromBackingInt(1),
            .initial = if (context) @fromBackingInt(2) else null,
        } } },
    });

    return .{
        .file_name = "legacy_predicate.zx",
        .types = types.view(),
        .symbols = symbols,
        .expressions = expressions,
        .input_type = list,
        .output_type = scalar(.bool),
        .output_ownership = .copy,
        .body = try ir.ControlBody.fromValues(allocator, &.{.{ .result = @fromBackingInt(3) }}),
    };
}

pub fn valid(value: ir.Program) !void {
    try std.testing.expect(try compiler.validateIr(std.testing.allocator, value) == null);
}

pub fn invalid(value: ir.Program) !void {
    const issue = (try compiler.validateIr(std.testing.allocator, value)).?;

    try std.testing.expectEqual(.contract, issue.code);
}
