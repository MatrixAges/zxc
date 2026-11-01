const std = @import("std");
const f = @import("buffer_eligibility/fixture.zig");
const same = @import("fixture.zig").same;

fn transition(before: f.Mode, after: f.Mode) !void {
    var cache = f.compiler.zig.GenerationCache.init(std.testing.allocator);

    defer cache.deinit();

    var original = try f.analyze(before);

    defer original.deinit();

    var changed = try f.analyze(after);

    defer changed.deinit();

    var first = try f.compiler.zig.emitModulesCached(std.testing.allocator, &original, &cache);

    defer first.deinit();

    var second = try f.compiler.zig.emitModulesCached(std.testing.allocator, &changed, &cache);

    defer second.deinit();

    var fresh = try f.compiler.zig.emitModules(std.testing.allocator, &changed);

    defer fresh.deinit();

    try same(second, fresh);
    try std.testing.expectEqual(first.modules.len, second.modules.len);

    var module_changed = false;

    for (first.modules, second.modules) |a, b| {
        try std.testing.expectEqualStrings(a.name, b.name);
        try std.testing.expectEqualDeep(a.imports, b.imports);
        if (!std.mem.eql(u8, a.source, b.source)) module_changed = true;
    }

    try std.testing.expect(module_changed);
    try std.testing.expectEqualStrings(first.entry.name, second.entry.name);
    try std.testing.expectEqualStrings(first.entry.source, second.entry.source);
    try std.testing.expect(std.mem.indexOf(u8, first.entry.source, "callValue") != null);
    try std.testing.expect(std.mem.indexOf(u8, second.entry.source, "callValue") != null);

    const generated = cache.generated;
    const reused = cache.reused;
    var repeated = try f.compiler.zig.emitModulesCached(std.testing.allocator, &changed, &cache);

    defer repeated.deinit();

    try same(repeated, fresh);
    try std.testing.expectEqual(generated, cache.generated);
    try std.testing.expect(cache.reused > reused);

    var restored = try f.compiler.zig.emitModulesCached(std.testing.allocator, &original, &cache);

    defer restored.deinit();

    try same(first, restored);
}

test "replacing append with reverse preserves the generic value caller ABI" {
    try transition(.push, .reverse);
}

test "restoring append preserves the generic value caller ABI" {
    try transition(.reverse, .push);
}

test "append payload edit preserves caller source while refreshing leaf" {
    try transition(.push, .changed);
}
