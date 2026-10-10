const std = @import("std");
const ir = @import("zx").ir;
const Self = @This();

pub const Variant = enum {
    regular,
    value,
    buffered,
    buffered_pointer,
    pub fn member(self: Variant) []const u8 {
        return switch (self) {
            .regular => "call",
            .value => "callValue",
            .buffered => "callBuffered",
            .buffered_pointer => "callBufferedPointer",
        };
    }
    pub fn name(self: Variant, allocator: std.mem.Allocator, id: ir.FunctionId) std.mem.Allocator.Error![]const u8 {
        return if (self == .regular)
            std.fmt.allocPrint(allocator, "function_{d}", .{@backingInt(id)})
        else
            std.fmt.allocPrint(allocator, "function_{d}_{s}", .{ @backingInt(id), @tagName(self) });
    }
};

pub const Item = struct { id: ir.FunctionId, variant: Variant, first: bool };

items: std.ArrayList(Item) = .empty,
seen: []std.EnumSet(Variant),
pub fn init(allocator: std.mem.Allocator, count: usize) std.mem.Allocator.Error!Self {
    const seen = try allocator.alloc(std.EnumSet(Variant), count);

    @memset(seen, std.EnumSet(Variant).empty);

    return .{ .seen = seen };
}

pub fn add(self: *Self, allocator: std.mem.Allocator, id: ir.FunctionId, variant: Variant) std.mem.Allocator.Error!void {
    const seen = &self.seen[@backingInt(id)];

    if (seen.contains(variant)) return;

    try self.items.append(allocator, .{ .id = id, .variant = variant, .first = seen.count() == 0 });

    seen.insert(variant);
}
