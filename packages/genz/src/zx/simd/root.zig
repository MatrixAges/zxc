const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const analysis = @import("analysis.zig");
pub const emit = @import("emission.zig").emit;

pub fn lower(self: *Lower, id: ir.ExprId, value: ir.Transform) Lower.Error!?node.ExpressionId {
    if (!@import("genz_options").generated_analysis) return @import("seed/root.zig").lower(self, id, value);

    var scratch = std.heap.ArenaAllocator.init(self.workspace);

    defer scratch.deinit();

    const plan = try analysis.analyze(scratch.allocator(), self.program, id, null);

    if (!plan.accepted) return null;

    return try @import("../state_value/list.zig").wrap(self, self.program.expression(id).type_id, try emit(self, plan), false);
}
