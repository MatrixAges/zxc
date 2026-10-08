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
    try collection.collect(init.io, allocator, args[5], "lint/naming/", &sources, &modules);

    std.mem.sort(compiler.project.Source, sources.items, {}, collection.lessSource);
    std.mem.sort(rx.TextSource, modules.items, {}, collection.lessModule);

    var parsed = try rx.parseModules(allocator, modules.items);

    defer parsed.deinit();

    if (parsed.value == .diagnostic) {
        std.debug.print("{s}: {s}\n", .{ modules.items[parsed.value.diagnostic.source_index].path, parsed.value.diagnostic.issue.message });

        return error.InvalidModule;
    }

    const inputs = try allocator.alloc(rx.ModuleSource, modules.items.len);

    for (inputs, modules.items, parsed.parsed) |*item, source, module| item.* = .{ .path = source.path, .node = module.value.node };

    const selected = try @import("parser_inputs.zig").reachable(allocator, inputs, args[2]);
    const interface_path = "zx/analysis/semantic/native/integers.d.zx";
    const interface_file = try std.fs.path.join(allocator, &.{ args[1], interface_path });
    const interface_source = try std.Io.Dir.cwd().readFileAlloc(init.io, interface_file, allocator, .unlimited);
    const interfaces = [_]compiler.project.NativeInterface{.{ .specifier = "zig:integers", .path = interface_path, .source = interface_source, .module = "integers" }};
    var analyzed = try analysis.project.infer(allocator, .{ .entry = args[2], .modules = selected, .sources = sources.items, .project = .{ .entry = "", .native_interfaces = &interfaces, .packages = &.{ .{ .specifier = "lint/naming", .entry = "lint/naming/check.zx" }, .{ .specifier = "lint/naming/model", .entry = "lint/naming/model.zx" } } } });

    defer analyzed.deinit();

    if (analyzed.value == .diagnostic) {
        const issue = analyzed.value.diagnostic;

        std.debug.print("{s}: {s}\n", .{ issue.path, issue.message });

        return error.InvalidSource;
    }

    var output = try compiler.zig.emitBundle(allocator, analyzed.value.contract.program);

    defer output.deinit(allocator);

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[3], .data = output.source });
    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[4], .data = output.types });
}
