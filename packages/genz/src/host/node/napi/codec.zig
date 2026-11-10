const std = @import("std");
const zx = @import("zx");
const node = @import("../../../node.zig");
const Types = @import("types.zig");

pub fn lower(types: Types, id: zx.ir.TypeId, reading: bool) Types.Error!node.Declaration {
    const builder = types.builder;
    const entry = @import("generated_node_napi_codec");
    const Input = std.meta.Child(entry.Input);
    const Bases = std.meta.Child(@FieldType(Input, "bases"));
    const table = zx.ir.TypeTable.borrow(std.meta.Child(@FieldType(Input, "types")), types.values);
    const bases: Bases = .{ .capture = null, .expression_base = @intCast(builder.nodes.expressions.tags.items.len), .statement_base = @intCast(builder.nodes.statements.tags.items.len), .field_base = @intCast(builder.nodes.field_columns.count()), .serial = 0 };
    const input: Input = .{ .types = &table, .id = @backingInt(id), .reading = reading, .bases = &bases };
    const output = zx.columns.invoke(entry.executeValue, builder.allocator, &input) catch |err| return failure(err);

    if (!output.supported) return error.UnsupportedNodeType;
    if (!output.valid) return error.OutOfMemory;

    const first = builder.nodes.declaration_rows.tags.items.len;
    @import("../../../node/import_module.zig").appendBorrowed(builder.allocator, builder.nodes, std.meta.Child(@FieldType(std.meta.Child(entry.Output), "module")), output.module) catch |err| return failure(err);

    return builder.nodes.materializeDeclaration(builder.allocator, @intCast(first));
}

fn failure(err: anyerror) std.mem.Allocator.Error {
    return switch (err) { error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory, else => @panic("invalid N-API codec AST") };
}
