const std = @import("std");
const f = @import("fixture.zig");
const compiler = f.compiler;

test "library preserves callable and type-only module views in declaration order" {
    var callable = try f.analyze("call.zx", f.function);

    defer callable.deinit();

    var types = try f.analyze("types.zx", f.declaration);

    defer types.deinit();

    var result = try compiler.library.link(std.testing.allocator, &.{ .{ .name = "run", .analysis = &callable }, .{ .name = "types", .analysis = &types } });

    defer result.deinit();

    try std.testing.expectEqual(@as(usize, 2), result.exports.len);
    try std.testing.expectEqualStrings("run", result.exports[0].name);
    try std.testing.expectEqualStrings("types", result.exports[1].name);
    try std.testing.expect(result.exports[0].function != null);
    try std.testing.expect(result.exports[1].function == null);
    try std.testing.expect(!(try result.module(0)).type_only);
    try std.testing.expect((try result.module(1)).type_only);
    try std.testing.expectError(error.InvalidModule, result.module(2));
    for (0..2) |index| try std.testing.expect(try compiler.validateIr(std.testing.allocator, try result.module(index)) == null);
}

fn identity(path: []const u8, same: bool) !void {
    var left = try f.analyze("shared.zx", f.declaration);

    defer left.deinit();

    var right = try f.analyze(path, f.declaration);

    defer right.deinit();

    var result = try compiler.library.link(std.testing.allocator, &.{ .{ .name = "left", .analysis = &left }, .{ .name = "right", .analysis = &right } });

    defer result.deinit();

    try std.testing.expectEqual(@as(usize, if (same) 1 else 2), result.nominal_types.count());

    for ([_][]const u8{ "Mode", "Maybe", "Items" }) |name| {
        try std.testing.expectEqual(same, try f.exportedType(&result, 0, name) == try f.exportedType(&result, 1, name));
    }
}

test "library same source nominal declarations keep shared identity" {
    try identity("shared.zx", true);
}

test "library independent identical enums remain distinct" {
    try identity("other.zx", false);
}

test "library structural public records merge across sources" {
    const source = "export type Record = { count: u64\n name: string }\n";
    var left = try f.analyze("left.zx", source);

    defer left.deinit();

    var right = try f.analyze("right.zx", source);

    defer right.deinit();

    var result = try compiler.library.link(std.testing.allocator, &.{ .{ .name = "left", .analysis = &left }, .{ .name = "right", .analysis = &right } });

    defer result.deinit();

    try std.testing.expectEqual(try f.exportedType(&result, 0, "Record"), try f.exportedType(&result, 1, "Record"));
}

test "library conflicting versions of same enum reject" {
    var left = try f.analyze("shared.zx", f.declaration);

    defer left.deinit();

    var right = try f.analyze("shared.zx", "export enum Mode { First, Third }\n");

    defer right.deinit();

    try std.testing.expectError(error.ConflictingNominalType, compiler.library.link(std.testing.allocator, &.{ .{ .name = "left", .analysis = &left }, .{ .name = "right", .analysis = &right } }));
}
