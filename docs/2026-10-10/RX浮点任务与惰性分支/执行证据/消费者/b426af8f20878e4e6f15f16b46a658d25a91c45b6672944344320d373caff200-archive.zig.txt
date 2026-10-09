const std = @import("std");
const compiler = @import("compiler");
const analysis = @import("rx_analysis");

pub fn encode(allocator: std.mem.Allocator, contract: analysis.module.Contract, reverse: bool) ![]u8 {
    var workflow = compiler.AnalysisResult{
        .arena = std.heap.ArenaAllocator.init(allocator),
        .value = .{ .ir = contract.program },
        .nominal_types = contract.nominal_types,
    };

    defer workflow.deinit();

    var scalar = try compiler.project.analyze(allocator, &.{.{
        .path = "scalar.zx",
        .source = "export type Input = u64\nexport type Output = u64\nexport default function (in: Input): Output { return in + 11 }\n",
    }}, .{ .entry = "scalar.zx" });

    defer scalar.deinit();

    if (scalar.value != .ir) return error.InvalidScalar;

    var inputs = [_]compiler.library.Input{
        .{ .name = "scalar", .analysis = &scalar },
        .{ .name = "workflow", .analysis = &workflow },
        .{ .name = "alias", .analysis = &workflow },
    };

    if (reverse) std.mem.reverse(compiler.library.Input, &inputs);

    var library = try compiler.library.link(allocator, &inputs);

    defer library.deinit();

    return compiler.library.codec.encode(allocator, &library);
}
