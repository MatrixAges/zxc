const std = @import("std");
const zx = @import("zx");
const project = @import("../../modules/project.zig");
const resources = @import("root.zig");

pub const Result = union(enum) { sources: []const project.Source, diagnostic: zx.Diagnostic };

pub fn sources(allocator: std.mem.Allocator, inputs: []const project.Source, options: project.Options) std.mem.Allocator.Error!Result {
    var updated: ?[]project.Source = null;

    for (inputs, 0..) |source, index| {
        if (std.mem.indexOf(u8, source.source, "templateFile") == null) continue;

        var reporter: zx.Reporter = .{};

        const expanded = resources.expand(allocator, source, options, &reporter) catch |err| {
            if (err == error.OutOfMemory) return error.OutOfMemory;

            var issue = reporter.diagnostic.?;
            issue.source_index = index;

            return .{ .diagnostic = issue };
        };

        if (expanded.source.ptr == source.source.ptr) continue;
        if (updated == null) updated = try allocator.dupe(project.Source, inputs);

        updated.?[index] = expanded;
    }

    return .{ .sources = updated orelse inputs };
}
