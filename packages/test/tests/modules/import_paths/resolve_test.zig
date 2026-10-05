const std = @import("std");
const compiler = @import("compiler");
const zx = @import("zx");
const allocation_testing = @import("allocation_testing");
const span = zx.Span{ .start = 19, .end = 37 };

fn check(allocator: std.mem.Allocator, path: []const u8, expected: []const u8) !void {
    var reporter = zx.Reporter{};
    const actual = try compiler.project.resolvePath(allocator, "/project/app/main.zx", path, "/project", &reporter, span);

    defer allocator.free(actual);

    try std.testing.expect(reporter.diagnostic == null);
    try std.testing.expectEqualStrings(expected, actual);
}

test "extensionless relative and root references resolve to explicit ZX identities" {
    const paths = [_][]const u8{
        "./helper", "./nested/../helper", "../app/helper", "@/app/helper",
    };

    for (paths) |path| try check(std.testing.allocator, path, "/project/app/helper.zx");
}

test "dots in directory names do not suppress ZX suffix completion" {
    for ([_][]const u8{ "../v1.2/helper", "@/v1.2/helper" }) |path| {
        try check(std.testing.allocator, path, "/project/v1.2/helper.zx");
    }
}

test "directory references and explicit extensions preserve import diagnostics" {
    const cases = [_]struct { path: []const u8, message: []const u8 }{
        .{ .path = "./", .message = "project imports must name a ZX module" },
        .{ .path = "../", .message = "project imports must name a ZX module" },
        .{ .path = "@/", .message = "project imports must name a ZX module" },
        .{ .path = "./folder/", .message = "project imports must name a ZX module" },
        .{ .path = "./folder/.", .message = "project imports must name a ZX module" },
        .{ .path = "./folder/..", .message = "project imports must name a ZX module" },
        .{ .path = "./helper.zx", .message = "project imports must omit the .zx extension; runtime and RX imports are forbidden" },
        .{ .path = "../app/helper.zx", .message = "project imports must omit the .zx extension; runtime and RX imports are forbidden" },
        .{ .path = "@/app/helper.zx", .message = "project imports must omit the .zx extension; runtime and RX imports are forbidden" },
        .{ .path = "./helper.rx", .message = "project imports must omit the .zx extension; runtime and RX imports are forbidden" },
        .{ .path = "./helper.js", .message = "project imports must omit the .zx extension; runtime and RX imports are forbidden" },
        .{ .path = "./helper.zxcir", .message = "project imports must omit the .zx extension; runtime and RX imports are forbidden" },
    };

    for (cases) |case| {
        var reporter = zx.Reporter{};

        try std.testing.expectError(error.InvalidSource, compiler.project.resolvePath(std.testing.allocator, "/project/app/main.zx", case.path, "/project", &reporter, span));

        const diagnostic = reporter.diagnostic orelse return error.MissingDiagnostic;

        try std.testing.expectEqual(.module, diagnostic.code);
        try std.testing.expectEqualStrings(case.message, diagnostic.message);
        try std.testing.expectEqualDeep(span, diagnostic.span);
    }
}

test "extensionless resolution cleans every allocation failure" {
    for ([_][]const u8{ "./helper", "../app/helper", "@/app/helper" }) |path| {
        try allocation_testing.checkAllAllocationFailures(std.testing.allocator, check, .{ path, "/project/app/helper.zx" });
    }
}
