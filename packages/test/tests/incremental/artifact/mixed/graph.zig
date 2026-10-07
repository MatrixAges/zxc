const std = @import("std");
const f = @import("fixture.zig");

pub const Ids = struct { mode: f.ir.TypeId, node: f.ir.TypeId, record: f.ir.TypeId, pair: f.ir.TypeId, values: f.ir.TypeId, saved: f.ir.TypeId };

pub fn field(types: f.ir.TypeTable, id: f.ir.TypeId, name: []const u8) !f.ir.TypeId {
    const value = types.get(id);

    try std.testing.expectEqual(.object, std.meta.activeTag(value));

    for (0..value.object.len) |index| {
        const item = value.object.at(index);

        if (std.mem.eql(u8, item.name, name)) return item.type_id;
    }

    return error.MissingFixtureField;
}

pub fn exported(module: f.artifact.Module, name: []const u8) !f.ir.TypeId {
    for (module.exports) |item| {
        if (std.mem.eql(u8, item.name, name)) return item.type_id;
    }

    return error.MissingFixtureExport;
}

fn object(types: f.ir.TypeTable, id: f.ir.TypeId, names: []const []const u8) !void {
    const value = types.get(id);

    try std.testing.expectEqual(.object, std.meta.activeTag(value));
    try std.testing.expectEqual(names.len, value.object.len);
    for (names, 0..) |name, index| try std.testing.expectEqualStrings(name, value.object.at(index).name);
}

pub fn check(types: f.ir.TypeTable, input: f.ir.TypeId, output: f.ir.TypeId) !Ids {
    try std.testing.expect(types.validStructure());

    for (std.enums.values(f.ir.Scalar), 0..) |value, index| {
        try std.testing.expectEqual(.scalar, std.meta.activeTag(types.at(index)));
        try std.testing.expectEqual(value, types.at(index).scalar);
    }

    try object(types, input, &.{ "node", "pair", "record", "saved", "values" });
    try object(types, output, &.{ "node", "pair", "record", "saved", "total", "values" });

    const node = try field(types, input, "node");
    const record = try field(types, input, "record");
    const pair = try field(types, input, "pair");
    const values = try field(types, input, "values");
    const saved = try field(types, input, "saved");

    try object(types, record, &.{ "count", "mode" });
    try std.testing.expectEqual(f.scalar(.u64), try field(types, record, "count"));

    const mode = try field(types, record, "mode");
    const enumeration = types.get(mode);
    const reference = types.get(node);
    const tuple = types.get(pair);
    const list = types.get(values);
    const optional = types.get(saved);

    try std.testing.expectEqual(.enumeration, std.meta.activeTag(enumeration));
    try std.testing.expectEqualStrings("Mode", enumeration.enumeration.name);
    try std.testing.expectEqual(@as(usize, 2), enumeration.enumeration.members.len);
    try std.testing.expectEqualStrings("First", enumeration.enumeration.members[0]);
    try std.testing.expectEqualStrings("Second", enumeration.enumeration.members[1]);
    try std.testing.expectEqual(.native_reference, std.meta.activeTag(reference));
    try std.testing.expectEqualStrings("Node", reference.native_reference);
    try std.testing.expectEqual(.tuple, std.meta.activeTag(tuple));
    try std.testing.expectEqual(@as(usize, 2), tuple.tuple.len);
    try std.testing.expectEqual(mode, tuple.tuple.at(0));
    try std.testing.expectEqual(f.scalar(.u64), tuple.tuple.at(1));
    try std.testing.expectEqual(.list, std.meta.activeTag(list));
    try std.testing.expectEqual(mode, list.list);
    try std.testing.expectEqual(.optional, std.meta.activeTag(optional));
    try std.testing.expectEqual(mode, optional.optional);
    try std.testing.expectEqual(node, try field(types, output, "node"));
    try std.testing.expectEqual(record, try field(types, output, "record"));
    try std.testing.expectEqual(pair, try field(types, output, "pair"));
    try std.testing.expectEqual(values, try field(types, output, "values"));
    try std.testing.expectEqual(saved, try field(types, output, "saved"));
    try std.testing.expectEqual(f.scalar(.u64), try field(types, output, "total"));

    return .{ .mode = mode, .node = node, .record = record, .pair = pair, .values = values, .saved = saved };
}

pub fn task(module: f.artifact.Module) !void {
    const function = module.function.?;
    var tasks: usize = 0;
    var awaits: usize = 0;

    for (0..function.expressions.count()) |expression_index| {
        const expression = function.expressions.at(expression_index);

        if (expression.value == .task) {
            tasks += 1;
            const value = module.types.get(expression.type_id);

            try std.testing.expectEqual(.task, std.meta.activeTag(value));
            try std.testing.expectEqual(f.scalar(.u64), value.task.result);

            const errors = module.types.get(value.task.errors);

            try std.testing.expectEqual(.error_set, std.meta.activeTag(errors));
            try std.testing.expectEqual(@as(usize, 1), errors.error_set.len);
            try std.testing.expectEqualStrings("NativeFailure", errors.error_set[0]);
            try std.testing.expectEqual(@as(usize, 1), expression.value.task.captures.len);

            const capture = expression.value.task.captures[0];
            const symbol = function.symbols.at(@backingInt(capture));
            const body = function.expressions.at(@backingInt(expression.value.task.body));

            try std.testing.expectEqualStrings("count", symbol.name);
            try std.testing.expectEqual(f.scalar(.u64), symbol.type_id);
            try std.testing.expectEqual(.call, std.meta.activeTag(body.value));
            try std.testing.expectEqual(value.task.result, body.type_id);
            try std.testing.expect(@backingInt(body.value.call.function) < module.functions.len);

            const signature = module.functions[@backingInt(body.value.call.function)];
            const argument = function.expressions.at(@backingInt(body.value.call.argument));

            try std.testing.expectEqualStrings("compute", signature.external.?.exportName());
            try std.testing.expect(signature.external.?.concurrent);
            try std.testing.expectEqual(f.scalar(.u64), signature.input_type);
            try std.testing.expectEqual(f.scalar(.u64), signature.output_type);
            try std.testing.expectEqual(.reference, std.meta.activeTag(argument.value));
            try std.testing.expectEqual(capture, argument.value.reference);
        } else if (expression.value == .await_task) {
            awaits += 1;

            try std.testing.expectEqual(f.scalar(.u64), expression.type_id);

            const work = function.expressions.at(@backingInt(expression.value.await_task));

            try std.testing.expectEqual(.reference, std.meta.activeTag(work.value));
            try std.testing.expectEqualStrings("work", function.symbols.at(@backingInt(work.value.reference)).name);
            try std.testing.expectEqual(.task, std.meta.activeTag(module.types.get(work.type_id)));
        }
    }

    try std.testing.expectEqual(@as(usize, 1), tasks);
    try std.testing.expectEqual(@as(usize, 1), awaits);
}
