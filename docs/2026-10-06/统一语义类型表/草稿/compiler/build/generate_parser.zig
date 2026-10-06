const std = @import("std");
const compiler = @import("compiler");
const rx = @import("rx");
const analysis = @import("rx_analysis");

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);
    var directory = try std.Io.Dir.cwd().openDir(init.io, args[1], .{ .iterate = true });

    defer directory.close(init.io);

    var walker = try directory.walk(allocator);

    defer walker.deinit();

    var sources: std.ArrayList(compiler.project.Source) = .empty;
    var modules: std.ArrayList(rx.TextSource) = .empty;

    while (try walker.next(init.io)) |entry| {
        if (entry.kind != .file) continue;

        const is_zx = std.mem.endsWith(u8, entry.path, ".zx");
        const is_rx = std.mem.endsWith(u8, entry.path, ".rx");

        if (!is_zx and !is_rx) continue;

        const path = try allocator.dupe(u8, entry.path);

        if (std.fs.path.sep == '\\') for (path) |*byte| if (byte.* == '\\') {
            byte.* = '/';
        };

        const source = try directory.readFileAlloc(init.io, entry.path, allocator, .unlimited);

        if (is_zx) try sources.append(allocator, .{ .path = path, .source = source }) else try modules.append(allocator, .{ .path = path, .source = source });
    }

    std.mem.sort(compiler.project.Source, sources.items, {}, lessSource);
    std.mem.sort(rx.TextSource, modules.items, {}, lessModule);

    var parsed = try rx.parseModules(allocator, modules.items);

    defer parsed.deinit();

    if (parsed.value == .diagnostic) {
        std.debug.print("{s}: {s}\n", .{ modules.items[parsed.value.diagnostic.source_index].path, parsed.value.diagnostic.issue.message });

        return error.InvalidParserModule;
    }

    const inputs = try allocator.alloc(rx.ModuleSource, modules.items.len);

    for (inputs, modules.items, parsed.parsed) |*item, source, module| item.* = .{ .path = source.path, .node = module.value.node };

    const interfaces = [_]compiler.project.NativeInterface{ .{
        .specifier = "zig:integers",
        .path = "zx/analysis/semantic/native/integers.d.zx",
        .source = @embedFile("semantic_integers"),
        .module = "integers",
    }, .{
        .specifier = "zig:field_columns",
        .path = "zx/analysis/semantic/ordering/columns.d.zx",
        .source = @embedFile("field_columns_interface"),
        .module = "field_columns",
    } };

    const entries = [_][]const u8{
        "zx/frontend/parser/program.rx",
        "zx/frontend/parser/expression_text.rx",
        "rx/syntax/parse.rx",
        "rx/path_segments/normalize.rx",
        "rx/dependency_graph/validate.rx",
        "rx/schema/attribute/classify.rx",
        "rx/schema/content/validate.rx",
        "rx/schema/call/validate.rx",
        "rx/path_kind/validate.rx",
        "rx/schema/file/classify.rx",
        "zx/modules/specifier/classify.rx",
        "zx/analysis/integer/decode.rx",
        "zx/frontend/parser/native.rx",
    };

    for (entries, args[2 .. 2 + entries.len]) |entry, output_path| {
        const output = try generate(allocator, inputs, sources.items, entry, false, &interfaces);

        try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = output_path, .data = output.source });
    }

    const semantic = try generate(allocator, inputs, sources.items, "zx/analysis/semantic/lookup.rx", true, &interfaces);

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[2 + entries.len], .data = semantic.source });
    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[3 + entries.len], .data = semantic.types });

    const nominal = try generate(allocator, inputs, sources.items, "zx/analysis/semantic/nominal.rx", true, &interfaces);

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[4 + entries.len], .data = nominal.source });
    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[5 + entries.len], .data = nominal.types });

    const ordering = try generate(allocator, inputs, sources.items, "zx/analysis/semantic/ordering/sort.rx", true, &interfaces);

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[6 + entries.len], .data = ordering.source });
    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[7 + entries.len], .data = ordering.types });
}

fn lessSource(_: void, left: compiler.project.Source, right: compiler.project.Source) bool {
    return std.mem.lessThan(u8, left.path, right.path);
}

fn lessModule(_: void, left: rx.TextSource, right: rx.TextSource) bool {
    return std.mem.lessThan(u8, left.path, right.path);
}

fn generate(allocator: std.mem.Allocator, modules: []const rx.ModuleSource, sources: []const compiler.project.Source, entry: []const u8, shared_abi: bool, interfaces: []const compiler.project.NativeInterface) !compiler.zig.Bundle {
    const selected = try @import("parser_inputs.zig").reachable(allocator, modules, entry);

    defer allocator.free(selected);

    var analyzed = try analysis.project.infer(allocator, .{
        .entry = entry,
        .modules = selected,
        .sources = sources,
        .project = .{ .entry = "", .native_interfaces = interfaces },
    });

    defer analyzed.deinit();

    if (analyzed.value == .diagnostic) {
        const issue = analyzed.value.diagnostic;

        std.debug.print("{s}: {s}\n", .{ issue.path, issue.message });

        return error.InvalidParserSource;
    }

    if (shared_abi) return compiler.zig.emitBundle(allocator, analyzed.value.contract.program);

    return .{ .source = try compiler.zig.emit(allocator, analyzed.value.contract.program), .types = &.{} };
}
