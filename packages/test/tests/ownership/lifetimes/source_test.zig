const std = @import("std");
const compiler = @import("compiler");
const report = @import("report.zig");
const helper = @embedFile("fixtures/borrow.zx");

comptime {
    _ = @import("source_cost.zig");
}

test "Source reports identity loans from actual typed IR" {
    const Case = struct {
        name: []const u8,
        source: []const u8,
        helper: []const u8 = helper,
        supported: bool = true,
        reason: ?[]const u8 = null,
    };

    const cases = [_]Case{
        .{ .name = "direct", .source = @embedFile("fixtures/direct.zx") },
        .{ .name = "dead", .source = @embedFile("fixtures/dead.zx"), .reason = "Candidate" },
        .{ .name = "retained", .source = @embedFile("fixtures/retained.zx"), .reason = "RetainedUse" },
        .{ .name = "returned", .source = @embedFile("fixtures/returned.zx"), .reason = "Returned" },
        .{ .name = "branch", .source = @embedFile("fixtures/branch.zx"), .supported = false, .reason = "UnsupportedControl" },
        .{ .name = "unknown", .source = @embedFile("fixtures/unknown.zx"), .helper = @embedFile("fixtures/unknown_helper.zx"), .reason = "UnknownCallee" },
    };

    for (cases) |case| {
        var analyzed = try compiler.project.analyze(std.testing.allocator, &.{
            .{ .path = "main.zx", .source = case.source },
            .{ .path = if (std.mem.eql(u8, case.name, "unknown")) "unknown_helper.zx" else "borrow.zx", .source = case.helper },
        }, .{ .entry = "main.zx", .root_dir = "/project" });

        defer analyzed.deinit();

        try std.testing.expect(analyzed.value == .ir);

        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

        defer arena.deinit();

        var counter = std.testing.FailingAllocator.init(arena.allocator(), .{});
        const output = try report.run(counter.allocator(), analyzed.value.ir);

        std.debug.print("loan source {s}: supported={any} loans={d} edges={d} allocations={d} bytes={d}\n", .{ case.name, output.supported, output.loans.len, output.edges, counter.alloc_index, counter.allocated_bytes });

        try std.testing.expectEqual(case.supported, output.supported);
        try std.testing.expectEqual(@as(usize, if (case.reason != null) 1 else 0), output.loans.len);

        if (case.reason) |reason| {
            const loan = output.loans[0];

            try std.testing.expectEqualStrings(reason, @tagName(loan.reason));

            if (loan.reason == .Candidate) {
                try std.testing.expect(loan.source != null);
                try std.testing.expectEqual(loan.last.? + 1, loan.release.?);
                try std.testing.expect(loan.created <= loan.last.?);
            } else try std.testing.expectEqual(null, loan.release);
        }

        for (output.loans) |loan| std.debug.print("  alias={d} source={any} created={d} last={any} release={any} reason={t}\n", .{ loan.alias, loan.source, loan.created, loan.last, loan.release, loan.reason });
    }
}
