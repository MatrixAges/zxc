const std = @import("std");
const zx = @import("zx");
const rx = @import("rx");
const Graph = @import("types.zig");
const Self = @This();

pub const Binding = struct { name: []const u8, value: Graph.Id };

graph: *Graph,
input: Graph.Id,
input_used: bool = false,
bindings: std.ArrayList(Binding) = .empty,
floor: usize = 0,
callback_depth: usize = 0,
attribute: rx.ast.Attribute,
span_offset: usize = 0,
pub fn infer(self: *Self, expression: *const zx.ast.Expression, expected: ?Graph.Id) zx.Error!Graph.Id {
    const span = self.sourceSpan(expression.span);

    if (self.lookup(expression)) |binding| {
        if (expected) |hint| try self.graph.expect(binding, hint, span);

        return expected orelse binding;
    }

    const hint = try self.payload(expected);

    const value = switch (expression.value) {
        .identifier => |name| block: {
            if (std.mem.eql(u8, name.text, "$in")) {
                if (self.callback_depth != 0) return self.graph.reporter.fail(.ownership, span, "callbacks cannot capture the module input");

                self.input_used = true;

                break :block self.input;
            }

            return self.graph.reporter.fail(.name, span, "flow value is not defined in this scope");
        },
        .field => |field| try self.graph.field(try self.infer(field.target, null), field.name.text, span),
        .number => |text| try self.graph.number(text, false, span),
        .boolean => try self.graph.scalar(.bool, span),
        .string, .template => block: {
            if (expression.value == .template) for (expression.value.template) |part| {
                if (part == .expression) _ = try self.infer(part.expression, null);
            };

            break :block try self.graph.scalar(.string, span);
        },
        .null_value => try self.graph.add(.{ .optional = try self.graph.add(.unknown, span) }, span),
        .object => try @import("objects.zig").infer(self, expression, hint),
        .list => try @import("sequences.zig").infer(self, expression, hint),
        .index => |item| block: {
            const target = try self.infer(item.target, null);

            _ = try self.infer(item.index, try self.graph.scalar(.u64, span));

            break :block try self.graph.payload(target, .list, span);
        },
        .unary => |unary| block: {
            if (unary.operator == .not) break :block try self.infer(unary.operand, try self.graph.scalar(.bool, span));
            if (unary.operand.value == .number) break :block try self.graph.number(unary.operand.value.number, true, span);

            const result = try self.graph.add(.unknown, span);

            try self.graph.restrict(result, Graph.Mask.initMany(&.{ .i32, .i64, .f32, .f64 }), span);

            _ = try self.infer(unary.operand, result);

            break :block result;
        },
        .binary => try @import("operators.zig").infer(self, expression, hint),
        .conditional => |branch| block: {
            const result = expected orelse try self.graph.add(.unknown, span);

            _ = try self.infer(branch.condition, try self.graph.scalar(.bool, span));
            _ = try self.infer(branch.yes, result);
            _ = try self.infer(branch.no, result);

            break :block result;
        },
        .match_expr => |selection| block: {
            const result = expected orelse try self.graph.add(.unknown, span);
            const subject = if (selection.subject) |item| try self.infer(item, null) else try self.graph.scalar(.bool, span);

            for (selection.arms) |arm| {
                _ = try self.infer(arm.condition, subject);
                _ = try self.infer(arm.result, result);
            }

            _ = try self.infer(selection.fallback, result);

            break :block result;
        },
        .call => try @import("calls.zig").infer(self, expression, hint),
        .lambda => return self.graph.reporter.fail(.unsupported, span, "callbacks require a collection operation"),
    };

    if (expected) |target| try self.graph.expect(value, target, span);

    return expected orelse value;
}

pub fn payload(self: *Self, expected: ?Graph.Id) zx.Error!?Graph.Id {
    var id = expected orelse return null;

    while (true) {
        const shape = self.graph.shape(id);

        if (shape == .optional) {
            id = shape.optional;

            continue;
        }

        if (shape == .known) {
            const value = self.graph.types.get(shape.known);

            if (value == .optional) {
                id = try self.graph.known(value.optional, self.graph.nodes.items[@intFromEnum(self.graph.root(id))].span);

                continue;
            }
        }

        if (shape == .unknown and self.graph.nodes.items[@intFromEnum(self.graph.root(id))].allowed == null) return null;

        return id;
    }
}

pub fn sourceSpan(self: *const Self, value: zx.Span) zx.Span {
    const start = (rx.attributeLocation(self.attribute, value.start) orelse self.attribute.value_location).offset;

    return .{ .start = self.span_offset + start, .end = self.span_offset + (if (value.start == value.end) start else (rx.attributeEndLocation(self.attribute, value.end) orelse self.attribute.value_location).offset) };
}

fn lookup(self: *const Self, expression: *const zx.ast.Expression) ?Graph.Id {
    var index = self.bindings.items.len;

    while (index > self.floor) {
        index -= 1;
        const binding = self.bindings.items[index];

        if (matches(expression, binding.name)) return binding.value;
    }

    return null;
}

fn matches(expression: *const zx.ast.Expression, name: []const u8) bool {
    if (expression.value == .identifier) return std.mem.eql(u8, expression.value.identifier.text, name);
    if (expression.value != .field) return false;

    const separator = std.mem.lastIndexOfScalar(u8, name, '.') orelse return false;

    return std.mem.eql(u8, expression.value.field.name.text, name[separator + 1 ..]) and matches(expression.value.field.target, name[0..separator]);
}
