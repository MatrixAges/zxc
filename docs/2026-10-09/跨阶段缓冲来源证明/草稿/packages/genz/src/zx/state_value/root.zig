const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
pub const Analysis = @import("analysis.zig");
pub const conversion = @import("conversion.zig");
const Self = @This();

lowering: *Lower,
types: []*const node.Expression,
layouts: []*const node.Expression,
cache: std.AutoHashMapUnmanaged(ir.ExprId, *const node.Expression),
active: bool,
buffer_pointer: bool,
pub fn enter(lowering: *Lower) Lower.Error!Self {
    const self = Self{ .lowering = lowering, .types = lowering.types, .layouts = lowering.layouts, .cache = lowering.cache, .active = lowering.state_active, .buffer_pointer = lowering.buffer_pointer };

    if (self.active) return self;

    var cache: std.AutoHashMapUnmanaged(ir.ExprId, *const node.Expression) = .empty;
    var entries = self.cache.iterator();

    while (entries.next()) |entry| {
        var body: std.ArrayList(node.Statement) = .empty;
        const value = try conversion.convert(lowering, &body, lowering.program.expression(entry.key_ptr.*).type_id, entry.value_ptr.*, .value);

        try cache.put(lowering.allocator, entry.key_ptr.*, try @import("../aggregate.zig").finish(lowering, &body, value));
    }

    lowering.cache = cache;
    lowering.types = lowering.state_types;
    lowering.layouts = lowering.state_layouts;
    lowering.state_active = true;
    lowering.buffer_pointer = false;

    return self;
}

pub fn restore(self: Self) void {
    if (self.active) return;

    self.lowering.types = self.types;
    self.lowering.layouts = self.layouts;
    self.lowering.cache = self.cache;
    self.lowering.state_active = self.active;
    self.lowering.buffer_pointer = self.buffer_pointer;
}

pub fn selected(lowering: *const Lower, id: ir.TypeId) bool {
    return lowering.state_active and lowering.state_plan.selected[@backingInt(id)];
}
