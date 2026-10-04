const std = @import("std");
const compiler = @import("compiler");
const rx = @import("rx");
const analysis = @import("rx_analysis");

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);
    const mode = std.meta.stringToEnum(enum { order, borrow, discard, imports_forward, imports_reverse, conditional, aggregate, owned_pop }, args[1]) orelse return error.InvalidMode;
    const source = switch (mode) {
        .owned_pop => @embedFile("fixtures/owned_pop.rx"),
        .aggregate => @embedFile("fixtures/aggregate.rx"),
        .conditional => @embedFile("fixtures/conditional.rx"),
        .order => @embedFile("fixtures/order.rx"),
        .borrow => @embedFile("fixtures/borrow.rx"),
        .discard => @embedFile("fixtures/discard.rx"),
        .imports_forward => @embedFile("fixtures/imports_forward.rx"),
        .imports_reverse => @embedFile("fixtures/imports_reverse.rx"),
    };

    var parsed = try rx.parseXml(allocator, source);

    defer parsed.deinit();

    if (parsed.value != .node) return error.InvalidXml;

    var result = try analysis.module.infer(allocator, .{
        .owner = "main.rx",
        .module = parsed.value.node,
        .sources = &.{
            .{ .path = "sum_values.zx", .source = @embedFile("fixtures/sum_values.zx") },
            .{ .path = "map_values.zx", .source = @embedFile("fixtures/map_values.zx") },
            .{ .path = "bridge.zx", .source = @embedFile("fixtures/bridge.zx") },
            .{ .path = "right.zx", .source = @embedFile("fixtures/right.zx") },
            .{ .path = "left.zx", .source = @embedFile("fixtures/left.zx") },
            .{ .path = "first.zx", .source = @embedFile("fixtures/first.zx") },
            .{ .path = "increment.zx", .source = @embedFile("fixtures/increment.zx") },
            .{ .path = "multiply.zx", .source = @embedFile("fixtures/multiply.zx") },
            .{ .path = "text.zx", .source = @embedFile("fixtures/text.zx") },
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
