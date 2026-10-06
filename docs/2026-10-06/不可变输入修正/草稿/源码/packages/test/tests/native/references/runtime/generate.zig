const std = @import("std");
const compiler = @import("compiler");
const Output = @import("library_output").Output;

fn analyze(allocator: std.mem.Allocator, sources: []const compiler.project.Source, declaration: []const u8) !compiler.AnalysisResult {
    var result = try compiler.analyzeProject(allocator, sources, .{
        .entry = "main.zx",
        .root_dir = "/provider",
        .native_interfaces = &.{.{ .specifier = "zig:host", .path = "host.d.zx", .source = declaration, .module = "host" }},
    });

    errdefer result.deinit();

    try inspect(&result);

    return result;
}

fn inspect(result: *const compiler.AnalysisResult) !void {
    if (result.value == .diagnostic) {
        const issue = result.value.diagnostic;

        std.debug.print("{t}: source {?d}, bytes {d}..{d}: {s}\n", .{ issue.code, issue.source_index, issue.span.start, issue.span.end, issue.message });

        return error.InvalidAnalysis;
    }
}

fn emit(io: std.Io, allocator: std.mem.Allocator, result: *const compiler.AnalysisResult, directory: []const u8) !void {
    var bundle = try compiler.zig.emitModules(allocator, result);

    defer bundle.deinit();

    var output = Output{ .io = io, .allocator = allocator, .directory = directory };

    try output.module("program", bundle.entry.source, bundle.entry.imports);
    for (bundle.modules) |module| try output.module(module.name, module.source, module.imports);
    try output.file("types.zig", bundle.types);

    for (bundle.native_modules) |module| {
        if (module.identity == null) continue;

        const view = try compiler.zig.abi_view.render(allocator, bundle.type_names, &.{.{ .name = module.specifier, .identity = module.key() }}, true);

        try output.file(try std.fmt.allocPrint(allocator, "{s}_abi.zig", .{module.import_name}), view);
    }

    try output.file("native.json", try std.json.Stringify.valueAlloc(allocator, bundle.native_modules, .{}));
    try output.file("modules.json", try std.json.Stringify.valueAlloc(allocator, output.modules.items, .{}));
}

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);

    if (args.len < 5) return error.ExpectedSourceDeclarationRouteAndDirectory;

    const source = try std.Io.Dir.cwd().readFileAlloc(init.io, args[1], allocator, .limited(1024 * 1024));
    const declaration = try std.Io.Dir.cwd().readFileAlloc(init.io, args[2], allocator, .limited(1024 * 1024));
    var sources: std.ArrayList(compiler.project.Source) = .empty;

    try sources.append(allocator, .{ .path = "main.zx", .source = source });

    for (args[5..]) |path| {
        try sources.append(allocator, .{ .path = std.fs.path.basename(path), .source = try std.Io.Dir.cwd().readFileAlloc(init.io, path, allocator, .limited(1024 * 1024)) });
    }

    var provider = try analyze(allocator, sources.items, declaration);

    defer provider.deinit();

    if (std.mem.eql(u8, args[3], "source")) return emit(init.io, allocator, &provider, args[4]);
    if (!std.mem.eql(u8, args[3], "library")) return error.InvalidRoute;

    var library = try compiler.library.link(allocator, &.{.{ .name = "run", .analysis = &provider }});

    defer library.deinit();

    const bytes = try compiler.library.codec.encode(allocator, &library);
    var decoded = try compiler.library.codec.decode(allocator, bytes);

    defer decoded.deinit();

    @memset(bytes, 0xdd);

    const consumer_source = try std.fmt.allocPrint(allocator, "import run from \"dependency\"\n\nimport type {{ SharedInput, SharedOutput }} from \"./types\"\n\nexport type Input = SharedInput\n\nexport type Output = SharedOutput\n\nexport default function (in: Input): Output {{\n  return run(in)\n}}\n", .{});

    var consumer = try compiler.analyzeProject(allocator, &.{
        .{ .path = "consumer.zx", .source = consumer_source },
        .{ .path = "types.zx", .source = "import type { Input, Output } from \"dependency\"\n\nexport type SharedInput = Input\n\nexport type SharedOutput = Output\n" },
    }, .{
        .entry = "consumer.zx",
        .root_dir = "/consumer",
        .packages = &.{.{ .specifier = "dependency", .compiled = .{ .instance = "references@1", .artifact = "references.zxlib", .name = "run" } }},
        .compiled_libraries = &.{.{ .instance = "references@1", .artifact = "references.zxlib", .program = decoded.program, .exports = decoded.exports, .nominal_types = decoded.nominal_types }},
    });

    defer consumer.deinit();

    try inspect(&consumer);
    try emit(init.io, allocator, &consumer, args[4]);
}
