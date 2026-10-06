const std = @import("std");
const allocation_testing = @import("allocation_testing");
const rx = @import("rx");
const fixtures = @import("fixtures.zig");
pub const checkPaths = @import("paths.zig").check;

pub fn check(size: usize, shape: fixtures.Shape, edges: []const usize, cyclic_edges: []const usize) !void {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const sources = try fixtures.sources(arena.allocator(), size, shape, edges);

    try validate(std.testing.allocator, sources, size, shape, cyclic_edges);
}

pub fn checkAllocationFailures(size: usize, shape: fixtures.Shape, edges: []const usize, cyclic_edges: []const usize) !void {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const sources = try fixtures.sources(arena.allocator(), size, shape, edges);

    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, validate, .{ sources, size, shape, cyclic_edges });
}

pub fn checkBoundedStack(size: usize, shape: fixtures.Shape, edges: []const usize, cyclic_edges: []const usize) !void {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    var context = struct {
        sources: []const rx.ModuleSource,
        size: usize,
        shape: fixtures.Shape,
        cyclic_edges: []const usize,
        failure: ?anyerror = null,
        fn run(self: *@This()) void {
            validate(std.testing.allocator, self.sources, self.size, self.shape, self.cyclic_edges) catch |err| {
                self.failure = err;
            };
        }
    }{
        .sources = try fixtures.sources(arena.allocator(), size, shape, edges),
        .size = size,
        .shape = shape,
        .cyclic_edges = cyclic_edges,
    };

    const thread = try std.Thread.spawn(.{ .stack_size = 256 * 1024 }, @TypeOf(context).run, .{&context});

    thread.join();

    if (context.failure) |err| return err;
}

fn validate(allocator: std.mem.Allocator, sources: []const rx.ModuleSource, size: usize, shape: fixtures.Shape, cyclic_edges: []const usize) !void {
    var result = try rx.validateModules(allocator, sources);

    defer result.deinit();

    if (cyclic_edges.len == 0) {
        try std.testing.expect(result.value == .data);
        try std.testing.expectEqual(size, result.value.data.len);

        for (result.value.data, 0..) |entry, index| {
            const owner = if (shape == .import) size - index - 1 else index;
            var buffer: [64]u8 = undefined;
            const expected = try std.fmt.bufPrint(&buffer, "graph/n{d}.rx", .{owner});

            try std.testing.expectEqualStrings(expected, entry.path);
        }

        return;
    }

    try std.testing.expect(result.value == .diagnostic);

    const diagnostic = result.value.diagnostic;
    const issue = diagnostic.issue;

    try std.testing.expectEqual(.context, issue.code);
    try std.testing.expectEqualStrings("Reference creates a circular module dependency", issue.message);
    try std.testing.expectEqualStrings(if (shape == .import) "Import" else "Call", issue.element);
    try std.testing.expectEqualStrings(if (shape == .import) "from" else "module", issue.attribute.?);
    try std.testing.expect(issue.location.offset >= 100);

    const edge = issue.location.offset - 100;

    try std.testing.expect(std.mem.indexOfScalar(usize, cyclic_edges, edge) != null);
    try std.testing.expectEqualDeep(fixtures.location(size, edge), issue.location);

    const owner = edge / size;
    const source_index = if (shape == .import) size - owner - 1 else owner;

    try std.testing.expectEqual(source_index, diagnostic.source_index);
}
