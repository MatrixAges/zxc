const std = @import("std");
const data = @import("nominal_data");
pub const Writer = @import("zxc_abi").native.@"zig:origin_writer".Writer;

pub const View = struct {
    allocator: std.mem.Allocator,
    items: *data.Storage,
    labels: []const []const u8,
    origin: data.Origin,
};

pub fn append(writer: Writer, index: u64) std.mem.Allocator.Error!void {
    const view: *const View = @ptrCast(@alignCast(writer));

    try view.items.append(view.allocator, .{
        .type_id = @fromBackingInt(@intCast(index)),
        .origin = try data.copy(view.allocator, view.origin),
        .name = view.labels[@intCast(index)],
    });
}
