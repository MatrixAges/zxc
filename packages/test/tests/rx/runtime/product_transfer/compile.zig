const std = @import("std");
const compiler = @import("compiler");
const rx = @import("rx");
const analysis = @import("rx_analysis");
const fixture = @import("fixture.zig");

pub fn main(init: std.process.Init) !void {
    const memory = init.arena.allocator();
    const args = try init.minimal.args.toSlice(memory);

    if (args.len != 4) return error.ExpectedModeAndTwoOutputs;

    const text = try fixture.entry(args[1]);
    const sources = try fixture.sources(args[1]);

    for (sources) |source| {
        const formatted = try compiler.format(memory, source.source, source.path);

        defer formatted.deinit(memory);

        if (formatted == .diagnostic) {
            std.debug.print("format {s}: {s}\n", .{ source.path, formatted.diagnostic.message });

            return error.InvalidSource;
        }

        try std.testing.expectEqualStrings(source.source, formatted.source);
        try std.testing.expect(std.mem.count(u8, source.source, "\n") <= 120);
    }

    const formatted = try compiler.format(memory, text, "main.rx");

    defer formatted.deinit(memory);

    try std.testing.expect(formatted == .source);
    try std.testing.expectEqualStrings(text, formatted.source);

    var parsed = try rx.parseXml(memory, text);

    defer parsed.deinit();

    if (parsed.value != .node) return error.InvalidXml;

    var result = try analysis.project.infer(memory, .{
        .entry = "main.rx",
        .modules = &.{.{ .path = "main.rx", .node = parsed.value.node }},
        .sources = &sources,
    });

    defer result.deinit();

    if (result.value == .diagnostic) {
        const issue = result.value.diagnostic;

        std.debug.print("{s}: {s}: {s}\n", .{ args[1], issue.path, issue.message });

        return error.InvalidProject;
    }

    const program = result.value.contract.program;

    if (try compiler.validateIr(memory, program) != null) return error.InvalidIr;

    const bundle = try compiler.zig.emitBundle(memory, program);

    defer bundle.deinit(memory);

    const start = std.mem.indexOf(u8, bundle.source, "pub fn execute(") orelse return error.MissingExecute;
    const end = std.mem.indexOfPos(u8, bundle.source, start, "\n}") orelse return error.MissingExecuteEnd;
    const slots = std.mem.count(u8, bundle.source[start .. end + 2], ".fromOwnedSlice");

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[2], .data = bundle.source });
    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[3], .data = bundle.types });

    std.debug.print("{s}: {d} transferred slots; formatted RX and ZX; valid IR\n", .{ args[1], slots });

    try std.testing.expectEqual(fixture.slots(args[1]), slots);
}
