const std = @import("std");
const zx = @import("zx");
const node = @import("../../node.zig");
const Builder = @import("../../builder.zig");
const Object = @import("../state.zig").Object;

pub fn lower(builder: Builder, declarations: *std.ArrayList(node.Declaration), objects: []const Object) std.mem.Allocator.Error!void {
    if (!@import("genz_options").generated_analysis) {
        const storage = @import("storage.zig");

        try @import("region.zig").lower(builder, declarations, storage.writable(objects));
        try declarations.append(builder.allocator, try @import("reclaim.zig").lower(builder, objects, storage.reclaimable(objects)));

        return;
    }

    const entry = @import("generated_store_regions");
    const Parameter = @typeInfo(@TypeOf(entry.executeValue)).@"fn".param_types[1].?;
    const indirect = @typeInfo(Parameter) == .pointer;
    const Input = if (indirect) std.meta.Child(Parameter) else Parameter;
    const Bases = std.meta.Child(@FieldType(Input, "bases"));
    const first = builder.nodes.declaration_rows.tags.items.len;

    const bases: Bases = .{
        .capture = null,
        .expression_base = @intCast(builder.nodes.expressions.tags.items.len),
        .statement_base = @intCast(builder.nodes.statements.tags.items.len),
        .field_base = @intCast(builder.nodes.field_columns.count()),
        .serial = 0,
    };

    const input: Input = .{
        .objects = zx.columns.slice(@FieldType(Input, "objects"), objects),
        .bases = &bases,
        .declaration_base = @intCast(first),
    };

    var scratch = std.heap.ArenaAllocator.init(builder.allocator);

    defer scratch.deinit();

    const output = entry.executeValue(scratch.allocator(), if (indirect) &input else input) catch |err| return failure(err);

    if (!output.valid) return error.OutOfMemory;

    const Output = std.meta.Child(entry.Output);
    @import("../../node/import_module.zig").append(builder.allocator, builder.nodes, Output, output) catch |err| return failure(err);
    for (first..builder.nodes.declaration_rows.tags.items.len) |index| try declarations.append(builder.allocator, try builder.nodes.materializeDeclaration(builder.allocator, @intCast(index)));
}

fn failure(err: anyerror) std.mem.Allocator.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => @panic("invalid Store region AST"),
    };
}
