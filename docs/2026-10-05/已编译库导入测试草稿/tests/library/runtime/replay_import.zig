const std = @import("std");
const compiler = @import("compiler");

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);
    if (args.len != 4) return error.ExpectedArtifactDirectoryAndOrder;

    var imported = block: {
        const bytes = try std.Io.Dir.cwd().readFileAlloc(init.io, args[1], std.heap.page_allocator, .limited(16 * 1024 * 1024));
        defer std.heap.page_allocator.free(bytes);
        var library = try compiler.library.codec.decode(std.heap.page_allocator, bytes);
        defer library.deinit();
        @memset(bytes, 0);

        var analyses: std.ArrayList(compiler.AnalysisResult) = .empty;
        defer for (analyses.items) |*analysis| analysis.deinit();
        var inputs: std.ArrayList(compiler.library.Input) = .empty;
        try analyses.ensureTotalCapacity(allocator, library.exports.len);

        for (library.exports) |exported| {
            const path = try std.fmt.allocPrint(allocator, "{s}.zx", .{exported.name});
            const is_rx = std.mem.startsWith(u8, args[3], "mixed") and !std.mem.eql(u8, exported.name, "beta");
            const bridge = if (is_rx) @embedFile("fixtures/import_rx_types.zx") else "import type { Input, Output } from \"dependency\"\nexport type SharedInput = Input\nexport type SharedOutput = Output\n";
            const source = "import run from \"dependency\"\nimport type { SharedInput, SharedOutput } from \"./types.zx\"\nexport type Input = SharedInput\nexport type Output = SharedOutput\nexport default function (in: Input): Output { return run(in) }\n";
            var analysis = try compiler.project.analyze(std.heap.page_allocator, &.{
                .{ .path = path, .source = source },
                .{ .path = "types.zx", .source = bridge },
            }, .{
                .entry = path,
                .root_dir = "/consumer",
                .packages = &.{.{ .specifier = "dependency", .compiled = .{ .instance = "workflow@1", .artifact = "library.zxlib", .name = exported.name } }},
                .compiled_libraries = &.{.{ .instance = "workflow@1", .artifact = "library.zxlib", .program = library.program, .exports = library.exports, .nominal_types = library.nominal_types }},
            });
            errdefer analysis.deinit();
            if (analysis.value == .diagnostic) {
                std.debug.print("{s}: {s}\n", .{ exported.name, analysis.value.diagnostic.message });
                return error.InvalidConsumer;
            }

            analyses.appendAssumeCapacity(analysis);
        }

        for (library.exports, analyses.items) |exported, *analysis| {
            try inputs.append(allocator, .{ .name = exported.name, .analysis = analysis });
        }

        break :block try compiler.library.link(allocator, inputs.items);
    };
    defer imported.deinit();

    try @import("emit.zig").emit(init.io, allocator, &imported, args[2]);
}
