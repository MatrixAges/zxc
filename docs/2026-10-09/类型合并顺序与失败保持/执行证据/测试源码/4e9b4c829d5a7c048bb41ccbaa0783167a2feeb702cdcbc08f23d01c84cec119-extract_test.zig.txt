const std = @import("std");
const compiler = @import("compiler");
const f = @import("record_fixture");
const artifact = compiler.project.artifact;

test "pure type artifact owns exports and enum declaration origin" {
    var analysis = try f.analyze(std.testing.allocator);

    defer analysis.deinit();

    var result = try artifact.extract(std.testing.allocator, &analysis, 0);

    defer result.deinit();

    try std.testing.expectEqualStrings("/project/shared.zx", result.value.path);
    try std.testing.expect(result.value.function == null);
    try std.testing.expectEqual(@as(usize, 2), result.value.exports.len);
    try std.testing.expectEqual(@as(usize, 0), result.value.functions.count());
    try std.testing.expectEqual(@as(usize, 1), result.value.nominal_types.count());
    try std.testing.expectEqualStrings("/project/shared.zx", result.value.nominal_types.at(0).origin.source);
}

test "helper artifact drops unrelated global enums but retains type import" {
    var analysis = try f.analyze(std.testing.allocator);

    defer analysis.deinit();

    var result = try artifact.extract(std.testing.allocator, &analysis, 1);

    defer result.deinit();

    try std.testing.expect(result.value.function != null);
    try std.testing.expectEqual(@as(usize, 11), result.value.types.count());
    try std.testing.expectEqual(@as(usize, 0), result.value.nominal_types.count());
    try std.testing.expectEqual(@as(usize, 1), result.value.type_imports.len);
    try std.testing.expectEqualStrings("Count", result.value.type_imports[0].name);
    try std.testing.expectEqual(.u64, result.value.types.get(result.value.type_imports[0].type_id).scalar);
}

test "entry artifact retains unused checked function and enum imports" {
    var analysis = try f.analyze(std.testing.allocator);

    defer analysis.deinit();

    var result = try artifact.extract(std.testing.allocator, &analysis, 3);

    defer result.deinit();

    try std.testing.expectEqual(@as(usize, 3), result.value.dependencies.len);
    try std.testing.expectEqual(@as(usize, 2), result.value.function_imports.len);
    try std.testing.expectEqual(@as(usize, 2), result.value.functions.count());
    try std.testing.expectEqualStrings("helper", result.value.function_imports[0].name);
    try std.testing.expectEqualStrings("unused", result.value.function_imports[1].name);
    try std.testing.expectEqualStrings("Mode", result.value.type_imports[0].name);
    try std.testing.expectEqualStrings("/project/main.zx", result.value.function.?.file_name);
    try std.testing.expectEqualSlices(u8, &analysis.modules[3].source_digest, &result.value.source_digest);
}

test "artifact remains readable after original analysis is destroyed" {
    var result = blk: {
        var analysis = try f.analyze(std.testing.allocator);

        defer analysis.deinit();

        break :blk try artifact.extract(std.testing.allocator, &analysis, 3);
    };

    defer result.deinit();

    try std.testing.expectEqualStrings("/project/main.zx", result.value.path);
    try std.testing.expectEqualStrings("./helper", result.value.dependencies[0].specifier);
    try std.testing.expectEqualStrings("helper", result.value.dependencies[0].names[0]);
    try std.testing.expectEqualStrings("/project/helper.zx", result.value.dependencies[0].target.source);
    try std.testing.expectEqualStrings("in", result.value.function.?.symbols.at(0).name);

    const nominal = result.value.nominal_types.at(0);

    try std.testing.expectEqualStrings("Mode", nominal.name);
    try std.testing.expectEqualStrings("First", result.value.types.get(nominal.type_id).enumeration.members[0]);
    try std.testing.expectEqualStrings("/project/shared.zx", nominal.origin.source);
}

test "global function id is remapped to the module local import id" {
    const main = "import noise from \"./noise\"\n import helper from \"./helper\"\n export type Input = u64\n export type Output = u64\n export default function (in: Input): Output { return helper(in) }";
    const helper = "import leaf from \"./leaf\"\n export type Input = u64\n export type Output = u64\n export default function (in: Input): Output { return leaf(in) }";

    var analysis = try compiler.project.analyze(std.testing.allocator, &.{
        .{ .path = "main.zx", .source = main },
        .{ .path = "noise.zx", .source = f.unused },
        .{ .path = "helper.zx", .source = helper },
        .{ .path = "leaf.zx", .source = f.unused },
    }, .{ .entry = "main.zx", .root_dir = "/project" });

    defer analysis.deinit();

    try std.testing.expect(analysis.value == .ir);
    try std.testing.expectEqualStrings("/project/helper.zx", analysis.modules[2].path);
    try std.testing.expectEqual(@as(u32, 1), @backingInt(analysis.modules[2].function_imports[0].id));

    var result = try artifact.extract(std.testing.allocator, &analysis, 2);

    defer result.deinit();

    try std.testing.expectEqual(@as(usize, 1), result.value.functions.count());
    try std.testing.expectEqual(@as(u32, 0), @backingInt(result.value.function_imports[0].id));
    try std.testing.expectEqualStrings("/project/leaf.zx", result.value.functions.at(0).file_name);

    var calls: usize = 0;

    for (0..result.value.function.?.expressions.count()) |expression_index| {
        const expression = result.value.function.?.expressions.at(expression_index);

        if (expression.value == .call) {
            try std.testing.expectEqual(@as(u32, 0), @backingInt(expression.value.call.function));

            calls += 1;
        }
    }

    try std.testing.expectEqual(@as(usize, 1), calls);
}

test "enum type id is remapped after unrelated earlier declarations are omitted" {
    var analysis = try compiler.project.analyze(std.testing.allocator, &.{
        .{ .path = "main.zx", .source = "import noise from \"./noise\"\n import { Mode } from \"./shared\"\n " ++ f.unused },
        .{ .path = "noise.zx", .source = "export enum Noise { Tag } " ++ f.unused },
        .{ .path = "shared.zx", .source = f.shared },
    }, .{ .entry = "main.zx", .root_dir = "/project" });

    defer analysis.deinit();

    try std.testing.expect(analysis.value == .ir);
    try std.testing.expectEqualStrings("Mode", analysis.nominal_types.at(1).name);

    const global_id = analysis.nominal_types.at(1).type_id;
    var result = try artifact.extract(std.testing.allocator, &analysis, 1);

    defer result.deinit();

    try std.testing.expectEqual(@as(usize, 1), result.value.nominal_types.count());

    const local_id = result.value.nominal_types.at(0).type_id;

    try std.testing.expect(global_id != local_id);
    try std.testing.expectEqualStrings("Mode", result.value.types.get(local_id).enumeration.name);
    try std.testing.expectEqualStrings("/project/shared.zx", result.value.nominal_types.at(0).origin.source);

    var found = false;

    for (result.value.exports) |item| {
        if (!std.mem.eql(u8, item.name, "Mode")) continue;
        try std.testing.expectEqual(local_id, item.type_id);

        found = true;
    }

    try std.testing.expect(found);
}
