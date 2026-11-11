const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../node.zig");
const Lower = @import("lower.zig");
const aggregate = @import("aggregate.zig");

/// List growth emitted into generated code: an append allocates a buffer with a header recording its capacity and the
/// length of the furthest value built on it. Appending to a value at that frontier writes in place and moves the
/// frontier; any other value copies, so older values never see the write. Only the values the uniqueness plan proves
/// headered are checked, and a pop of a unique headered value hands the frontier back. A loop whose state must own a
/// list renews it once on entry, copying the records on the way so the loop never writes into its initial value.
pub fn declarations(self: *Lower, exported: bool) Lower.Error![6]node.Declaration {
    if (!@import("genz_options").generated_analysis) return @import("growth/declarations_seed.zig").declarations(self, exported);

    return @import("growth/declarations.zig").lower(self, exported);
}

/// The value of `id` with the lists the plan renews in it moved to growth buffers of their own, where a value read out of
/// a list or another opaque source enters the values that later appends extend.
pub fn renewValue(self: *Lower, id: ir.ExprId, value: node.ExpressionId) Lower.Error!node.ExpressionId {
    if (!@import("genz_options").generated_analysis) return @import("growth/value_seed.zig").renewValue(self, id, value);

    var body: std.ArrayList(node.Statement) = .empty;
    const name = try self.fresh("renewed");
    const renewed = try self.builder.identifier(name);
    const source = if (self.state_active) try @import("state_value/ownership.zig").clip(self, &body, id, value) else value;

    try body.append(self.allocator, .{ .variable = .{ .name = name, .value = source } });
    try @import("growth/renew.zig").appendValue(self, &body, id, renewed);

    return aggregate.finish(self, &body, renewed);
}

/// A growable buffer of `count` elements holding `source` as its prefix; `frontier` reuses a headered source in place.
pub fn reserve(self: *Lower, body: *std.ArrayList(node.Statement), element: node.ExpressionId, source: node.ExpressionId, count: node.ExpressionId, frontier: bool) Lower.Error!node.ExpressionId {
    if (!@import("genz_options").generated_analysis) return @import("growth/call_seed.zig").reserve(self, body, element, source, count, frontier);

    return @import("growth/call.zig").lower(self, body, .Reserve, .{ .element = element, .value = source, .count = count, .flag = frontier });
}

pub fn reserveBounded(self: *Lower, body: *std.ArrayList(node.Statement), element: node.ExpressionId, source: node.ExpressionId, count: node.ExpressionId, minimum: node.ExpressionId) Lower.Error!node.ExpressionId {
    if (!@import("genz_options").generated_analysis) return @import("growth/call_seed.zig").reserveBounded(self, body, element, source, count, minimum);

    return @import("growth/call.zig").lower(self, body, .Bounded, .{ .element = element, .value = source, .count = count, .minimum = minimum });
}

pub fn copy(self: *Lower, body: *std.ArrayList(node.Statement), element: node.ExpressionId, source: node.ExpressionId, exact: bool) Lower.Error!node.ExpressionId {
    if (!@import("genz_options").generated_analysis) return @import("growth/call_seed.zig").copy(self, body, element, source, exact);

    return @import("growth/call.zig").lower(self, body, .Copy, .{ .element = element, .value = source, .flag = exact });
}

/// One growth copy of a plain list the plan found flowing into appends, so they extend it in place from then on.
pub fn normalize(self: *Lower, id: ir.ExprId, value: node.ExpressionId) Lower.Error!node.ExpressionId {
    if (!@import("genz_options").generated_analysis) return @import("growth/normalize_seed.zig").normalize(self, id, value);
    if (self.iteration_value) |context| if (context.buffered(self.program.expression(id).type_id)) return value;

    var body: std.ArrayList(node.Statement) = .empty;
    const type_id = self.program.expression(id).type_id;
    const child = self.program.typeOf(type_id).list;

    const element = if (self.state_active)
        try @import("state_value/elements.zig").typeExpr(self, type_id)
    else
        try @import("iteration_value/types.zig").element(self, child);

    const selected = @import("state_value/list.zig").selected(self, type_id);
    const qualified = if (selected) try @import("state_value/ownership.zig").clip(self, &body, id, value) else value;
    const serial = self.serial;
    const layout = if (selected) try @import("types.zig").get(self, self.state_types, type_id) else null;

    std.debug.assert(serial == self.serial);

    const result = try @import("growth/call.zig").normalize(self, &body, element, qualified, selected, layout);

    return aggregate.finish(self, &body, result);
}

pub fn retract(self: *Lower, body: *std.ArrayList(node.Statement), element: node.ExpressionId, source: node.ExpressionId, length: node.ExpressionId) Lower.Error!void {
    if (!@import("genz_options").generated_analysis) return @import("growth/call_seed.zig").retract(self, body, element, source, length);

    _ = try @import("growth/call.zig").lower(self, body, .Retract, .{ .element = element, .value = source, .count = length });
}
