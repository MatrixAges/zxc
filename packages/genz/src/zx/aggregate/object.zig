const std = @import("std");
const zx = @import("zx");
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const generated = @import("genz_options").generated_analysis;

pub const Field = if (generated) u32 else node.Field;

pub fn allocate(self: *Lower, scratch: std.mem.Allocator, count: usize) Lower.Error![]Field {
    return (if (generated) scratch else self.allocator).alloc(Field, count);
}

pub fn operand(names: []const []const u8, index: u32, value: node.ExpressionId) Field {
    return if (generated) @backingInt(value) else .{ .name = names[index], .value = value };
}

pub const Request = struct {
    type_expr: node.ExpressionId,
    names: []const []const u8,
    indices: []const u32,
    fields: []const Field,
};

pub fn lower(self: *Lower, scratch: std.mem.Allocator, request: Request) Lower.Error!node.ExpressionId {
    if (!generated) return self.builder.expression(.{ .object = .{ .type_expr = request.type_expr, .fields = request.fields } });

    const entry = @import("generated_aggregate_object");
    const Input = std.meta.Child(entry.Input);
    const Selection = std.meta.Child(@FieldType(Input, "selection"));
    const Expression = std.meta.Child(@FieldType(std.meta.Child(entry.Output), "expression"));
    const base = self.builder.nodes.expressions.tags.items.len;
    const selection: Selection = .{ .names = request.names, .first = 0, .indices = request.indices, .values = request.fields };

    const input: Input = .{
        .type_expr = @backingInt(request.type_expr),
        .first = @intCast(self.builder.nodes.field_columns.count()),
        .selection = &selection,
    };

    var buffer: [std.heap.page_size_min]u8 = undefined;
    var memory = std.heap.BufferFirstAllocator.init(&buffer, scratch);
    const output = zx.columns.invoke(entry.executeValue, memory.allocator(), &input) catch |err| return failure(err);
    const expression = zx.columns.view(Expression, output.expression);

    try @import("../../node/import_fields.zig").appendObject(self.allocator, &self.builder.nodes.field_columns, &output.fields);
    @import("../../node/import_rows.zig").appendBorrowed(self.allocator, &self.builder.nodes.expressions, &expression) catch |err| return failure(err);

    return @fromBackingInt(@intCast(base));
}

fn failure(err: anyerror) Lower.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => unreachable,
    };
}
