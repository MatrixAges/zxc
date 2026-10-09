const std = @import("std");
const f = @import("fixture.zig");

pub fn exported(exports: []const f.ir.Export, name: []const u8) !f.ir.TypeId {
    for (exports) |item| if (std.mem.eql(u8, item.name, name)) return item.type_id;

    return error.MissingFixtureExport;
}

pub fn field(types: f.ir.TypeTable, id: f.ir.TypeId, name: []const u8) !f.ir.TypeId {
    const object = types.get(id);

    try std.testing.expectEqual(.object, std.meta.activeTag(object));

    for (0..object.object.len) |index| {
        const item = object.object.at(index);

        if (std.mem.eql(u8, item.name, name)) return item.type_id;
    }

    return error.MissingFixtureField;
}

pub fn leaf(types: f.ir.TypeTable, id: f.ir.TypeId) !void {
    const object = types.get(id);

    try std.testing.expectEqual(.object, std.meta.activeTag(object));
    try std.testing.expectEqual(@as(usize, 2), object.object.len);
    try std.testing.expectEqualStrings("a", object.object.at(0).name);
    try std.testing.expectEqual(f.scalar(.u64), object.object.at(0).type_id);
    try std.testing.expectEqualStrings("z", object.object.at(1).name);
    try std.testing.expectEqual(f.scalar(.string), object.object.at(1).type_id);
}

pub fn declarations(types: f.ir.TypeTable, exports: []const f.ir.Export) !void {
    const value = try exported(exports, "Payload");
    const object = types.get(value);

    try std.testing.expectEqual(value, try exported(exports, "Mirror"));
    try std.testing.expectEqual(.object, std.meta.activeTag(object));
    try std.testing.expectEqual(@as(usize, 3), object.object.len);
    try std.testing.expectEqualStrings("direct", object.object.at(0).name);
    try std.testing.expectEqualStrings("optional", object.object.at(1).name);
    try std.testing.expectEqualStrings("rows", object.object.at(2).name);

    const direct = try field(types, value, "direct");

    try leaf(types, direct);
    try std.testing.expectEqual(direct, try exported(exports, "Leaf"));

    const optional = try field(types, value, "optional");
    const rows = try field(types, value, "rows");

    try std.testing.expectEqual(.optional, std.meta.activeTag(types.get(optional)));
    try std.testing.expectEqual(direct, types.get(optional).optional);
    try std.testing.expectEqual(.list, std.meta.activeTag(types.get(rows)));

    const row = types.get(rows).list;

    try std.testing.expectEqual(row, try exported(exports, "Row"));

    const tuple = types.get(row);

    try std.testing.expectEqual(.tuple, std.meta.activeTag(tuple));
    try std.testing.expectEqual(@as(usize, 3), tuple.tuple.len);
    try std.testing.expectEqual(optional, tuple.tuple.at(0));
    try std.testing.expectEqual(f.scalar(.bool), tuple.tuple.at(1));

    const numbers = types.get(tuple.tuple.at(2));

    try std.testing.expectEqual(.list, std.meta.activeTag(numbers));
    try std.testing.expectEqual(f.scalar(.u64), numbers.list);

    const mode = types.get(try exported(exports, "Mode"));

    try std.testing.expectEqual(.enumeration, std.meta.activeTag(mode));
    try std.testing.expectEqualStrings("Mode", mode.enumeration.name);
    try std.testing.expectEqual(@as(usize, 2), mode.enumeration.members.len);
    try std.testing.expectEqualStrings("Second", mode.enumeration.members[0]);
    try std.testing.expectEqualStrings("First", mode.enumeration.members[1]);
}

pub fn expression(program: f.ir.Program) !void {
    var rows: usize = 0;
    var entries: usize = 0;

    for (0..program.symbols.count()) |symbol_index| {
        const symbol = program.symbols.at(symbol_index);

        if (std.mem.eql(u8, symbol.name, "row")) {
            rows += 1;

            const tuple = program.types.get(symbol.type_id);

            try std.testing.expectEqual(.tuple, std.meta.activeTag(tuple));
            try std.testing.expectEqual(@as(usize, 3), tuple.tuple.len);

            const optional = program.types.get(tuple.tuple.at(0));
            const list = program.types.get(tuple.tuple.at(2));

            try std.testing.expectEqual(.optional, std.meta.activeTag(optional));
            try std.testing.expectEqual(f.scalar(.u64), optional.optional);
            try std.testing.expectEqual(f.scalar(.bool), tuple.tuple.at(1));
            try std.testing.expectEqual(.list, std.meta.activeTag(list));
            try std.testing.expectEqual(f.scalar(.u64), list.list);
        } else if (std.mem.eql(u8, symbol.name, "entry")) {
            entries += 1;

            try leaf(program.types, symbol.type_id);
        }
    }

    try std.testing.expectEqual(@as(usize, 1), rows);
    try std.testing.expectEqual(@as(usize, 1), entries);
    try std.testing.expectEqual(f.scalar(.u64), program.output_type);
}
