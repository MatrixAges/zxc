const std = @import("std");
const ir = @import("zx").ir;
const Origins = @import("../nominal_origins.zig");
const Module = @import("../artifact/model.zig").Module;
const Self = @This();
pub const Error = std.mem.Allocator.Error || error{ InvalidModule, MissingNominalOrigin, ConflictingNominalType };

allocator: std.mem.Allocator,
items: std.ArrayList(ir.Type) = .empty,
origins: Origins,
pub fn init(allocator: std.mem.Allocator) Error!Self {
    var self = Self{ .allocator = allocator, .origins = .{ .allocator = allocator } };

    for (std.enums.values(ir.Scalar)) |scalar| try self.items.append(allocator, .{ .scalar = scalar });

    return self;
}

pub fn append(self: *Self, temporary: std.mem.Allocator, module: Module) Error![]const ir.TypeId {
    if (!@import("../../ir/type_rules.zig").validate(module.types)) return error.InvalidModule;

    const origins = try temporary.alloc(?Origins.Origin, module.types.len);

    @memset(origins, null);

    for (module.nominal_types) |item| {
        const index = @intFromEnum(item.type_id);

        if (index >= module.types.len or origins[index] != null) return error.InvalidModule;
        if (module.types[index] != .enumeration or !std.mem.eql(u8, module.types[index].enumeration.name, item.name)) return error.InvalidModule;

        origins[index] = item.origin;
    }

    const mapping = try self.allocator.alloc(ir.TypeId, module.types.len);

    for (module.types, 0..) |value, index| {
        const mapped = try remap(temporary, value, mapping[0..index]);

        if (value == .enumeration) {
            mapping[index] = try self.enumeration(mapped, origins[index] orelse return error.MissingNominalOrigin);
        } else {
            mapping[index] = try self.structural(mapped);
        }
    }

    return mapping;
}

fn structural(self: *Self, value: ir.Type) Error!ir.TypeId {
    for (self.items.items, 0..) |existing, index| {
        if (sameType(existing, value)) return @enumFromInt(index);
    }

    return self.insert(value);
}

fn enumeration(self: *Self, value: ir.Type, origin: Origins.Origin) Error!ir.TypeId {
    for (self.origins.items.items) |item| {
        if (!std.mem.eql(u8, item.name, value.enumeration.name) or !sameOrigin(item.origin, origin)) continue;
        if (!sameType(self.items.items[@intFromEnum(item.type_id)], value)) return error.ConflictingNominalType;

        return item.type_id;
    }

    const id = try self.insert(value);

    try self.origins.append(self.items.items, @intFromEnum(id), origin);

    return id;
}

fn insert(self: *Self, value: ir.Type) Error!ir.TypeId {
    const owned: ir.Type = switch (value) {
        .scalar, .optional, .list => value,
        .tuple => |children| .{ .tuple = try self.allocator.dupe(ir.TypeId, children) },
        .object => |fields| blk: {
            const copied = try self.allocator.dupe(ir.TypeField, fields);

            for (copied) |*field| field.name = try self.allocator.dupe(u8, field.name);

            break :blk .{ .object = copied };
        },
        .enumeration => |entry| blk: {
            const members = try self.allocator.alloc([]const u8, entry.members.len);

            for (entry.members, members) |member, *copied| copied.* = try self.allocator.dupe(u8, member);

            break :blk .{ .enumeration = .{ .name = try self.allocator.dupe(u8, entry.name), .members = members } };
        },
    };

    const id: ir.TypeId = @enumFromInt(self.items.items.len);

    try self.items.append(self.allocator, owned);

    return id;
}

fn remap(allocator: std.mem.Allocator, value: ir.Type, mapping: []const ir.TypeId) Error!ir.Type {
    return switch (value) {
        .scalar, .enumeration => value,
        .optional => |child| .{ .optional = mapping[@intFromEnum(child)] },
        .list => |child| .{ .list = mapping[@intFromEnum(child)] },
        .tuple => |children| blk: {
            const mapped = try allocator.alloc(ir.TypeId, children.len);

            for (children, mapped) |child, *item| item.* = mapping[@intFromEnum(child)];

            break :blk .{ .tuple = mapped };
        },
        .object => |fields| blk: {
            const mapped = try allocator.dupe(ir.TypeField, fields);

            for (mapped) |*field| field.type_id = mapping[@intFromEnum(field.type_id)];

            break :blk .{ .object = mapped };
        },
    };
}

fn sameType(left: ir.Type, right: ir.Type) bool {
    if (std.meta.activeTag(left) != std.meta.activeTag(right)) return false;

    return switch (left) {
        .scalar => |value| value == right.scalar,
        .optional => |child| child == right.optional,
        .list => |child| child == right.list,
        .tuple => |children| std.mem.eql(ir.TypeId, children, right.tuple),
        .object => |fields| blk: {
            if (fields.len != right.object.len) break :blk false;

            for (fields, right.object) |a, b| {
                if (a.type_id != b.type_id or !std.mem.eql(u8, a.name, b.name)) break :blk false;
            }

            break :blk true;
        },
        .enumeration => |value| blk: {
            if (!std.mem.eql(u8, value.name, right.enumeration.name) or value.members.len != right.enumeration.members.len) break :blk false;

            for (value.members, right.enumeration.members) |a, b| {
                if (!std.mem.eql(u8, a, b)) break :blk false;
            }

            break :blk true;
        },
    };
}

fn sameOrigin(left: Origins.Origin, right: Origins.Origin) bool {
    if (std.meta.activeTag(left) != std.meta.activeTag(right)) return false;

    return switch (left) {
        .source => |path| std.mem.eql(u8, path, right.source),
        .native => |name| std.mem.eql(u8, name, right.native),
        .external => |entry| std.mem.eql(u8, entry.importer, right.external.importer) and std.mem.eql(u8, entry.binding, right.external.binding) and std.mem.eql(u8, entry.member, right.external.member),
    };
}
