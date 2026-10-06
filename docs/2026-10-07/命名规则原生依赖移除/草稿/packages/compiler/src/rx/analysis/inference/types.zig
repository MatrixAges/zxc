const std = @import("std");
const zx = @import("zx");
const Types = @import("frontend").types;
const Self = @This();
pub const Id = enum(u32) { _ };
pub const Mask = std.enums.EnumSet(zx.ir.Scalar);
pub const Field = struct { name: []const u8, value: Id };
pub const Shape = union(enum) { unknown, sequence, known: zx.ir.TypeId, object: []const Field, list: Id, optional: Id, tuple: []const Id };
pub const Node = struct { parent: Id, shape: Shape, span: zx.Span, allowed: ?Mask = null, fallback: ?zx.ir.Scalar = null };

const Projection = struct { target: Id, value: Id, span: zx.Span };
const ValueUse = struct { value: Id, span: zx.Span };
const Assignment = @import("assignment.zig");

allocator: std.mem.Allocator,
reporter: *zx.Reporter,
types: Types,
nodes: std.ArrayList(Node) = .empty,
lengths: std.ArrayList(Projection) = .empty,
indexes: std.ArrayList(@import("index.zig").Projection) = .empty,
value_uses: std.ArrayList(ValueUse) = .empty,
binding_collisions: std.ArrayList(@import("bindings.zig").Collision) = .empty,
binding_lookups: std.ArrayList(@import("bindings.zig").Lookup) = .empty,
assignments: std.ArrayList(Assignment.Edge) = .empty,
constructions: std.ArrayList(@import("construction.zig").Object) = .empty,
sequences: std.ArrayList(@import("sequences.zig").Sequence) = .empty,
known_types: std.AutoHashMapUnmanaged(zx.ir.TypeId, Id) = .empty,
revision: usize = 0,
pub fn init(allocator: std.mem.Allocator, reporter: *zx.Reporter, existing: zx.ir.TypeTable) zx.Error!Self {
    if (existing.count() != 0 and !@import("frontend").validateTypes(existing)) return reporter.fail(.contract, .{ .start = 0, .end = 0 }, "invalid inference type table");

    var types = Types{ .allocator = allocator, .reporter = reporter, .declarations = &.{} };

    try types.items.appendDelta(allocator, try @import("frontend").type_table.copy(allocator, existing));
    try types.initialize();

    return .{ .allocator = allocator, .reporter = reporter, .types = types };
}

pub fn add(self: *Self, initial_shape: Shape, span: zx.Span) zx.Error!Id {
    const id: Id = @fromBackingInt(@intCast(self.nodes.items.len));

    try self.nodes.append(self.allocator, .{ .parent = id, .shape = initial_shape, .span = span });

    return id;
}

pub fn known(self: *Self, type_id: zx.ir.TypeId, span: zx.Span) zx.Error!Id {
    if (@backingInt(type_id) >= self.types.items.view().count()) return self.reporter.fail(.contract, span, "inference type is outside the shared table");

    const entry = try self.known_types.getOrPut(self.allocator, type_id);

    if (!entry.found_existing) entry.value_ptr.* = try self.add(.{ .known = type_id }, span);

    return entry.value_ptr.*;
}

pub fn scalar(self: *Self, value: zx.ir.Scalar, span: zx.Span) zx.Error!Id {
    return self.known(Types.scalarId(value), span);
}

pub fn root(self: *const Self, id: Id) Id {
    var current = id;

    while (self.nodes.items[@backingInt(current)].parent != current) current = self.nodes.items[@backingInt(current)].parent;

    return current;
}

pub fn shape(self: *const Self, id: Id) Shape {
    return self.nodes.items[@backingInt(self.root(id))].shape;
}

pub fn unify(self: *Self, left: Id, right: Id, span: zx.Span) zx.Error!void {
    return @import("unify.zig").merge(self, left, right, span, 0);
}

pub fn expect(self: *Self, value: Id, expected: Id, span: zx.Span) zx.Error!void {
    if (self.root(value) == self.root(expected)) return;

    for (self.assignments.items) |item| {
        if (self.root(item.value) == self.root(value) and self.root(item.expected) == self.root(expected)) return;
    }

    try self.assignments.append(self.allocator, .{ .value = value, .expected = expected, .span = span });

    self.revision += 1;
}

pub fn requireValue(self: *Self, value: Id, span: zx.Span) zx.Error!void {
    try self.checkValue(.{ .value = value, .span = span });
    if (self.shape(value) != .unknown) return;
    try self.value_uses.append(self.allocator, .{ .value = value, .span = span });
}

fn checkValue(self: *Self, use: ValueUse) zx.Error!void {
    const value = self.shape(use.value);

    if (value == .known and value.known == Types.scalarId(.void)) return self.reporter.fail(.name, use.span, "flow value is not defined in this scope");
}

pub fn restrict(self: *Self, id: Id, allowed: Mask, span: zx.Span) zx.Error!void {
    const index = @backingInt(self.root(id));
    const merged = if (self.nodes.items[index].allowed) |previous| previous.intersectWith(allowed) else allowed;

    if (merged.count() == 0) return self.reporter.fail(.type_mismatch, span, "incompatible inferred scalar requirements");

    switch (self.nodes.items[index].shape) {
        .unknown => {},
        .known => |type_id| {
            const value = self.types.get(type_id);

            if (value != .scalar or !merged.contains(value.scalar)) return self.reporter.fail(.type_mismatch, span, "inferred type does not satisfy the operator");
        },
        else => return self.reporter.fail(.type_mismatch, span, "the operator requires a scalar value"),
    }

    if (self.nodes.items[index].allowed == null or !self.nodes.items[index].allowed.?.eql(merged)) self.revision += 1;

    self.nodes.items[index].allowed = merged;
}

pub fn number(self: *Self, text: []const u8, negative: bool, span: zx.Span) zx.Error!Id {
    const floating = std.mem.indexOfAny(u8, text, ".eE") != null;
    const id = try self.add(.unknown, span);

    try self.restrict(id, if (floating) Mask.initMany(&.{ .f32, .f64 }) else if (negative) Mask.initMany(&.{ .i32, .i64, .f32, .f64 }) else numeric(), span);

    self.nodes.items[@backingInt(id)].fallback = if (floating) .f64 else if (negative) .i64 else .u64;

    return id;
}

pub fn numeric() Mask {
    return Mask.initMany(&.{ .u8, .u16, .u32, .u64, .i32, .i64, .f32, .f64 });
}

pub fn field(self: *Self, id: Id, name: []const u8, span: zx.Span) zx.Error!Id {
    const index = @backingInt(self.root(id));
    const value = self.nodes.items[index].shape;

    if (value == .known) {
        const resolved = self.types.get(value.known);

        if (std.mem.eql(u8, name, "length") and (resolved == .list or (resolved == .scalar and resolved.scalar == .string))) return self.scalar(.u64, span);
        if (resolved != .object) return self.reporter.fail(.type_mismatch, span, "field access requires an object");

        for (0..resolved.object.len) |view_index| {
            const item = resolved.object.at(view_index);

            if (std.mem.eql(u8, item.name, name)) return self.known(item.type_id, span);
        }

        return self.reporter.fail(.type_mismatch, span, "the complete input type does not contain this field");
    }

    if (value == .sequence and std.mem.eql(u8, name, "length")) {
        _ = try self.payload(id, .list, span);

        return self.scalar(.u64, span);
    }

    if (value == .list and std.mem.eql(u8, name, "length")) return self.scalar(.u64, span);

    if (value == .unknown and std.mem.eql(u8, name, "length")) {
        const result = try self.add(.unknown, span);

        try self.lengths.append(self.allocator, .{ .target = id, .value = result, .span = span });

        return result;
    }

    if (value != .unknown and value != .object) return self.reporter.fail(.type_mismatch, span, "field requirements conflict with the inferred input type");
    if (self.nodes.items[index].allowed != null) return self.reporter.fail(.type_mismatch, span, "object fields conflict with scalar requirements");

    const fields = if (value == .object) value.object else &.{};

    for (fields) |item| {
        if (std.mem.eql(u8, item.name, name)) return item.value;
    }

    const result = try self.add(.unknown, span);
    const extended = try self.allocator.alloc(Field, fields.len + 1);

    @memcpy(extended[0..fields.len], fields);

    extended[fields.len] = .{ .name = try self.allocator.dupe(u8, name), .value = result };
    self.nodes.items[index].shape = .{ .object = extended };
    self.revision += 1;

    return result;
}

pub fn payload(self: *Self, id: Id, kind: enum { list, optional }, span: zx.Span) zx.Error!Id {
    const child = try self.add(.unknown, span);
    const container = try self.add(if (kind == .list) .{ .list = child } else .{ .optional = child }, span);

    try self.unify(id, container, span);

    return child;
}

pub fn finish(self: *Self) zx.Error!void {
    while (true) {
        const revision = self.revision;

        for (self.value_uses.items) |use| try self.checkValue(use);

        try @import("bindings.zig").propagate(self, false);
        for (self.sequences.items) |sequence| try @import("sequences.zig").propagate(self, sequence);
        for (self.constructions.items) |object| try @import("construction.zig").propagate(self, object, false);

        for (self.lengths.items) |projection| {
            if (self.shape(projection.target) == .unknown) continue;

            const value = try self.field(projection.target, "length", projection.span);

            try self.unify(value, projection.value, projection.span);
        }

        for (self.indexes.items) |*projection| {
            if (!projection.resolved) projection.resolved = try @import("index.zig").propagate(self, projection.*);
        }

        if (revision != self.revision) continue;

        const base = try Assignment.Base.init(self);

        defer base.deinit(self.allocator);

        try base.propagate(self);
        if (revision != self.revision) continue;
        if (try @import("sequences.zig").defaultLists(self, base)) continue;
        try Assignment.materialize(self, base);
        if (revision != self.revision) continue;
        if (try @import("index.zig").defaultLists(self)) continue;
        for (self.constructions.items) |object| try @import("construction.zig").propagate(self, object, true);
        if (revision != self.revision) continue;

        break;
    }

    for (self.lengths.items) |projection| {
        if (self.shape(projection.target) == .unknown) return self.reporter.fail(.type_mismatch, projection.span, "length alone cannot determine whether the input is a list, string or object");
    }

    try @import("bindings.zig").propagate(self, true);
    try Assignment.validate(self);
}

pub fn resolve(self: *Self, id: Id) zx.Error!zx.ir.TypeId {
    return @import("resolve.zig").resolve(self, id, 0);
}
