const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../../node.zig");
const Builder = @import("../../../builder.zig");
const Self = @This();
pub const Error = std.mem.Allocator.Error || error{UnsupportedNodeType};

builder: Builder,
values: ir.TypeTable,
aliases: []const ?u32,
reads: []const bool,
writes: []const bool,
pub fn create(builder: Builder, values: ir.TypeTable, input_id: ir.TypeId, output_id: ir.TypeId) Error!Self {
    if (comptime !@import("genz_options").generated_analysis) {
        const seed = try @import("types_seed.zig").init(builder, values);

        try seed.mark(input_id, try builder.path(&.{ "application", "Input" }), true);
        try seed.mark(output_id, try builder.path(&.{ "application", "Output" }), false);

        return .{ .builder = builder, .values = values, .aliases = seed.aliases, .reads = seed.reads, .writes = seed.writes };
    }

    const zx = @import("zx");
    const entry = @import("generated_node_napi_plan");
    const Input = std.meta.Child(entry.Input);
    const Bases = std.meta.Child(@FieldType(Input, "bases"));
    const table = ir.TypeTable.borrow(std.meta.Child(@FieldType(Input, "types")), values);

    const bases: Bases = .{
        .capture = null,
        .expression_base = @intCast(builder.nodes.expressions.tags.items.len),
        .statement_base = @intCast(builder.nodes.statements.tags.items.len),
        .field_base = @intCast(builder.nodes.field_columns.count()),
        .serial = 0,
    };

    const input: Input = .{ .types = &table, .input = @backingInt(input_id), .output = @backingInt(output_id), .bases = &bases };
    const output = zx.columns.invoke(entry.executeValue, builder.allocator, &input) catch |err| return failure(err);

    if (!output.valid) return error.OutOfMemory;
    if (!output.supported) return error.UnsupportedNodeType;
    @import("../../../node/import_module.zig").appendBorrowed(builder.allocator, builder.nodes, std.meta.Child(entry.Output), output) catch |err| return failure(err);

    return .{ .builder = builder, .values = values, .aliases = output.aliases, .reads = output.reads, .writes = output.writes };
}

fn failure(err: anyerror) std.mem.Allocator.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => @panic("invalid N-API type plan"),
    };
}

pub fn name(self: Self, prefix: []const u8, id: ir.TypeId) std.mem.Allocator.Error![]const u8 {
    return std.fmt.allocPrint(self.builder.allocator, "{s}{d}", .{ prefix, @backingInt(id) });
}

pub fn typeExpression(self: Self, id: ir.TypeId) std.mem.Allocator.Error!node.ExpressionId {
    return self.builder.identifier(try self.name("Type", id));
}

pub fn layout(self: Self, id: ir.TypeId) std.mem.Allocator.Error!node.ExpressionId {
    return self.builder.field(try self.builder.field(try self.builder.builtin(.typeInfo, &.{try self.typeExpression(id)}), "pointer"), "child");
}
