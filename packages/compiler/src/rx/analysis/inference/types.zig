const std = @import("std");
const zx = @import("zx");
const Types = @import("frontend").types;
const Scalar = @import("scalar.zig");
const FieldAccess = @import("fields/access.zig");
const Known = @import("known.zig");
const Nodes = @import("nodes.zig");
const Registration = @import("assignment/registration.zig");
const Self = @This();
pub const Id = enum(u32) { _ };
pub const Mask = Scalar.Mask;
pub const Fields = @import("fields.zig");
pub const Field = Fields.Field;
pub const Shape = union(enum) { unknown, sequence, known: zx.ir.TypeId, object: Fields, list: Id, optional: Id, tuple: []const Id };
pub const Node = struct { shape: Shape, span: zx.Span, allowed: ?Mask = null, fallback: ?zx.ir.Scalar = null };

const Bindings = @import("bindings.zig");
const Assignment = @import("assignment.zig");
const Projections = @import("projections.zig");

allocator: std.mem.Allocator,
scratch: std.mem.Allocator,
reporter: *zx.Reporter,
types: Types,
nodes: Nodes.Storage = .empty,
forest: @import("forest.zig") = .{},
pending: Constraints,
revision: usize = 0,
/// Changes that affect the roots or known types seen by object rules.
object_revision: u64 = 0,
const Constraints = struct {
    allocator: std.mem.Allocator,
    lengths: std.MultiArrayList(Projections.Length) = .empty,
    indexes: std.MultiArrayList(@import("index.zig").Projection) = .empty,
    value_uses: std.MultiArrayList(Bindings.Use) = .empty,
    binding_collisions: std.MultiArrayList(Bindings.Collision) = .empty,
    binding_lookups: std.MultiArrayList(Bindings.Lookup) = .empty,
    assignments: std.MultiArrayList(Assignment.Edge) = .empty,
    assignment_keys: Registration = .{},
    constructions: std.MultiArrayList(@import("construction.zig").Object) = .empty,
    construction_parts: std.MultiArrayList(@import("construction.zig").Part) = .empty,
    selections: std.MultiArrayList(@import("selection.zig").Selection) = .empty,
    sequences: std.MultiArrayList(@import("sequences.zig").Sequence) = .empty,
    nonnull: std.MultiArrayList(@import("non_null.zig").Projection) = .empty,
    known_types: Known = .{},
};

pub const Memory = struct {
    graph: std.mem.Allocator,
    pending: std.mem.Allocator,
    result: std.mem.Allocator,
    backing: std.mem.Allocator,
};

pub fn init(memory: Memory, reporter: *zx.Reporter, existing: zx.ir.TypeTable) zx.Error!Self {
    if (existing.count() != 0 and !@import("frontend").validateTypes(existing)) return reporter.fail(.contract, .{ .start = 0, .end = 0 }, "invalid inference type table");

    var types = Types{ .allocator = memory.result, .scratch = memory.backing, .reporter = reporter, .declarations = &.{} };

    types.items = try @import("frontend").type_table.storage(memory.result, existing);

    try types.initialize();

    return .{ .allocator = memory.graph, .scratch = memory.backing, .pending = .{ .allocator = memory.pending }, .reporter = reporter, .types = types };
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
    if (self.pending.known_types.get(type_id)) |id| return id;

    const id = try self.add(.{ .known = type_id }, span);

    self.pending.known_types.put(self.pending.allocator, type_id, id) catch |err| {
        self.nodes.len -= 1;

        self.forest.rollback();

        return err;
    };

    return id;
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

pub const expect = Registration.expect;

pub fn requireValue(self: *Self, value: Id, span: zx.Span) zx.Error!void {
    return Bindings.requireValue(self, value, span);
}

pub const restrict = @import("scalar/restriction.zig").restrict;

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

pub const field = FieldAccess.field;

pub fn payload(self: *Self, id: Id, kind: enum { list, optional }, span: zx.Span) zx.Error!Id {
    const child = try self.add(.unknown, span);
    const container = try self.add(if (kind == .list) .{ .list = child } else .{ .optional = child }, span);

    try self.unify(id, container, span);

    return child;
}

pub const finish = @import("solve.zig").finish;

pub fn resolve(self: *Self, id: Id) zx.Error!zx.ir.TypeId {
    return @import("resolve.zig").resolve(self, id);
}
