const std = @import("std");
const allocation_testing = @import("allocation_testing");
const f = @import("fixture.zig");
const codec = f.compiler.project.SemanticCache.codec;
const identity = @as([32]u8, @splat(11));
const context = @as([32]u8, @splat(37));

fn roundtrip(allocator: std.mem.Allocator, owned: bool) !void {
    var decoded: [2]codec.Decoded = undefined;
    var count: usize = 0;

    defer for (decoded[0..count]) |*value| value.result.deinit();

    {
        var modules = try f.Modules.init(allocator, if (owned) f.consume_source else f.borrowed_source);

        defer modules.deinit();

        for (modules.values, &decoded) |module, *value| {
            const bytes = try codec.encode(allocator, module, context, identity);

            defer allocator.free(bytes);

            value.* = try codec.decode(allocator, bytes, identity);
            count += 1;

            @memset(bytes, 0);

            try std.testing.expectEqualSlices(u8, &context, &value.context_digest);
            try std.testing.expectEqual(module.function.?.output_ownership, value.result.value.function.?.output_ownership);
            try std.testing.expectEqualSlices(f.compiler.ir.SymbolTable.Ownership, module.functions.ownership, value.result.value.functions.ownership);
        }
    }

    const modules = [_]f.artifact.Module{ decoded[1].result.value, decoded[0].result.value };
    var linked = try f.artifact.linker.link(allocator, &modules, "/project/main.zx");

    defer linked.deinit();

    try std.testing.expectEqual(.owned, linked.program.output_ownership);
    try std.testing.expect(try f.compiler.validateIr(allocator, linked.program) == null);

    var found = false;

    for (0..linked.program.functions.count()) |function_row| {
        const function = linked.program.functions.at(function_row);

        if (!std.mem.endsWith(u8, function.file_name, "/consume.zx")) continue;
        try std.testing.expectEqual(.owned, function.output_ownership);

        found = true;
    }

    try std.testing.expect(found);
}

test "semantic cache retains result ownership after original bytes disappear" {
    try roundtrip(std.testing.allocator, true);
}

test "semantic cache retains mapped result ownership after original bytes disappear" {
    try roundtrip(std.testing.allocator, false);
}

fn mismatch(owned: bool) !void {
    var modules = try f.Modules.init(std.testing.allocator, if (owned) f.consume_source else f.borrowed_source);

    defer modules.deinit();

    var changed = false;

    for (&modules.values) |*module| {
        if (module.functions.count() == 0) continue;

        const ownership = try std.testing.allocator.dupe(f.compiler.ir.SymbolTable.Ownership, module.functions.ownership);

        defer std.testing.allocator.free(ownership);

        ownership[0] = if (ownership[0] == .Owned) .Borrowed else .Owned;
        module.functions.ownership = ownership;
        changed = true;

        try std.testing.expectError(error.ConflictingInterface, f.artifact.linker.link(std.testing.allocator, &modules.values, "/project/main.zx"));

        break;
    }

    try std.testing.expect(changed);
}

test "link rejects importer misreporting append result ownership" {
    try mismatch(true);
}

test "link rejects importer misreporting mapped result ownership" {
    try mismatch(false);
}

test "owned module cache and relink chain releases allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, roundtrip, .{true});
}

test "borrowed module cache and relink chain releases allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, roundtrip, .{false});
}
