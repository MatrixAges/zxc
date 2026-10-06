const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Self = @This();
pub const Fields = @import("types/fields.zig");
pub const Shared = @import("shared_types.zig").Shared;
const NativeView = @import("types/native_view.zig");
const resolution = @import("types/resolve.zig");
const lookup = @import("semantic/lookup.zig");

allocator: std.mem.Allocator,
reporter: *zx.Reporter,
declarations: []const zx.ast.Declaration,
items: ir.TypeStorage = .{},
resolved: std.StringHashMapUnmanaged(ir.TypeId) = .empty,
visiting: std.StringHashMapUnmanaged(void) = .empty,
aliases: []const ir.Export = &.{},
shared: ?Shared = null,
native_interface: bool = false,
pub fn initialize(self: *Self) zx.Error!void {
    return resolution.initialize(self, NativeView{ .items = self.declarations });
}

pub fn scalarId(scalar: ir.Scalar) ir.TypeId {
    return @fromBackingInt(@intCast(@backingInt(scalar)));
}

pub fn named(self: *Self, name: zx.ast.Name) zx.Error!ir.TypeId {
    return resolution.named(self, NativeView{ .items = self.declarations }, name);
}

pub fn resolve(self: *Self, value: *const zx.ast.Type) zx.Error!ir.TypeId {
    return resolution.node(self, NativeView{ .items = self.declarations }, value);
}

pub fn wrap(self: *Self, kind: enum { optional, list }, child: ir.TypeId) zx.Error!ir.TypeId {
    if (self.get(child) == .task) return self.reporter.fail(.ownership, .{ .start = 0, .end = 0 }, "tasks cannot be placed in containers");
    if (kind == .list and child == scalarId(.void)) return self.reporter.fail(.type_mismatch, .{ .start = 0, .end = 0 }, "lists cannot contain void");

    const candidate: lookup.Value = if (kind == .optional) .{ .optional = child } else .{ .list = child };

    if (try lookup.find(self.items.view(), candidate)) |id| return id;

    const id: ir.TypeId = @fromBackingInt(@intCast(self.items.view().count()));

    try self.items.append(self.allocator, if (kind == .optional) .{ .optional = child } else .{ .list = child });

    return id;
}

pub fn tuple(self: *Self, children: []const ir.TypeId) zx.Error!ir.TypeId {
    for (children) |child| if (self.get(child) == .task) return self.reporter.fail(.ownership, .{ .start = 0, .end = 0 }, "tasks cannot be placed in tuples");
    if (try lookup.find(self.items.view(), .{ .tuple = children })) |id| return id;

    const id: ir.TypeId = @fromBackingInt(@intCast(self.items.view().count()));

    try self.items.append(self.allocator, .{ .tuple = children });

    return id;
}

pub fn errorSet(self: *Self, members: []const []const u8) zx.Error!ir.TypeId {
    const names = try self.allocator.dupe([]const u8, members);

    try @import("semantic/ordering.zig").sort(names, null);

    if (try lookup.find(self.items.view(), .{ .error_set = names })) |id| {
        self.allocator.free(names);

        return id;
    }

    for (names) |*name| name.* = try self.allocator.dupe(u8, name.*);

    const id: ir.TypeId = @fromBackingInt(@intCast(self.items.count()));

    try self.items.append(self.allocator, .{ .error_set = names });

    return id;
}

pub fn task(self: *Self, result: ir.TypeId, errors: ir.TypeId) zx.Error!ir.TypeId {
    if (try ir.containsNativeReference(self.allocator, self.items.view(), result)) return self.reporter.fail(.capability, .{ .start = 0, .end = 0 }, "tasks cannot return host references");
    if (self.get(result) == .task) return self.reporter.fail(.ownership, .{ .start = 0, .end = 0 }, "a task cannot return another task");
    if (try lookup.find(self.items.view(), .{ .task = .{ .result = result, .errors = errors } })) |id| return id;

    const id: ir.TypeId = @fromBackingInt(@intCast(self.items.count()));

    try self.items.append(self.allocator, .{ .task = .{ .result = result, .errors = errors } });

    return id;
}

pub fn get(self: *const Self, id: ir.TypeId) ir.Type {
    return self.items.view().at(@backingInt(id));
}

pub fn containsList(self: *const Self, id: ir.TypeId) bool {
    return switch (self.get(id)) {
        .list => true,
        .optional => |child| self.containsList(child),
        .tuple => |children| blk: {
            for (0..children.len) |entry_index| {
                const child = children.at(entry_index);

                if (self.containsList(child)) break :blk true;
            }

            break :blk false;
        },
        .object => |fields| blk: {
            for (0..fields.len) |item_index| {
                const field = fields.at(item_index);

                if (self.containsList(field.type_id)) break :blk true;
            }

            break :blk false;
        },
        else => false,
    };
}

pub fn object(self: *Self, fields: Fields) zx.Error!ir.TypeId {
    for (fields.types) |type_id| if (self.get(@fromBackingInt(type_id)) == .task) return self.reporter.fail(.ownership, .{ .start = 0, .end = 0 }, "tasks cannot be placed in objects");
    try fields.sort();
    if (try lookup.find(self.items.view(), .{ .object = fields.view() })) |id| return id;

    const id: ir.TypeId = @fromBackingInt(@intCast(self.items.count()));

    try self.items.append(self.allocator, .{ .object = fields.view() });

    return id;
}
