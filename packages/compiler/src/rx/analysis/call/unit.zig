const std = @import("std");
const zx = @import("zx");
const rx = @import("rx");

pub fn create(allocator: std.mem.Allocator, owner: []const u8, types: zx.ir.TypeTable, location: rx.ast.Location) std.mem.Allocator.Error!zx.ir.Program {
    const void_type: zx.ir.TypeId = @fromBackingInt(@intCast(@backingInt(zx.ir.Scalar.void)));
    const span = zx.Span{ .start = location.offset, .end = location.offset };

    return .{
        .file_name = try allocator.dupe(u8, owner),
        .types = types,
        .input_type = void_type,
        .output_type = void_type,
        .symbols = try zx.ir.SymbolTable.fromValues(allocator, &.{.{ .name = "$in", .type_id = void_type, .span = span }}),
        .expressions = try zx.ir.ExpressionTable.fromValues(allocator, &.{.{ .type_id = void_type, .span = span, .value = .unit }}),
        .body = try allocator.dupe(zx.ir.Statement, &.{.{ .result = @fromBackingInt(@intCast(0)) }}),
    };
}
