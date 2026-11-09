const std = @import("std");
const zx = @import("zx");
const node = @import("../node.zig");
const Builder = @import("../builder.zig");
const Service = @import("root.zig").Service;

pub fn lower(builder: Builder, service: Service, index: usize) std.mem.Allocator.Error!node.Declaration {
    if (comptime !@import("genz_options").generated_analysis) return @import("invoke_seed.zig").lower(builder, service, index);

    const entry = @import("generated_gateway_invoke");
    const Input = std.meta.Child(entry.Input);
    const Bases = std.meta.Child(@FieldType(Input, "bases"));
    const types = zx.ir.TypeTable.borrow(std.meta.Child(@FieldType(Input, "types")), service.output.types);

    const bases: Bases = .{
        .capture = null,
        .expression_base = @intCast(builder.nodes.expressions.tags.items.len),
        .statement_base = @intCast(builder.nodes.statements.tags.items.len),
        .field_base = @intCast(builder.nodes.field_columns.count()),
        .serial = 0,
    };

    const input: Input = .{
        .bases = &bases,
        .declaration_base = @intCast(builder.nodes.declaration_rows.tags.items.len),
        .index = index,
        .slot_count = service.slots.len,
        .requires_io = service.requires_io,
        .requires_process = service.requires_process,
        .types = &types,
        .output_type = @backingInt(service.output.id),
    };

    const output = zx.columns.invoke(entry.executeValue, builder.allocator, &input) catch |err| return failure(err);

    if (!output.valid) return error.OutOfMemory;

    const Output = @TypeOf(output);
    const Module = if (@typeInfo(Output) == .pointer) std.meta.Child(Output) else Output;
    @import("../node/import_module.zig").appendBorrowed(builder.allocator, builder.nodes, Module, output) catch |err| return failure(err);

    return try builder.nodes.materializeDeclaration(builder.allocator, output.root);
}

fn failure(err: anyerror) std.mem.Allocator.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => @panic("invalid Gateway invocation AST"),
    };
}
