const std = @import("std");
const ir = @import("zx").ir;
const lookup = @import("../../analysis/semantic/lookup.zig");
const Origins = @import("../nominal_origins.zig");
pub const Error = std.mem.Allocator.Error || error{ InvalidModule, MissingNominalOrigin, ConflictingNominalType };

pub fn appendPrepared(self: anytype, temporary: std.mem.Allocator, values: ir.TypeTable, nominal_types: Origins.Table, first: usize, origins: []const u64, mapping: []ir.TypeId) Error![]const ir.TypeId {
    for (first..values.count()) |index| {
        const value = values.at(index);
        const mapped = try @import("../../analysis/semantic/remap.zig").value(temporary, values, index, .{ .dense = mapping[0..index] });

        if (value.nominalName() != null) {
            if (origins[index] == 0) return error.MissingNominalOrigin;

            mapping[index] = try nominal(self, mapped, nominal_types.at(@intCast(origins[index] - 1)).origin);
        } else {
            mapping[index] = try structural(self, mapped);
        }
    }

    return mapping;
}

fn structural(self: anytype, value: ir.TypeValue) Error!ir.TypeId {
    if (try lookup.find(self.items.view(), value)) |id| return id;

    return insert(self, value);
}

fn nominal(self: anytype, value: ir.TypeValue, origin: Origins.Origin) Error!ir.TypeId {
    if (try @import("../../analysis/semantic/nominal.zig").find(self.items.view(), self.origins.items.view(), origin, value)) |id| return id;

    const id = try insert(self, value);

    try self.origins.append(self.items.view(), @backingInt(id), origin);

    return id;
}

fn insert(self: anytype, value: ir.TypeValue) Error!ir.TypeId {
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
