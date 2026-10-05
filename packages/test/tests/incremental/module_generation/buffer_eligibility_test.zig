const std = @import("std");
const f = @import("buffer_eligibility/fixture.zig");
const same = @import("fixture.zig").same;

fn transition(before: f.Mode, after: f.Mode, changes_entry: bool) !void {
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
        if (!std.mem.eql(u8, a.source, b.source)) module_changed = true;
    }

    try std.testing.expect(module_changed);
    try std.testing.expectEqualStrings(first.entry.name, second.entry.name);
    try std.testing.expectEqual(changes_entry, !std.mem.eql(u8, first.entry.source, second.entry.source));
    try std.testing.expectEqual(before != .reverse, std.mem.indexOf(u8, first.entry.source, "callBuffered") != null);
    try std.testing.expectEqual(after != .reverse, std.mem.indexOf(u8, second.entry.source, "callBuffered") != null);

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

test "reverse dependency invalidates transitive buffered caller" {
    try transition(.push, .reverse, true);
}

test "restoring append eligibility invalidates transitive value caller" {
    try transition(.reverse, .push, true);
}

test "append payload edit preserves caller source while refreshing leaf" {
    try transition(.push, .changed, false);
}
