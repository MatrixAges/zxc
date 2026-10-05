const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;

pub fn validate(allocator: std.mem.Allocator, program: ir.Program) std.mem.Allocator.Error!bool {
    if (!try expressions(allocator, program, program.expressions)) return false;

    for (program.functions) |function| {
        if (!try expressions(allocator, program, function.expressions)) return false;
    }

    return true;
}

fn expressions(allocator: std.mem.Allocator, program: ir.Program, values: []const ir.Expression) std.mem.Allocator.Error!bool {
    for (values) |value| {
        if (value.value != .capture) continue;

        const members = try zx.error_effects.expression(allocator, program.types, program.functions, values, value.value.capture) orelse return false;

        defer allocator.free(members);

        const tuple = program.typeOf(value.type_id).tuple;
        const errors = program.typeOf(program.typeOf(tuple[0]).optional).error_set;

        if (members.len != errors.len) return false;

        for (members, errors) |actual, declared| {
            if (!std.mem.eql(u8, actual, declared)) return false;
        }
    }

    return true;
}
