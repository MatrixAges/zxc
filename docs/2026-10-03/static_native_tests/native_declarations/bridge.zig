const std = @import("std");
pub const Mode = enum { Add, Keep };
pub const Item = struct { value: i32 };
pub const Snapshot = struct { value: i32 };
pub const Request = struct { items: []const Item, baseline: []const Snapshot, offset: i32, mode: ?Mode };
pub const Response = struct { items: []const Snapshot, baseline: []const Snapshot, mode: ?Mode };

pub fn process(allocator: std.mem.Allocator, input: Request) !Response {
    const items = try allocator.alloc(Snapshot, input.items.len);

    if (input.offset < 0) return error.NegativeOffset;

    for (input.items, items) |item, *result| {
        result.* = .{ .value = if (input.mode == .Add) item.value + input.offset else item.value };
    }

    return .{ .items = items, .baseline = input.baseline, .mode = input.mode };
}
