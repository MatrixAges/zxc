const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Self = @This();
pub const Shared = @import("shared_types.zig").Shared;

allocator: std.mem.Allocator,
reporter: *zx.Reporter,
declarations: []const zx.ast.Declaration,
items: std.ArrayList(ir.Type) = .empty,
resolved: std.StringHashMapUnmanaged(ir.TypeId) = .empty,
visiting: std.StringHashMapUnmanaged(void) = .empty,
aliases: []const ir.Export = &.{},
shared: ?Shared = null,
pub fn initialize(self: *Self) zx.Error!void {
    const first = self.items.items.len;

    if (self.items.items.len == 0) {
        for (std.enums.values(ir.Scalar)) |scalar| try self.items.append(self.allocator, .{ .scalar = scalar });
    }

    for (self.aliases, 0..) |alias, index| {
        if (builtin(alias.name) != null or std.mem.eql(u8, alias.name, "Array")) return self.reporter.fail(.name, .{ .start = 0, .end = 0 }, "an imported type cannot replace a built-in type");

        for (self.aliases[0..index]) |previous| {
            if (std.mem.eql(u8, alias.name, previous.name)) return self.reporter.fail(.name, .{ .start = 0, .end = 0 }, "duplicate imported type name");
        }

        for (self.declarations) |declaration| {
            if (std.mem.eql(u8, alias.name, declaration.name.text)) return self.reporter.fail(.name, declaration.name.span, "a local type cannot replace an imported type");
        }
    }

    for (self.declarations, 0..) |declaration, index| {
        if (builtin(declaration.name.text) != null or std.mem.eql(u8, declaration.name.text, "Array")) return self.reporter.fail(.name, declaration.name.span, "a type cannot replace a built-in scalar");

        for (self.declarations[0..index]) |previous| {
            if (std.mem.eql(u8, previous.name.text, declaration.name.text)) return self.reporter.fail(.name, declaration.name.span, "duplicate type declaration");
        }
    }

    for (self.declarations) |declaration| _ = try self.named(declaration.name);
    if (self.shared) |shared| try @import("shared_types.zig").resolve(self, first, shared);
}

pub fn scalarId(scalar: ir.Scalar) ir.TypeId {
    return @fromBackingInt(@intCast(@backingInt(scalar)));
}

pub fn named(self: *Self, name: zx.ast.Name) zx.Error!ir.TypeId {
    if (builtin(name.text)) |scalar| return scalarId(scalar);
    if (self.resolved.get(name.text)) |id| return id;

    for (self.aliases) |alias| {
        if (std.mem.eql(u8, alias.name, name.text)) return alias.type_id;
    }

    if (self.visiting.contains(name.text)) return self.reporter.fail(.type_mismatch, name.span, "recursive type aliases are not supported");
    if (self.visiting.count() >= 256) return self.reporter.fail(.unsupported, name.span, "type alias nesting exceeds 256 levels");

    for (self.declarations) |declaration| {
        if (!std.mem.eql(u8, declaration.name.text, name.text)) continue;
        try self.visiting.put(self.allocator, name.text, {});

        defer _ = self.visiting.remove(name.text);
        const id = if (declaration.value.* == .enumeration) try self.enumeration(declaration.name, declaration.value.enumeration) else try self.resolve(declaration.value);

        try self.resolved.put(self.allocator, name.text, id);

        return id;
    }

    return self.reporter.fail(.name, name.span, "unknown or unsupported type");
}

pub fn resolve(self: *Self, value: *const zx.ast.Type) zx.Error!ir.TypeId {
    switch (value.*) {
        .named => |name| return self.named(name),
        .optional => |child| return self.wrap(.optional, try self.resolve(child)),
        .list => |child| return self.wrap(.list, try self.resolve(child)),
        .tuple => |children| {
            const items = try self.allocator.alloc(ir.TypeId, children.len);

            for (children, 0..) |child, index| items[index] = try self.resolve(child);

            return self.tuple(items);
        },
        .enumeration => return self.reporter.fail(.type_mismatch, .{ .start = 0, .end = 0 }, "enum types require a named declaration"),
        .application => |application| {
            if (std.mem.eql(u8, application.name.text, "Array")) return self.wrap(.list, try self.resolve(application.argument));

            return self.reporter.fail(.unsupported, application.name.span, "generic and database types are not enabled");
        },
        .object => |fields| {
            const resolved_fields = try self.allocator.alloc(ir.TypeField, fields.len);

            for (fields, 0..) |field, index| {
                for (fields[0..index]) |previous| {
                    if (std.mem.eql(u8, previous.name.text, field.name.text)) return self.reporter.fail(.name, field.name.span, "duplicate object field");
                }

                const type_id = try self.resolve(field.value);

                if (type_id == scalarId(.void)) return self.reporter.fail(.type_mismatch, field.name.span, "object fields cannot have type void");

                resolved_fields[index] = .{ .name = try self.allocator.dupe(u8, field.name.text), .type_id = type_id };
            }

            return self.object(resolved_fields);
        },
    }
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
    if (self.get(result) == .task) return self.reporter.fail(.ownership, .{ .start = 0, .end = 0 }, "a task cannot return another task");

    for (self.items.items, 0..) |item, index| {
        if (item == .task and item.task.result == result and item.task.errors == errors) return @fromBackingInt(@intCast(index));
    }

    const id: ir.TypeId = @fromBackingInt(@intCast(self.items.items.len));

    try self.items.append(self.allocator, .{ .task = .{ .result = result, .errors = errors } });

    return id;
}

fn enumeration(self: *Self, name: zx.ast.Name, members: []const zx.ast.Name) zx.Error!ir.TypeId {
    if (members.len == 0) return self.reporter.fail(.type_mismatch, name.span, "an enum must have at least one member");

    const names = try self.allocator.alloc([]const u8, members.len);

    for (members, 0..) |member, index| {
        for (names[0..index]) |previous| {
            if (std.mem.eql(u8, previous, member.text)) return self.reporter.fail(.name, member.span, "duplicate enum member");
        }

        names[index] = try self.allocator.dupe(u8, member.text);
    }

    const id: ir.TypeId = @fromBackingInt(@intCast(self.items.items.len));

    try self.items.append(self.allocator, .{ .enumeration = .{ .name = try self.allocator.dupe(u8, name.text), .members = names } });

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

fn builtin(name: []const u8) ?ir.Scalar {
    if (std.mem.eql(u8, name, "number")) return .f64;
    if (std.mem.eql(u8, name, "boolean")) return .bool;

    return std.meta.stringToEnum(ir.Scalar, name);
}
