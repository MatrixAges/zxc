const std = @import("std");
const compiler = @import("compiler");
const save = @import("save.zig");

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);
    if (args.len != 3) return error.ExpectedOrderAndDirectory;

    var library = if (std.mem.startsWith(u8, args[1], "mixed")) try @import("mixed.zig").link(allocator, std.mem.endsWith(u8, args[1], "reverse")) else block: {
        const sources = [_]compiler.project.Source{
            .{ .path = "alpha.zx", .source = @embedFile("fixtures/alpha.zx") },
            .{ .path = "beta.zx", .source = @embedFile("fixtures/beta.zx") },
            .{ .path = "leaf.zx", .source = @embedFile("fixtures/leaf.zx") },
            .{ .path = "tail.zx", .source = @embedFile("fixtures/tail.zx") },
        };
        var alpha = try compiler.project.analyze(std.heap.page_allocator, &sources, .{ .entry = "alpha.zx", .root_dir = "/project" });
        defer alpha.deinit();
        var beta = try compiler.project.analyze(std.heap.page_allocator, &sources, .{ .entry = "beta.zx", .root_dir = "/project" });
        defer beta.deinit();
        if (alpha.value != .ir or beta.value != .ir) return error.InvalidFixture;

        var inputs = [_]compiler.library.Input{
            .{ .name = "alpha", .analysis = &alpha },
            .{ .name = "beta", .analysis = &beta },
            .{ .name = "repeat", .analysis = &alpha },
        };
        if (std.mem.eql(u8, args[1], "reverse")) std.mem.reverse(compiler.library.Input, &inputs);

        break :block try compiler.library.link(allocator, &inputs);
    };
    defer library.deinit();

    var output = save.Output{ .io = init.io, .allocator = allocator, .directory = args[2] };

    for (library.exports, 0..) |exported, index| {
        var analysis = compiler.AnalysisResult{ .arena = std.heap.ArenaAllocator.init(allocator), .value = .{ .ir = try library.module(index) }, .nominal_types = library.nominal_types };
        defer analysis.deinit();
        var bundle = try compiler.zig.emitModules(allocator, &analysis);
        defer bundle.deinit();

        try output.module(exported.name, bundle.entry.source, bundle.entry.imports);
        for (bundle.modules) |module| try output.module(module.name, module.source, module.imports);
        try output.file("types.zig", bundle.types);
    }

    try output.file("modules.json", try std.json.Stringify.valueAlloc(allocator, output.modules.items, .{ .whitespace = .indent_2 }));
}
