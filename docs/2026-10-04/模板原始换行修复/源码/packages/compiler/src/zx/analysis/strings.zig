const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Analyzer = @import("analyzer.zig");
const Types = @import("types.zig");
const literal = @import("../frontend/string_literal.zig");

pub fn template(self: *Analyzer, expression: *const zx.ast.Expression) zx.Error!ir.ExprId {
    const parts = try self.allocator.alloc(ir.ExprId, expression.value.template.len);

    for (expression.value.template, 0..) |part, index| {
        parts[index] = switch (part) {
            .text => |text| try self.append(.{ .span = expression.span, .type_id = Types.scalarId(.string), .value = .{ .string = try literal.decodeTemplate(self.allocator, text) } }),
            .expression => |value| try self.expression(value, null),
        };

        const value_type = self.types.get(self.node(parts[index]).type_id);

        if (value_type != .scalar or value_type.scalar == .void) return self.reporter.fail(.type_mismatch, expression.span, "template interpolation requires a scalar value");
    }

    return self.append(.{ .span = expression.span, .type_id = Types.scalarId(.string), .value = .{ .template = parts } });
}

pub const decode = literal.decode;
