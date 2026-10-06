const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Self = @This();
pub const Shared = @import("shared_types.zig").Shared;
const NativeView = @import("types/native_view.zig");
const resolution = @import("types/resolve.zig");

allocator: std.mem.Allocator,
reporter: *zx.Reporter,
declarations: []const zx.ast.Declaration,
items: std.ArrayList(ir.Type) = .empty,
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

    for (self.items.items, 0..) |item, index| {
        if (kind == .optional and item == .optional and item.optional == child) return @fromBackingInt(@intCast(index));
        if (kind == .list and item == .list and item.list == child) return @fromBackingInt(@intCast(index));
    }

    const id: ir.TypeId = @fromBackingInt(@intCast(self.items.items.len));

    try self.items.append(self.allocator, if (kind == .optional) .{ .optional = child } else .{ .list = child });

    return id;
}

pub fn tuple(self: *Self, children: []const ir.TypeId) zx.Error!ir.TypeId {
    for (children) |child| if (self.get(child) == .task) return self.reporter.fail(.ownership, .{ .start = 0, .end = 0 }, "tasks cannot be placed in tuples");

    for (self.items.items, 0..) |item, index| {
        if (item == .tuple and std.mem.eql(ir.TypeId, item.tuple, children)) return @fromBackingInt(@intCast(index));
    }

    const id: ir.TypeId = @fromBackingInt(@intCast(self.items.items.len));

    try self.items.append(self.allocator, .{ .tuple = try self.allocator.dupe(ir.TypeId, children) });

    return id;
}

pub fn errorSet(self: *Self, members: []const []const u8) zx.Error!ir.TypeId {
    const names = try self.allocator.dupe([]const u8, members);

    std.mem.sort([]const u8, names, {}, struct {
        fn less(_: void, left: []const u8, right: []const u8) bool {
            return std.mem.lessThan(u8, left, right);
        }
    }.less);

    for (self.items.items, 0..) |item, index| {
        if (item != .error_set or item.error_set.len != names.len) continue;

        for (item.error_set, names) |left, right| {
            if (!std.mem.eql(u8, left, right)) break;
        } else {
            self.allocator.free(names);

            return @fromBackingInt(@intCast(index));
        }
    }

    for (names) |*name| name.* = try self.allocator.dupe(u8, name.*);

    const id: ir.TypeId = @fromBackingInt(@intCast(self.items.items.len));

    try self.items.append(self.allocator, .{ .error_set = names });

    return id;
}

pub fn task(self: *Self, result: ir.TypeId, errors: ir.TypeId) zx.Error!ir.TypeId {
    if (try ir.containsNativeReference(self.allocator, self.items.items, result)) return self.reporter.fail(.capability, .{ .start = 0, .end = 0 }, "tasks cannot return host references");
    if (self.get(result) == .task) return self.reporter.fail(.ownership, .{ .start = 0, .end = 0 }, "a task cannot return another task");

    for (self.items.items, 0..) |item, index| {
        if (item == .task and item.task.result == result and item.task.errors == errors) return @fromBackingInt(@intCast(index));
    }

    const id: ir.TypeId = @fromBackingInt(@intCast(self.items.items.len));

    try self.items.append(self.allocator, .{ .task = .{ .result = result, .errors = errors } });

    return id;
}

pub fn get(self: *const Self, id: ir.TypeId) ir.Type {
    return self.items.items[@backingInt(id)];
}

pub fn containsList(self: *const Self, id: ir.TypeId) bool {
    return switch (self.get(id)) {
        .list => true,
        .optional => |child| self.containsList(child),
        .tuple => |children| blk: {
            for (children) |child| {
                if (self.containsList(child)) break :blk true;
            }

            break :blk false;
        },
        .object => |fields| blk: {
            for (fields) |field| {
                if (self.containsList(field.type_id)) break :blk true;
            }

            break :blk false;
        },
        else => false,
    };
}

pub fn object(self: *Self, fields: []ir.TypeField) zx.Error!ir.TypeId {
    for (fields) |field| if (self.get(field.type_id) == .task) return self.reporter.fail(.ownership, .{ .start = 0, .end = 0 }, "tasks cannot be placed in objects");

    std.mem.sort(ir.TypeField, fields, {}, lessThan);

    for (self.items.items, 0..) |item, index| {
        if (item != .object or item.object.len != fields.len) continue;

        var equal = true;

        for (item.object, fields) |left, right| {
            if (left.type_id != right.type_id or !std.mem.eql(u8, left.name, right.name)) {
                equal = false;

                break;
            }
        }

        if (equal) return @fromBackingInt(@intCast(index));
    }

    const id: ir.TypeId = @fromBackingInt(@intCast(self.items.items.len));

    try self.items.append(self.allocator, .{ .object = fields });

    return id;
}

fn lessThan(_: void, left: ir.TypeField, right: ir.TypeField) bool {
    return std.mem.lessThan(u8, left.name, right.name);
}
