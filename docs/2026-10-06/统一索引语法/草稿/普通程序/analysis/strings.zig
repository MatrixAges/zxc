const std = @import("std");
const zx = @import("zx");
const syntax = zx.syntax.borrow;
const ir = zx.ir;
const Analyzer = @import("analyzer.zig");
const Types = @import("types.zig");
const literal = @import("../frontend/string_literal.zig");

pub fn template(self: *Analyzer, expression: anytype) zx.Error!ir.ExprId {
    const template_parts = syntax.value(expression).template;
    const parts = try self.allocator.alloc(ir.ExprId, template_parts.len);

    for (0..template_parts.len) |index| {
        const part = syntax.item(template_parts, index);

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
