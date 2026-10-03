const std = @import("std");
pub const Mode = enum { Scale, Keep };
pub const Item = struct { value: f64 };
pub const Snapshot = struct { value: f64 };
pub const Request = struct { items: []const Item, baseline: []const Snapshot, factor: f64, mode: ?Mode };
pub const Response = struct { items: []const Snapshot, baseline: []const Snapshot, mode: ?Mode };

pub fn process(allocator: std.mem.Allocator, input: Request) !Response {
    const items = try allocator.alloc(Snapshot, input.items.len);

    for (input.items, items) |item, *result| {
        result.* = .{ .value = if (input.mode == .Scale) item.value * input.factor else item.value };
    }

    return .{ .items = items, .baseline = input.baseline, .mode = input.mode };
}
