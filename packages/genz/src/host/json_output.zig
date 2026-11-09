const std = @import("std");
const zx = @import("zx");
const node = @import("../node.zig");
const Builder = @import("../builder.zig");

pub const Output = struct { types: zx.ir.TypeTable, id: zx.ir.TypeId };

pub fn lower(builder: Builder, output: Output) std.mem.Allocator.Error!node.Block {
    return lowerFailure(builder, output, &.{.{ .result = try builder.expression(.{ .error_value = "NonFiniteJsonNumber" }) }});
}

pub fn lowerFailure(builder: Builder, output: Output, failure: []const node.Statement) std.mem.Allocator.Error!node.Block {
    if (comptime !@import("genz_options").generated_analysis) return @import("json_output_seed.zig").lowerFailure(builder, .{ .types = output.types, .id = output.id }, failure);

    const entry = @import("generated_json_output");
    const Input = std.meta.Child(entry.Input);
    const Bases = std.meta.Child(@FieldType(Input, "bases"));
    const types = zx.ir.TypeTable.borrow(std.meta.Child(@FieldType(Input, "types")), output.types);
    const failed = try builder.statements(failure);

    const bases: Bases = .{
        .capture = null,
        .expression_base = @intCast(builder.nodes.expressions.tags.items.len),
        .statement_base = @intCast(builder.nodes.statements.tags.items.len),
        .field_base = @intCast(builder.nodes.field_columns.count()),
        .serial = 0,
    };

    const input: Input = .{
        .bases = &bases,
        .types = &types,
        .type_id = @backingInt(output.id),
        .failure_first = failed.start,
        .failure_count = failed.len,
    };

    const result = zx.columns.invoke(entry.executeValue, builder.allocator, &input) catch |err| return generatedFailure(err);

    if (!result.valid) return error.OutOfMemory;
    @import("../node/import_module.zig").appendBorrowed(builder.allocator, builder.nodes, std.meta.Child(entry.Output), result) catch |err| return generatedFailure(err);

    return .{ .start = result.first, .len = result.count };
}

fn generatedFailure(err: anyerror) std.mem.Allocator.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => @panic("invalid JSON output AST"),
    };
}
