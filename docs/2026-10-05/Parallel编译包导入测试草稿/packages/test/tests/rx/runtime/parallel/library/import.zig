const std = @import("std");
const compiler = @import("compiler");
const rx = @import("rx");
const analysis = @import("rx_analysis");
pub const Language = enum { rx, zx };

pub fn link(allocator: std.mem.Allocator, library: *const compiler.library.Result, name: []const u8, language: Language) !compiler.library.Result {
    const temporary = std.heap.page_allocator;

    const options = compiler.project.Options{
        .entry = "consumer.zx",
        .root_dir = "/consumer",
        .packages = &.{.{ .specifier = "dependency", .compiled = .{ .instance = "parallel@1", .artifact = "dependency.zxlib", .name = name } }},
        .compiled_libraries = &.{.{ .instance = "parallel@1", .artifact = "dependency.zxlib", .program = library.program, .exports = library.exports, .nominal_types = library.nominal_types }},
    };

    if (language == .zx) {
        var consumer = try compiler.project.analyze(temporary, &.{.{ .path = "consumer.zx", .source = @embedFile("consumer.zx") }}, options);

        defer consumer.deinit();

        if (consumer.value == .diagnostic) {
            std.debug.print("ZX consumer: {s}\n", .{consumer.value.diagnostic.message});

            return error.InvalidConsumer;
        }

        return compiler.library.link(allocator, &.{.{ .name = "consumer", .analysis = &consumer }});
    }

    var parsed = try rx.parseXml(temporary, @embedFile("consumer.rx"));

    defer parsed.deinit();

    if (parsed.value != .node) return error.InvalidXml;

    var inferred = try analysis.project.infer(temporary, .{
        .entry = "consumer.rx",
        .modules = &.{.{ .path = "consumer.rx", .node = parsed.value.node }},
        .sources = &.{},
        .project = options,
    });

    defer inferred.deinit();

    if (inferred.value == .diagnostic) {
        const issue = inferred.value.diagnostic;

        std.debug.print("RX consumer: {s}:{d}:{d}: {s}: {s}\n", .{ issue.path, issue.location.line, issue.location.column, issue.code, issue.message });

        return error.InvalidConsumer;
    }

    const contract = inferred.value.contract;
    var consumer = compiler.AnalysisResult{ .arena = std.heap.ArenaAllocator.init(temporary), .value = .{ .ir = contract.program }, .nominal_types = contract.nominal_types };

    defer consumer.deinit();

    return compiler.library.link(allocator, &.{.{ .name = "consumer", .analysis = &consumer }});
}
