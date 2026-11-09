const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const aggregate = @import("../aggregate.zig");
const lists = @import("../state_value/list.zig");
const functions = @import("functions.zig");
const emission = @import("emitting.zig");

pub fn lower(self: *Lower, id: ir.ExprId, value: ir.Transform) Lower.Error!node.ExpressionId {
    if (!@import("genz_options").generated_analysis) return @import("root_seed.zig").lower(self, id, value);

    const slot = self.task_declarations.count();
    const name = try emission.reserve(self, slot);
    const list_type = self.program.expression(value.target).type_id;
    const child = try @import("../state_value/elements.zig").typeExpr(self, list_type);
    const errors = try @import("../error_effects.zig").expression(self, id);
    const worker = try @import("worker.zig").build(self, value, child, errors);
    const helpers = try functions.build(self, child, errors);
    const declarations = try self.allocator.dupe(node.Declaration, &.{ worker.declaration, helpers[0], helpers[1] });

    try emission.publish(self, slot, name, declarations);

    self.uses_allocator = true;
    self.uses_io = self.uses_io or worker.io;
    self.uses_process = self.uses_process or worker.process;

    var body: std.ArrayList(node.Statement) = .empty;
    const evaluated = try self.expr(value.target);
    const qualified = if (lists.selected(self, list_type)) try @import("../state_value/ownership.zig").clip(self, &body, value.target, evaluated) else evaluated;
    const source_value = try aggregate.bind(self, &body, qualified);
    const source = try lists.items(self, list_type, source_value);
    const selected = lists.selected(self, list_type);
    const chosen = try emission.reuse(self, self.plan.get(id).in_place, selected);
    const reuse = try aggregate.bind(self, &body, chosen orelse try lists.writable(self, source_value));
    const environment = try aggregate.bind(self, &body, try self.expr(value.initial.?));
    const header = if (selected) try lists.headered(self, source_value) else @as(node.ExpressionId, @fromBackingInt(0));

    const result = try emission.expression(self, &body, .{
        .name = name,
        .source = source,
        .reuse = reuse,
        .environment = environment,
        .errors = errors,
        .io = worker.io,
        .process = worker.process,
        .selected = selected,
        .headered = header,
    });

    return aggregate.finish(self, &body, try lists.owned(self, list_type, result.value, result.headered));
}
