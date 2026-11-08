const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const node = @import("../node.zig");
const view = @import("../node/view.zig");
const Lower = @import("lower.zig");

pub fn lower(self: *Lower, value: ir.ExpressionRow, items: []const ir.ExprId) Lower.Error!?node.ExpressionId {
    if (!@import("genz_options").generated_analysis) return @import("static_list/seed.zig").lower(self, value, items);
    if (!candidate(self, value.type_id, items)) return null;

    const values = try self.allocator.alloc(node.ExpressionId, items.len);

    for (items, values) |item, *expression| expression.* = try self.expr(item);

    return try @import("static_list/emit.zig").lower(self, value.type_id, values);
}

fn candidate(self: *const Lower, type_id: ir.TypeId, items: []const ir.ExprId) bool {
    const generated = @import("generated_static_list_candidate");
    const Input = std.meta.Child(generated.Input);
    const types = ir.TypeTable.borrow(std.meta.Child(@FieldType(Input, "types")), self.program.types);

    const input: Input = .{
        .scalar = self.entry_flags.scalar,
        .types = &types,
        .kinds = zx.columns.slice(@FieldType(Input, "kinds"), self.program.expressions.kinds),
        .type_id = @backingInt(type_id),
        .items = view.slice(@FieldType(Input, "items"), items),
    };

    var memory = std.heap.FixedBufferAllocator.init(&.{});

    return zx.columns.invoke(generated.executeValue, memory.allocator(), @as(*const Input, &input)) catch unreachable;
}
