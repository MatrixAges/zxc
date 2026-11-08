const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const node = @import("../../node.zig");
const view = @import("../../node/view.zig");
const Lower = @import("../lower.zig");

pub fn lower(self: *Lower, type_id: ir.TypeId, values: []const node.ExpressionId) Lower.Error!node.ExpressionId {
    const generated = @import("generated_static_list_emit");
    const Input = std.meta.Child(generated.Input);
    const Output = std.meta.Child(generated.Output);
    const element = try self.typeExpr(self.program.typeOf(type_id).list);
    const target = try @import("../types.zig").get(self, self.abi_types, type_id);

    const input: Input = .{
        .values = view.slice(@FieldType(Input, "values"), values),
        .element = @backingInt(element),
        .target = @backingInt(target),
        .base = @intCast(self.builder.nodes.expressions.tags.items.len),
    };

    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var buffered = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const output = zx.columns.invoke(generated.executeValue, buffered.allocator(), @as(*const Input, &input)) catch |err| switch (err) {
        error.OutOfMemory, error.IntegerOverflow => return error.OutOfMemory,
        else => unreachable,
    };

    if (!output.valid) return error.OutOfMemory;

    var rows = zx.columns.view(std.meta.Child(@FieldType(Output, "nodes")), output.nodes);
    const arguments = try self.allocator.dupe(u32, rows.builtin_arguments[0]);

    rows.builtin_arguments = &.{arguments};

    @import("../../node/import_rows.zig").appendBorrowed(self.allocator, &self.builder.nodes.expressions, &rows) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        error.InvalidAst => unreachable,
    };

    return @fromBackingInt(output.root);
}
