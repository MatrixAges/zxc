const std = @import("std");
const compiler = @import("compiler");
const rx = @import("rx");
const analysis = @import("rx_analysis");

pub fn link(allocator: std.mem.Allocator, reverse: bool) !compiler.library.Result {
    const temporary = std.heap.page_allocator;
    var main = try rx.parseXml(temporary, @embedFile("fixtures/main.rx"));
    defer main.deinit();
    var select = try rx.parseXml(temporary, @embedFile("fixtures/select.rx"));
    defer select.deinit();
    if (main.value != .node or select.value != .node) return error.InvalidXml;

    const sources = [_]compiler.project.Source{.{ .path = "leaf.zx", .source = @embedFile("fixtures/leaf.zx") }};
    var inferred = try analysis.project.infer(temporary, .{
        .entry = "main.rx",
        .modules = &.{ .{ .path = "main.rx", .node = main.value.node }, .{ .path = "select.rx", .node = select.value.node } },
        .sources = &sources,
    });
    defer inferred.deinit();
    if (inferred.value != .contract) return error.InvalidContract;

    const contract = inferred.value.contract;
    var workflow = compiler.AnalysisResult{ .arena = std.heap.ArenaAllocator.init(temporary), .value = .{ .ir = contract.program }, .nominal_types = contract.nominal_types };
    defer workflow.deinit();
    var logic = try compiler.project.analyze(temporary, &sources, .{ .entry = "leaf.zx" });
    defer logic.deinit();
    if (logic.value != .ir) return error.InvalidLogic;

    var inputs = [_]compiler.library.Input{
        .{ .name = "alpha", .analysis = &workflow },
        .{ .name = "beta", .analysis = &logic },
        .{ .name = "repeat", .analysis = &workflow },
    };
    if (reverse) std.mem.reverse(compiler.library.Input, &inputs);

    return compiler.library.link(allocator, &inputs);
}
