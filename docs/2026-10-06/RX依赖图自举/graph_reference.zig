const std = @import("std");
const rx = @import("rx");
const native = @import("native");
const fixtures = @import("fixtures");
const Row = struct { id: []const u8, size: usize, shape: fixtures.Shape, edges: []const usize };

pub fn main(init: std.process.Init) !void {
    const args = try init.minimal.args.toSlice(init.arena.allocator());
    var cases: usize = 0;
    var diagnostics: usize = 0;

    for (args[1..]) |path| {
        const source = try std.Io.Dir.cwd().readFileAlloc(init.io, path, init.arena.allocator(), .unlimited);
        var lines = std.mem.splitScalar(u8, source, '\n');

        while (lines.next()) |line| {
            if (line.len == 0) continue;

            var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);

            defer arena.deinit();

            const allocator = arena.allocator();
            const row = try std.json.parseFromSliceLeaky(Row, allocator, line, .{ .ignore_unknown_fields = true });

            diagnostics += @intFromBool(compare(allocator, row) catch |err| {
                std.debug.print("{s}: {s}\n", .{ row.id, @errorName(err) });

                return err;
            });

            cases += 1;
        }
    }

    var buffer: [4096]u8 = undefined;
    var output = std.Io.File.Writer.initStreaming(.stdout(), init.io, &buffer);

    try std.json.Stringify.value(.{ .cases = cases, .diagnostics = diagnostics, .failures = 0 }, .{}, &output.interface);
    try output.interface.writeByte('\n');
    try output.interface.flush();
}

fn compare(allocator: std.mem.Allocator, row: Row) !bool {
    const sources = try fixtures.sources(allocator, row.size, row.shape, row.edges);
    const seed_sources = try allocator.alloc(native.ModuleSource, sources.len);

    for (sources, seed_sources) |source, *target| target.* = .{ .path = source.path, .node = source.node, .packages = source.packages };

    var expected = try native.validateModules(allocator, seed_sources);

    defer expected.deinit();

    var actual = try rx.validateModules(allocator, sources);

    defer actual.deinit();

    if ((expected.value == .data) != (actual.value == .data)) return error.GraphResultMismatch;

    if (expected.value == .data) {
        if (!std.mem.eql(usize, expected.dependency_order, actual.dependency_order)) return error.GraphOrderMismatch;

        return false;
    }

    const left = try std.json.Stringify.valueAlloc(allocator, expected.value.diagnostic, .{});
    const right = try std.json.Stringify.valueAlloc(allocator, actual.value.diagnostic, .{});

    if (!std.mem.eql(u8, left, right)) return error.GraphDiagnosticMismatch;

    return true;
}
