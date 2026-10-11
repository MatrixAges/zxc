const std = @import("std");
const zx = @import("zx");
const syntax = zx.syntax.borrow;
const ir = zx.ir;
const Analyzer = @import("../analyzer.zig");

pub fn contains(self: *const Analyzer, expression: anytype) bool {
    for (0..self.refinement.projectionCount()) |index| {
        const projection = self.refinement.projectionAt(index) orelse continue;

        if (matches(self, expression, projection)) return true;
    }

    return false;
}

fn matches(self: *const Analyzer, expression: anytype, projection: ir.ExprId) bool {
    var source = expression;
    var value = projection;
    var remaining = self.nodes.view().count();

    while (remaining != 0) : (remaining -= 1) {
        const node = self.node(value).value;

        switch (node) {
            .optional_value => |child| value = child,
            .reference => |symbol| {
                const binding = @import("../expression_binding.zig").lookup(self, source) orelse switch (syntax.value(source)) {
                    .identifier => |name| self.lookup(name.text) orelse return false,
                    else => return false,
                };

                return binding == symbol;
            },
            .field => |field| {
                const source_value = syntax.value(source);

                if (source_value != .field) return false;

                const target = self.types.get(self.node(field.target).type_id);

                if (target != .object or field.index >= target.object.len) return false;
                if (!std.mem.eql(u8, target.object.at(field.index).name, source_value.field.name.text)) return false;

                source = source_value.field.target;
                value = field.target;
            },
            else => return false,
        }
    }

    return false;
}
