const std = @import("std");
const dsl = @import("dsl");
const modules = @import("modules.zig");

pub fn validate(allocator: std.mem.Allocator, sources: []const modules.Source, entries: []const modules.Module, source_index: *usize, reporter: *dsl.Reporter) dsl.Error![]const usize {
    if (!@import("rx_options").generated_graph) return @import("dependency_graph/seed.zig").validate(allocator, sources, entries, source_index, reporter);

    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const temporary = arena.allocator();
    const prepared = try @import("dependency_graph/prepare.zig").build(temporary, sources, entries);
    const execute = @import("generated_graph").executeValue;
    const Parameter = @typeInfo(@TypeOf(execute)).@"fn".param_types[1].?;

    const result = execute(temporary, if (@typeInfo(Parameter) == .pointer) &prepared.input else prepared.input) catch |err| switch (err) {
        error.OutOfMemory, error.Overflow => return error.OutOfMemory,
        error.IndexOutOfBounds => unreachable,
    };

    if (result.message) |message| {
        const link = prepared.links[@intCast(result.edge)];

        source_index.* = @intCast(result.owner);

        return reporter.fail(.{
            .code = .context,
            .location = link.attribute.value_location,
            .element = link.node.name,
            .attribute = link.attribute.name,
            .message = message,
        });
    }

    std.debug.assert(result.count == sources.len);

    if (comptime @sizeOf(usize) == @sizeOf(u64) and @alignOf(u64) >= @alignOf(usize)) {
        return allocator.dupe(usize, @ptrCast(result.order[0..sources.len]));
    }

    const order = try allocator.alloc(usize, @intCast(result.count));

    for (order, result.order[0..order.len]) |*target, value| target.* = @intCast(value);

    return order;
}
