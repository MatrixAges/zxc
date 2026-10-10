const std = @import("std");
const f = @import("fixture.zig");
const modules = f.checks.modules;

fn names(allocator: std.mem.Allocator, program: f.ir.Program) !modules.Names {
    const functions = try allocator.alloc([]const u8, program.functions.count());
    const types = try allocator.alloc([]const u8, program.types.count());

    for (functions, 0..) |*name, index| name.* = try std.fmt.allocPrint(allocator, "function_{d}", .{index});
    for (types, 0..) |*name, index| name.* = try std.fmt.allocPrint(allocator, "type_{d}", .{index});

    return .{ .types = types, .functions = functions };
}

test "reused function summaries preserve independent entry function and type generation" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const program = try f.program(arena.allocator(), 3, .none);
    const identities = try names(arena.allocator(), program);
    var shared = try modules.Analysis.create(std.testing.allocator, program);

    defer shared.deinit();

    for ([_]modules.Unit{ .entry, .{ .function = @fromBackingInt(2) }, .types, .{ .function = @fromBackingInt(0) }, .{ .function = @fromBackingInt(1) }, .entry, .types }) |unit| {
        const single = try modules.prepared(std.testing.allocator, program, identities, unit);

        defer std.testing.allocator.free(single);

        const reused = try modules.analyzed(std.testing.allocator, std.testing.allocator, program, identities, unit, shared.value);

        defer std.testing.allocator.free(reused);

        try std.testing.expect(single.len != 0);
        try std.testing.expectEqualStrings(single, reused);
        try f.expected(shared.value, 3, .none);
    }
}

test "generated output remains owned after its shared summary is released" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const program = try f.program(arena.allocator(), 1, .none);
    const identities = try names(arena.allocator(), program);

    const saved = block: {
        var shared = try modules.Analysis.create(std.testing.allocator, program);

        defer shared.deinit();

        break :block try modules.analyzed(std.testing.allocator, std.testing.allocator, program, identities, .entry, shared.value);
    };

    defer std.testing.allocator.free(saved);

    const independent = try modules.prepared(std.testing.allocator, program, identities, .entry);

    defer std.testing.allocator.free(independent);

    try std.testing.expectEqualStrings(independent, saved);
}
