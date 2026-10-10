const std = @import("std");
const compiler = @import("compiler");
const rx = @import("rx");
const analysis = @import("rx_analysis");
const collection = @import("source_collection.zig");
const entries = @import("entries.zig");

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);

    if (std.mem.eql(u8, args[1], "--standard-abi")) return @import("generate_types.zig").generate(init, args[2]);

    const set = std.meta.stringToEnum(entries.Set, args[1]) orelse return error.UnknownEntrySet;
    var sources: std.ArrayList(compiler.project.Source) = .empty;
    var modules: std.ArrayList(rx.TextSource) = .empty;

    try collection.collect(init.io, allocator, args[2], "", &sources, &modules);
    try collection.collect(init.io, allocator, args[3], "lint/naming/", &sources, &modules);
    try collection.collect(init.io, allocator, args[4], "core/", &sources, &modules);

    std.mem.sort(compiler.project.Source, sources.items, {}, collection.lessSource);
    std.mem.sort(rx.TextSource, modules.items, {}, collection.lessModule);

    var parsed = try rx.parseModules(allocator, modules.items);

    defer parsed.deinit();

    if (parsed.value == .diagnostic) {
        std.debug.print("{s}: {s}\n", .{ modules.items[parsed.value.diagnostic.source_index].path, parsed.value.diagnostic.issue.message });

        return error.InvalidParserModule;
    }

    const inputs = try allocator.alloc(rx.ModuleSource, modules.items.len);

    for (inputs, modules.items, parsed.parsed) |*item, source, module| item.* = .{ .path = source.path, .node = module.value.node };

    const interfaces = [_]compiler.project.NativeInterface{ .{
        .specifier = "zig:floats",
        .path = "zx/analysis/semantic/native/floats.d.zx",
        .source = @embedFile("semantic_floats"),
        .module = "floats",
    }, .{
        .specifier = "zig:integers",
        .path = "zx/analysis/semantic/native/integers.d.zx",
        .source = @embedFile("semantic_integers"),
        .module = "integers",
    } };

    const selected = entries.of(set);
    const jobs = try allocator.alloc(Job, selected.len);
    var next: usize = 5;

    for (selected, jobs) |entry, *job| {
        job.* = .{ .entry = entry.path, .output = args[next], .types = if (entry.abi != null) args[next + 1] else null };
        next += if (entry.abi != null) 2 else 1;
    }

    if (next != args.len) return error.OutputCountMismatch;
    try @import("parallel_generation.zig").run(init, jobs, .{ .modules = inputs, .sources = sources.items, .interfaces = &interfaces }, generate);
}

pub const Job = @import("parallel_generation.zig").Job;
pub const Inputs = @import("parallel_generation.zig").Inputs;

fn generate(init: std.process.Init, inputs: Inputs, job: Job) !void {
    const modules = inputs.modules;
    const sources = inputs.sources;
    const interfaces = inputs.interfaces;
    const entry = job.entry;
    const output_path = job.output;
    const types_path = job.types;
    const temporary = init.gpa;
    const project = compiler.project.Options{ .entry = "", .native_interfaces = interfaces, .packages = @import("source_packages.zig").entries };
    const selected = try @import("source_inputs.zig").reachable(temporary, modules, sources, entry, project);

    defer temporary.free(selected);

    var analyzed = try analysis.project.infer(temporary, .{
        .entry = entry,
        .modules = selected,
        .sources = sources,
        .project = project,
    });

    defer analyzed.deinit();

    if (analyzed.value == .diagnostic) {
        const issue = analyzed.value.diagnostic;

        std.debug.print("{s}:{d}:{d}: {s}: {s}\n", .{ issue.path, issue.location.line, issue.location.column, issue.code, issue.message });

        return error.InvalidParserSource;
    }

    const bundle = if (types_path != null)
        try compiler.zig.emitBundle(temporary, analyzed.value.contract.program)
    else
        compiler.zig.Bundle{ .source = try compiler.zig.emit(temporary, analyzed.value.contract.program), .types = &.{} };

    defer bundle.deinit(temporary);

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = output_path, .data = bundle.source });
    if (types_path) |path| try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = path, .data = bundle.types });
}
