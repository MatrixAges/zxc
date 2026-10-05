const std = @import("std");
const compiler = @import("compiler");
const f = @import("fixture.zig");

test "every permutation of seven representative import categories has one canonical output" {
    const selected = [_]usize{ 0, 1, 2, 3, 4, 5, 11 };
    const expected = "import stdFn from \"std:zeta\"\nimport zigFn from \"zig:zeta\"\nimport cFn from \"c:zeta\"\nimport packageFn from \"zeta\"\n\nimport { Mode } from \"@/mode\"\n\nimport localFn from \"./zeta\"\n\nimport type { LocalType } from \"./zeta\"\n\n" ++ f.body;
    var order = [_]usize{ 0, 1, 2, 3, 4, 5, 6 };
    var count: usize = 0;

    while (true) {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

        defer arena.deinit();

        const allocator = arena.allocator();
        var source: std.ArrayList(u8) = .empty;

        for (order) |index| {
            try source.appendSlice(allocator, f.declarations[selected[index]].text);
            try source.append(allocator, '\n');
        }

        try source.append(allocator, '\n');
        try source.appendSlice(allocator, f.body);
        try f.check(std.testing.allocator, source.items, expected);

        count += 1;

        if (!nextPermutation(&order)) break;
    }

    try std.testing.expectEqual(@as(usize, 5040), count);
}

test "all ordered category pairs omit empty groups and keep type subcategories" {
    var count: usize = 0;

    for (f.declarations, 0..) |left, left_index| {
        for (f.declarations, 0..) |right, right_index| {
            if (left_index == right_index) continue;

            const first = f.declarations[@min(left_index, right_index)];
            const second = f.declarations[@max(left_index, right_index)];
            const separator: []const u8 = if (first.group == second.group) "\n" else "\n\n";
            const source = try std.fmt.allocPrint(std.testing.allocator, "{s}\n{s}\n\n{s}", .{ left.text, right.text, f.body });

            defer std.testing.allocator.free(source);

            const expected = try std.fmt.allocPrint(std.testing.allocator, "{s}{s}{s}\n\n{s}", .{ first.text, separator, second.text, f.body });

            defer std.testing.allocator.free(expected);

            try f.check(std.testing.allocator, source, expected);

            count += 1;
        }
    }

    try std.testing.expectEqual(@as(usize, 132), count);
}

test "same paths preserve declaration order and named binding order without merging" {
    const source = "import second from \"./same\"\nimport first from \"./same\"\nimport { Zebra, Alpha } from \"./same\"\nimport type { OtherType } from \"./same\"\nimport type { InputType } from \"./same\"\n\n" ++ f.body;
    const expected = "import second from \"./same\"\nimport first from \"./same\"\nimport { Zebra, Alpha } from \"./same\"\n\nimport type { OtherType } from \"./same\"\nimport type { InputType } from \"./same\"\n\n" ++ f.body;

    try f.check(std.testing.allocator, source, expected);
}

test "paths sort by case sensitive UTF8 bytes and scoped packages stay external" {
    const source = "import greek from \"./α\"\nimport accented from \"./É\"\nimport lower from \"./z\"\nimport upper from \"./Z\"\nimport parent from \"../parent\"\nimport root from \"@/root\"\nimport ordinary from \"alpha\"\nimport scoped from \"@scope/zeta\"\n\n" ++ f.body;
    const expected = "import scoped from \"@scope/zeta\"\nimport ordinary from \"alpha\"\n\nimport root from \"@/root\"\n\nimport parent from \"../parent\"\nimport upper from \"./Z\"\nimport lower from \"./z\"\nimport accented from \"./É\"\nimport greek from \"./α\"\n\n" ++ f.body;

    try f.check(std.testing.allocator, source, expected);
}

test "compiler and project entry points reject import order before module analysis" {
    const source = "import zeta from \"./zeta\"\nimport alpha from \"./alpha\"\n\n" ++ f.body;
    const expected = "import alpha from \"./alpha\"\nimport zeta from \"./zeta\"\n\n" ++ f.body;
    const compiled = try compiler.compile(std.testing.allocator, source, "main.zx");

    defer compiled.deinit(std.testing.allocator);

    try std.testing.expect(compiled == .diagnostic);
    try std.testing.expectEqual(.spacing, compiled.diagnostic.code);
    try std.testing.expectEqual(@as(usize, 0), compiled.diagnostic.span.start);
    try std.testing.expectEqual(@as(usize, 53), compiled.diagnostic.span.end);

    var rejected = try compiler.analyzeProject(std.testing.allocator, &.{
        .{ .path = "alpha.zx", .source = f.body },
        .{ .path = "zeta.zx", .source = f.body },
        .{ .path = "main.zx", .source = source },
    }, .{ .entry = "main.zx", .root_dir = "/project" });

    defer rejected.deinit();

    try std.testing.expect(rejected.value == .diagnostic);
    try std.testing.expectEqual(.spacing, rejected.value.diagnostic.code);
    try std.testing.expectEqual(@as(usize, 2), rejected.value.diagnostic.source_index);

    var accepted = try compiler.analyzeProject(std.testing.allocator, &.{
        .{ .path = "alpha.zx", .source = f.body },
        .{ .path = "zeta.zx", .source = f.body },
        .{ .path = "main.zx", .source = expected },
    }, .{ .entry = "main.zx", .root_dir = "/project" });

    defer accepted.deinit();

    try std.testing.expect(accepted.value == .ir);
    try std.testing.expectEqual(@as(usize, 3), accepted.modules.len);
}

fn nextPermutation(values: []usize) bool {
    var pivot = values.len - 1;

    while (pivot > 0 and values[pivot - 1] >= values[pivot]) pivot -= 1;
    if (pivot == 0) return false;

    var successor = values.len - 1;

    while (values[successor] <= values[pivot - 1]) successor -= 1;

    std.mem.swap(usize, &values[pivot - 1], &values[successor]);
    std.mem.reverse(usize, values[pivot..]);

    return true;
}
