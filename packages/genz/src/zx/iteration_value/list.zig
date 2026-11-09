const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Context = @import("root.zig");
const Lower = @import("../lower.zig");
const Operand = @import("operand.zig");
const emitting = @import("literals.zig");

pub fn lower(self: *Context, id: ir.TypeId, items: []const ir.ExprId) Lower.Error!node.ExpressionId {
    if (!@import("genz_options").generated_analysis) return @import("list_seed.zig").lower(self, id, items);

    const lowering = self.lowering;
    const element = try @import("types.zig").get(self, lowering.program.typeOf(id).list);
    var scratch = std.heap.ArenaAllocator.init(lowering.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var memory = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const bindings = try emitting.Bindings.init(memory.allocator(), items.len);

    for (items, 0..) |item, index| bindings.set(index, try Operand.lower(lowering, item));

    const layout = try @import("types.zig").get(self, id);

    return emitting.lower(self, .{ .mode = .List, .type_id = id, .layout = layout, .element = element, .bindings = bindings });
}
