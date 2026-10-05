const std = @import("std");
const compiler = @import("compiler");
const rx = @import("rx");
const analysis = @import("rx_analysis");

pub fn infer(path: []const u8, kind: []const u8) !analysis.module.Result {
    const allocator = std.testing.allocator;
    const text = try std.fmt.allocPrint(allocator, "<Module><Store from='{s}' as='jobs'/><Call fn='read' in={{store.jobs.counter}} out='ctx.result'/><Return value={{ctx.result}}/></Module>", .{path});

    defer allocator.free(text);

    var main = try rx.parseXml(allocator, text);

    defer main.deinit();

    const store = try std.fmt.allocPrint(allocator, "<Store name='same_name' version={{1}}><Object name='counter'><Field name='value' type='{s}' value={{3}}/></Object></Store>", .{kind});

    defer allocator.free(store);

    var state = try rx.parseXml(allocator, store);

    defer state.deinit();

    try std.testing.expect(main.value == .node and state.value == .node);

    const source = try std.fmt.allocPrint(allocator, "export type Input = {{ value: {s} }}\n\nexport type Output = {s}\n\nexport default function (in: Input): Output {{\n  return in.value\n}}\n", .{ kind, kind });

    defer allocator.free(source);

    var result = try analysis.project.infer(allocator, .{
        .entry = "main.rx",
        .modules = &.{.{ .path = "main.rx", .node = main.value.node }},
        .stores = &.{.{ .path = path, .node = state.value.node }},
        .sources = &.{.{ .path = "read.zx", .source = source }},
    });

    errdefer result.deinit();

    if (result.value == .diagnostic) {
        const issue = result.value.diagnostic;

        std.debug.print("{s}:{s}: {s}\n", .{ issue.path, issue.code, issue.message });
    }

    try std.testing.expect(result.value == .contract);

    return result;
}

pub fn link(allocator: std.mem.Allocator, path: []const u8, kind: []const u8, reverse: bool) !compiler.library.Result {
    var left = try infer("state.store.rx", "u64");

    defer left.deinit();

    var right = try infer(path, kind);

    defer right.deinit();

    var a = compiler.AnalysisResult{ .arena = std.heap.ArenaAllocator.init(std.testing.allocator), .value = .{ .ir = left.value.contract.program }, .nominal_types = left.value.contract.nominal_types };

    defer a.deinit();

    var b = compiler.AnalysisResult{ .arena = std.heap.ArenaAllocator.init(std.testing.allocator), .value = .{ .ir = right.value.contract.program }, .nominal_types = right.value.contract.nominal_types };

    defer b.deinit();

    var inputs = [_]compiler.library.Input{ .{ .name = "left", .analysis = &a }, .{ .name = "right", .analysis = &b } };

    if (reverse) std.mem.reverse(compiler.library.Input, &inputs);

    return compiler.library.link(allocator, &inputs);
}
