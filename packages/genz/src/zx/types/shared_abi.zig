const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const view = @import("../../node/view.zig");
const rows = @import("../../node/import_rows.zig");
const Lower = @import("../lower.zig");
const generated = @import("generated_shared_abi");

pub fn build(self: *Lower, index: usize) Lower.Error!void {
    const Input = std.meta.Child(generated.Input);
    const types = ir.TypeTable.borrow(std.meta.Child(@FieldType(Input, "types")), self.program.types);
    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var buffered = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const input: Input = .{
        .types = &types,
        .names = self.type_names,
        .cached = view.slice(@FieldType(Input, "cached"), @as([]const node.ExpressionId, self.abi_types)),
        .root = @intCast(index),
        .base = @intCast(self.builder.nodes.expressions.tags.items.len),
    };

    const output = generated.executeValue(buffered.allocator(), &input) catch |err| switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => return error.OutOfMemory,
        else => unreachable,
    };

    if (!output.valid) return error.OutOfMemory;

    const Expressions = std.meta.Child(@FieldType(std.meta.Child(generated.Output), "expressions"));
    var expressions: Expressions = undefined;

    inline for (@typeInfo(Expressions).@"struct".field_names) |name| {
        @field(expressions, name) = @field(output.expressions, name);
    }

    const imported = if (self.type_names != null)
        rows.appendBorrowingText(self.allocator, &self.builder.nodes.expressions, &expressions)

    else
        rows.append(self.allocator, &self.builder.nodes.expressions, &expressions);

    imported catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        error.InvalidAst => unreachable,
    };

    for (output.ids, output.values, output.layouts) |id, value, layout| {
        self.abi_types[id] = @fromBackingInt(value);
        self.abi_layouts[id] = @fromBackingInt(layout);
    }
}
