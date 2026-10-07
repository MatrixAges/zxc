const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Facts = @import("check.zig").Facts;

pub fn facts(allocator: std.mem.Allocator, program: ir.Program, reporter: *zx.Reporter) zx.Error!Facts {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const outcome = @import("input.zig").execute(&arena, program) catch |err| switch (err) {
        error.OutOfMemory, error.Overflow => return error.OutOfMemory,
        else => return reporter.fail(.contract, .{ .start = 0, .end = 0 }, try std.fmt.allocPrint(allocator, "internal compiler error: generated ownership check failed with {s}", .{@errorName(err)})),
    };

    if (!outcome.complete) return reporter.fail(.contract, .{ .start = 0, .end = 0 }, "internal compiler error: generated ownership check is incomplete");

    if (outcome.failed) {
        if (outcome.expression >= program.expressions.count()) return reporter.fail(.contract, .{ .start = 0, .end = 0 }, "internal compiler error: generated ownership location is invalid");

        return reporter.fail(.ownership, program.expressions.at(@intCast(outcome.expression)).span, "the previous owner was consumed; use the new binding returned by the operation");
    }

    const output: ir.Ownership = switch (outcome.output) {
        .Copy => .copy,
        .Borrowed => .borrowed,
        .Owned => .owned,
        .Loaned, .Moved => return reporter.fail(.contract, .{ .start = 0, .end = 0 }, "internal compiler error: generated ownership result is invalid"),
    };

    return .{ .output = output, .stores_owned = outcome.stores_owned };
}
