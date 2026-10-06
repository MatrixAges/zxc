const std = @import("std");
const ir = @import("zx").ir;
const NominalOrigins = @import("../nominal_origins.zig");
const Error = @import("model.zig").Error;
const Self = @This();

allocator: std.mem.Allocator,
temporary: std.mem.Allocator,
source: ir.TypeTable,
origins: NominalOrigins.Table,
mapping: []?ir.TypeId,
items: ir.TypeStorage = .{},
nominal_origins: NominalOrigins,
pub fn init(allocator: std.mem.Allocator, temporary: std.mem.Allocator, source: ir.TypeTable, origins: NominalOrigins.Table) Error!Self {
    if (!@import("../../ir/type_rules.zig").validate(source)) return error.InvalidIr;
    if (!origins.hasValidShape()) return error.InvalidModule;

    const mapping = try temporary.alloc(?ir.TypeId, source.count());
    var self = Self{ .allocator = allocator, .temporary = temporary, .source = source, .origins = origins, .mapping = mapping, .nominal_origins = .{ .allocator = allocator } };
    const count = std.enums.values(ir.Scalar).len;

    @memset(mapping, null);

    try self.items.appendDelta(allocator, source.prefix(count));
    for (0..count) |index| mapping[index] = @fromBackingInt(@intCast(index));

    return self;
}

pub fn include(self: *Self, id: ir.TypeId) Error!ir.TypeId {
    const index = @backingInt(id);

    if (index >= self.source.count()) return error.InvalidModule;
    if (self.mapping[index]) |mapped| return mapped;

    const Step = struct { id: ir.TypeId, ready: bool = false };
    var pending: std.ArrayList(Step) = .empty;

    defer pending.deinit(self.temporary);

    try pending.append(self.temporary, .{ .id = id });

    while (pending.pop()) |step| {
        const current = @backingInt(step.id);

        if (self.mapping[current] != null) continue;

        const value = self.source.at(current);

        if (!step.ready) {
            try pending.append(self.temporary, .{ .id = step.id, .ready = true });

            switch (value) {
                .task => |task| {
                    try pending.append(self.temporary, .{ .id = task.result });
                    try pending.append(self.temporary, .{ .id = task.errors });
                },
                .optional, .list => |child| try pending.append(self.temporary, .{ .id = child }),
                .tuple => |children| {
                    var remaining = children.len;

                    while (remaining > 0) {
                        remaining -= 1;

                        try pending.append(self.temporary, .{ .id = children.at(remaining) });
                    }
                },
                .object => |fields| {
                    var remaining = fields.len;

                    while (remaining > 0) {
                        remaining -= 1;

                        try pending.append(self.temporary, .{ .id = fields.at(remaining).type_id });
                    }
                },
                .scalar, .enumeration, .error_set, .native_reference => {},
            }

            continue;
        }

        const mapped: ir.TypeId = @fromBackingInt(@intCast(self.items.view().count()));

        try self.items.append(self.allocator, try self.copy(current));

        self.mapping[current] = mapped;

        if (value.nominalName()) |name| {
            var origin: ?NominalOrigins.Origin = null;

            for (0..self.origins.count()) |origin_index| {
                const item = self.origins.at(origin_index);

                if (item.type_id != step.id) continue;
                if (origin != null or !std.mem.eql(u8, item.name, name)) return error.InvalidModule;

                origin = item.origin;
            }

            try self.nominal_origins.append(self.items.view(), @backingInt(mapped), origin orelse return error.MissingNominalOrigin);
        }
    }

    return self.mapping[index].?;
}

fn copy(self: *Self, index: usize) Error!ir.TypeValue {
    const value = try @import("../../analysis/semantic/remap.zig").value(self.temporary, self.source, index, .{ .sparse = self.mapping });

    return switch (value) {
        .scalar => |scalar| .{ .scalar = scalar },
        .native_reference => |name| .{ .native_reference = try self.allocator.dupe(u8, name) },
        .task, .optional, .list, .tuple => value,
        .object => |fields| blk: {
            const names = try self.allocator.alloc([]const u8, fields.len);

            for (fields.names, names) |name, *owned| owned.* = try self.allocator.dupe(u8, name);

            break :blk .{ .object = .{ .names = names, .types = fields.types, .len = fields.len } };
        },
        .error_set => |names| blk: {
            const members = try self.allocator.alloc([]const u8, names.len);

            for (names, members) |member, *owned| owned.* = try self.allocator.dupe(u8, member);

            break :blk .{ .error_set = members };
        },
        .enumeration => |value_enum| blk: {
            const members = try self.allocator.alloc([]const u8, value_enum.members.len);

            for (value_enum.members, members) |member, *owned| owned.* = try self.allocator.dupe(u8, member);

            break :blk .{ .enumeration = .{ .name = try self.allocator.dupe(u8, value_enum.name), .members = members } };
        },
    };
}
