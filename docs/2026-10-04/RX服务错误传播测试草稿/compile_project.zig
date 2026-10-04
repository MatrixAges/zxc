const std = @import("std");
const compiler = @import("compiler");
const rx = @import("rx");
const analysis = @import("rx_analysis");

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);
    const mode = std.meta.stringToEnum(enum { project_forward, project_reverse, diamond_forward, diamond_reverse_calls, diamond_reverse_modules, diamond_reverse_both, owned_service, error_service }, args[1]) orelse return error.InvalidMode;
    const owned = mode == .owned_service;
    const error_service = mode == .error_service;
    const diamond = std.mem.startsWith(u8, args[1], "diamond_");
    const reverse_calls = mode == .diamond_reverse_calls or mode == .diamond_reverse_both;
    const reverse_modules = mode == .project_reverse or mode == .diamond_reverse_modules or mode == .diamond_reverse_both;
    const texts: []const []const u8 = if (error_service) &.{
        @embedFile("fixtures/service_error_main.rx"),
        @embedFile("fixtures/service_error_bridge.rx"),
        @embedFile("fixtures/service_error_leaf.rx"),
    } else if (owned) &.{
        @embedFile("fixtures/service_owned_main.rx"),
        @embedFile("fixtures/service_owned_bridge.rx"),
        @embedFile("fixtures/service_owned_leaf.rx"),
    } else if (diamond) &.{
        if (reverse_calls) @embedFile("fixtures/diamond/main_reverse.rx") else @embedFile("fixtures/diamond/main_forward.rx"),
        @embedFile("fixtures/diamond/forwarder.rx"),
        @embedFile("fixtures/diamond/forwarder.rx"),
        @embedFile("fixtures/diamond/identity.rx"),
    } else &.{
        @embedFile("fixtures/project_main.rx"),
        @embedFile("fixtures/project_bridge.rx"),
        @embedFile("fixtures/project_leaf.rx"),
    };
    const names: []const []const u8 = if (diamond) &.{ "main.rx", "left.rx", "right.rx", "identity.rx" } else &.{ "main.rx", "bridge.rx", "leaf.rx" };
    const parsed = try allocator.alloc(rx.XmlResult, texts.len);

    defer allocator.free(parsed);

    var count: usize = 0;

    defer for (parsed[0..count]) |*item| item.deinit();

    for (texts, parsed) |text, *item| {
        item.* = try rx.parseXml(allocator, text);
        count += 1;

        if (item.value != .node) return error.InvalidXml;
    }

    const sources = try allocator.alloc(rx.ModuleSource, texts.len);

    defer allocator.free(sources);

    for (names, 0..) |name, index| {
        const target = if (reverse_modules) names.len - 1 - index else index;
        sources[target] = .{ .path = name, .node = parsed[index].value.node };
    }

    var result = try analysis.project.infer(allocator, .{
        .entry = "main.rx",
        .modules = sources,
        .sources = &.{
            .{ .path = "first.zx", .source = @embedFile("fixtures/first.zx") },
            .{ .path = "map_values.zx", .source = @embedFile("fixtures/map_values.zx") },
            .{ .path = "number.zx", .source = @embedFile("fixtures/diamond/number.zx") },
            .{ .path = "optional.zx", .source = @embedFile("fixtures/diamond/optional.zx") },
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
