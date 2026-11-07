const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../node.zig");
const view = @import("../node/view.zig");
const Lower = @import("lower.zig");

pub fn lower(self: *Lower, items: []const ir.ExprId, values: []const node.ExpressionId) Lower.Error!node.ExpressionId {
    if (!@import("genz_options").generated_analysis) return @import("templates/seed.zig").lower(self, items, values);

    const generated = @import("generated_template_emit");
    const Input = std.meta.Child(generated.Input);
    var scratch = std.heap.ArenaAllocator.init(self.workspace);

    defer scratch.deinit();

    const types = ir.TypeTable.borrow(std.meta.Child(@FieldType(Input, "types")), self.program.types);

    const input = Input{
        .types = &types,
        .expression_types = view.slice(@FieldType(Input, "expression_types"), self.program.expressions.types),
        .items = view.slice(@FieldType(Input, "items"), items),
        .values = view.slice(@FieldType(Input, "values"), values),
        .capture = if (self.capture) |capture| &.{ .name = capture.name, .label = capture.label, .failure = @backingInt(capture.failure) } else null,
        .expression_base = @intCast(self.builder.nodes.expressions.tags.items.len),
        .statement_base = @intCast(self.builder.nodes.statements.tags.items.len),
        .field_base = @intCast(self.builder.nodes.field_columns.count()),
        .serial = self.serial,
    };

    const output = generated.executeIn(scratch.allocator(), &input) catch |err| switch (err) {
        error.OutOfMemory, error.IntegerOverflow => return error.OutOfMemory,
        else => unreachable,
    };

    if (!output.valid) return error.OutOfMemory;

    const expressions = view.join(output.expressions.*, output.forms.*);
    const statements = view.join(output.statements.*, output.variables.*);
    const rows = @import("../node/import_rows.zig");

    rows.append(self.allocator, &self.builder.nodes.expressions, &expressions) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        error.InvalidAst => unreachable,
    };

    rows.append(self.allocator, &self.builder.nodes.statements, &statements) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        error.InvalidAst => unreachable,
    };

    self.serial = @intCast(output.serial);
    self.uses_allocator = self.uses_allocator or output.uses_allocator;

    return @fromBackingInt(output.root);
}
