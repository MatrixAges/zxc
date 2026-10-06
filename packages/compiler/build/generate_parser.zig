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

    const entries = [_][]const u8{ "zx/frontend/parser/program.rx", "zx/frontend/parser/expression_text.rx", "rx/syntax/parse.rx", "rx/path_segments/normalize.rx", "rx/dependency_graph/validate.rx" };

    for (entries, args[2..7]) |entry, output_path| {
        const output = try generate(allocator, inputs, sources.items, entry);

        try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = output_path, .data = output });
    }
}

fn lessSource(_: void, left: compiler.project.Source, right: compiler.project.Source) bool {
    return std.mem.lessThan(u8, left.path, right.path);
}

fn lessModule(_: void, left: rx.TextSource, right: rx.TextSource) bool {
    return std.mem.lessThan(u8, left.path, right.path);
}

fn generate(allocator: std.mem.Allocator, modules: []const rx.ModuleSource, sources: []const compiler.project.Source, entry: []const u8) ![]u8 {
    var analyzed = try analysis.project.infer(allocator, .{ .entry = entry, .modules = modules, .sources = sources });

    defer analyzed.deinit();

    if (analyzed.value == .diagnostic) {
        const issue = analyzed.value.diagnostic;

        std.debug.print("{s}: {s}\n", .{ issue.path, issue.message });

        return error.InvalidParserSource;
    }

    return compiler.zig.emit(allocator, analyzed.value.contract.program);
}
