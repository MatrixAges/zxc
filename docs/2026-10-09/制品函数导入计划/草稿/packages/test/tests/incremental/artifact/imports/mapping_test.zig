const std = @import("std");
const f = @import("fixture.zig");
const check = @import("check.zig");

test "artifact import mappings follow real signatures across all source orderings" {
    for (f.orderings) |ordering| {
        var analysis = try f.analyze(std.testing.allocator, ordering, false);

        defer analysis.deinit();

        const index = try f.entry(analysis);
        var result = try f.artifact.extract(std.testing.allocator, &analysis, index);

        defer result.deinit();

        try check.module(analysis, index, result.value);
    }
}

test "two source aliases retain names and share one artifact function signature" {
    for (f.orderings) |ordering| {
        var analysis = try f.analyze(std.testing.allocator, ordering, true);

        defer analysis.deinit();

        const index = try f.entry(analysis);
        var result = try f.artifact.extract(std.testing.allocator, &analysis, index);

        defer result.deinit();

        try check.module(analysis, index, result.value);
        try std.testing.expectEqual(try f.local(result.value, "first"), try f.local(result.value, "twin"));
    }
}

test "uncalled imported signature retains its enum origin and composite types" {
    var analysis = try f.analyze(std.testing.allocator, f.orderings[0], false);

    defer analysis.deinit();

    var result = try f.artifact.extract(std.testing.allocator, &analysis, try f.entry(analysis));

    defer result.deinit();

    const noise = result.value.functions[@backingInt(try f.local(result.value, "noise"))];
    const value = result.value.types.get(noise.output_type);

    try std.testing.expectEqual(.enumeration, std.meta.activeTag(value));
    try std.testing.expectEqualStrings("Noise", value.enumeration.name);
    try std.testing.expectEqual(@as(usize, 1), result.value.nominal_types.count());
    try std.testing.expectEqual(noise.output_type, result.value.nominal_types.at(0).type_id);
    try std.testing.expectEqualStrings("/project/noise.zx", result.value.nominal_types.at(0).origin.source);
}
