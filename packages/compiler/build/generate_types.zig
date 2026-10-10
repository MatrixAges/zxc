const std = @import("std");
const compiler = @import("compiler");

/// Writes the standard library ABI types; the seed compiler produces the same declarations as the bootstrapped one.
pub fn generate(init: std.process.Init, output_path: []const u8) !void {
    const allocator = init.arena.allocator();
    var source: std.Io.Writer.Allocating = .init(allocator);

    defer source.deinit();

    const order = try allocator.alloc(usize, compiler.project.standard.len);

    for (order, 0..) |*item, index| item.* = index;

    std.mem.sort(usize, order, {}, lessThan);

    for (order) |index| {
        const module = compiler.project.standard[index];

        try source.writer.print("import module{d} from \"{f}\"\n", .{ index, std.zig.fmtString(module.specifier) });
    }

    try source.writer.writeAll("\nexport type Input = void\n\nexport type Output = void\n\nexport default function (in: Input): Output {\n  return\n}\n");

    var analyzed = try compiler.analyzeProject(allocator, &.{.{ .path = "standard.zx", .source = source.written() }}, .{ .entry = "standard.zx" });

    defer analyzed.deinit();

    if (analyzed.value == .diagnostic) {
        std.debug.print("{s}\n", .{analyzed.value.diagnostic.message});

        return error.InvalidStandardDeclarations;
    }

    const bundle = try compiler.zig.emitBundle(allocator, analyzed.value.ir);

    defer bundle.deinit(allocator);

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = output_path, .data = bundle.types });
}

fn lessThan(_: void, left: usize, right: usize) bool {
    return std.mem.lessThan(u8, compiler.project.standard[left].specifier, compiler.project.standard[right].specifier);
}
