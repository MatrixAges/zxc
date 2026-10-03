const std = @import("std");
const abi = @import("zxc_abi").native.@"zig:bridge";
const layouts = @import("zxc_abi").layouts.@"zig:bridge";
pub const Mode = abi.Mode;
pub const Item = abi.Item;
pub const Snapshot = abi.Snapshot;
pub const Request = abi.Request;
pub const Response = abi.Response;

pub fn process(allocator: std.mem.Allocator, input: Request) !Response {
    const items = try allocator.alloc(Snapshot, input.items.len);

    if (input.offset < 0) return error.NegativeOffset;

    for (input.items, items) |item, *result| {
        const snapshot = try allocator.create(layouts.Snapshot);
        snapshot.* = .{ .value = if (input.mode == .Add) item.value + input.offset else item.value };
        result.* = snapshot;
    }

    const output = try allocator.create(layouts.Response);

    output.* = .{ .items = items, .baseline = input.baseline, .mode = input.mode };

    return output;
}
