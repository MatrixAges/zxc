const std = @import("std");
const compiler = @import("compiler");
const rx = @import("rx");
const analysis = @import("rx_analysis");
const collection = @import("source_collection.zig");

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);
    var sources: std.ArrayList(compiler.project.Source) = .empty;
    var modules: std.ArrayList(rx.TextSource) = .empty;

    try collection.collect(init.io, allocator, args[1], "", &sources, &modules);

    std.mem.sort(compiler.project.Source, sources.items, {}, collection.lessSource);
    std.mem.sort(rx.TextSource, modules.items, {}, collection.lessModule);

    var parsed = try rx.parseModules(allocator, modules.items);

    defer parsed.deinit();

    if (parsed.value == .diagnostic) {
        const issue = parsed.value.diagnostic;

        std.debug.print("{s}: {s}\n", .{ modules.items[issue.source_index].path, issue.issue.message });

        return error.InvalidLexerModule;
    }

    const inputs = try allocator.alloc(rx.ModuleSource, modules.items.len);

    for (inputs, modules.items, parsed.parsed) |*item, source, module| item.* = .{ .path = source.path, .node = module.value.node };

    const selected = try @import("parser_inputs.zig").reachable(allocator, inputs, "scan.rx");

    var analyzed = try analysis.project.infer(allocator, .{
        .entry = "scan.rx",
        .modules = selected,
        .sources = sources.items,
        .project = .{ .entry = "" },
    });

    defer analyzed.deinit();

    if (analyzed.value == .diagnostic) {
        const issue = analyzed.value.diagnostic;

        std.debug.print("{s}: {s}\n", .{ issue.path, issue.message });

        return error.InvalidLexerSource;
    }

    const output = try compiler.zig.emit(allocator, analyzed.value.contract.program);

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[2], .data = output });
}
