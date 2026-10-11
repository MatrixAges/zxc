const std = @import("std");
const Output = struct { feasibility: []const u8, correctness: []const u8 };

pub fn executeValue(allocator: std.mem.Allocator, input: anytype) std.mem.Allocator.Error!Output {
    const declarations = try std.fmt.allocPrint(allocator, "{s}\n{s}", .{ try std.mem.join(allocator, "\n", input.declarations), input.definitions });
    const failures = if (input.violations.len == 0) "false" else try std.fmt.allocPrint(allocator, "(or {s})", .{try std.mem.join(allocator, " ", input.violations)});
    const header = "(set-logic QF_BV)\n(set-option :produce-models true)\n(set-option :timeout 10000)\n";

    return .{
        .feasibility = try std.fmt.allocPrint(allocator, "{s}{s}\n(assert {s})\n(check-sat)\n", .{ header, declarations, input.precondition }),
        .correctness = try std.fmt.allocPrint(allocator, "{s}{s}\n(assert {s})\n(check-sat)\n", .{ header, declarations, failures }),
    };
}
