const std = @import("std");
const zx = @import("zx");
const node = @import("../node.zig");
const Builder = @import("../builder.zig");
const Route = @import("root.zig").Route;

pub fn lower(builder: Builder, routes: []const Route) std.mem.Allocator.Error!node.Declaration {
    if (comptime !@import("genz_options").generated_analysis) return @import("dispatch_seed.zig").lower(builder, routes);

    const entry = @import("generated_gateway_dispatch");
    const Parameter = @typeInfo(@TypeOf(entry.executeValue)).@"fn".param_types[1].?;
    const indirect = @typeInfo(Parameter) == .pointer;
    const Input = if (indirect) std.meta.Child(Parameter) else Parameter;
    const Bases = std.meta.Child(@FieldType(Input, "bases"));
    const Routes = @FieldType(Input, "routes");
    const framed = @typeInfo(Routes) == .@"struct";
    const Slice = if (framed) @FieldType(Routes, "items") else Routes;
    const borrowed = zx.columns.storage.view(Slice, routes);

    const bases: Bases = .{
        .capture = null,
        .expression_base = @intCast(builder.nodes.expressions.tags.items.len),
        .statement_base = @intCast(builder.nodes.statements.tags.items.len),
        .field_base = @intCast(builder.nodes.field_columns.count()),
        .serial = 0,
    };

    const input: Input = .{
        .bases = &bases,
        .routes = if (framed) .{ .items = borrowed, .storage = .plain } else borrowed,
        .declaration_base = @intCast(builder.nodes.declaration_rows.tags.items.len),
    };

    const output = entry.executeValue(builder.allocator, if (indirect) &input else input) catch |err| return failure(err);

    if (output.invalid_route) @panic("invalid Gateway method group");
    if (!output.valid) return error.OutOfMemory;

    const Output = @TypeOf(output);
    const Module = if (@typeInfo(Output) == .pointer) std.meta.Child(Output) else Output;
    @import("../node/import_module.zig").appendBorrowed(builder.allocator, builder.nodes, Module, output) catch |err| return failure(err);

    return builder.nodes.materializeDeclaration(builder.allocator, output.root);
}

fn failure(err: anyerror) std.mem.Allocator.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => @panic("invalid Gateway dispatch AST"),
    };
}
