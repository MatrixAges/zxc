const std = @import("std");
const zx = @import("zx");

pub const Index = struct { first: []const u32, items: []const u32 };

pub fn build(allocator: std.mem.Allocator, count: usize, owners: []const u32) std.mem.Allocator.Error!Index {
    if (!@import("genz_options").generated_analysis) return seed(allocator, count, owners);

    const entry = @import("generated_uniqueness_group");
    const Input = std.meta.Child(entry.Input);
    const input: Input = .{ .count = count, .owners = owners, .items = null };

    const output = zx.columns.invoke(entry.executeValue, allocator, &input) catch |err| switch (@as(anyerror, err)) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => return error.OutOfMemory,
        else => std.debug.panic("replay visit grouping failed: {s}", .{@errorName(err)}),
    };

    return .{ .first = output.first, .items = output.items };
}

fn seed(allocator: std.mem.Allocator, count: usize, owners: []const u32) std.mem.Allocator.Error!Index {
    const first = try allocator.alloc(u32, count + 1);
    const items = try allocator.alloc(u32, owners.len);

    @memset(first, 0);

    for (owners) |body| first[body] += 1;
    for (1..first.len) |index| first[index] += first[index - 1];

    var index = owners.len;

    while (index != 0) {
        index -= 1;
        const body = owners[index];
        first[body] -= 1;
        items[first[body]] = @intCast(index);
    }

    return .{ .first = first, .items = items };
}
