const std = @import("std");
const program = @import("program");
const probe = @import("probe");

test "multiplication calls operands in source order and stops on first failure" {
    for ([_]bool{ false, true }) |reverse| {
        for ([_]bool{ false, true }) |fail_left| {
            for ([_]bool{ false, true }) |fail_right| {
                var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

                defer arena.deinit();

                probe.count = 0;
                const result = program.execute(&arena, .{ .reverse = reverse, .fail_left = fail_left, .fail_right = fail_right });
                const first_fails = if (reverse) fail_right else fail_left;
                const second_fails = if (reverse) fail_left else fail_right;
                const expected_trace: []const u8 = if (reverse) (if (first_fails) "R" else "RL") else (if (first_fails) "L" else "LR");

                try std.testing.expectEqualStrings(expected_trace, probe.trace[0..probe.count]);

                if (first_fails) {
                    try std.testing.expectError(if (reverse) error.RightFailure else error.LeftFailure, result);
                } else if (second_fails) {
                    try std.testing.expectError(if (reverse) error.LeftFailure else error.RightFailure, result);
                } else {
                    try std.testing.expectEqual(@as(f64, 6), try result);
                }
            }
        }
    }
}
