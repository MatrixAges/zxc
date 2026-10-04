const std = @import("std");
const compiler = @import("compiler");
const rx = @import("rx");
const analysis = @import("rx_analysis");

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);
    const mode = std.meta.stringToEnum(enum { direct, service, error_first, allocation_first, input_error }, args[1]) orelse return error.InvalidMode;

    const entry_text = switch (mode) {
        .direct => @embedFile("parallel/fixtures/main.rx"),
        .service => @embedFile("parallel/fixtures/service.rx"),
        .error_first => @embedFile("parallel/fixtures/error_first.rx"),
        .allocation_first => @embedFile("parallel/fixtures/allocation_first.rx"),
        .input_error => @embedFile("parallel/fixtures/input_error.rx"),
    };

    const texts = [_][]const u8{ entry_text, @embedFile("parallel/fixtures/left.rx"), @embedFile("parallel/fixtures/right.rx") };
    const names = [_][]const u8{ "main.rx", "left.rx", "right.rx" };
    var parsed: [3]rx.XmlResult = undefined;
    var sources: [3]rx.ModuleSource = undefined;
    var count: usize = 0;

    defer for (parsed[0..count]) |*item| item.deinit();

    for (texts, names, &parsed, &sources) |text, name, *item, *source| {
        item.* = try rx.parseXml(allocator, text);
        count += 1;

        if (item.value != .node) return error.InvalidXml;

        source.* = .{ .path = name, .node = item.value.node };
    }

    var result = try analysis.project.infer(allocator, .{
        .entry = "main.rx",
        .modules = &sources,
        .sources = &.{
            .{ .path = "first.zx", .source = @embedFile("fixtures/first.zx") },
            .{ .path = "map_values.zx", .source = @embedFile("fixtures/map_values.zx") },
            .{ .path = "double_values.zx", .source = @embedFile("parallel/fixtures/double_values.zx") },
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
