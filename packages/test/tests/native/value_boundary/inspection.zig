const std = @import("std");
const compiler = @import("compiler");
const checks = @import("native_value_checks");
const Case = @import("fixture.zig").Case;

pub fn check(allocator: std.mem.Allocator, program: compiler.ir.Program, case: Case, expected_ordinary: usize) !void {
    try std.testing.expect(try compiler.validateIr(allocator, program) == null);

    const summary = try checks.summary.analyze(allocator, program);

    defer allocator.free(summary.pure);
    defer allocator.free(summary.local);
    defer allocator.free(summary.values);
    defer allocator.free(summary.state.selected);
    defer allocator.free(summary.state.keys);

    var native_count: usize = 0;
    var ordinary_count: usize = 0;

    for (0..program.functions.count(), 0..) |function_row, index| {
        const function = program.functions.at(function_row);

        try std.testing.expectEqual(case.pure, summary.pure[index]);
        try std.testing.expectEqual(case.local, summary.local[index]);

        if (function.external) |external| {
            native_count += 1;

            try std.testing.expectEqual(case.pure, checks.native.valueBoundary(program, function));
            try std.testing.expectEqual(case.local, checks.native.isolated(program, function));
            try std.testing.expectEqual(case.io, external.io_argument);
            try std.testing.expectEqual(case.process, external.process_argument);
            try std.testing.expectEqual(case.allocating, external.allocator_argument);
            try std.testing.expectEqual(case.expanded, external.expand_tuple);
            try std.testing.expectEqualStrings("apply", external.member[0]);
        } else {
            ordinary_count += 1;

            try std.testing.expect(program.typeOf(function.output_type) == .object);
            try std.testing.expectEqual(case.local, summary.values[index]);
            try std.testing.expect(!checks.native.valueBoundary(program, function));
            try std.testing.expect(!checks.native.isolated(program, function));
        }
    }

    try std.testing.expectEqual(@as(usize, 1), native_count);
    try std.testing.expectEqual(expected_ordinary, ordinary_count);
}
