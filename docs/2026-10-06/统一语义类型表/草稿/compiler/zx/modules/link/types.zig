const std = @import("std");
const ir = @import("zx").ir;
const lookup = @import("../../analysis/semantic/lookup.zig");
const Origins = @import("../nominal_origins.zig");
const Module = @import("../artifact/model.zig").Module;
const Self = @This();
pub const Error = std.mem.Allocator.Error || error{ InvalidModule, MissingNominalOrigin, ConflictingNominalType };

allocator: std.mem.Allocator,
items: ir.TypeStorage = .{},
origins: Origins,
pub fn init(allocator: std.mem.Allocator) Error!Self {
    var self = Self{ .allocator = allocator, .origins = .{ .allocator = allocator } };

    for (std.enums.values(ir.Scalar)) |scalar| try self.items.append(allocator, .{ .scalar = scalar });

    return self;
}

pub fn append(self: *Self, temporary: std.mem.Allocator, module: Module) Error![]const ir.TypeId {
    return self.appendFrom(temporary, module.types, module.nominal_types, 0);
}

pub fn appendFrom(self: *Self, temporary: std.mem.Allocator, values: ir.TypeTable, nominal_types: []const Origins.Item, first: usize) Error![]const ir.TypeId {
    if (!@import("../../ir/type_rules.zig").validate(values)) return error.InvalidModule;

    const origins = try temporary.alloc(?Origins.Origin, values.count());

    @memset(origins, null);

    for (nominal_types) |item| {
        const index = @backingInt(item.type_id);

        if (index >= values.count() or origins[index] != null) return error.InvalidModule;

        const name = values.at(index).nominalName() orelse return error.InvalidModule;

        if (!std.mem.eql(u8, name, item.name)) return error.InvalidModule;
        if (values.at(index) == .native_reference and item.origin != .native) return error.InvalidModule;

        origins[index] = item.origin;
    }

    if (first > values.count() or (first != 0 and first != self.items.view().count())) return error.InvalidModule;

    const mapping = try self.allocator.alloc(ir.TypeId, values.count());

    for (0..first) |index| {
        const value = values.at(index);
        const existing = self.items.view().at(index);

        if (!sameType(value, existing)) return error.InvalidModule;

        mapping[index] = @fromBackingInt(@intCast(index));
    }

    for (first..values.count()) |index| {
        const value = values.at(index);
        const mapped = try remap(temporary, value, mapping[0..index]);

        if (value.nominalName() != null) {
            mapping[index] = try self.nominal(mapped, origins[index] orelse return error.MissingNominalOrigin);
        } else {
            mapping[index] = try self.structural(mapped);
        }
    }

    return mapping;
}

fn structural(self: *Self, value: ir.TypeValue) Error!ir.TypeId {
    if (try lookup.find(self.items.view(), value)) |id| return id;

    return self.insert(value);
}

fn nominal(self: *Self, value: ir.TypeValue, origin: Origins.Origin) Error!ir.TypeId {
    for (self.origins.items.items) |item| {
        if (!std.mem.eql(u8, item.name, value.nominalName().?) or !Origins.same(item.origin, origin)) continue;
        if (!sameType(self.items.view().at(@backingInt(item.type_id)), value)) return error.ConflictingNominalType;

        return item.type_id;
    }

    const id = try self.insert(value);

    try self.origins.append(self.items.view(), @backingInt(id), origin);

    return id;
}

fn insert(self: *Self, value: ir.TypeValue) Error!ir.TypeId {
    const owned: ir.TypeValue = switch (value) {
        .scalar, .optional, .list, .task => value,
        .native_reference => |name| .{ .native_reference = try self.allocator.dupe(u8, name) },
        .tuple => |children| .{ .tuple = try self.allocator.dupe(ir.TypeId, children) },
        .object => |fields| blk: {
            const names = try self.allocator.alloc([]const u8, fields.len);

            for (fields.names, names) |name, *copied| copied.* = try self.allocator.dupe(u8, name);

            break :blk .{ .object = .{ .names = names, .types = fields.types, .len = fields.len } };
        },
        .error_set => |names| blk: {
            const members = try self.allocator.alloc([]const u8, names.len);

            for (names, members) |member, *owned| owned.* = try self.allocator.dupe(u8, member);

            break :blk .{ .error_set = members };
        },
        .enumeration => |entry| blk: {
            const members = try self.allocator.alloc([]const u8, entry.members.len);

            for (entry.members, members) |member, *copied| copied.* = try self.allocator.dupe(u8, member);

            break :blk .{ .enumeration = .{ .name = try self.allocator.dupe(u8, entry.name), .members = members } };
        },
    };

    const id: ir.TypeId = @fromBackingInt(@intCast(self.items.count()));

    try self.items.append(self.allocator, owned);

    return id;
}

fn remap(allocator: std.mem.Allocator, value: ir.Type, mapping: []const ir.TypeId) Error!ir.TypeValue {
    return switch (value) {
        .scalar => |scalar| .{ .scalar = scalar },
        .enumeration => |entry| .{ .enumeration = .{ .name = entry.name, .members = entry.members } },
        .error_set => |members| .{ .error_set = members },
        .native_reference => |name| .{ .native_reference = name },
        .task => |task| .{ .task = .{ .result = mapping[@backingInt(task.result)], .errors = mapping[@backingInt(task.errors)] } },
        .optional => |child| .{ .optional = mapping[@backingInt(child)] },
        .list => |child| .{ .list = mapping[@backingInt(child)] },
        .tuple => |children| blk: {
            const mapped = try allocator.alloc(ir.TypeId, children.len);

            for (mapped, 0..) |*item, position| item.* = mapping[@backingInt(children.at(position))];

            break :blk .{ .tuple = mapped };
        },
        .object => |fields| blk: {
            const mapped = try allocator.alloc(u32, fields.len);

            for (fields.types, mapped) |type_id, *field| field.* = @backingInt(mapping[type_id]);

            break :blk .{ .object = .{ .names = fields.names, .types = mapped, .len = fields.len } };
        },
    };
}

fn sameType(left: ir.Type, right: anytype) bool {
    if (std.meta.activeTag(left) != std.meta.activeTag(right)) return false;

    return switch (left) {
        .scalar => |value| value == right.scalar,
        .native_reference => |name| std.mem.eql(u8, name, right.native_reference),
        .task => |task| task.result == right.task.result and task.errors == right.task.errors,
        .error_set => |members| blk: {
            if (members.len != right.error_set.len) break :blk false;

            for (members, right.error_set) |left_name, right_name| {
                if (!std.mem.eql(u8, left_name, right_name)) break :blk false;
            }

            break :blk true;
        },
        .optional => |child| child == right.optional,
        .list => |child| child == right.list,
        .tuple => |children| blk: {
            if (children.len != right.tuple.len) break :blk false;

            for (0..children.len) |position| {
                const child = if (@TypeOf(right) == ir.Type) right.tuple.at(position) else right.tuple[position];

                if (children.at(position) != child) break :blk false;
            }

            break :blk true;
        },
        .object => |fields| blk: {
            if (fields.len != right.object.len) break :blk false;

            for (0..fields.len) |position| {
                const a = fields.at(position);
                const b = right.object.at(position);

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
