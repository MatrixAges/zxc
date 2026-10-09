const std = @import("std");
const h = @import("provenance/check.zig");
const f = h.f;

test "source native and external dependencies preserve their kinds through every import order" {
    for (f.orders) |order| {
        var analysis = try f.analyze(order);

        defer analysis.deinit();

        const main = try f.index(analysis, f.main_path);
        var source_count: usize = 0;
        var native_count: usize = 0;
        var external_count: usize = 0;

        for (analysis.modules[main].imports) |dependency| switch (dependency.target) {
            .source => source_count += 1,
            .native => native_count += 1,
            .external => external_count += 1,
            .compiled => return error.UnexpectedCompiledDependency,
        };

        try std.testing.expectEqual(@as(usize, 3), source_count);
        try std.testing.expectEqual(@as(usize, 1), native_count);
        try std.testing.expectEqual(@as(usize, 1), external_count);
        for (analysis.modules, 0..) |_, selected| try f.control(&analysis, selected);
    }
}

test "compiled dependency in the first checked import is rejected in every order" {
    try h.compiled(0);
}

test "compiled dependency in a middle checked import is rejected in every order" {
    try h.compiled(2);
}

test "compiled dependency in the last checked import is rejected in every order" {
    try h.compiled(4);
}

test "unused compiled dependency rejects an entry record" {
    try h.unused(f.main_path);
}

test "unused compiled dependency rejects a source function record" {
    try h.unused(f.helper_path);
}

test "unused compiled dependency rejects a type record" {
    try h.unused(f.types_path);
}

test "compiled dependency in a different record does not reject the selected artifact" {
    var analysis = try f.analyze(f.orders[0]);

    defer analysis.deinit();

    const selected = try f.index(analysis, f.main_path);
    const other = try f.index(analysis, f.types_path);

    try h.mutation.unused(&analysis, other);
    try h.rejected(&analysis, other, error.InvalidModule);
    try f.control(&analysis, selected);
}
