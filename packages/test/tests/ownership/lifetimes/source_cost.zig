const std = @import("std");
const compiler = @import("compiler");
const report = @import("report.zig");

fn source(allocator: std.mem.Allocator, loans: usize) ![]u8 {
    var text: std.Io.Writer.Allocating = .init(allocator);

    defer text.deinit();

    try text.writer.writeAll("import borrow from \"./borrow\"\n\nexport type Input = u64[]\n\nexport type Output = u64\n\nexport default function (in: Input): Output {\n");
    for (0..loans) |index| try text.writer.print("    const view_{d} = borrow(in)\n    const size_{d} = view_{d}.length\n\n", .{ index, index, index });
    try text.writer.print("    return size_{d}\n}}\n", .{loans - 1});

    return text.toOwnedSlice();
}

test "Source loan reporting cost over increasing actual typed IR" {
    for ([_]usize{ 64, 256, 1024 }) |loans| {
        const text = try source(std.testing.allocator, loans);

        defer std.testing.allocator.free(text);

        var analyzed = try compiler.project.analyze(std.testing.allocator, &.{
            .{ .path = "main.zx", .source = text },
            .{ .path = "borrow.zx", .source = @embedFile("fixtures/borrow.zx") },
        }, .{ .entry = "main.zx", .root_dir = "/project" });

        defer analyzed.deinit();

        try std.testing.expect(analyzed.value == .ir);

        var samples: [15]i96 = undefined;
        var bytes: usize = 0;
        var allocations: usize = 0;
        var edges: u64 = 0;

        for (0..samples.len + 3) |round| {
            var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);

            defer arena.deinit();

            var counter = std.testing.FailingAllocator.init(arena.allocator(), .{});
            const started = std.Io.Timestamp.now(std.testing.io, .awake);
            const output = try report.run(counter.allocator(), analyzed.value.ir);
            const elapsed = started.durationTo(std.Io.Timestamp.now(std.testing.io, .awake)).nanoseconds;

            try std.testing.expect(output.supported);
            try std.testing.expectEqual(loans, output.loans.len);

            for (output.loans) |loan| {
                try std.testing.expectEqual(.Candidate, loan.reason);
                try std.testing.expectEqual(loan.last.? + 1, loan.release.?);
            }

            if (round >= 3) samples[round - 3] = elapsed;

            bytes = counter.allocated_bytes;
            allocations = counter.alloc_index;
            edges = output.edges;
        }

        std.mem.sort(i96, &samples, {}, std.sort.asc(i96));
        std.debug.print("loan source cost: loans={d} expressions={d} edges={d} allocations={d} requested_bytes={d} wall_p50_ns={d}\n", .{ loans, analyzed.value.ir.expressions.count(), edges, allocations, bytes, samples[samples.len / 2] });
    }
}
