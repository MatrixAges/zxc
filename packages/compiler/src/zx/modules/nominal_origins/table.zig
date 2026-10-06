const model = @import("model.zig");
const Self = @This();

ids: []const u32 = &.{},
kinds: []const u8 = &.{},
owners: []const []const u8 = &.{},
members: []const []const u8 = &.{},
names: []const []const u8 = &.{},
pub fn count(self: Self) usize {
    return self.ids.len;
}

pub fn hasValidShape(self: Self) bool {
    if (self.kinds.len != self.ids.len or self.owners.len != self.ids.len or
        self.members.len != self.ids.len or self.names.len != self.ids.len) return false;

    for (self.kinds, self.members) |kind, member| {
        if (kind > 2 or (kind != 2 and member.len != 0)) return false;
    }

    return true;
}

pub fn at(self: Self, index: usize) model.Item {
    return .{
        .type_id = @fromBackingInt(self.ids[index]),
        .origin = switch (self.kinds[index]) {
            0 => .{ .source = self.owners[index] },
            1 => .{ .native = self.owners[index] },
            2 => .{ .external = .{ .module = self.owners[index], .member = self.members[index] } },
            else => unreachable,
        },
        .name = self.names[index],
    };
}

pub fn borrow(comptime Bindings: type, self: Self) Bindings {
    return .{ .ids = self.ids, .kinds = self.kinds, .owners = self.owners, .members = self.members };
}
