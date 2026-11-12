const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Facts = @import("check.zig").Facts;

pub fn facts(allocator: std.mem.Allocator, program: ir.Program, reporter: *zx.Reporter) zx.Error!Facts {
    var arena = zx.Arena.init(allocator);

    defer arena.deinit();

    const outcome = @import("input.zig").execute(arena.allocator(), program) catch |err| switch (err) {
        error.OutOfMemory, error.Overflow => return error.OutOfMemory,
        else => return reporter.fail(.contract, .{ .start = 0, .end = 0 }, try std.fmt.allocPrint(allocator, "internal compiler error: generated ownership check failed with {s}", .{@errorName(err)})),
    };

    if (outcome.message.len != 0) return reporter.fail(
        std.meta.stringToEnum(@FieldType(zx.Diagnostic, "code"), outcome.code) orelse unreachable,
        .{ .start = @intCast(outcome.start), .end = @intCast(outcome.end) },
        outcome.message,
    );

    return .{ .output = @fromBackingInt(@intCast(@backingInt(outcome.ownership))), .stores_owned = outcome.stores_owned };
}
