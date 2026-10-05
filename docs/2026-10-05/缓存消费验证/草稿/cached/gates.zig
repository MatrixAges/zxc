const std = @import("std");
const compiler = @import("compiler");

pub fn check(allocator: std.mem.Allocator, analysis: *const compiler.AnalysisResult, rejected: bool) !void {
    const result = compiler.library.link(allocator, &.{.{ .name = "run", .analysis = analysis }});

    if (rejected) {
        if (result) |value| {
            var unexpected = value;

            unexpected.deinit();

            return error.ExpectedInvalidLibrary;
        } else |err| {
            if (err == error.OutOfMemory) return err;
            try std.testing.expectEqual(error.InvalidIr, err);
        }

        return;
    }

    var library = try result;

    defer library.deinit();

    const bytes = try compiler.library.codec.encode(allocator, &library);

    defer allocator.free(bytes);

    var decoded = try compiler.library.codec.decode(allocator, bytes);

    defer decoded.deinit();

    try std.testing.expect(try compiler.validateIr(allocator, try decoded.module(0)) == null);
}
