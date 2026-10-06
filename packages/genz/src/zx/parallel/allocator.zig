const node = @import("../../node.zig");
const Lower = @import("../lower.zig");

pub fn declaration(self: *Lower) Lower.Error!node.Declaration {
    return .{ .constant = .{ .name = "zx_parallel_allocator", .value = try @import("../allocator.zig").lower(self, false) } };
}
