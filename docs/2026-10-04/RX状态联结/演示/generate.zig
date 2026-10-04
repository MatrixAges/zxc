const std = @import("std");
const compiler = @import("compiler");
const rx = @import("rx");
const analysis = @import("rx_analysis");

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);

    if (args.len != 3) return error.ExpectedStoreAndOutputDirectory;

    const source = try std.Io.Dir.cwd().readFileAlloc(init.io, args[1], std.heap.page_allocator, .limited(16 * 1024 * 1024));
    var parsed = try rx.parseXml(std.heap.page_allocator, source);

    std.heap.page_allocator.free(source);

    if (parsed.value == .diagnostic) {
        parsed.deinit();

        return error.InvalidXml;
    }

    var result = analysis.store.analyze(std.heap.page_allocator, .{ .owner = std.fs.path.basename(args[1]), .node = parsed.value.node }) catch |err| {
        parsed.deinit();

        return err;
    };

    parsed.deinit();
    defer result.deinit();

    if (result.value == .diagnostic) {
        const issue = result.value.diagnostic;

        std.debug.print("{s}:{d}:{d}: {s}: {s}\n", .{ issue.path, issue.location.line, issue.location.column, issue.code, issue.message });

        return error.InvalidStore;
    }

    try std.Io.Dir.cwd().createDirPath(init.io, args[2]);

    for (result.value.definition.objects, 0..) |object, index| {
        const output = try compiler.zig.emit(allocator, object.initial);
        const path = try std.fmt.allocPrint(allocator, "{s}/object_{d}.zig", .{ args[2], index });

        try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = path, .data = output });

        std.debug.print("{s}: {s}\n", .{ object.name, path });
    }
}
