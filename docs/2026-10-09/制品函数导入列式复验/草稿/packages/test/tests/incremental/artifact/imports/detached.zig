const std = @import("std");
const f = @import("fixture.zig");
const Self = @This();

results: [4]f.artifact.Result,
values: [4]f.artifact.Module,
pub fn init(allocator: std.mem.Allocator, ordering: [3][]const u8, alias: bool) !Self {
    var analysis = try f.analyze(allocator, ordering, alias);

    defer analysis.deinit();

    var result: Self = undefined;
    var count: usize = 0;

    errdefer for (result.results[0..count]) |*item| item.deinit();

    for (&result.results, &result.values, 0..) |*item, *value, index| {
        item.* = try f.artifact.extract(allocator, &analysis, index);
        value.* = item.value;
        count += 1;
    }

    return result;
}

pub fn deinit(self: *Self) void {
    for (&self.results) |*result| result.deinit();
}
