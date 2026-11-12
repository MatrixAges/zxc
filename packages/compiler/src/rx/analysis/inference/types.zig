const std = @import("std");
const zx = @import("zx");
const Types = @import("frontend").types;
const Scalar = @import("scalar.zig");
const FieldAccess = @import("fields/access.zig");
const Unification = @import("unification/plan.zig");
const Nodes = @import("nodes.zig");
const Self = @This();
pub const Id = enum(u32) { _ };
pub const Mask = Scalar.Mask;
pub const Fields = @import("fields.zig");
pub const Field = Fields.Field;
pub const Shape = union(enum) { unknown, sequence, known: zx.ir.TypeId, object: Fields, list: Id, optional: Id, tuple: []const Id };
pub const Node = struct { shape: Shape, span: zx.Span, allowed: ?Mask = null, fallback: ?zx.ir.Scalar = null };

const Bindings = @import("bindings.zig");
const Assignment = @import("assignment.zig");
const ObjectClosure = @import("object_closure.zig");
const Projections = @import("projections.zig");

allocator: std.mem.Allocator,
scratch: std.mem.Allocator,
reporter: *zx.Reporter,
types: Types,
nodes: Nodes.Storage = .empty,
forest: @import("forest.zig") = .{},
lengths: std.MultiArrayList(Projections.Length) = .empty,
indexes: std.MultiArrayList(@import("index.zig").Projection) = .empty,
value_uses: std.MultiArrayList(Bindings.Use) = .empty,
binding_collisions: std.MultiArrayList(Bindings.Collision) = .empty,
binding_lookups: std.ArrayList(Bindings.Lookup) = .empty,
assignments: std.MultiArrayList(Assignment.Edge) = .empty,
assignment_keys: std.AutoHashMapUnmanaged([2]Id, void) = .empty,
constructions: std.MultiArrayList(@import("construction.zig").Object) = .empty,
construction_parts: std.MultiArrayList(@import("construction.zig").Part) = .empty,
selections: std.MultiArrayList(@import("selection.zig").Selection) = .empty,
sequences: std.ArrayList(@import("sequences.zig").Sequence) = .empty,
nonnull: std.MultiArrayList(@import("non_null.zig").Projection) = .empty,
known_types: std.AutoHashMapUnmanaged(zx.ir.TypeId, Id) = .empty,
revision: usize = 0,
/// Changes that affect the roots or known types seen by object rules.
object_revision: usize = 0,
pub fn init(allocator: std.mem.Allocator, scratch: std.mem.Allocator, reporter: *zx.Reporter, existing: zx.ir.TypeTable) zx.Error!Self {
    if (existing.count() != 0 and !@import("frontend").validateTypes(existing)) return reporter.fail(.contract, .{ .start = 0, .end = 0 }, "invalid inference type table");

    var types = Types{ .allocator = allocator, .reporter = reporter, .declarations = &.{} };

    try types.items.appendDelta(allocator, try @import("frontend").type_table.copy(allocator, existing));
    try types.initialize();

    return .{ .allocator = allocator, .scratch = scratch, .reporter = reporter, .types = types };
}

pub fn add(self: *Self, initial_shape: Shape, span: zx.Span) zx.Error!Id {
    const id: Id = @fromBackingInt(@intCast(self.nodes.len));

    try self.nodes.ensureUnusedCapacity(self.allocator, 1);
    try self.forest.append(self.allocator, id);

    self.nodes.appendAssumeCapacity(Nodes.record(initial_shape, span));

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
    return self.forest.root(id);
}

pub fn shape(self: *const Self, id: Id) Shape {
    return self.shapeAt(@backingInt(self.root(id)));
}

pub fn shapeAt(self: *const Self, index: usize) Shape {
    return Nodes.shape(self.nodes.slice(), index);
}

pub fn nodeAt(self: *const Self, index: usize) Node {
    return Nodes.get(self.nodes.slice(), index);
}

pub fn setShape(self: *Self, index: usize, value: Shape) void {
    Nodes.setShape(self.nodes.slice(), index, value);
}

pub fn unify(self: *Self, left: Id, right: Id, span: zx.Span) zx.Error!void {
    return @import("unify.zig").merge(self, left, right, span, 0);
}

/// Keys are root pairs at insertion time; a union may leave a stale key and admit one duplicate edge, which only costs another fixpoint round.
pub fn expect(self: *Self, value: Id, expected: Id, span: zx.Span) zx.Error!void {
    const key = [2]Id{ self.root(value), self.root(expected) };

    if (key[0] == key[1]) return;
    if ((try self.assignment_keys.getOrPut(self.allocator, key)).found_existing) return;
    try self.assignments.append(self.allocator, .{ .value = key[0], .expected = key[1], .span = span });

    self.revision += 1;
}

pub fn requireValue(self: *Self, value: Id, span: zx.Span) zx.Error!void {
    return Bindings.requireValue(self, value, span);
}

pub fn restrict(self: *Self, id: Id, allowed: Mask, span: zx.Span) zx.Error!void {
    const index = @backingInt(self.root(id));
    const current = self.shapeAt(index);
    const rows = self.nodes.slice();
    const previous = &rows.items(.allowed)[index];

    const known_scalar: ?zx.ir.Scalar = if (current == .known) switch (self.types.get(current.known)) {
        .scalar => |value| value,
        else => null,
    } else null;

    const constraint_shape: Scalar.Shape = switch (current) {
        .unknown => .open,
        .known => if (known_scalar != null) .scalar else .concrete,
        else => .structure,
    };

    const merged = Scalar.restrict(Nodes.allowed(rows, index), allowed, constraint_shape, known_scalar);

    switch (merged.issue) {
        .none => {},
        .empty => return self.reporter.fail(.type_mismatch, span, "incompatible inferred scalar requirements"),
        .operator => return self.reporter.fail(.type_mismatch, span, "inferred type does not satisfy the operator"),
        .structure => return self.reporter.fail(.type_mismatch, span, "the operator requires a scalar value"),
    }

    const bits: u16 = @intCast(merged.allowed.bits.mask);

    if (previous.* == null or previous.*.? != bits) {
        self.revision += 1;
    }

    previous.* = bits;
}

pub fn number(self: *Self, text: []const u8, negative: bool, span: zx.Span) zx.Error!Id {
    const number_type = Scalar.literal(text, negative);
    const id = try self.add(.unknown, span);
    const rows = self.nodes.slice();
    const index = @backingInt(id);

    rows.items(.allowed)[index] = @intCast(number_type.allowed.bits.mask);
    rows.items(.fallback)[index] = @backingInt(number_type.fallback);

    self.revision += 1;

    return id;
}

pub fn field(self: *Self, id: Id, name: []const u8, span: zx.Span) zx.Error!Id {
    const index = @backingInt(self.root(id));
    const value = self.shapeAt(index);
    const declared = if (value == .known) self.types.get(value.known) else null;

    switch (FieldAccess.route(value, declared, name)) {
        .Declared => {
            const object = declared.?.object;

            const position = Unification.position(object.names[0..object.len], name) orelse
                return self.reporter.fail(.type_mismatch, span, "the complete input type does not contain this field");

            return self.known(object.at(position).type_id, span);
        },
        .Length => return self.scalar(.u64, span),
        .RequireList => {
            _ = try self.payload(id, .list, span);

            return self.scalar(.u64, span);
        },
        .DeferLength => {
            const result = try self.add(.unknown, span);

            try self.lengths.append(self.allocator, .{ .target = id, .value = result, .span = span });

            return result;
        },
        .InvalidDeclared => return self.reporter.fail(.type_mismatch, span, "field access requires an object"),
        .InvalidInferred => return self.reporter.fail(.type_mismatch, span, "field requirements conflict with the inferred input type"),
        .Open => {},
    }

    if (self.nodes.items(.allowed)[index] != null) return self.reporter.fail(.type_mismatch, span, "object fields conflict with scalar requirements");

    const fields: Fields = if (value == .object) value.object else .{};

    if (Unification.position(fields.names(), name)) |position| return fields.values()[position];

    const result = try self.add(.unknown, span);
    const extended = try Fields.init(self.allocator, fields.len + 1);

    fields.copyTo(extended);
    extended.set(fields.len, try self.allocator.dupe(u8, name), result);
    self.setShape(index, .{ .object = extended });

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
    var workspace = std.heap.ArenaAllocator.init(self.scratch);
    var object_closure = ObjectClosure.init(self.scratch);

    defer workspace.deinit();
    defer object_closure.deinit();

    while (true) {
        const revision = self.revision;

        try Bindings.validateUses(self);
        try Bindings.propagate(self, false);
        try @import("non_null.zig").propagate(self, false);
        for (self.sequences.items) |sequence| try @import("sequences.zig").propagate(self, sequence);
        for (0..self.constructions.len) |index| try @import("construction.zig").propagate(self, &object_closure, self.constructions.get(index), false);
        for (0..self.selections.len) |index| try @import("selection.zig").propagate(self, &object_closure, self.selections.get(index), false);
        try Projections.applyLengths(self);
        try @import("index.zig").replay(self);
        if (revision != self.revision) continue;

        _ = workspace.reset(.retain_capacity);
        const scratch = workspace.allocator();
        const base = try Assignment.Base.init(self, scratch);

        try base.propagate(self);

        if (revision != self.revision) continue;
        if (try @import("sequences/defaults/apply.zig").apply(self, base, scratch)) continue;
        try Assignment.materialize(self, base, scratch);
        if (revision != self.revision) continue;
        if (try @import("index.zig").defaultLists(self)) continue;
        try @import("non_null.zig").propagate(self, true);
        if (revision != self.revision) continue;
        for (0..self.selections.len) |index| try @import("selection.zig").propagate(self, &object_closure, self.selections.get(index), true);
        if (revision != self.revision) continue;
        for (0..self.constructions.len) |index| try @import("construction.zig").propagate(self, &object_closure, self.constructions.get(index), true);
        if (revision != self.revision) continue;

        break;
    }

    try Projections.validateLengths(self);
    try Bindings.propagate(self, true);
    try Assignment.validate(self);
}

pub fn resolve(self: *Self, id: Id) zx.Error!zx.ir.TypeId {
    return @import("resolve.zig").resolve(self, id);
}
