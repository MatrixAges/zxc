const std = @import("std");
const compiler = @import("compiler");
const api = @import("observed");

pub fn main(init: std.process.Init) !void {
    const args = try init.minimal.args.toSlice(init.arena.allocator());

    if (args.len < 5 or args.len > 7) return error.ExpectedEntryOutputZigLibrary;
    if (args.len == 7 and !std.mem.eql(u8, args[6], "--wait")) return error.InvalidArguments;

    var heap: std.heap.DebugAllocator(.{}) = .init;

    defer std.debug.assert(heap.deinit() == .ok);

    var arena = std.heap.ArenaAllocator.init(heap.allocator());

    defer arena.deinit();

    const allocator = arena.allocator();
    var inputs = try api.Inputs.init(init.io, heap.allocator());

    defer inputs.deinit();

    const loaded = try api.project.loadWithInputs(init.io, allocator, args[1], null, &inputs);

    if (loaded.diagnostic != null) return error.InvalidProject;

    var cache = compiler.project.SemanticCache.init(heap.allocator());

    defer cache.deinit();

    const source = try std.Io.Dir.cwd().readFileAlloc(init.io, loaded.project.entry, allocator, .limited(16 * 1024 * 1024));
    const sources = try api.sources.readWithInputs(init.io, allocator, source, loaded.project, &cache.parse_cache, &inputs);
    var buffer: [4096]u8 = undefined;
    var output = std.Io.File.stdout().writer(init.io, &buffer);

    defer output.interface.flush() catch {};

    var generated = try compiler.compileProjectModulesVerified(heap.allocator(), .{ .io = init.io, .sources = sources, .project = loaded.project, .semantic_cache = &cache, .writer = &output.interface });

    defer generated.deinit();

    if (generated == .diagnostic) return error.InvalidProgram;

    const options: api.Options = .{ .input = args[1], .output = args[2], .native = true, .assembly = if (args.len >= 6) args[5] else null };
    const toolchain: api.Paths = .{ .root = "", .executable = args[3], .library = args[4], .standard = "" };

    for (0..2) |index| {
        var result = try api.build.runObserved(init.io, allocator, generated.bundle, options, loaded, toolchain, init.environ_map, &inputs);

        defer result.deinit();

        try result.response.diagnostics.renderToWriter(.{}, &output.interface);
        try output.interface.writeAll(result.response.stderr);

        if (index == 1 and args.len == 7) {
            try output.interface.writeAll("ready\n");
            try output.interface.flush();

            var input_buffer: [128]u8 = undefined;
            var input = std.Io.File.stdin().reader(init.io, &input_buffer);

            _ = try input.interface.takeDelimiter('\n') orelse return error.ExpectedPublishCommand;
        }

        const published = try result.publish(init.io, heap.allocator(), &inputs, options);

        try output.interface.print("pass={d} success={any} cached={any} new_inputs={any} published={any}\n", .{ index + 1, result.response.succeeded, result.response.cached, result.new_inputs, published });
        try output.interface.flush();
    }
}
