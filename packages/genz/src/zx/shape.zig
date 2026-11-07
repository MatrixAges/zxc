const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../node.zig");
const Lower = @import("lower.zig");

pub fn lower(self: *Lower, declarations: *std.ArrayList(node.Declaration)) Lower.Error!void {
    if (!@import("genz_options").generated_analysis) return @import("shape/seed.zig").lower(self, declarations);

    const generated = @import("generated_shape_declarations");
    const Input = std.meta.Child(generated.Input);
    var scratch = std.heap.ArenaAllocator.init(self.workspace);

    defer scratch.deinit();

    const types = ir.TypeTable.borrow(std.meta.Child(@FieldType(Input, "types")), self.program.types);

    const input = Input{
        .types = &types,
        .input = @backingInt(self.program.input_type),
        .output = @backingInt(self.program.output_type),
        .expression_base = @intCast(self.builder.nodes.expressions.tags.items.len),
        .field_base = @intCast(self.builder.nodes.field_columns.count()),
        .declaration_base = @intCast(declarations.items.len),
    };

    const output = generated.executeIn(scratch.allocator(), &input) catch |err| switch (err) {
        error.OutOfMemory, error.IntegerOverflow => return error.OutOfMemory,
        else => unreachable,
    };

    if (!output.valid) return error.OutOfMemory;

    @import("../node/import_rows.zig").append(self.allocator, &self.builder.nodes.expressions, output.expressions) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        error.InvalidAst => unreachable,
    };

    @import("../node/import_fields.zig").append(self.allocator, &self.builder.nodes.field_columns, output.fields) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        error.InvalidAst => unreachable,
    };

    @import("../node/import_constants.zig").append(self.allocator, declarations, output.declarations) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        error.InvalidAst => unreachable,
    };
}
