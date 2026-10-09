const std = @import("std");
const f = @import("fixture.zig");

test "independent structural modules share optional list tuple and object types" {
    var left = try f.extract("left.zx", f.structural);

    defer left.deinit();

    var right = try f.extract("right.zx", f.structural);

    defer right.deinit();

    var result = try f.artifact.type_link.merge(std.testing.allocator, &.{ left.value, right.value });

    defer result.deinit();

    try std.testing.expectEqual(@as(usize, 0), result.nominal_types.count());

    for ([_][]const u8{ "Maybe", "Items", "Pair", "Record" }) |name| {
        try std.testing.expectEqual(result.mappings[0][try f.exportIndex(left.value, name)], result.mappings[1][try f.exportIndex(right.value, name)]);
    }
}

test "same source declaration shares enum and containing structures" {
    try checkIdentity("shared.zx", true);
}

test "different source declarations separate enum and containing structures" {
    try checkIdentity("other.zx", false);
}

fn checkIdentity(right_path: []const u8, same: bool) !void {
    var left = try f.extract("shared.zx", f.declaration);

    defer left.deinit();

    var right = try f.extract(right_path, f.declaration);

    defer right.deinit();

    var result = try f.artifact.type_link.merge(std.testing.allocator, &.{ left.value, right.value });

    defer result.deinit();

    try std.testing.expectEqual(@as(usize, if (same) 1 else 2), result.nominal_types.count());

    for ([_][]const u8{ "Mode", "Maybe", "Items", "Pair", "Record" }) |name| {
        const a = result.mappings[0][try f.exportIndex(left.value, name)];
        const b = result.mappings[1][try f.exportIndex(right.value, name)];

        try std.testing.expectEqual(same, a == b);
    }
}

test "same declaration with changed members is rejected" {
    var left = try f.extract("shared.zx", f.declaration);

    defer left.deinit();

    var right = try f.extract("shared.zx", "export enum Mode { First, Third }");

    defer right.deinit();

    try std.testing.expectError(error.ConflictingNominalType, f.artifact.type_link.merge(std.testing.allocator, &.{ left.value, right.value }));
}

test "same nominal declaration merges across different local type indices" {
    var left = try f.extract("shared.zx", f.declaration);

    defer left.deinit();

    var right = try f.extract("shared.zx", "export enum Noise { Value } " ++ f.declaration);

    defer right.deinit();

    const left_index = try f.exportIndex(left.value, "Mode");
    const right_index = try f.exportIndex(right.value, "Mode");

    try std.testing.expect(left_index != right_index);

    var result = try f.artifact.type_link.merge(std.testing.allocator, &.{ right.value, left.value });

    defer result.deinit();

    try std.testing.expectEqual(@as(usize, 2), result.nominal_types.count());
    try std.testing.expectEqual(result.mappings[0][right_index], result.mappings[1][left_index]);
}

test "merged enum names members origins and objects outlive inputs" {
    var result = block: {
        var source = try f.extract("shared.zx", f.declaration);

        defer source.deinit();

        break :block try f.artifact.type_link.merge(std.testing.allocator, &.{source.value});
    };

    defer result.deinit();

    const origin = result.nominal_types.at(0);
    const enumeration = result.types.get(origin.type_id).enumeration;

    try std.testing.expectEqualStrings("/project/shared.zx", origin.origin.source);
    try std.testing.expectEqualStrings("Mode", origin.name);
    try std.testing.expectEqualStrings("Mode", enumeration.name);
    try std.testing.expectEqualStrings("First", enumeration.members[0]);
    try std.testing.expectEqualStrings("Second", enumeration.members[1]);

    var objects: usize = 0;

    for (0..result.types.count()) |type_index| {
        const value = result.types.at(type_index);

        if (value != .object) continue;

        objects += 1;

        try std.testing.expectEqualStrings("count", value.object.at(0).name);
        try std.testing.expectEqualStrings("mode", value.object.at(1).name);
        try std.testing.expectEqual(origin.type_id, value.object.at(1).type_id);
    }

    try std.testing.expectEqual(@as(usize, 1), objects);
}
