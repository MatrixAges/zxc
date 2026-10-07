const std = @import("std");
const ir = @import("zx").ir;
const model = @import("model.zig");

pub fn expression(allocator: std.mem.Allocator, table: model.Table, index: usize) std.mem.Allocator.Error!ir.Expression {
    const source = @import("read.zig").expression(&table, index);

    const value: @FieldType(ir.Expression, "value") = switch (source.value) {
        .parallel => |view| blk: {
            const values = try allocator.alloc(ir.ParallelBranch, view.len);

            for (values, 0..) |*item, position| item.* = view.at(position);

            break :blk .{ .parallel = values };
        },
        .scope => |item| blk: {
            const bindings = try allocator.alloc(ir.ScopeBinding, item.bindings.len);

            for (bindings, 0..) |*binding, position| binding.* = item.bindings.at(position);

            break :blk .{ .scope = .{ .bindings = bindings, .result = item.result } };
        },
        .match_expr => |item| blk: {
            const arms = try allocator.alloc(ir.MatchArm, item.arms.len);

            for (arms, 0..) |*arm, position| arm.* = item.arms.at(position);

            break :blk .{ .match_expr = .{ .subject = item.subject, .arms = arms, .fallback = item.fallback } };
        },
        .object => |item| blk: {
            const fields = try allocator.alloc(ir.ObjectField, item.fields.len);

            for (fields, 0..) |*field, position| field.* = item.fields.at(position);

            break :blk .{ .object = .{ .fields = fields, .evaluation = item.evaluation } };
        },
        inline else => |item, tag| @unionInit(@FieldType(ir.Expression, "value"), @tagName(tag), item),
    };

    return .{ .type_id = source.type_id, .span = source.span, .value = value };
}
