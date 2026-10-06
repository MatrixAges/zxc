const std = @import("std");
const dsl = @import("dsl");
const checks = @import("checks.zig");
const modules = @import("modules.zig");

pub fn validate(allocator: std.mem.Allocator, sources: []const modules.Source, entries: []const modules.Module, source_index: *usize, reporter: *dsl.Reporter) dsl.Error![]const usize {
    if (!@import("rx_options").generated_graph) return @import("dependency_graph/seed.zig").validate(allocator, sources, entries, source_index, reporter);

    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const prepared = try @import("dependency_graph/prepare.zig").build(arena.allocator(), sources, entries);

    const result = @import("generated_graph").execute(&arena, &prepared.input) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        error.IndexOutOfBounds => unreachable,
    };

    if (result.issue != .None) {
        const link = prepared.links[@intCast(result.edge)];
        source_index.* = link.owner;

        const message = switch (result.issue) {
            .None => unreachable,
            .InvalidPath => "Module reference escapes the project root or is not a valid module path",
            .Missing => "Referenced module file is not registered",
            .Cycle => "Reference creates a circular module dependency",
        };

        return checks.fail(link.node.*, link.attribute, message, reporter);
    }

    std.debug.assert(result.count == sources.len);

    const order = try allocator.alloc(usize, @intCast(result.count));

    for (order, result.order[0..order.len]) |*target, value| target.* = @intCast(value);

    return order;
}
