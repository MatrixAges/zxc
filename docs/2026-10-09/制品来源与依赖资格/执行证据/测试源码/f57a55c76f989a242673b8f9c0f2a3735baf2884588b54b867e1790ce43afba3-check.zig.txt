const std = @import("std");
const f = @import("fixture.zig");

pub fn mapped(ids: f.Ids, mapping: []const f.ir.TypeId) f.Ids {
    var result: f.Ids = undefined;

    inline for (@typeInfo(f.Ids).@"struct".field_names) |name| @field(result, name) = mapping[@backingInt(@field(ids, name))];

    return result;
}

pub fn graph(types: f.ir.TypeTable, ids: f.Ids, options: f.Options) !void {
    try std.testing.expect(types.validStructure());

    const plain = types.get(ids.plain);

    if (options.change == .plain_kind) {
        try std.testing.expectEqual(.list, std.meta.activeTag(plain));
        try std.testing.expectEqual(f.scalar(.u64), plain.list);
    } else {
        try std.testing.expectEqual(.optional, std.meta.activeTag(plain));
        try std.testing.expectEqual(f.scalar(.u64), plain.optional);
    }

    const mode = types.get(ids.mode);

    if (options.mode_native) {
        try std.testing.expectEqual(.native_reference, std.meta.activeTag(mode));
        try std.testing.expectEqualStrings(options.mode_name, mode.native_reference);
    } else {
        try std.testing.expectEqual(.enumeration, std.meta.activeTag(mode));
        try std.testing.expectEqualStrings(options.mode_name, mode.enumeration.name);
        try std.testing.expectEqual(options.members.len, mode.enumeration.members.len);
        for (options.members, mode.enumeration.members) |a, b| try std.testing.expectEqualStrings(a, b);
    }

    const node = types.get(ids.node);

    try std.testing.expectEqual(.native_reference, std.meta.activeTag(node));
    try std.testing.expectEqualStrings(options.native_name, node.native_reference);

    const errors = types.get(ids.errors);
    const members: []const []const u8 = if (options.change == .errors) &.{ "Read", "Zero" } else &.{ "Read", "Write" };

    try std.testing.expectEqual(.error_set, std.meta.activeTag(errors));
    try std.testing.expectEqual(members.len, errors.error_set.len);
    for (members, errors.error_set) |a, b| try std.testing.expectEqualStrings(a, b);

    const pair = types.get(ids.pair);

    try std.testing.expectEqual(.tuple, std.meta.activeTag(pair));
    try std.testing.expectEqual(@as(usize, 3), pair.tuple.len);
    try std.testing.expectEqual(ids.mode, pair.tuple.at(0));
    try std.testing.expectEqual(ids.node, pair.tuple.at(1));
    try std.testing.expectEqual(f.scalar(if (options.change == .tuple_tail) .bool else .u64), pair.tuple.at(2));

    const saved = types.get(ids.saved);
    const list = types.get(ids.list);

    try std.testing.expectEqual(.optional, std.meta.activeTag(saved));
    try std.testing.expectEqual(ids.pair, saved.optional);
    try std.testing.expectEqual(.list, std.meta.activeTag(list));
    try std.testing.expectEqual(ids.saved, list.list);

    const record = types.get(ids.record);
    const names: []const []const u8 = if (options.change == .object_name) &.{ "items", "mode", "node", "stored" } else &.{ "items", "mode", "node", "saved" };
    const field_types = [_]f.ir.TypeId{ ids.list, ids.mode, ids.node, if (options.change == .object_type) ids.saved else ids.plain };

    try std.testing.expectEqual(.object, std.meta.activeTag(record));
    try std.testing.expectEqual(@as(usize, 4), record.object.len);

    for (names, field_types, 0..) |name, type_id, index| {
        try std.testing.expectEqualStrings(name, record.object.at(index).name);
        try std.testing.expectEqual(type_id, record.object.at(index).type_id);
    }

    const task = types.get(ids.task);

    try std.testing.expectEqual(.task, std.meta.activeTag(task));
    try std.testing.expectEqual(if (options.change == .task_result) ids.pair else ids.record, task.task.result);

    if (options.change == .task_errors) {
        const value = types.get(task.task.errors);

        try std.testing.expectEqual(.error_set, std.meta.activeTag(value));
        try std.testing.expectEqual(@as(usize, 1), value.error_set.len);
        try std.testing.expectEqualStrings("Alpha", value.error_set[0]);
        try std.testing.expect(task.task.errors != ids.errors);
    } else try std.testing.expectEqual(ids.errors, task.task.errors);
}

pub fn origin(result: f.link.Result, id: f.ir.TypeId, expected: f.Origin, label: []const u8) !void {
    var matches: usize = 0;

    for (0..result.nominal_types.count()) |index| {
        const item = result.nominal_types.at(index);

        if (item.type_id != id) continue;

        matches += 1;

        try std.testing.expectEqualStrings(label, item.name);
        try std.testing.expectEqual(std.meta.activeTag(expected), std.meta.activeTag(item.origin));

        switch (expected) {
            .source => |value| try std.testing.expectEqualStrings(value, item.origin.source),
            .native => |value| try std.testing.expectEqualStrings(value, item.origin.native),
            .external => |value| {
                try std.testing.expectEqualStrings(value.module, item.origin.external.module);
                try std.testing.expectEqualStrings(value.member, item.origin.external.member);
            },
        }
    }

    try std.testing.expectEqual(@as(usize, 1), matches);
}

pub fn module(result: f.link.Result, source: f.Source, index: usize) !f.Ids {
    const mapping = result.mappings[index];

    try std.testing.expectEqual(source.module.types.count(), mapping.len);
    for (std.enums.values(f.ir.Scalar), 0..) |value, position| try std.testing.expectEqual(f.scalar(value), mapping[position]);

    const ids = mapped(source.ids, mapping);

    try graph(result.types, ids, source.options);
    try origin(result, ids.mode, source.options.mode_origin, source.options.mode_name);
    try origin(result, ids.node, .{ .native = source.options.native_owner }, source.options.native_name);

    if (source.aliases) |aliases| {
        const mapped_aliases = mapped(aliases, mapping);

        inline for (@typeInfo(f.Ids).@"struct".field_names) |name| try std.testing.expectEqual(@field(ids, name), @field(mapped_aliases, name));
        try graph(result.types, mapped_aliases, source.options);
    }

    return ids;
}
