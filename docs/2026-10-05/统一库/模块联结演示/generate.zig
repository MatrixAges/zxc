const std = @import("std");
const compiler = @import("compiler");
const rx = @import("rx");
const analysis = @import("rx_analysis");

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);

    if (args.len != 4) return error.ExpectedWorkflowLogicAndOutput;

    var library = block: {
        const workflow = try read(init.io, allocator, args[1]);
        const logic = try read(init.io, allocator, args[2]);
        const parsed = try rx.parseXml(allocator, workflow);

        if (parsed.value == .diagnostic) return error.InvalidXml;

        const sources = [_]compiler.project.Source{.{ .path = "read.zx", .source = logic }};

        var inferred = try analysis.project.infer(allocator, .{
            .entry = "main.rx",
            .modules = &.{.{ .path = "main.rx", .node = parsed.value.node }},
            .sources = &sources,
        });

        defer inferred.deinit();

        if (inferred.value == .diagnostic) return error.InvalidWorkflow;

        const contract = inferred.value.contract;
        var workflow_analysis = compiler.AnalysisResult{ .arena = std.heap.ArenaAllocator.init(allocator), .value = .{ .ir = contract.program }, .nominal_types = contract.nominal_types };

        defer workflow_analysis.deinit();

        var logic_analysis = try compiler.analyzeProject(allocator, &sources, .{ .entry = "read.zx" });

        defer logic_analysis.deinit();

        break :block try compiler.library.link(allocator, &.{
            .{ .name = "choose", .analysis = &workflow_analysis },
            .{ .name = "read", .analysis = &logic_analysis },
        });
    };

    defer library.deinit();

    const Module = struct { name: []const u8, imports: []const []const u8 };
    var modules: std.ArrayList(Module) = .empty;

    for (library.exports, 0..) |exported, index| {
        var analyzed = compiler.AnalysisResult{ .arena = std.heap.ArenaAllocator.init(allocator), .value = .{ .ir = try library.module(index) }, .nominal_types = library.nominal_types };

        defer analyzed.deinit();

        var bundle = try compiler.zig.emitModules(allocator, &analyzed);

        defer bundle.deinit();

        try write(init.io, allocator, args[3], try std.fmt.allocPrint(allocator, "{s}.zig", .{exported.name}), bundle.entry.source);
        try modules.append(allocator, .{ .name = exported.name, .imports = try copy(allocator, bundle.entry.imports) });

        for (bundle.modules) |module| {
            var found = false;

            for (modules.items) |existing| if (std.mem.eql(u8, existing.name, module.name)) {
                found = true;

                break;
            };

            if (found) continue;
            try write(init.io, allocator, args[3], try std.fmt.allocPrint(allocator, "{s}.zig", .{module.name}), module.source);
            try modules.append(allocator, .{ .name = try allocator.dupe(u8, module.name), .imports = try copy(allocator, module.imports) });
        }

        try write(init.io, allocator, args[3], "abi.zig", bundle.types);
    }

    try write(init.io, allocator, args[3], "modules.json", try std.json.Stringify.valueAlloc(allocator, modules.items, .{ .whitespace = .indent_2 }));
    try write(init.io, allocator, args[3], "exports.json", try std.json.Stringify.valueAlloc(allocator, library.exports, .{ .whitespace = .indent_2 }));

    std.debug.print("exports={d} types={d} functions={d}\n", .{ library.exports.len, library.program.types.len, library.program.functions.len });
}

fn read(io: std.Io, allocator: std.mem.Allocator, path: []const u8) ![]const u8 {
    return std.Io.Dir.cwd().readFileAlloc(io, path, allocator, .limited(1024 * 1024));
}

fn write(io: std.Io, allocator: std.mem.Allocator, directory: []const u8, name: []const u8, text: []const u8) !void {
    const path = try std.fs.path.join(allocator, &.{ directory, name });
    var file = try std.Io.Dir.cwd().createFileAtomic(io, path, .{ .make_path = true, .replace = true });

    defer file.deinit(io);

    try file.file.writeStreamingAll(io, text);
    try file.replace(io);
}

fn copy(allocator: std.mem.Allocator, items: []const []const u8) ![]const []const u8 {
    const result = try allocator.alloc([]const u8, items.len);

    for (items, result) |item, *owned| owned.* = try allocator.dupe(u8, item);

    return result;
}
