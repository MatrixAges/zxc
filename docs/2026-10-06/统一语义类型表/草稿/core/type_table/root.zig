const model = @import("model.zig");
const Self = @This();

kinds: []const u8 = &.{},
first: []const u32 = &.{},
second: []const u32 = &.{},
labels: []const []const u8 = &.{},
children: []const u32 = &.{},
field_types: []const u32 = &.{},
field_names: []const []const u8 = &.{},
names: []const []const u8 = &.{},
pub fn count(self: Self) usize {
    return self.kinds.len;
}

pub fn get(self: Self, id: model.TypeId) model.Type {
    return self.at(@backingInt(id));
}

pub fn at(self: Self, index: usize) model.Type {
    const kind: model.Kind = @fromBackingInt(@intCast(self.kinds[index]));
    const first: usize = self.first[index];
    const second: usize = self.second[index];

    return switch (kind) {
        .scalar => .{ .scalar = @fromBackingInt(@intCast(first)) },
        .object => .{ .object = .{
            .names = self.field_names[first..][0..second],
            .types = self.field_types[first..][0..second],
            .len = second,
        } },
        .optional => .{ .optional = @fromBackingInt(@intCast(first)) },
        .list => .{ .list = @fromBackingInt(@intCast(first)) },
        .tuple => .{ .tuple = .{ .values = self.children[first..][0..second], .len = second } },
        .error_set => .{ .error_set = self.names[first..][0..second] },
        .task => .{ .task = .{ .result = @fromBackingInt(@intCast(first)), .errors = @fromBackingInt(@intCast(second)) } },
        .enumeration => .{ .enumeration = .{ .name = self.labels[index], .members = self.names[first..][0..second] } },
        .native_reference => .{ .native_reference = self.labels[index] },
    };
}
