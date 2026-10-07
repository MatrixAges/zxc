const std = @import("std");
const f = @import("fixture.zig");

fn accepted(case: f.Case) !void {
    const allocator = std.testing.allocator;
    var value = try f.library(allocator);

    defer value.deinit();

    var result = try f.consume(allocator, &value, case);

    defer result.deinit();

    if (result.value == .diagnostic) std.debug.print("unexpected reference identity diagnostic {t}: {s}\n", .{ result.value.diagnostic.code, result.value.diagnostic.message });
    try std.testing.expect(result.value == .ir);
    try f.inspect(allocator, result.value.ir, case.distinct);
}

test "compiled native reference public aliases share a rebound owner and type" {
    try accepted(.{});
}

test "compiled native reference distinct instances isolate owners and import names" {
    try accepted(.{ .distinct = true });
}

test "compiled native reference can cross call aliases within one instance" {
    try accepted(.{ .swap = true });
}

test "compiled native reference cannot cross call aliases of distinct instances" {
    const allocator = std.testing.allocator;
    var value = try f.library(allocator);

    defer value.deinit();

    var result = try f.consume(allocator, &value, .{ .distinct = true, .swap = true });

    defer result.deinit();

    try std.testing.expect(result.value == .diagnostic);

    const diagnostic = result.value.diagnostic;

    try std.testing.expectEqual(.type_mismatch, diagnostic.code);
    try std.testing.expectEqualStrings("expression type does not match its context", diagnostic.message);
    try std.testing.expectEqual(@as(?usize, 2), diagnostic.source_index);

    const source = try f.consumerSource(allocator, .{ .distinct = true, .swap = true });

    defer allocator.free(source);

    try std.testing.expectEqualStrings("in.left", source[diagnostic.span.start..diagnostic.span.end]);
}

test "generated native reference descriptors survive releasing library and analysis" {
    const allocator = std.testing.allocator;

    var bundle = block: {
        var value = try f.library(allocator);

        defer value.deinit();

        var result = try f.consume(allocator, &value, .{ .distinct = true });

        defer result.deinit();

        try std.testing.expect(result.value == .ir);
        try f.inspect(allocator, result.value.ir, true);

        break :block try f.compiler.zig.emitModules(allocator, &result);
    };

    defer bundle.deinit();

    try std.testing.expectEqual(@as(usize, 2), bundle.native_modules.count());

    for (0..bundle.native_modules.count()) |module_row| {
        const module = bundle.native_modules.at(module_row);

        try std.testing.expectEqualStrings("zig:host", module.specifier);
        try std.testing.expect(std.mem.indexOf(u8, bundle.types, module.key()) != null);
        try std.testing.expect(std.mem.startsWith(u8, module.import_name, "library_native_"));
    }
}
