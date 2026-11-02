const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const Consumer = @import("../iteration_consumer.zig").Consumer;
const analysis = @import("analysis.zig");

pub fn lower(self: *Lower, id: ir.ExprId, consumer: Consumer) Lower.Error!?node.ExpressionId {
    if (!@import("genz_options").generated_analysis) return @import("seed/iteration.zig").lower(self, self.program.expression(id).value.iteration, consumer);

    var scratch = std.heap.ArenaAllocator.init(self.workspace);

    defer scratch.deinit();

    const plan = try analysis.analyze(scratch.allocator(), self.program, id, consumer);

    if (!plan.accepted) return null;

    return try @import("root.zig").emit(self, plan);
}
