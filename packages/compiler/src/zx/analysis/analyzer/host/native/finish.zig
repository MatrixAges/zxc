const std = @import("std");
const zx = @import("zx");
const Context = @import("context.zig");
const model = @import("model.zig");
const borrow = @import("../../../../ir/canonical/borrow.zig");
const Reference = @import("../../../semantic/resolving/host/model.zig").Reference;
pub const Result = struct { expressions: *const model.Expressions, blocks: *const model.Blocks, native: *const model.Native };

pub fn apply(context: *Context, declarations: []const zx.ast.Declaration, import_names: []const []const u8) std.mem.Allocator.Error!Result {
    while (context.pending.pop()) |pending| switch (pending) {
        .expression => |value| try @import("expressions.zig").fill(context, value),
        .block => |value| try @import("blocks.zig").fill(context, value),
    };

    const types = try context.types.prepare(declarations, null);

    const text = try context.keep(model.Text, .{
        .expression_names = context.expression_names.items,
        .expression_values = context.expression_values.items,
        .field_names = context.field_names.items,
        .parameter_names = context.parameter_names.items,
        .template_values = context.template_values.items,
        .statement_names = context.statement_names.items,
        .destructure_names = context.destructure_names.items,
        .type_references = borrow.slice(@FieldType(model.Text, "type_references"), @as([]const *const Reference, context.type_references.items)),
    });

    const native = try context.keep(model.Native, .{
        .types = borrow.pointer(@FieldType(model.Native, "types"), types.source),
        .text = text,
        .import_names = import_names,
    });

    const expressions = try context.keep(model.Expressions, .{
        .nodes = context.nodes.items,
        .items = context.items.items,
        .fields = context.fields.items,
        .parameters = context.parameters.items,
        .parts = context.parts.items,
        .arms = context.arms.items,
    });

    const blocks = try context.keep(model.Blocks, .{
        .statements = context.statements.items,
        .blocks = context.blocks.items,
        .items = context.block_items.items,
        .names = context.names.items,
        .cases = context.cases.items,
    });

    return .{ .expressions = expressions, .blocks = blocks, .native = native };
}
