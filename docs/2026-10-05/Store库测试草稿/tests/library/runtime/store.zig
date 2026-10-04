const std = @import("std");
const compiler = @import("compiler");
const rx = @import("rx");
const analysis = @import("rx_analysis");

pub fn link(allocator: std.mem.Allocator, reverse: bool) !compiler.library.Result {
    var advance = try rx.parseXml(allocator, @embedFile("store/advance.rx"));
    defer advance.deinit();
    var read = try rx.parseXml(allocator, @embedFile("store/read.rx"));
    defer read.deinit();
    var store = try rx.parseXml(allocator, @embedFile("store/state.store.rx"));
    defer store.deinit();
    if (advance.value != .node or read.value != .node or store.value != .node) return error.InvalidFixture;

    const options = analysis.project.Options{
        .entry = "advance.rx",
        .modules = &.{ .{ .path = "advance.rx", .node = advance.value.node }, .{ .path = "read.rx", .node = read.value.node } },
        .stores = &.{.{ .path = "state.store.rx", .node = store.value.node }},
        .sources = &.{
            .{ .path = "advance.zx", .source = @embedFile("store/advance.zx") },
            .{ .path = "read.zx", .source = @embedFile("store/read.zx") },
        },
    };
    var write_result = try analysis.project.infer(allocator, options);
    defer write_result.deinit();
    var read_options = options;
    read_options.entry = "read.rx";
    var read_result = try analysis.project.infer(allocator, read_options);
    defer read_result.deinit();
    if (write_result.value != .contract or read_result.value != .contract) return error.InvalidContract;

    var writer = compiler.AnalysisResult{ .arena = std.heap.ArenaAllocator.init(allocator), .value = .{ .ir = write_result.value.contract.program }, .nominal_types = write_result.value.contract.nominal_types };
    defer writer.deinit();
    var reader = compiler.AnalysisResult{ .arena = std.heap.ArenaAllocator.init(allocator), .value = .{ .ir = read_result.value.contract.program }, .nominal_types = read_result.value.contract.nominal_types };
    defer reader.deinit();
    var inputs = [_]compiler.library.Input{
        .{ .name = "alpha", .analysis = &writer },
        .{ .name = "beta", .analysis = &reader },
        .{ .name = "repeat", .analysis = &writer },
    };
    if (reverse) std.mem.reverse(compiler.library.Input, &inputs);

    return compiler.library.link(allocator, &inputs);
}
