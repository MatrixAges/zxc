const std = @import("std");
const ir = @import("zx").ir;
const NominalOrigins = @import("../nominal_origins.zig");
const Error = @import("model.zig").Error;
const Self = @This();

allocator: std.mem.Allocator,
temporary: std.mem.Allocator,
source: []const ir.Type,
origins: []const NominalOrigins.Item,
mapping: []?ir.TypeId,
items: std.ArrayList(ir.Type) = .empty,
nominal_origins: NominalOrigins,
pub fn init(allocator: std.mem.Allocator, temporary: std.mem.Allocator, source: []const ir.Type, origins: []const NominalOrigins.Item) Error!Self {
    if (!@import("../../ir/type_rules.zig").validate(source)) return error.InvalidIr;

    const mapping = try temporary.alloc(?ir.TypeId, source.len);
    var self = Self{ .allocator = allocator, .temporary = temporary, .source = source, .origins = origins, .mapping = mapping, .nominal_origins = .{ .allocator = allocator } };
    const count = std.enums.values(ir.Scalar).len;

    @memset(mapping, null);

    try self.items.appendSlice(allocator, source[0..count]);
    for (0..count) |index| mapping[index] = @enumFromInt(index);

    return self;
}

pub fn include(self: *Self, id: ir.TypeId) Error!ir.TypeId {
    const index = @intFromEnum(id);

    if (index >= self.source.len) return error.InvalidModule;
    if (self.mapping[index]) |mapped| return mapped;

    const Step = struct { id: ir.TypeId, ready: bool = false };
    var pending: std.ArrayList(Step) = .empty;

    defer pending.deinit(self.temporary);

    try pending.append(self.temporary, .{ .id = id });

    while (pending.pop()) |step| {
        const current = @intFromEnum(step.id);

        if (self.mapping[current] != null) continue;

        const value = self.source[current];

        if (!step.ready) {
            try pending.append(self.temporary, .{ .id = step.id, .ready = true });

            switch (value) {
                .optional, .list => |child| try pending.append(self.temporary, .{ .id = child }),
                .tuple => |children| {
                    var remaining = children.len;

                    while (remaining > 0) {
                        remaining -= 1;

                        try pending.append(self.temporary, .{ .id = children[remaining] });
                    }
                },
                .object => |fields| {
                    var remaining = fields.len;

                    while (remaining > 0) {
                        remaining -= 1;

                        try pending.append(self.temporary, .{ .id = fields[remaining].type_id });
                    }
                },
                .scalar, .enumeration => {},
            }

            continue;
        }

        const mapped: ir.TypeId = @enumFromInt(self.items.items.len);

        try self.items.append(self.allocator, try self.copy(value));

        self.mapping[current] = mapped;

        if (value == .enumeration) {
            var origin: ?NominalOrigins.Origin = null;

            for (self.origins) |item| {
                if (item.type_id != step.id) continue;
                if (origin != null or !std.mem.eql(u8, item.name, value.enumeration.name)) return error.InvalidModule;

                origin = item.origin;
            }

            try self.nominal_origins.append(self.items.items, @intFromEnum(mapped), origin orelse return error.MissingNominalOrigin);
        }
    }

    return self.mapping[index].?;
}

fn copy(self: *Self, value: ir.Type) Error!ir.Type {
    return switch (value) {
        .scalar => value,
        .optional => |child| .{ .optional = self.mapping[@intFromEnum(child)].? },
        .list => |child| .{ .list = self.mapping[@intFromEnum(child)].? },
        .tuple => |children| blk: {
            const result = try self.allocator.alloc(ir.TypeId, children.len);

            for (children, result) |child, *mapped| mapped.* = self.mapping[@intFromEnum(child)].?;

            break :blk .{ .tuple = result };
        },
        .object => |fields| blk: {
            const result = try self.allocator.alloc(ir.TypeField, fields.len);

            for (fields, result) |field, *mapped| mapped.* = .{ .name = try self.allocator.dupe(u8, field.name), .type_id = self.mapping[@intFromEnum(field.type_id)].? };

            break :blk .{ .object = result };
        },
        .enumeration => |value_enum| blk: {
            const members = try self.allocator.alloc([]const u8, value_enum.members.len);

            for (value_enum.members, members) |member, *owned| owned.* = try self.allocator.dupe(u8, member);

            break :blk .{ .enumeration = .{ .name = try self.allocator.dupe(u8, value_enum.name), .members = members } };
        },
    };
}
