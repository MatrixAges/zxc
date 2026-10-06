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

pub fn appendFrom(self: *Self, temporary: std.mem.Allocator, values: ir.TypeTable, nominal_types: Origins.Table, first: usize) Error![]const ir.TypeId {
    if (!@import("../../ir/type_rules.zig").validate(values)) return error.InvalidModule;

    const prepared = try @import("../../analysis/semantic/preflight.zig").prepare(self.allocator, temporary, values, nominal_types, self.items.view(), first);
    const origins = prepared.origins;
    const mapping = prepared.mapping;

    for (first..values.count()) |index| {
        const value = values.at(index);
        const mapped = try @import("../../analysis/semantic/remap.zig").value(temporary, values, index, .{ .dense = mapping[0..index] });

        if (value.nominalName() != null) {
            mapping[index] = try self.nominal(mapped, nominal_types.at(origins[index] orelse return error.MissingNominalOrigin).origin);
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
    if (try @import("../../analysis/semantic/nominal.zig").find(self.items.view(), self.origins.items.view(), origin, value)) |id| return id;

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
