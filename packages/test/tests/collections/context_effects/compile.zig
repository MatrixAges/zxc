const std = @import("std");
const compiler = @import("compiler");

pub fn main(init: std.process.Init) !void {
    const memory = init.arena.allocator();
    const args = try init.minimal.args.toSlice(memory);

    if (args.len != 5) return error.ExpectedSourceMethodAndOutputPaths;

    const source = try std.Io.Dir.cwd().readFileAlloc(init.io, args[1], memory, .limited(1024 * 1024));
    const mapping = std.mem.eql(u8, args[2], "map");
    const visit_signature = if (mapping) "export type Input = { item: i64, context: i64 }\nexport type Output = i64\n" else "export type Input = { item: i64, context: i64 }\nexport type Output = bool\n";

    var analysis = try compiler.analyzeProject(memory, &.{.{ .path = "main.zx", .source = source }}, .{
        .entry = "main.zx",
        .externals = &.{
            .{ .specifier = "lib:source", .signature = "export type Input = i64[]\nexport type Output = i64[]\n", .implementation = .{ .module = "host", .member = "source", .fallible = true } },
            .{ .specifier = "lib:context", .signature = "export type Input = i64\nexport type Output = i64\n", .implementation = .{ .module = "host", .member = "context", .fallible = true } },
            .{ .specifier = "lib:visit", .signature = visit_signature, .implementation = .{ .module = "host", .member = if (mapping) "mapValue" else "predicate", .fallible = true } },
        },
    });

    defer analysis.deinit();

    if (analysis.value == .diagnostic) {
        std.debug.print("{t}: {s}\n", .{ analysis.value.diagnostic.code, analysis.value.diagnostic.message });

        return error.InvalidSource;
    }

    if (try compiler.validateIr(memory, analysis.value.ir) != null) return error.InvalidIr;

    const bundle = try compiler.zig.emitBundle(memory, analysis.value.ir);

    defer bundle.deinit(memory);

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[3], .data = bundle.source });
    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[4], .data = bundle.types });
}
