const std = @import("std");
const zx = @import("zx");
const node = @import("../../node.zig");
const view = @import("../../node/view.zig");
const rows = @import("../../node/import_rows.zig");
const Lower = @import("../lower.zig");

pub fn lower(self: *Lower, type_id: zx.ir.TypeId) Lower.Error!node.Declaration {
    const generated = @import("generated_ordering_emit");
    const Input = std.meta.Child(generated.Input);
    const Output = std.meta.Child(generated.Output);
    const Naming = std.meta.Child(@FieldType(Input, "naming"));

    const naming: Naming = .{
        .type_id = @backingInt(type_id),
        .scalar = @backingInt(self.program.typeOf(type_id).scalar),
        .named = self.type_names != null,
    };

    const type_expr = try self.typeExpr(type_id);

    const input: Input = .{
        .naming = &naming,
        .type_expr = @backingInt(type_expr),
        .expression_base = @intCast(self.builder.nodes.expressions.tags.items.len),
        .statement_base = @intCast(self.builder.nodes.statements.tags.items.len),
    };

    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var buffered = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const output = zx.columns.invoke(generated.executeValue, buffered.allocator(), @as(*const Input, &input)) catch |err| switch (err) {
        error.OutOfMemory, error.IntegerOverflow => return error.OutOfMemory,
        else => unreachable,
    };

    if (!output.valid) return error.OutOfMemory;

    const expression_rows = zx.columns.view(std.meta.Child(@FieldType(Output, "expressions")), output.expressions);
    const forms = zx.columns.view(std.meta.Child(@FieldType(Output, "forms")), output.forms);
    const statements = zx.columns.view(std.meta.Child(@FieldType(Output, "statements")), output.statements);
    const expressions = view.join(expression_rows, forms);

    try append(self, &self.builder.nodes.expressions, &expressions);
    try append(self, &self.builder.nodes.statements, &statements);

    const parameters = try self.allocator.alloc(node.Field, output.fields.name.len);

    for (parameters, 0..) |*field, index| field.* = .{
        .name = try self.allocator.dupe(u8, output.fields.name[index]),
        .value = @fromBackingInt(output.fields.value[index]),
        .default_value = if (output.fields.default_value[index]) |id| @fromBackingInt(id) else null,
        .comptime_parameter = output.fields.comptime_parameter[index],
    };

    const declaration = output.declaration;

    return .{ .function = .{
        .name = try self.allocator.dupe(u8, declaration.function_name[0]),
        .parameters = parameters[declaration.function_parameters_start[0]..][0..declaration.function_parameters_len[0]],
        .return_type = @fromBackingInt(declaration.function_return_type[0]),
        .body = .{ .start = declaration.function_body_start[0], .len = declaration.function_body_len[0] },
        .exported = declaration.function_exported[0],
        .abi_export = declaration.function_abi_export[0],
        .inlined = declaration.function_inlined[0],
        .calling_convention = if (declaration.function_calling_convention[0]) |id| @fromBackingInt(id) else null,
    } };
}

fn append(self: *Lower, target: anytype, source: anytype) Lower.Error!void {
    rows.append(self.allocator, target, source) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        error.InvalidAst => unreachable,
    };
}
