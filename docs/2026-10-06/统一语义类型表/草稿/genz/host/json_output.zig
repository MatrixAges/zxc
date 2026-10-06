const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../node.zig");
const Builder = @import("../builder.zig");

pub const Output = struct { types: ir.TypeTable, id: ir.TypeId };

pub fn lower(builder: Builder, output: Output) std.mem.Allocator.Error![]const node.Statement {
    return lowerFailure(builder, output, &.{.{ .result = try builder.expression(.{ .error_value = "NonFiniteJsonNumber" }) }});
}

pub fn lowerFailure(builder: Builder, output: Output, failure: []const node.Statement) std.mem.Allocator.Error![]const node.Statement {
    var sequence: usize = 0;

    return check(builder, output.types, output.id, try builder.identifier("output"), &sequence, failure);
}

fn check(builder: Builder, types: ir.TypeTable, id: ir.TypeId, value: *const node.Expression, sequence: *usize, failure: []const node.Statement) std.mem.Allocator.Error![]const node.Statement {
    var body: std.ArrayList(node.Statement) = .empty;

    switch (types.at(@backingInt(id))) {
        .scalar => |scalar| if (scalar == .f32 or scalar == .f64) {
            const finite = try builder.call(try builder.path(&.{ "std", "math", "isFinite" }), &.{value});

            try body.append(builder.allocator, try builder.branch(try builder.expression(.{ .unary = .{ .operator = .not, .operand = finite } }), failure, &.{}));
        },
        .optional, .list => |child| {
            const name = try std.fmt.allocPrint(builder.allocator, "json_value_{d}", .{sequence.*});
            sequence.* += 1;

            const nested = try check(builder, types, child, try builder.identifier(name), sequence, failure);

            if (nested.len != 0) try body.append(builder.allocator, if (types.at(@backingInt(id)) == .optional)
                .{ .branch = .{ .condition = value, .capture = name, .yes = nested, .no = &.{} } }
            else
                .{ .for_loop = .{ .iterable = value, .capture = name, .body = nested } });
        },
        .object => |fields| for (0..fields.len) |view_index| {
            const field = fields.at(view_index);

            try body.appendSlice(builder.allocator, try check(builder, types, field.type_id, try builder.field(value, field.name), sequence, failure));
        },
        .tuple => |fields| for (0..fields.len) |index| {
            const child = fields.at(index);
            const name = try std.fmt.allocPrint(builder.allocator, "{d}", .{index});

            try body.appendSlice(builder.allocator, try check(builder, types, child, try builder.field(value, name), sequence, failure));
        },
        .enumeration, .error_set, .native_reference, .task => {},
    }

    return body.toOwnedSlice(builder.allocator);
}
