const std = @import("std");
const check = @import("check");

const sample: check.Case = .{
    .body = "  const first = in.lists.first.reverse()[0]\n  const second = in.lists.second.sort()[0]\n\n  return first.length + second.length + in.count",
    .input = "{ lists: { first: u64[], second: u64[] }, count: u64 }",
};

pub fn main() !void {
    var safe: std.heap.SafeAllocator = .init(std.heap.page_allocator, .{});
    defer _ = safe.deinit();
    const backing = safe.allocator();
    var vtable = backing.vtable.*;
    vtable.resize = std.mem.Allocator.noResize;
    vtable.remap = std.mem.Allocator.noRemap;
    const stable: std.mem.Allocator = .{ .ptr = backing.ptr, .vtable = &vtable };

    for ([_]std.mem.Allocator{ backing, stable }, [_][]const u8{ "safe", "no_resize" }) |allocator, name| {
        for (0..20) |index| {
            var failing = std.testing.FailingAllocator.init(allocator, .{});

            try check.allocated(failing.allocator(), sample);

            std.debug.print("{s} {d}: allocations={d} resizes={d} bytes={d} freed={d}\n", .{ name, index, failing.alloc_index, failing.resize_index, failing.allocated_bytes, failing.freed_bytes });
        }
    }

    try std.testing.checkAllAllocationFailures(stable, check.allocated, .{sample});

    std.debug.print("existing allocation-failure traversal: passed\n", .{});
}
