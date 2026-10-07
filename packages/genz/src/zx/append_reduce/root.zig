const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const aggregate = @import("../aggregate.zig");
const intrinsic = @import("../intrinsics.zig");
const Self = @This();

lowering: *Lower,
transform: ir.Transform,
dependencies: []const bool,
has_append: bool = false,
buffer: *const node.Expression = undefined,
started: *const node.Expression = undefined,
initial: *const node.Expression = undefined,
pub fn lower(lowering: *Lower, transform: ir.Transform) Lower.Error!?*const node.Expression {
    if (transform.kind != .reduce or lowering.program.typeOf(lowering.program.expression(transform.body).type_id) != .list) return null;

    const dependencies = try @import("dependencies.zig").analyze(lowering.allocator, lowering.program.expressions, transform.parameters[0]);

    defer lowering.allocator.free(dependencies);

    var self = Self{ .lowering = lowering, .transform = transform, .dependencies = dependencies };

    if (!self.matches(transform.body) or !self.has_append) return null;

    var body: std.ArrayList(node.Statement) = .empty;
    const source = try aggregate.bind(lowering, &body, try lowering.expr(transform.target));
    self.initial = try aggregate.bind(lowering, &body, try lowering.expr(transform.initial.?));

    const name = try lowering.fresh("append_items");
    const started_name = try lowering.fresh("append_started");
    const child = lowering.program.typeOf(lowering.program.expression(transform.body).type_id).list;
    const buffer_type = try lowering.call(try lowering.field(try lowering.builder.identifier("std"), "ArrayList"), &.{lowering.types[@intFromEnum(child)]}, false);
    self.buffer = try lowering.builder.identifier(name);
    self.started = try lowering.builder.identifier(started_name);

    try body.append(lowering.allocator, .{ .variable = .{ .name = name, .type_expr = buffer_type, .value = try lowering.builder.expression(.{ .enum_literal = "empty" }) } });
    try body.append(lowering.allocator, .{ .variable = .{ .name = started_name, .value = try lowering.builder.expression(.{ .boolean = false }) } });
    try body.append(lowering.allocator, .{ .defer_expression = try self.method("deinit", &.{}, false) });

    const loop = try self.statements(transform.body);
    const element = transform.parameters[1];

    try body.append(lowering.allocator, .{ .for_loop = .{ .iterable = source, .capture = if (lowering.used[@intFromEnum(element)]) lowering.names[@intFromEnum(element)] else "_", .body = loop } });

    const result = try lowering.builder.expression(.{ .conditional = .{ .condition = self.started, .yes = try self.method("toOwnedSlice", &.{}, true), .no = self.initial } });

    return try aggregate.finish(lowering, &body, result);
}

fn matches(self: *Self, id: ir.ExprId) bool {
    return switch (self.lowering.program.expression(id).value) {
        .reference => |symbol| symbol == self.transform.parameters[0],
        .conditional => |value| !self.dependencies[@intFromEnum(value.condition)] and self.matches(value.yes) and self.matches(value.no),
        .match_expr => |selection| blk: {
            if (selection.subject) |subject| if (self.dependencies[@backingInt(subject)]) break :blk false;

            for (0..selection.arms.len) |index| {
                const arm = selection.arms.at(index);

                if (self.dependencies[@backingInt(arm.condition)] or !self.matches(arm.result)) break :blk false;
            }

            break :blk self.matches(selection.fallback);
        },
        .tuple_field => |projection| blk: {
            if (projection.index != 0) break :blk false;

            const value = self.lowering.program.expression(projection.target).value;

            if (value != .list_operation) break :blk false;

            const operation = value.list_operation;
            const target = self.lowering.program.expression(operation.target).value;
            const eligible = (operation.kind == .push or operation.kind == .concat) and target == .reference and target.reference == self.transform.parameters[0] and !self.dependencies[@intFromEnum(operation.arguments[0])];

            if (eligible) self.has_append = true;

            break :blk eligible;
        },
        else => false,
    };
}

fn statements(self: Self, id: ir.ExprId) Lower.Error![]const node.Statement {
    const lowering = self.lowering;
    var body: std.ArrayList(node.Statement) = .empty;

    switch (lowering.program.expression(id).value) {
        .reference => {},
        .conditional => |value| try body.append(lowering.allocator, .{ .branch = .{ .condition = try lowering.expr(value.condition), .yes = try self.statements(value.yes), .no = try self.statements(value.no) } }),
        .match_expr => |selection| return self.matchStatements(selection),
        .tuple_field => |projection| {
            const operation = lowering.program.expression(projection.target).value.list_operation;
            const argument = try aggregate.bind(lowering, &body, try lowering.expr(operation.arguments[0]));
            const current = try lowering.builder.expression(.{ .conditional = .{ .condition = self.started, .yes = try lowering.field(self.buffer, "items"), .no = self.initial } });
            const added = if (operation.kind == .push) try lowering.builder.integer(1) else try lowering.field(argument, "len");
            const length = try intrinsic.standard(lowering, &.{ "math", "add" }, &.{ try lowering.builder.expression(.{ .primitive = .usize }), try lowering.field(current, "len"), added }, true);

            try body.append(lowering.allocator, .{ .discard = length });

            try body.append(lowering.allocator, .{ .branch = .{ .condition = try lowering.builder.expression(.{ .unary = .{ .operator = .not, .operand = self.started } }), .yes = try lowering.allocator.dupe(node.Statement, &.{
                .{ .expression = try self.method("appendSlice", &.{self.initial}, true) },
                .{ .assignment = .{ .target = self.started, .value = try lowering.builder.expression(.{ .boolean = true }) } },
            }), .no = &.{} } });

            try body.append(lowering.allocator, .{ .expression = try self.method(if (operation.kind == .push) "append" else "appendSlice", &.{argument}, true) });
        },
        else => unreachable,
    }

    return body.toOwnedSlice(lowering.allocator);
}

fn matchStatements(self: Self, selection: ir.MatchRow) Lower.Error![]const node.Statement {
    const lowering = self.lowering;
    var body: std.ArrayList(node.Statement) = .empty;
    const previous = if (selection.subject) |subject| lowering.cache.get(subject) else null;

    if (selection.subject) |subject| {
        const saved = try aggregate.bind(lowering, &body, try lowering.expr(subject));

        try lowering.cache.put(lowering.allocator, subject, saved);
        if (selection.arms.len == 0) try body.append(lowering.allocator, .{ .discard = saved });
    }

    defer {
        if (selection.subject) |subject| {
            if (previous) |value| lowering.cache.put(lowering.allocator, subject, value) catch unreachable else _ = lowering.cache.remove(subject);
        }
    }

    var tail = try self.statements(selection.fallback);
    var index = selection.arms.len;

    while (index > 0) {
        index -= 1;
        const arm = selection.arms.at(index);

        const condition = if (selection.subject) |subject|
            try lowering.binary(.{ .operator = .equal, .left = subject, .right = arm.condition })

        else
            try lowering.expr(arm.condition);

        tail = try lowering.allocator.dupe(node.Statement, &.{.{ .branch = .{ .condition = condition, .yes = try self.statements(arm.result), .no = tail } }});
    }

    try body.appendSlice(lowering.allocator, tail);

    return body.toOwnedSlice(lowering.allocator);
}

fn method(self: Self, name: []const u8, arguments: []const *const node.Expression, fallible: bool) Lower.Error!*const node.Expression {
    const values = try self.lowering.allocator.alloc(*const node.Expression, arguments.len + 1);

    values[0] = try self.lowering.builder.identifier("allocator");

    @memcpy(values[1..], arguments);

    return self.lowering.call(try self.lowering.field(self.buffer, name), values, fallible);
}
