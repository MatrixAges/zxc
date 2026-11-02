const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const view = @import("../../node/view.zig");
const Lower = @import("../lower.zig");
const generated = @import("generated_state_types");

pub fn build(self: *Lower, declarations: *std.ArrayList(node.Declaration), exported: bool) Lower.Error!void {
    const Input = std.meta.Child(generated.Input);
    const Output = std.meta.Child(@FieldType(std.meta.Child(generated.Output), "types"));
    const types = ir.TypeTable.borrow(std.meta.Child(@FieldType(Input, "types")), self.program.types);
    const allocator = self.allocator;
    const keys = try allocator.alloc([]const u8, self.state_plan.keys.len);

    for (self.state_plan.keys, keys) |*key, *target| target.* = key;

    const input: Input = .{
        .types = &types,
        .selected = self.state_plan.selected,
        .keys = keys,
        .names = self.type_names,
        .abi_types = view.slice(@FieldType(Input, "abi_types"), @as([]const node.ExpressionId, self.abi_types)),
        .abi_layouts = view.slice(@FieldType(Input, "abi_layouts"), @as([]const node.ExpressionId, self.abi_layouts)),
        .base = @intCast(self.builder.nodes.expressions.tags.items.len),
        .field_base = @intCast(self.builder.nodes.field_columns.count()),
        .exported = exported,
    };

    const result = generated.executeValue(allocator, &input) catch |err| switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => return error.OutOfMemory,
        else => unreachable,
    };

    const output = result.types;

    if (!output.valid) return error.OutOfMemory;
    try @import("import.zig").append(self, declarations, Output, output, result.fields, .retain);

    for (output.values, output.layouts, output.views, self.state_types, self.state_layouts, self.view_types) |value, layout, projected, *state_type, *state_layout, *view_type| {
        state_type.* = @fromBackingInt(value);
        state_layout.* = @fromBackingInt(layout);
        view_type.* = @fromBackingInt(projected);
    }
}
