const std = @import("std");
const f = @import("value_eligibility/fixture.zig");
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
    try std.testing.expectEqualStrings(first.entry.name, second.entry.name);
    try std.testing.expectEqual(changes_entry, !std.mem.eql(u8, first.entry.source, second.entry.source));
    try std.testing.expectEqual(before != .native_object, std.mem.indexOf(u8, first.entry.source, "callValue") != null);
    try std.testing.expectEqual(after != .native_object, std.mem.indexOf(u8, second.entry.source, "callValue") != null);

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

test "scalar native dependency preserves transitive value caller" {
    try transition(.pure, .native, false);
}

test "replacing scalar native dependency preserves transitive value caller" {
    try transition(.native, .pure, false);
}

test "object native dependency invalidates transitive value caller" {
    try transition(.native, .native_object, true);
}

test "restoring scalar native dependency invalidates transitive pointer caller" {
    try transition(.native_object, .native, true);
}

test "pure body edit keeps caller generation unchanged" {
    try transition(.pure, .changed, false);
}
