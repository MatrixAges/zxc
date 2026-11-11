const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const rows = @import("../../node/import_rows.zig");
const Self = @This();

name: []const u8,
value: node.ExpressionId,
reference: node.ExpressionId,
pub const empty: Self = .{ .name = &.{}, .value = @fromBackingInt(0), .reference = @fromBackingInt(0) };

pub fn lower(lowering: *Lower, id: ir.ExprId) Lower.Error!Self {
    return bind(lowering, try lowering.expr(id));
}

noinline fn bind(lowering: *Lower, value: node.ExpressionId) Lower.Error!Self {
    const entry = @import("generated_operand_reference");
    const Input = std.meta.Child(entry.Input);

    const input: Input = .{
        .expression_base = @intCast(lowering.builder.nodes.expressions.tags.items.len),
        .serial = lowering.serial,
    };

    var scratch = std.heap.ArenaAllocator.init(lowering.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var memory = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const output = zx.columns.invoke(entry.executeValue, memory.allocator(), &input) catch |err| return failure(err);

    if (!output.valid) return error.OutOfMemory;

    const name = try lowering.allocator.dupe(u8, output.name);
    const names = [_][]const u8{name};
    var expressions = zx.columns.view(std.meta.Child(@FieldType(std.meta.Child(entry.Output), "expressions")), output.expressions);

    expressions.identifier = &names;

    rows.appendBorrowed(lowering.allocator, &lowering.builder.nodes.expressions, &expressions) catch |err| return failure(err);

    lowering.serial = output.serial;

    return .{ .name = name, .value = value, .reference = @fromBackingInt(output.root) };
}

fn failure(err: anyerror) Lower.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => unreachable,
    };
}
