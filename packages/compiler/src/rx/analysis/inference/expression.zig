const std = @import("std");
const zx = @import("zx");
const syntax = zx.syntax.borrow;
const rx = @import("rx");
const Graph = @import("types.zig");
const Self = @This();

pub const Binding = struct { name: []const u8, value: Graph.Id, span: zx.Span = .{ .start = 0, .end = 0 } };

graph: *Graph,
input: Graph.Id,
input_used: bool = false,
bindings: std.ArrayList(Binding) = .empty,
nonnull: std.ArrayList([]const u8) = .empty,
attribute: rx.ast.Attribute,
span_offset: usize = 0,
pub fn infer(self: *Self, expression: anytype, expected: ?Graph.Id) zx.Error!Graph.Id {
    const node = syntax.value(expression);
    const span = self.sourceSpan(expression.span);

    if (try self.lookup(expression)) |original| {
        const binding = try self.refined(expression, original);

        try self.graph.requireValue(binding, span);
        if (expected) |hint| try self.graph.expect(binding, hint, span);

        return expected orelse binding;
    }

    const hint = try self.payload(expected);

    const value = switch (node) {
        .identifier => |name| block: {
            if (std.mem.eql(u8, name.text, "$in")) {
                self.input_used = true;

                break :block self.input;
            }

            return self.graph.reporter.fail(.name, span, "flow value is not defined in this scope");
        },
        .field => |field| try self.graph.field(try self.infer(field.target, null), field.name.text, span),
        .number => |text| try self.graph.number(text, false, span),
        .boolean => try self.graph.scalar(.bool, span),
        .string, .template => block: {
            if (node == .template) for (0..node.template.len) |index| {
                const part = syntax.item(node.template, index);

                if (part == .expression) _ = try self.infer(part.expression, null);
            };

            break :block try self.graph.scalar(.string, span);
        },
        .null_value => try self.graph.add(.{ .optional = try self.graph.add(.unknown, span) }, span),
        .object => try @import("objects.zig").infer(self, expression, hint),
        .list => try @import("sequences.zig").infer(self, expression, hint),
        .index => try @import("index.zig").infer(self, expression),
        .unary => |unary| block: {
            if (unary.operator == .not) break :block try self.infer(unary.operand, try self.graph.scalar(.bool, span));

            const operand = syntax.value(unary.operand);

            if (operand == .number) break :block try self.graph.number(operand.number, true, span);

            const result = try self.graph.add(.unknown, span);

            try self.graph.restrict(result, Graph.Mask.initMany(&.{ .i32, .i64, .f32, .f64 }), span);

            _ = try self.infer(unary.operand, result);

            break :block result;
        },
        .binary => try @import("operators.zig").infer(self, expression, hint),
        .conditional => |branch| block: {
            const result = expected orelse try self.graph.add(.unknown, span);

            _ = try self.infer(branch.condition, try self.graph.scalar(.bool, span));

            const facts = self.nonnull.items.len;

            defer self.nonnull.shrinkRetainingCapacity(facts);

            try @import("../condition.zig").assumeValue(branch.condition, true, self);

            _ = try self.infer(branch.yes, result);

            self.nonnull.shrinkRetainingCapacity(facts);

            try @import("../condition.zig").assumeValue(branch.condition, false, self);

            _ = try self.infer(branch.no, result);

            break :block result;
        },
        .match_expr => |selection| block: {
            const result = expected orelse try self.graph.add(.unknown, span);
            const subject = if (selection.subject) |item| try self.infer(item, null) else try self.graph.scalar(.bool, span);

            for (0..selection.arms.len) |index| {
                const arm = syntax.item(selection.arms, index);
                _ = try self.infer(arm.condition, subject);
                _ = try self.infer(arm.result, result);
            }

            _ = try self.infer(selection.fallback, result);

            break :block result;
        },
        .call, .lambda, .state_block, .capture, .task, .await_task, .cancel_task => return self.graph.reporter.fail(.unsupported, span, @import("../value_rules.zig").message),
    };

    const narrowed = try self.refined(expression, value);

    if (expected) |target| try self.graph.expect(narrowed, target, span);

    return expected orelse narrowed;
}

pub fn declared(self: *Self, expression: anytype) zx.Error!Graph.Id {
    const span = self.sourceSpan(expression.span);

    if (try self.lookup(expression)) |binding| {
        try self.graph.requireValue(binding, span);

        return binding;
    }

    const node = syntax.value(expression);

    if (node == .identifier and std.mem.eql(u8, node.identifier.text, "$in")) {
        self.input_used = true;

        return self.input;
    }

    if (node == .field) return self.graph.field(try self.infer(node.field.target, null), node.field.name.text, span);

    return self.infer(expression, null);
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
                id = try self.graph.known(value.optional, self.graph.nodes.items[@backingInt(self.graph.root(id))].span);

                continue;
            }
        }

        if (shape == .unknown and self.graph.nodes.items[@backingInt(self.graph.root(id))].allowed == null) return null;

        return id;
    }
}

pub fn sourceSpan(self: *const Self, value: zx.Span) zx.Span {
    const start = (rx.attributeLocation(self.attribute, value.start) orelse self.attribute.value_location).offset;

    return .{ .start = self.span_offset + start, .end = self.span_offset + (if (value.start == value.end) start else (rx.attributeEndLocation(self.attribute, value.end) orelse self.attribute.value_location).offset) };
}

fn lookup(self: *Self, expression: anytype) zx.Error!?Graph.Id {
    var selected: ?Graph.Id = null;
    var candidates: std.ArrayList(Graph.Id) = .empty;

    defer candidates.deinit(self.graph.allocator);

    for (self.bindings.items) |binding| {
        if (!@import("../condition.zig").matches(expression, binding.name) or @import("bindings.zig").isVoid(self.graph, binding.value)) continue;

        if (selected) |previous| {
            if (candidates.items.len == 0) try candidates.append(self.graph.allocator, previous);
            try candidates.append(self.graph.allocator, binding.value);
        }

        selected = binding.value;
    }

    if (candidates.items.len == 0) return selected;

    return try @import("bindings.zig").lookup(self.graph, candidates.items, self.sourceSpan(expression.span));
}

pub fn assumeNonNull(self: *Self, expression: anytype) zx.Error!void {
    const condition = @import("../condition.zig");

    const visible = condition.rooted(expression, "$in") or (for (self.bindings.items) |binding| {
        if (condition.rooted(expression, binding.name)) break true;
    } else false);

    if (!visible) return;

    const name = try condition.path(self.graph.allocator, expression) orelse return;

    try self.nonnull.append(self.graph.allocator, name);
}

fn refined(self: *Self, expression: anytype, value: Graph.Id) zx.Error!Graph.Id {
    for (self.nonnull.items) |name| {
        if (@import("../condition.zig").matches(expression, name)) return @import("non_null.zig").read(self.graph, value, self.sourceSpan(expression.span));
    }

    return value;
}
