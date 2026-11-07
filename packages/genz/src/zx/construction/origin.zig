const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");

pub fn lower(self: *Lower, id: ir.TypeId, value: node.ExpressionId) Lower.Error!node.ExpressionId {
    const generated = @import("generated_tuple_origin");
    const Input = std.meta.Child(generated.Input);
    const kind = self.program.typeOf(id);
    const ast = @import("ast.zig").borrow(std.meta.Child(@FieldType(Input, "table")), self);

    const input: Input = .{
        .table = &ast,
        .value = @backingInt(value),
        .active = self.state_active,
        .selected = if (self.state_active) self.state_plan.selected[@backingInt(id)] else false,
        .is_tuple = kind == .tuple,
        .arity = if (kind == .tuple) kind.tuple.len else 0,
        .expression_base = @intCast(self.builder.nodes.expressions.tags.items.len),
    };

    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var buffered = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const output = generated.executeIn(buffered.allocator(), &input) catch |err| switch (@as(anyerror, err)) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => return error.OutOfMemory,
        else => unreachable,
    };

    if (!output.valid) return error.OutOfMemory;
    try @import("apply.zig").expressions(self, output);

    return @fromBackingInt(output.root);
}
