const std = @import("std");
const f = @import("fixture.zig");
const Case = enum { builtin, resolved, alias, recursive, depth, unknown };

fn priority(case: Case) !void {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    var reporter: f.zx.Reporter = .{};
    const memory = arena.allocator();
    const target = f.name(if (case == .builtin) "u64" else "Target", 17);
    const declarations = &.{f.declaration("Target", 3, try f.node(memory, .{ .named = f.name("Missing", 71) }))};
    var types = try f.base(memory, &reporter, declarations);

    try f.held(&types, if (case == .depth) 256 else 255);
    if (case == .builtin or case == .resolved) try types.resolved.put(memory, target.text, f.scalar(.bool));
    if (case == .builtin or case == .resolved or case == .alias) types.aliases = &.{.{ .name = target.text, .type_id = f.scalar(.string) }};
    if (case == .builtin or case == .resolved or case == .alias or case == .recursive) try types.visiting.put(memory, target.text, {});

    const previous = types.visiting.count();

    switch (case) {
        .builtin => try std.testing.expectEqual(f.scalar(.u64), try types.named(target)),
        .resolved => try std.testing.expectEqual(f.scalar(.bool), try types.named(target)),
        .alias => try std.testing.expectEqual(f.scalar(.string), try types.named(target)),
        .recursive => {
            try std.testing.expectError(error.InvalidSource, types.named(target));
            try f.diagnostic(reporter, .type_mismatch, "recursive type aliases are not supported", target.span);
        },
        .depth => {
            try std.testing.expectError(error.InvalidSource, types.named(f.name("Missing", target.span.start)));
            try f.diagnostic(reporter, .unsupported, "type alias nesting exceeds 256 levels", f.name("Missing", target.span.start).span);
        },
        .unknown => {
            try std.testing.expectError(error.InvalidSource, types.named(f.name("Missing", target.span.start)));
            try f.diagnostic(reporter, .name, "unknown or unsupported type", f.name("Missing", target.span.start).span);
        },
    }

    try std.testing.expectEqual(previous, types.visiting.count());
    if (case == .builtin or case == .resolved or case == .alias or case == .recursive) try std.testing.expect(types.visiting.contains(target.text));
}

test "builtin precedes resolved alias and preexisting visiting at full depth" {
    try priority(.builtin);
}

test "resolved name precedes alias and preexisting visiting at full depth" {
    try priority(.resolved);
}

test "imported alias precedes preexisting visiting and depth" {
    try priority(.alias);
}

test "recursive reference precedes full depth and preserves existing marker" {
    try priority(.recursive);
}

test "full visiting depth precedes unknown declaration lookup" {
    try priority(.depth);
}

test "unknown declaration below full visiting depth keeps exact reference span" {
    try priority(.unknown);
}

fn depth(count: usize, tail: []const u8, expected: ?enum { depth, unknown }) !void {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    var reporter: f.zx.Reporter = .{};
    const declarations = try f.chain(arena.allocator(), count, tail);
    var types = try f.base(arena.allocator(), &reporter, declarations);

    if (expected) |problem| {
        try std.testing.expectError(error.InvalidSource, types.named(f.name("Alias0", 9000)));

        const reference = declarations[if (problem == .depth and count > 256) 255 else count - 1].value.named;

        try f.diagnostic(reporter, if (problem == .depth) .unsupported else .name, if (problem == .depth) "type alias nesting exceeds 256 levels" else "unknown or unsupported type", reference.span);
        try std.testing.expectEqual(@as(u32, 0), types.resolved.count());
    } else {
        try std.testing.expectEqual(f.scalar(.u64), try types.named(f.name("Alias0", 9000)));
        try std.testing.expectEqual(@as(u32, @intCast(count)), types.resolved.count());
    }

    try std.testing.expectEqual(@as(u32, 0), types.visiting.count());
    try f.prefix(types);
}

test "255 named aliases terminate at builtin without hitting depth limit" {
    try depth(255, "u64", null);
}

test "256 named aliases terminate at builtin at the exact allowed limit" {
    try depth(256, "u64", null);
}

test "257 named aliases reject the 257th reference with its own span" {
    try depth(257, "u64", .depth);
}

test "unknown tail after 255 names reports unknown rather than depth" {
    try depth(255, "Missing", .unknown);
}

test "unknown tail after 256 names reports depth before unknown" {
    try depth(256, "Missing", .depth);
}

test "preexisting 255 markers allow one additional declaration terminating at builtin" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    var reporter: f.zx.Reporter = .{};
    const memory = arena.allocator();
    var types = try f.base(memory, &reporter, &.{f.declaration("Target", 0, try f.node(memory, .{ .named = f.name("u64", 50) }))});

    try f.held(&types, 255);
    try std.testing.expectEqual(f.scalar(.u64), try types.named(f.name("Target", 70)));
    try f.heldUnchanged(types, 255);
}

test "builtin aliases include every scalar number and boolean without appending rows" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    var reporter: f.zx.Reporter = .{};
    var types = try f.base(arena.allocator(), &reporter, &.{});

    for (std.enums.values(f.ir.Scalar)) |value| try std.testing.expectEqual(f.scalar(value), try types.named(f.name(@tagName(value), 1)));
    try std.testing.expectEqual(f.scalar(.f64), try types.named(f.name("number", 1)));
    try std.testing.expectEqual(f.scalar(.bool), try types.named(f.name("boolean", 1)));
    try std.testing.expectEqual(@as(usize, 11), types.items.count());
    try std.testing.expectEqual(@as(u32, 0), types.resolved.count());
}

test "failed nested alias preserves unrelated visiting and resolved state" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    var reporter: f.zx.Reporter = .{};
    const memory = arena.allocator();
    var types = try f.base(memory, &reporter, try f.chain(memory, 3, "Missing"));

    try f.held(&types, 4);
    try types.resolved.put(memory, "Cached", f.scalar(.string));
    try std.testing.expectError(error.InvalidSource, types.named(f.name("Alias0", 70)));
    try f.heldUnchanged(types, 4);
    try std.testing.expectEqual(f.scalar(.string), types.resolved.get("Cached").?);
    try std.testing.expectEqual(@as(u32, 1), types.resolved.count());

    reporter.diagnostic = null;

    try std.testing.expectEqual(f.scalar(.u64), try types.named(f.name("u64", 80)));
    try f.heldUnchanged(types, 4);
}

test "mutual alias recursion removes only markers owned by the failed call" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    var reporter: f.zx.Reporter = .{};
    const memory = arena.allocator();

    const declarations = &.{
        f.declaration("Left", 0, try f.node(memory, .{ .named = f.name("Right", 20) })),
        f.declaration("Right", 30, try f.node(memory, .{ .named = f.name("Left", 50) })),
    };

    var types = try f.base(memory, &reporter, declarations);

    try f.held(&types, 2);
    try std.testing.expectError(error.InvalidSource, types.named(f.name("Left", 80)));
    try f.diagnostic(reporter, .type_mismatch, "recursive type aliases are not supported", declarations[1].value.named.span);
    try f.heldUnchanged(types, 2);
}

test "deep container frames do not consume named alias depth" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    var reporter: f.zx.Reporter = .{};
    const memory = arena.allocator();
    var value = try f.node(memory, .{ .named = f.name("u64", 0) });

    for (0..300) |_| value = try f.node(memory, .{ .optional = value });

    var types = try f.base(memory, &reporter, &.{f.declaration("Deep", 0, value)});
    var id = try types.named(f.name("Deep", 90));

    for (0..300) |_| {
        try std.testing.expectEqual(.optional, std.meta.activeTag(types.get(id)));

        id = types.get(id).optional;
    }

    try std.testing.expectEqual(f.scalar(.u64), id);
    try std.testing.expectEqual(@as(usize, 311), types.items.count());
    try std.testing.expectEqual(@as(u32, 0), types.visiting.count());
    try f.prefix(types);
}

fn zero(cache: bool) !void {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    var reporter: f.zx.Reporter = .{};
    const memory = arena.allocator();
    var types = try f.base(memory, &reporter, &.{});

    try f.held(&types, 255);
    try types.visiting.put(memory, "Ready", {});
    if (cache) try types.resolved.put(memory, "Ready", f.scalar(.void)) else types.aliases = &.{.{ .name = "Ready", .type_id = f.scalar(.void) }};
    try std.testing.expectEqual(f.scalar(.void), try types.named(f.name("Ready", 7)));
    try std.testing.expectEqual(@as(u32, 256), types.visiting.count());
    try std.testing.expect(types.visiting.contains("Ready"));
    try std.testing.expectEqual(null, reporter.diagnostic);
}

test "resolved void type id zero is a hit before visiting and depth" {
    try zero(true);
}

test "imported void type id zero is a hit before visiting and depth" {
    try zero(false);
}

test "later field failure keeps completed child cache and retries without recursive markers" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    var reporter: f.zx.Reporter = .{};
    const memory = arena.allocator();
    const child = try f.node(memory, .{ .named = f.name("Child", 40) });
    const missing = try f.node(memory, .{ .named = f.name("Missing", 80) });

    const object = try f.node(memory, .{ .object = &.{
        .{ .name = f.name("child", 30), .value = child },
        .{ .name = f.name("later", 70), .value = missing },
    } });

    const declarations = &.{
        f.declaration("Root", 0, object),
        f.declaration("Child", 100, try f.node(memory, .{ .list = try f.node(memory, .{ .named = f.name("u64", 120) }) })),
    };

    var types = try f.base(memory, &reporter, declarations);

    try f.held(&types, 2);
    try types.resolved.put(memory, "Cached", f.scalar(.bool));
    try std.testing.expectError(error.InvalidSource, types.named(f.name("Root", 140)));
    try f.diagnostic(reporter, .name, "unknown or unsupported type", missing.named.span);
    try f.heldUnchanged(types, 2);

    const completed = types.resolved.get("Child").?;
    const count = types.items.count();

    try std.testing.expectEqual(f.scalar(.u64), types.get(completed).list);
    try std.testing.expectEqual(f.scalar(.bool), types.resolved.get("Cached").?);
    try std.testing.expectEqual(@as(u32, 2), types.resolved.count());

    reporter.diagnostic = null;

    try std.testing.expectError(error.InvalidSource, types.named(f.name("Root", 140)));
    try f.diagnostic(reporter, .name, "unknown or unsupported type", missing.named.span);
    try f.heldUnchanged(types, 2);
    try std.testing.expectEqual(completed, types.resolved.get("Child").?);
    try std.testing.expectEqual(count, types.items.count());
    try f.prefix(types);
}
