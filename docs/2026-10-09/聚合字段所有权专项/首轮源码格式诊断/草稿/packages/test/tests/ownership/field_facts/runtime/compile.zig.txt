const std = @import("std");
const compiler = @import("compiler");
const Output = @import("library_output").Output;

fn inspect(result: *const compiler.AnalysisResult) !void {
    if (result.value == .diagnostic) {
        const issue = result.value.diagnostic;

        std.debug.print("{t}: bytes {d}..{d}: {s}\n", .{ issue.code, issue.span.start, issue.span.end, issue.message });

        return error.InvalidAnalysis;
    }
}

fn emit(init: std.process.Init, result: *const compiler.AnalysisResult, directory: []const u8) !void {
    const allocator = init.arena.allocator();

    try std.testing.expect(try compiler.validateIr(allocator, result.value.ir) == null);

    var bundle = try compiler.zig.emitModules(allocator, result);

    defer bundle.deinit();

    try std.testing.expectEqual(@as(usize, 0), bundle.native_modules.count());

    var output = Output{ .io = init.io, .allocator = allocator, .directory = directory };

    try output.module("program", bundle.entry.source, bundle.entry.imports);
    for (bundle.modules) |module| try output.module(module.name, module.source, module.imports);
    try output.file("types.zig", bundle.types);
    try output.file("native.json", "[]\n");
    try output.file("modules.json", try std.json.Stringify.valueAlloc(allocator, output.modules.items, .{}));
}

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);

    if (args.len < 4) return error.ExpectedSourceRouteAndDirectory;

    var sources: std.ArrayList(compiler.project.Source) = .empty;

    try sources.append(allocator, .{ .path = "main.zx", .source = try std.Io.Dir.cwd().readFileAlloc(init.io, args[1], allocator, .limited(1024 * 1024)) });
    for (args[4..]) |path| try sources.append(allocator, .{ .path = std.fs.path.basename(path), .source = try std.Io.Dir.cwd().readFileAlloc(init.io, path, allocator, .limited(1024 * 1024)) });

    if (std.mem.eql(u8, args[2], "source")) {
        var provider = try compiler.analyzeProject(allocator, sources.items, .{ .entry = "main.zx", .root_dir = "/provider" });

        defer provider.deinit();

        try inspect(&provider);

        return emit(init, &provider, args[3]);
    }

    if (!std.mem.eql(u8, args[2], "library")) return error.InvalidRoute;

    var decoded = block: {
        var provider = try compiler.analyzeProject(std.heap.page_allocator, sources.items, .{ .entry = "main.zx", .root_dir = "/provider" });

        defer provider.deinit();

        try inspect(&provider);

        var library = try compiler.library.link(std.heap.page_allocator, &.{.{ .name = "run", .analysis = &provider }});

        defer library.deinit();

        const bytes = try compiler.library.codec.encode(std.heap.page_allocator, &library);

        defer std.heap.page_allocator.free(bytes);

        const restored = try compiler.library.codec.decode(allocator, bytes);

        @memset(bytes, 0xdd);

        break :block restored;
    };

    defer decoded.deinit();

    var consumer = try compiler.analyzeProject(allocator, &.{
        .{ .path = "consumer.zx", .source = "import run from \"dependency\"\n\nimport type { SharedInput, SharedOutput } from \"./types\"\n\nexport type Input = SharedInput\n\nexport type Output = SharedOutput\n\nexport default function (in: Input): Output { return run(in) }\n" },
        .{ .path = "types.zx", .source = "import type { Input, Output } from \"dependency\"\n\nexport type SharedInput = Input\n\nexport type SharedOutput = Output\n" },
    }, .{
        .entry = "consumer.zx",
        .root_dir = "/consumer",
        .packages = &.{.{ .specifier = "dependency", .compiled = .{ .instance = "field-facts@1", .artifact = "field-facts.zxlib", .name = "run" } }},
        .compiled_libraries = &.{.{ .instance = "field-facts@1", .artifact = "field-facts.zxlib", .program = decoded.program, .exports = decoded.exports, .nominal_types = decoded.nominal_types }},
    });

    defer consumer.deinit();

    try inspect(&consumer);
    try emit(init, &consumer, args[3]);
}
