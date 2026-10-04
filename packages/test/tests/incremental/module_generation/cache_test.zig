const std = @import("std");
const f = @import("fixture.zig");

test "only called helper gets an independent file and entry dependency" {
    var analysis = try f.analyze(std.testing.allocator, false);

    defer analysis.deinit();

    try std.testing.expectEqual(@as(usize, 2), analysis.value.ir.functions.len);

    var bundle = try f.compiler.zig.emitModules(std.testing.allocator, &analysis);

    defer bundle.deinit();

    try std.testing.expectEqual(@as(usize, 1), bundle.modules.len);
    try std.testing.expectEqual(@as(usize, 1), bundle.entry.imports.len);
    try std.testing.expectEqualStrings(bundle.modules[0].name, bundle.entry.imports[0]);
    try std.testing.expectEqual(@as(usize, 0), bundle.modules[0].imports.len);
    try std.testing.expect(std.mem.indexOf(u8, bundle.modules[0].source, "pub fn call") != null);
}

test "repeat generation reuses all three units and equals uncached output" {
    var cache = f.compiler.zig.GenerationCache.init(std.testing.allocator);

    defer cache.deinit();

    var analysis = try f.analyze(std.testing.allocator, false);

    defer analysis.deinit();

    var first = try f.compiler.zig.emitModulesCached(std.testing.allocator, &analysis, &cache);

    defer first.deinit();

    try std.testing.expectEqual(@as(usize, 3), cache.generated);
    try std.testing.expectEqual(@as(usize, 0), cache.reused);

    var second = try f.compiler.zig.emitModulesCached(std.testing.allocator, &analysis, &cache);

    defer second.deinit();

    var uncached = try f.compiler.zig.emitModules(std.testing.allocator, &analysis);

    defer uncached.deinit();

    try f.same(first, second);
    try f.same(second, uncached);
    try std.testing.expectEqual(@as(usize, 3), cache.generated);
    try std.testing.expectEqual(@as(usize, 3), cache.reused);
}

test "helper body edit regenerates only helper and retains its stable name" {
    var cache = f.compiler.zig.GenerationCache.init(std.testing.allocator);

    defer cache.deinit();

    var original = try f.analyze(std.testing.allocator, false);

    defer original.deinit();

    var changed = try f.analyze(std.testing.allocator, true);

    defer changed.deinit();

    var first = try f.compiler.zig.emitModulesCached(std.testing.allocator, &original, &cache);

    defer first.deinit();

    var second = try f.compiler.zig.emitModulesCached(std.testing.allocator, &changed, &cache);

    defer second.deinit();

    try f.sameFile(first.entry, second.entry);
    try std.testing.expectEqualStrings(first.types, second.types);
    try std.testing.expectEqualStrings(first.modules[0].name, second.modules[0].name);
    try std.testing.expect(!std.mem.eql(u8, first.modules[0].source, second.modules[0].source));
    try std.testing.expectEqual(@as(usize, 4), cache.generated);
    try std.testing.expectEqual(@as(usize, 2), cache.reused);
}
