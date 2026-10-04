const std = @import("std");
const compiler = @import("compiler");
const rx = @import("rx");
const analysis = @import("rx_analysis");

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);
    const mode = std.meta.stringToEnum(enum { project_forward, project_reverse }, args[1]) orelse return error.InvalidMode;
    const texts = [_][]const u8{
        @embedFile("fixtures/project_main.rx"),
        @embedFile("fixtures/project_bridge.rx"),
        @embedFile("fixtures/project_leaf.rx"),
    };
    const names = [_][]const u8{ "main.rx", "bridge.rx", "leaf.rx" };
    var parsed: [3]rx.XmlResult = undefined;
    var count: usize = 0;

    defer for (parsed[0..count]) |*item| item.deinit();

    for (texts, &parsed) |text, *item| {
        item.* = try rx.parseXml(allocator, text);
        count += 1;

        if (item.value != .node) return error.InvalidXml;
    }

    const order: [3]usize = if (mode == .project_forward) .{ 0, 1, 2 } else .{ 2, 1, 0 };
    var sources: [3]rx.ModuleSource = undefined;

    for (order, &sources) |index, *source| source.* = .{ .path = names[index], .node = parsed[index].value.node };

    var result = try analysis.project.infer(allocator, .{
        .entry = "main.rx",
        .modules = &sources,
        .sources = &.{
            .{ .path = "increment.zx", .source = @embedFile("fixtures/increment.zx") },
            .{ .path = "multiply.zx", .source = @embedFile("fixtures/multiply.zx") },
        },
    });

    defer result.deinit();

    if (result.value == .diagnostic) {
        const issue = result.value.diagnostic;
        std.debug.print("{s}:{d}:{d}: {s}: {s}\n", .{ issue.path, issue.location.line, issue.location.column, issue.code, issue.message });

        return error.InvalidContract;
    }

    const program = result.value.contract.program;

    if (try compiler.validateIr(allocator, program) != null) return error.InvalidIr;

    const bundle = try compiler.zig.emitBundle(allocator, program);

    defer bundle.deinit(allocator);

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[2], .data = bundle.source });
    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[3], .data = bundle.types });
}
