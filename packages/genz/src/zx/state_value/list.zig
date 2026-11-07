const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const aggregate = @import("../aggregate.zig");
const seed = @import("list_seed.zig");
pub const Storage = seed.Storage;

pub fn selected(self: *const Lower, id: ir.TypeId) bool {
    if (!@import("genz_options").generated_analysis) return seed.selected(self, id);

    const generated = @import("generated_state_list_selected");
    const Input = std.meta.Child(generated.Input);
    const index = @backingInt(id);

    const input: Input = .{
        .active = self.state_active,
        .chosen = if (self.state_active) self.state_plan.selected[index] else false,
        .kind = if (self.state_active) self.program.types.kinds[index] else 0,
    };

    var fixed = std.heap.FixedBufferAllocator.init(&.{});

    return @import("zx").columns.invoke(generated.executeValue, fixed.allocator(), &input) catch unreachable;
}

pub fn tag(self: *Lower, storage: Storage) Lower.Error!node.ExpressionId {
    if (!@import("genz_options").generated_analysis) return seed.tag(self, storage);

    return @import("list_emission.zig").lower(self, null, .Tag, .{ .storage = @fromBackingInt(@backingInt(storage)) });
}

pub fn headered(self: *Lower, value: node.ExpressionId) Lower.Error!node.ExpressionId {
    if (!@import("genz_options").generated_analysis) return seed.headered(self, value);

    return @import("list_emission.zig").lower(self, null, .Headered, .{ .value = value });
}

pub fn exclusive(self: *Lower, value: node.ExpressionId) Lower.Error!node.ExpressionId {
    if (!@import("genz_options").generated_analysis) return seed.exclusive(self, value);

    return @import("list_emission.zig").lower(self, null, .Exclusive, .{ .value = value });
}

pub fn writable(self: *Lower, value: node.ExpressionId) Lower.Error!node.ExpressionId {
    if (!@import("genz_options").generated_analysis) return seed.writable(self, value);

    return @import("list_emission.zig").lower(self, null, .Writable, .{ .value = value });
}

pub fn weakened(self: *Lower, value: node.ExpressionId) Lower.Error!node.ExpressionId {
    if (!@import("genz_options").generated_analysis) return seed.weakened(self, value);

    return @import("list_emission.zig").lower(self, null, .Weakened, .{ .value = value });
}

pub fn create(self: *Lower, id: ir.TypeId, slice: node.ExpressionId, has_header: node.ExpressionId) Lower.Error!node.ExpressionId {
    if (!@import("genz_options").generated_analysis) return seed.create(self, id, slice, has_header);

    return @import("list_emission.zig").lower(self, id, .Create, .{ .value = slice, .condition = has_header });
}

pub fn proven(self: *Lower, id: ir.TypeId, slice: node.ExpressionId, has_header: node.ExpressionId, is_unique: node.ExpressionId) Lower.Error!node.ExpressionId {
    if (!@import("genz_options").generated_analysis) return seed.proven(self, id, slice, has_header, is_unique);

    return @import("list_emission.zig").lower(self, id, .Proven, .{ .value = slice, .condition = has_header, .unique = is_unique });
}

pub fn owned(self: *Lower, id: ir.TypeId, slice: node.ExpressionId, has_header: node.ExpressionId) Lower.Error!node.ExpressionId {
    if (!@import("genz_options").generated_analysis) return seed.owned(self, id, slice, has_header);

    return @import("list_emission.zig").lower(self, id, .Owned, .{ .value = slice, .condition = has_header, .selected = selected(self, id) });
}

pub fn borrowed(self: *Lower, id: ir.TypeId, slice: node.ExpressionId) Lower.Error!node.ExpressionId {
    if (!@import("genz_options").generated_analysis) return seed.borrowed(self, id, slice);

    return @import("list_emission.zig").lower(self, id, .Borrowed, .{ .value = slice });
}

pub fn items(self: *Lower, id: ir.TypeId, value: node.ExpressionId) Lower.Error!node.ExpressionId {
    if (!@import("genz_options").generated_analysis) return seed.items(self, id, value);

    return @import("list_emission.zig").lower(self, id, .Items, .{ .value = value, .selected = selected(self, id) });
}

pub fn wrap(self: *Lower, id: ir.TypeId, value: node.ExpressionId, has_header: bool) Lower.Error!node.ExpressionId {
    if (!@import("genz_options").generated_analysis) return seed.wrap(self, id, value, has_header);

    return @import("list_emission.zig").lower(self, id, .Wrap, .{ .value = value, .flag = has_header, .selected = selected(self, id) });
}

pub fn reserve(self: *Lower, body: *std.ArrayList(node.Statement), id: ir.TypeId, value: node.ExpressionId, count: node.ExpressionId, frontier: bool) Lower.Error!node.ExpressionId {
    const source = try aggregate.bind(self, body, value);
    const view = try self.field(source, "items");
    var yes: std.ArrayList(node.Statement) = .empty;
    var no: std.ArrayList(node.Statement) = .empty;
    const element = try @import("elements.zig").typeExpr(self, id);
    const copied = try @import("../growth.zig").reserve(self, &no, element, view, count, false);

    const result = if (frontier) chosen: {
        const extended = try @import("../growth.zig").reserve(self, &yes, element, view, count, true);

        break :chosen try self.builder.expression(.{ .conditional = .{
            .condition = try headered(self, source),
            .yes = try aggregate.finish(self, &yes, extended),
            .no = try aggregate.finish(self, &no, copied),
        } });
    } else try aggregate.finish(self, &no, copied);

    return aggregate.bind(self, body, result);
}

pub fn expression(self: *Lower, id: ir.ExprId) Lower.Error!node.ExpressionId {
    return items(self, self.program.expression(id).type_id, try self.expr(id));
}
