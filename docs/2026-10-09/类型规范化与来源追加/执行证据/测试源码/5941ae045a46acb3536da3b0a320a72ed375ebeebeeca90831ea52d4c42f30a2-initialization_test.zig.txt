const std = @import("std");
const f = @import("fixture.zig");
const Problem = enum { imported_builtin, imported_duplicate, imported_local, local_builtin, local_duplicate, names_before_values };

fn rejected(problem: Problem) !void {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    var reporter: f.zx.Reporter = .{};
    const memory = arena.allocator();
    const missing = try f.node(memory, .{ .named = f.name("Missing", 100) });
    const local = f.declaration(if (problem == .local_builtin) "Array" else "Local", 21, missing);
    const first = f.declaration("First", 1, missing);

    const declarations: []const f.Declaration = switch (problem) {
        .local_duplicate => &.{ local, f.declaration("Local", 45, missing) },
        .names_before_values => &.{ first, local, f.declaration("Local", 45, missing) },
        else => &.{local},
    };

    var types = f.Types{ .allocator = memory, .reporter = &reporter, .declarations = declarations };

    types.aliases = switch (problem) {
        .imported_builtin => &.{.{ .name = "number", .type_id = f.scalar(.u64) }},
        .imported_duplicate => &.{ .{ .name = "Import", .type_id = f.scalar(.u64) }, .{ .name = "Import", .type_id = f.scalar(.bool) } },
        .imported_local => &.{.{ .name = "Local", .type_id = f.scalar(.u64) }},
        else => &.{},
    };

    try std.testing.expectError(error.InvalidSource, types.initialize());

    const message: []const u8 = switch (problem) {
        .imported_builtin => "an imported type cannot replace a built-in type",
        .imported_duplicate => "duplicate imported type name",
        .imported_local => "a local type cannot replace an imported type",
        .local_builtin => "a type cannot replace a built-in scalar",
        .local_duplicate, .names_before_values => "duplicate type declaration",
    };

    const span: f.zx.Span = switch (problem) {
        .imported_builtin, .imported_duplicate => .{ .start = 0, .end = 0 },
        .imported_local, .local_builtin => local.name.span,
        .local_duplicate, .names_before_values => declarations[declarations.len - 1].name.span,
    };

    try f.diagnostic(reporter, .name, message, span);
    try std.testing.expectEqual(@as(usize, 11), types.items.count());
    try std.testing.expectEqual(@as(u32, 0), types.resolved.count());
    try std.testing.expectEqual(@as(u32, 0), types.visiting.count());
    try f.prefix(types);
}

test "empty type initialization appends the complete scalar prefix once" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    var reporter: f.zx.Reporter = .{};
    var types = f.Types{ .allocator = arena.allocator(), .reporter = &reporter, .declarations = &.{} };

    try types.initialize();
    try types.initialize();
    try std.testing.expectEqual(@as(usize, 11), types.items.count());
    try f.prefix(types);
}

test "initialization rejects imported builtin before resolving local declarations" {
    try rejected(.imported_builtin);
}

test "initialization rejects duplicate imported names before local values" {
    try rejected(.imported_duplicate);
}

test "initialization rejects imported local conflict at declaration span" {
    try rejected(.imported_local);
}

test "initialization rejects local Array override before resolving its value" {
    try rejected(.local_builtin);
}

test "initialization rejects duplicate local declarations at the later name" {
    try rejected(.local_duplicate);
}

test "all local names are checked before any unknown value is resolved" {
    try rejected(.names_before_values);
}

test "initialization resolves forward aliases and imports without duplicate scalar rows" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    var reporter: f.zx.Reporter = .{};
    const memory = arena.allocator();

    const declarations = &.{
        f.declaration("First", 0, try f.node(memory, .{ .named = f.name("Later", 10) })),
        f.declaration("Later", 20, try f.node(memory, .{ .named = f.name("Imported", 30) })),
    };

    var types = try f.base(memory, &reporter, declarations);

    types.aliases = &.{.{ .name = "Imported", .type_id = f.scalar(.u64) }};

    try types.initialize();
    try std.testing.expectEqual(f.scalar(.u64), types.resolved.get("First").?);
    try std.testing.expectEqual(f.scalar(.u64), types.resolved.get("Later").?);
    try std.testing.expectEqual(@as(usize, 11), types.items.count());
    try std.testing.expectEqual(@as(u32, 0), types.visiting.count());
}

test "import conflict precedes later imported builtin override" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    var reporter: f.zx.Reporter = .{};
    const memory = arena.allocator();
    const local = f.declaration("Local", 21, try f.node(memory, .{ .named = f.name("Missing", 90) }));
    var types = try f.base(memory, &reporter, &.{local});

    types.aliases = &.{ .{ .name = "Local", .type_id = f.scalar(.u64) }, .{ .name = "Array", .type_id = f.scalar(.bool) } };

    try std.testing.expectError(error.InvalidSource, types.initialize());
    try f.diagnostic(reporter, .name, "a local type cannot replace an imported type", local.name.span);
}

test "repeated initialization reuses resolved enum declaration identity" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    var reporter: f.zx.Reporter = .{};
    const memory = arena.allocator();
    const value = try f.node(memory, .{ .enumeration = &.{ f.name("First", 20), f.name("Second", 30) } });
    var types = try f.base(memory, &reporter, &.{f.declaration("Mode", 0, value)});

    try types.initialize();

    const id = types.resolved.get("Mode").?;
    const count = types.items.count();

    try types.initialize();
    try std.testing.expectEqual(id, types.resolved.get("Mode").?);
    try std.testing.expectEqual(count, types.items.count());
    try std.testing.expectEqual(@as(u32, 0), types.visiting.count());
}
