const std = @import("std");
const f = @import("buffer_eligibility/fixture.zig");
const same = @import("fixture.zig").same;

fn check(before: f.Mode, after: f.Mode) !void {
    var original = try f.analyze(before);

    defer original.deinit();

    var changed = try f.analyze(after);

    defer changed.deinit();

    var first = try f.compiler.zig.emitModules(std.testing.allocator, &original);

    defer first.deinit();

    var second = try f.compiler.zig.emitModules(std.testing.allocator, &changed);

    defer second.deinit();

    var offset: usize = 0;

    while (true) : (offset += 1) {
        var failing = std.testing.FailingAllocator.init(std.testing.allocator, .{ .resize_fail_index = 0 });
        const allocator = failing.allocator();
        var cache = f.compiler.zig.GenerationCache.init(allocator);

        defer cache.deinit();

        {
            var populated = try f.compiler.zig.emitModulesCached(allocator, &original, &cache);

            defer populated.deinit();

            try same(populated, first);
        }

        failing.fail_index = failing.alloc_index + offset;

        if (f.compiler.zig.emitModulesCached(allocator, &changed, &cache)) |result| {
            var bundle = result;

            defer bundle.deinit();

            try same(bundle, second);
            try std.testing.expect(!failing.has_induced_failure);
            try std.testing.expect(offset > 0);

            break;
        } else |err| {
            try std.testing.expectEqual(error.OutOfMemory, err);
            try std.testing.expect(failing.has_induced_failure);
        }

        failing.fail_index = std.math.maxInt(usize);

        {
            var recovered = try f.compiler.zig.emitModulesCached(allocator, &changed, &cache);

            defer recovered.deinit();

            try same(recovered, second);
        }

        const generated = cache.generated;

        {
            var repeated = try f.compiler.zig.emitModulesCached(allocator, &changed, &cache);

            defer repeated.deinit();

            try same(repeated, second);
            try std.testing.expectEqual(generated, cache.generated);
        }

        var restored = try f.compiler.zig.emitModulesCached(allocator, &original, &cache);

        defer restored.deinit();

        try same(restored, first);
    }
}

test "same cache retries every failed loss of buffer eligibility" {
    try check(.push, .reverse);
}

test "same cache retries every failed gain of buffer eligibility" {
    try check(.reverse, .push);
}

test "same cache retries every failed buffered payload replacement" {
    try check(.push, .changed);
}
