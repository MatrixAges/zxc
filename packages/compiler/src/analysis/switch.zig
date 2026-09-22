const std = @import("std");
const zx = @import("zx");
const Analyzer = @import("analyzer.zig");
const Types = @import("types.zig");
const numbers = @import("numbers.zig");
const ir = zx.ir;

pub fn analyze(self: *Analyzer, subject: *const zx.ast.Expression, source_cases: []const zx.ast.SwitchCase) zx.Error!ir.Statement {
    const value = try self.expression(subject, null);
    const type_id = self.node(value).type_id;
    const value_type = self.types.get(type_id);

    if (value_type != .enumeration and !numbers.isInteger(type_id) and type_id != Types.scalarId(.bool) and type_id != Types.scalarId(.string)) {
        return self.reporter.fail(.type_mismatch, subject.span, "switch requires an enum, integer, bool or string");
    }

    var cases: std.ArrayList(ir.SwitchCase) = .empty;
    var has_default = false;

    for (source_cases) |source_case| {
        var label: ?ir.ExprId = null;

        if (source_case.value) |source_label| {
            label = try self.expression(source_label, type_id);

            if (!isConstant(self.node(label.?).value)) return self.reporter.fail(.type_mismatch, source_label.span, "case labels must be literals or enum members");

            for (cases.items) |previous| {
                if (previous.value) |previous_label| {
                    if (equal(self.node(label.?).value, self.node(previous_label).value)) return self.reporter.fail(.name, source_label.span, "duplicate switch case");
                }
            }
        } else {
            if (has_default) return self.reporter.fail(.name, source_case.span, "duplicate switch default");

            has_default = true;
        }

        try cases.append(self.allocator, .{ .value = label, .body = try self.block(source_case.body) });
    }

    const exhaustive = has_default or (value_type == .enumeration and cases.items.len == value_type.enumeration.members.len) or (type_id == Types.scalarId(.bool) and cases.items.len == 2);

    return .{ .switch_stmt = .{ .subject = value, .cases = try cases.toOwnedSlice(self.allocator), .exhaustive = exhaustive } };
}

fn isConstant(value: @FieldType(ir.Expression, "value")) bool {
    return switch (value) {
        .integer, .negative_integer, .boolean, .string, .enum_value => true,
        else => false,
    };
}

fn equal(left: @FieldType(ir.Expression, "value"), right: @FieldType(ir.Expression, "value")) bool {
    if (std.meta.activeTag(left) != std.meta.activeTag(right)) {
        return (left == .integer and left.integer == 0 and right == .negative_integer and right.negative_integer == 0) or
            (right == .integer and right.integer == 0 and left == .negative_integer and left.negative_integer == 0);
    }

    return switch (left) {
        .integer => |value| value == right.integer,
        .negative_integer => |value| value == right.negative_integer,
        .boolean => |value| value == right.boolean,
        .enum_value => |value| value == right.enum_value,
        .string => |value| std.mem.eql(u8, value, right.string),
        else => false,
    };
}
