const std = @import("std");
const zx = @import("zx");
const syntax = zx.syntax.borrow;
const rx = @import("rx");
const Graph = @import("types.zig");
const Self = @This();

pub const Binding = struct { name: []const u8, value: Graph.Id, span: zx.Span = .{ .start = 0, .end = 0 } };

graph: *Graph,
aliases: []const zx.ir.Export = &.{},
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
        .field => |field| (try self.enumMember(field.target, field.name, span)) orelse try self.graph.field(try self.infer(field.target, null), field.name.text, span),
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

            try self.graph.restrict(result, @import("scalar.zig").domain(.signed), span);

            _ = try self.infer(unary.operand, result);

            break :block result;
        },
        .binary => try @import("operators.zig").infer(self, expression, hint),
        .conditional => |branch| block: {
            const result = expected orelse try self.graph.add(.unknown, span);

            _ = try self.infer(branch.condition, try self.graph.scalar(.bool, span));

            const facts = self.nonnull.items.len;

            defer self.nonnull.shrinkRetainingCapacity(facts);

            try @import("../condition.zig").assumeValue(self.graph.scratch, branch.condition, true, self);

            _ = try self.infer(branch.yes, result);

            self.nonnull.shrinkRetainingCapacity(facts);

            try @import("../condition.zig").assumeValue(self.graph.scratch, branch.condition, false, self);

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
        .call => try @import("selection.zig").infer(self, expression),
        .pipeline, .lambda, .state_block, .capture, .task, .await_task, .cancel_task => return self.graph.reporter.fail(.unsupported, span, @import("../value_rules.zig").message),
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

    if (node == .field) return (try self.enumMember(node.field.target, node.field.name, span)) orelse try self.graph.field(try self.infer(node.field.target, null), node.field.name.text, span);

    return self.infer(expression, null);
}

pub fn payload(self: *Self, expected: ?Graph.Id) zx.Error!?Graph.Id {
    return @import("optional.zig").hint(self.graph, expected orelse return null);
}

pub fn sourceSpan(self: *const Self, value: zx.Span) zx.Span {
    const base = self.attribute.value_location.offset;
    const start = rx.attributeByteOffset(self.attribute, value.start, false) orelse base;
    const end = if (value.start == value.end) start else rx.attributeByteOffset(self.attribute, value.end, true) orelse base;

    return .{ .start = self.span_offset + start, .end = self.span_offset + end };
}

fn lookup(self: *Self, expression: anytype) zx.Error!?Graph.Id {
    var selected: ?Graph.Id = null;
    var candidates: std.ArrayList(Graph.Id) = .empty;

    errdefer candidates.deinit(self.graph.allocator);

    for (self.bindings.items) |binding| {
        if (!@import("frontend").binding_path.matches(expression, binding.name) or @import("bindings.zig").isVoid(self.graph, binding.value)) continue;

        if (selected) |previous| {
            if (candidates.items.len == 0) {
                try candidates.ensureTotalCapacityPrecise(self.graph.allocator, 2);

                candidates.appendAssumeCapacity(previous);
                candidates.appendAssumeCapacity(binding.value);
            } else {
                try candidates.append(self.graph.allocator, binding.value);
            }
        }

        selected = binding.value;
    }

    if (candidates.items.len == 0) return selected;

    return try @import("bindings.zig").lookup(self.graph, candidates.items, self.sourceSpan(expression.span));
}

pub fn assumeNonNull(self: *Self, expression: anytype) zx.Error!void {
    const paths = @import("frontend").binding_path;

    const visible = paths.rooted(expression, "$in") or (for (self.bindings.items) |binding| {
        if (paths.rooted(expression, binding.name)) break true;
    } else false);

    if (!visible) return;

    const name = try paths.path(self.graph.allocator, expression) orelse return;

    try self.nonnull.append(self.graph.allocator, name);
}

fn refined(self: *Self, expression: anytype, value: Graph.Id) zx.Error!Graph.Id {
    for (self.nonnull.items) |name| {
        if (@import("frontend").binding_path.matches(expression, name)) return @import("non_null.zig").read(self.graph, value, self.sourceSpan(expression.span));
    }

    return value;
}

fn enumMember(self: *Self, owner: anytype, name: zx.ast.Name, span: zx.Span) zx.Error!?Graph.Id {
    const value = syntax.value(owner);

    if (value != .field or syntax.value(value.field.target) != .identifier or self.aliases.len == 0) return null;
    if (@import("frontend").binding_path.rooted(owner, "$in")) return null;

    for (self.bindings.items) |binding| {
        if (@import("frontend").binding_path.rooted(owner, binding.name)) return null;
    }

    for (self.aliases) |alias| {
        if (!@import("frontend").binding_path.matches(owner, alias.name)) continue;

        const target = self.graph.types.get(alias.type_id);

        if (target != .enumeration) return null;

        for (target.enumeration.members) |member| {
            if (std.mem.eql(u8, member, name.text)) return try self.graph.known(alias.type_id, span);
        }

        return self.graph.reporter.fail(.name, self.sourceSpan(name.span), "unknown enum member");
    }

    return null;
}
