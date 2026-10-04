const std = @import("std");
const rx = @import("rx");
const zx = @import("zx");
const Flow = @import("program/flow.zig");
const Prepared = @import("project/flow.zig");
const Diagnostic = @import("expression.zig").Diagnostic;
const Value = @FieldType(zx.ir.Expression, "value");

pub fn check(subject: zx.ir.Program, attribute: rx.ast.Attribute, cases: []const Flow.Case, sources: []const Prepared.Case) ?Diagnostic {
    const type_id = subject.output_type;
    const value_type = subject.typeOf(type_id);
    const integer = @intFromEnum(type_id) >= @intFromEnum(zx.ir.Scalar.u8) and @intFromEnum(type_id) <= @intFromEnum(zx.ir.Scalar.i64);
    const boolean = @intFromEnum(type_id) == @intFromEnum(zx.ir.Scalar.bool);
    const string = @intFromEnum(type_id) == @intFromEnum(zx.ir.Scalar.string);

    if (value_type != .enumeration and !integer and !boolean and !string) return issue(attribute, .type_mismatch, "Switch.on requires an enum, integer, bool or string");

    for (cases, sources, 0..) |case, source, index| {
        const program = case.value orelse continue;
        const value = label(program);

        switch (value) {
            .integer, .negative_integer, .string, .boolean, .enum_value => {},
            else => return issue(source.value.?, .type_mismatch, "Case.value must be a literal or enum member"),
        }

        for (cases[0..index]) |previous| {
            if (previous.value) |other| if (same(value, label(other))) return issue(source.value.?, .name, "duplicate Switch case value");
        }
    }

    return null;
}

fn label(program: zx.ir.Program) Value {
    return program.expression(program.body[program.body.len - 1].result.?).value;
}

fn same(left: Value, right: Value) bool {
    if (std.meta.activeTag(left) != std.meta.activeTag(right)) {
        return (left == .integer and left.integer == 0 and right == .negative_integer and right.negative_integer == 0) or (right == .integer and right.integer == 0 and left == .negative_integer and left.negative_integer == 0);
    }

    return switch (left) {
        .integer => |value| value == right.integer,
        .negative_integer => |value| value == right.negative_integer,
        .string => |value| std.mem.eql(u8, value, right.string),
        .boolean => |value| value == right.boolean,
        .enum_value => |value| value == right.enum_value,
        else => false,
    };
}

fn issue(attribute: rx.ast.Attribute, code: @FieldType(zx.Diagnostic, "code"), message: []const u8) Diagnostic {
    const location = attribute.value_location;

    return .{ .location = location, .issue = .{ .code = code, .span = .{ .start = location.offset, .end = location.offset }, .message = message } };
}
