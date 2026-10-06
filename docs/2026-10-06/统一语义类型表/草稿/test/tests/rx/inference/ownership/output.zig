const std = @import("std");
const compiler = @import("compiler");
const ir = compiler.ir;
pub const Field = struct { name: []const u8, kind: enum { list, pop } };
pub const Shape = union(enum) { pop, fields: []const Field };

pub fn check(program: ir.Program, expected: Shape) !void {
    try std.testing.expect(try compiler.validateIr(std.testing.allocator, program) == null);

    switch (expected) {
        .pop => try pop(program.types, program.output_type),
        .fields => |fields| {
            const value = program.typeOf(program.output_type);

            try std.testing.expect(value == .object);
            try std.testing.expectEqual(fields.len, value.object.len);

            for (fields, 0..) |field, index| {
                const actual = value.object.at(index);

                try std.testing.expectEqualStrings(field.name, actual.name);

                switch (field.kind) {
                    .list => try list(program.types, actual.type_id),
                    .pop => try pop(program.types, actual.type_id),
                }
            }
        },
    }
}

fn pop(types: ir.TypeTable, id: ir.TypeId) !void {
    const value = types.get(id);

    try std.testing.expect(value == .tuple);
    try std.testing.expectEqual(@as(usize, 2), value.tuple.len);
    try list(types, value.tuple.at(0));

    const tail = types.get(value.tuple.at(1));

    try std.testing.expect(tail == .optional);
    try std.testing.expectEqualDeep(ir.Type{ .scalar = .u64 }, types.get(tail.optional));
}

fn list(types: ir.TypeTable, id: ir.TypeId) !void {
    const value = types.get(id);

    try std.testing.expect(value == .list);
    try std.testing.expectEqualDeep(ir.Type{ .scalar = .u64 }, types.get(value.list));
}
