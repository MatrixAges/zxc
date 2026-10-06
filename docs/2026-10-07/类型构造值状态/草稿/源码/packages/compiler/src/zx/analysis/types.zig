const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Self = @This();
pub const Fields = @import("types/fields.zig");
pub const Shared = @import("shared_types.zig").Shared;
const NativeView = @import("type_views").Native;
const resolution = @import("types/resolve.zig");
const construction = @import("semantic/construction.zig");
const seed = @import("types/construct_seed.zig");

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
    if (!@import("parser_options").generated_parser) return seed.wrap(self, kind, child);

    return construction.create(self, if (kind == .optional) .{ .optional = child } else .{ .list = child });
}

pub fn tuple(self: *Self, children: []const ir.TypeId) zx.Error!ir.TypeId {
    if (!@import("parser_options").generated_parser) return seed.tuple(self, children);

    return construction.create(self, .{ .tuple = children });
}

pub fn errorSet(self: *Self, members: []const []const u8) zx.Error!ir.TypeId {
    if (!@import("parser_options").generated_parser) return seed.errorSet(self, members);

    return construction.create(self, .{ .error_set = members });
}

pub fn task(self: *Self, result: ir.TypeId, errors: ir.TypeId) zx.Error!ir.TypeId {
    if (!@import("parser_options").generated_parser) return seed.task(self, result, errors);

    return construction.create(self, .{ .task = .{ .result = result, .errors = errors } });
}

pub fn get(self: *const Self, id: ir.TypeId) ir.Type {
    return self.items.view().at(@backingInt(id));
}

pub fn containsList(self: *const Self, id: ir.TypeId) std.mem.Allocator.Error!bool {
    if (!@import("parser_options").generated_parser) return seed.containsList(self, id);

    return @import("semantic/query.zig").contains(self.allocator, self.items.view(), id, false);
}

pub fn object(self: *Self, fields: Fields) zx.Error!ir.TypeId {
    if (!@import("parser_options").generated_parser) return seed.object(self, fields);

    return construction.create(self, .{ .object = fields.view() });
}
