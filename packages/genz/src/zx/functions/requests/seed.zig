const std = @import("std");
const ir = @import("zx").ir;
const Requests = @import("../requests.zig");
const Self = @This();

items: std.ArrayList(Requests.Item) = .empty,
seen: []std.EnumSet(Requests.Variant),
pub fn init(allocator: std.mem.Allocator, count: usize) std.mem.Allocator.Error!Self {
    const seen = try allocator.alloc(std.EnumSet(Requests.Variant), count);

    @memset(seen, std.EnumSet(Requests.Variant).empty);

    return .{ .seen = seen };
}

pub fn add(self: *Self, allocator: std.mem.Allocator, id: ir.FunctionId, variant: Requests.Variant) std.mem.Allocator.Error!void {
    const seen = &self.seen[@backingInt(id)];

    if (seen.contains(variant)) return;

    try self.items.append(allocator, .{ .id = id, .variant = variant, .first = seen.count() == 0 });

    seen.insert(variant);
}
