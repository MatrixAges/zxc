const std = @import("std");
const h = @import("native_keys/check.zig");
const f = h.f;

fn snapshot(value: f.artifact.Module) ![]u8 {
    return std.json.Stringify.valueAlloc(std.testing.allocator, .{ .dependencies = value.dependencies, .native_modules = value.native_modules }, .{});
}

test "real provider aliases resolve by shared identity while preserving their distinct specifiers" {
    var analysis = try @import("native_keys/alias.zig").analyze();

    defer analysis.deinit();

    const main = try f.index(analysis, "/project/main.zx");
    const helper = try f.index(analysis, "/project/helper.zx");
    const item = try f.dependency(analysis, "zig:alias");

    try std.testing.expectEqualStrings("host@1", item.identity.?);
    try h.accepted(&analysis, main, &.{"host@1"});
    try h.accepted(&analysis, helper, &.{"host@1"});

    const selected = try h.records.types(&analysis, &.{item});

    try h.accepted(&analysis, selected, &.{"host@1"});
}

test "native keys dependency names and provider metadata survive poisoned source arenas" {
    var before: []u8 = undefined;

    var result = block: {
        var analysis = try f.analyze(f.orders[0], true);

        defer analysis.deinit();

        const memory = analysis.arena.allocator();
        var modules: [3]f.compiler.ir.NativeModule = undefined;
        var imports: [3]f.Import = undefined;

        for (f.specifiers, 0..) |specifier, position| {
            imports[position] = try f.dependency(analysis, specifier);
            imports[position].specifier = try memory.dupe(u8, imports[position].specifier);
            imports[position].identity = try memory.dupe(u8, imports[position].identity.?);
            const names = try memory.alloc([]const u8, 1);

            names[0] = try memory.dupe(u8, "owned_alias");
            imports[position].names = names;
            modules[position] = analysis.value.ir.native_modules.at(position);
            modules[position].specifier = try memory.dupe(u8, modules[position].specifier);
            modules[position].identity = try memory.dupe(u8, modules[position].identity.?);
            modules[position].import_name = try memory.dupe(u8, modules[position].import_name);
        }

        analysis.value.ir.native_modules = try f.compiler.ir.NativeModuleTable.fromValues(memory, &modules);

        const selected = try h.records.types(&analysis, &imports);
        var owned = try f.artifact.extract(std.testing.allocator, &analysis, selected);

        errdefer owned.deinit();

        try h.module(analysis, selected, owned.value, &f.identities);

        before = try snapshot(owned.value);

        for (imports, modules) |dependency, module| {
            @memset(@constCast(dependency.specifier), 0xa5);
            @memset(@constCast(dependency.identity.?), 0xa5);
            @memset(@constCast(dependency.names[0]), 0xa5);
            @memset(@constCast(module.specifier), 0xa5);
            @memset(@constCast(module.identity.?), 0xa5);
            @memset(@constCast(module.import_name), 0xa5);
        }

        break :block owned;
    };

    defer result.deinit();
    defer std.testing.allocator.free(before);

    const after = try snapshot(result.value);

    defer std.testing.allocator.free(after);

    try std.testing.expectEqualStrings(before, after);
    try std.testing.expectEqual(@as(usize, 3), result.value.native_modules.count());
}
