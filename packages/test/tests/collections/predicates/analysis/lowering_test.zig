const std = @import("std");
const f = @import("fixture.zig");

test "source predicates lower to validated ordinary iterations" {
    for ([_][]const u8{ "every", "some" }) |method| {
        const body = try std.fmt.allocPrint(std.testing.allocator, "return in.{s}(item => item > 0)", .{method});

        defer std.testing.allocator.free(body);

        var result = try f.analyze(.{ .body = body });

        defer result.deinit();

        try std.testing.expect(result.value == .ir);
        try std.testing.expect(try f.compiler.validateIr(std.testing.allocator, result.value.ir) == null);
        try std.testing.expectEqual(f.compiler.ir.Ownership.copy, result.value.ir.output_ownership);

        var iterations: usize = 0;

        for (0..result.value.ir.expressions.count()) |index| {
            const expression = result.value.ir.expressions.at(index);

            try std.testing.expect(expression.value != .transform);
            if (expression.value == .iteration) iterations += 1;
        }

        try std.testing.expectEqual(@as(usize, 1), iterations);
    }
}

test "nested and constant predicates emit validated Zig bundles" {
    for ([_]f.Case{
        .{ .body = "return in.every(row => row.some(item => item > 0))", .input = "i64[][]" },
        .{ .body = "return in.every(item => true)" },
        .{ .body = "return in.some(item => false)" },
    }) |case| {
        var result = try f.analyze(case);

        defer result.deinit();

        try std.testing.expect(result.value == .ir);
        try std.testing.expect(try f.compiler.validateIr(std.testing.allocator, result.value.ir) == null);

        const bundle = try f.compiler.zig.emitBundle(std.testing.allocator, result.value.ir);

        defer bundle.deinit(std.testing.allocator);

        try std.testing.expect(bundle.source.len > 0);
    }
}
