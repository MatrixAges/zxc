const model = @import("model.zig");
const Self = @This();
pub const borrow = @import("borrow.zig").columns;
pub const validStructure = @import("structure.zig").valid;

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

pub fn prefix(self: Self, len: usize) Self {
    var result = self;
    result.kinds = self.kinds[0..len];
    result.first = self.first[0..len];
    result.second = self.second[0..len];
    result.labels = self.labels[0..len];
    var child_end: usize = 0;
    var field_end: usize = 0;
    var name_end: usize = 0;

    for (result.kinds, result.first, result.second) |code, first, second| {
        const kind: model.Kind = @fromBackingInt(@intCast(code));
        const end = @as(usize, first) + @as(usize, second);

        switch (kind) {
            .object => field_end = @max(field_end, end),
            .tuple => child_end = @max(child_end, end),
            .error_set, .enumeration => name_end = @max(name_end, end),
            else => {},
        }
    }

    result.children = self.children[0..child_end];
    result.field_types = self.field_types[0..field_end];
    result.field_names = self.field_names[0..field_end];
    result.names = self.names[0..name_end];

    return result;
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
