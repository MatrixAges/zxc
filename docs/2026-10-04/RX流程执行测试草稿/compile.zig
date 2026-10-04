const std = @import("std");
const compiler = @import("compiler");
const rx = @import("rx");
const analysis = @import("rx_analysis");

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);
    const source = if (std.mem.eql(u8, args[1], "order")) @embedFile("fixtures/order.rx") else if (std.mem.eql(u8, args[1], "borrow")) @embedFile("fixtures/borrow.rx") else @embedFile("fixtures/discard.rx");
    var parsed = try rx.parseXml(allocator, source);

    defer parsed.deinit();

    if (parsed.value != .node) return error.InvalidXml;

    var result = try analysis.module.infer(allocator, .{
        .owner = "main.rx",
        .module = parsed.value.node,
        .sources = &.{
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
