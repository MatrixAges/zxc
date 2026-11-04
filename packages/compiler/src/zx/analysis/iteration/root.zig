const std = @import("std");
const zx = @import("zx");
const syntax = zx.syntax.borrow;
const ir = zx.ir;
const Analyzer = @import("../analyzer.zig");
const Types = @import("../types.zig");

pub fn analyze(self: *Analyzer, expression: anytype, expected: ?ir.TypeId) zx.Error!ir.ExprId {
    const arguments = syntax.value(expression).call.arguments;

    if (arguments.len != 2 and arguments.len != 3) return self.reporter.fail(.type_mismatch, expression.span, "loop requires an initial state and a rule literal");

    const rules = syntax.item(arguments, 1);
    const rule_value = syntax.value(rules);

    if (rule_value != .object) return self.reporter.fail(.type_mismatch, rules.span, "loop rules must be an inline literal");

    const fields = rule_value.object;
    var condition: ?@TypeOf(expression) = null;
    var step: ?@TypeOf(expression) = null;
    var postcondition = false;

    for (0..fields.len) |index| {
        const field = syntax.item(fields, index);

        if (field.spread) return self.reporter.fail(.type_mismatch, field.value.span, "loop rules cannot use spread");

        if (std.mem.eql(u8, field.name.text, "while")) {
            if (condition != null) return self.reporter.fail(.name, field.name.span, "duplicate loop condition");

            condition = field.value;
        } else if (std.mem.eql(u8, field.name.text, "next") or std.mem.eql(u8, field.name.text, "do")) {
            if (step != null) return self.reporter.fail(.name, field.name.span, "loop requires exactly one next or do step");

            step = field.value;
            postcondition = std.mem.eql(u8, field.name.text, "do");
        } else return self.reporter.fail(.name, field.name.span, "unknown loop rule; expected while and next or do");
    }

    if (condition == null or step == null) return self.reporter.fail(.type_mismatch, rules.span, "loop requires while and exactly one next or do step");

    const initial_value = try self.expression(syntax.item(arguments, 0), @import("../aggregates.zig").payload(self, expected));
    const type_id = self.node(initial_value).type_id;

    if (type_id == Types.scalarId(.void)) return self.reporter.fail(.type_mismatch, syntax.item(arguments, 0).span, "loop state cannot be void");

    const readonly_value = if (arguments.len == 3) try self.expression(syntax.item(arguments, 2), null) else null;

    if (readonly_value) |value| if (self.node(value).type_id == Types.scalarId(.void)) return self.reporter.fail(.type_mismatch, syntax.item(arguments, 2).span, "loop context cannot be void");

    const saved_initial = if (readonly_value != null) try save(self, initial_value, "loop_initial") else null;
    const saved_context = if (readonly_value) |value| try save(self, value, "loop_context") else null;
    const context = if (saved_context) |saved| saved.reference else null;
    const predicate = try callback(self, condition.?, type_id, false, context);
    const next = try callback(self, step.?, type_id, true, context);

    const result = try self.append(.{ .span = expression.span, .type_id = type_id, .value = .{ .iteration = .{
        .initial = if (saved_initial) |saved| saved.reference else initial_value,
        .condition_parameter = predicate.parameter,
        .parameter = next.parameter,
        .environment_symbol = if (saved_context) |saved| saved.symbol else null,
        .condition = predicate.body,
        .body = next.body,
        .postcondition = postcondition,
    } } });

    if (saved_context) |saved| return self.append(.{ .span = expression.span, .type_id = type_id, .value = .{ .scope = .{
        .bindings = try self.allocator.dupe(ir.ScopeBinding, &.{ .{ .symbol = saved_initial.?.symbol, .value = initial_value }, .{ .symbol = saved.symbol, .value = readonly_value.? } }),
        .result = result,
    } } });

    return result;
}

const Callback = struct { parameter: ir.SymbolId, body: ir.ExprId };
const Saved = struct { symbol: ir.SymbolId, reference: ir.ExprId };

fn save(self: *Analyzer, value: ir.ExprId, name: []const u8) zx.Error!Saved {
    const node = self.node(value);
    const symbol: ir.SymbolId = @fromBackingInt(@intCast(self.symbols.count()));

    try self.symbols.append(self.allocator, .{ .name = name, .type_id = node.type_id, .span = node.span });

    return .{ .symbol = symbol, .reference = try self.append(.{ .span = node.span, .type_id = node.type_id, .value = .{ .reference = symbol } }) };
}

fn callback(self: *Analyzer, source: anytype, type_id: ir.TypeId, updating: bool, context: ?ir.ExprId) zx.Error!Callback {
    const message = if (context != null) "loop callbacks require a state parameter and at most one context parameter" else "loop callbacks require one inline state parameter";

    if (syntax.value(source) != .lambda) return self.reporter.fail(.type_mismatch, source.span, message);

    const lambda = syntax.value(source).lambda;

    if (lambda.parameters.len != 1 and !(context != null and lambda.parameters.len == 2)) return self.reporter.fail(.type_mismatch, source.span, message);
    if (updating and syntax.value(lambda.body) != .state_block) return self.reporter.fail(.type_mismatch, lambda.body.span, "loop next and do require a state update block");

    const start = self.active.items.len;
    const floor = self.scope_floor;
    const captures = self.collection_captures;

    self.collection_captures = null;
    self.scope_floor = start;
    self.lambda_depth += 1;

    defer {
        self.active.shrinkRetainingCapacity(start);

        self.scope_floor = floor;
        self.collection_captures = captures;
        self.lambda_depth -= 1;
    }

    const parameter = try self.bind(syntax.item(lambda.parameters, 0), type_id, start);

    self.symbols.ownership.items[@backingInt(parameter)] = .Borrowed;

    const readonly_parameter = if (lambda.parameters.len == 2) try self.bind(syntax.item(lambda.parameters, 1), self.node(context.?).type_id, start) else null;

    if (readonly_parameter) |id| self.symbols.ownership.items[@backingInt(id)] = .Borrowed;

    const body = if (updating)
        try @import("block.zig").analyze(self, syntax.value(lambda.body).state_block, parameter)
    else
        try self.expression(lambda.body, Types.scalarId(.bool));

    return .{ .parameter = parameter, .body = if (readonly_parameter) |id| try self.append(.{ .span = self.node(body).span, .type_id = self.node(body).type_id, .value = .{ .scope = .{
        .bindings = try self.allocator.dupe(ir.ScopeBinding, &.{.{ .symbol = id, .value = context.? }}),
        .result = body,
    } } }) else body };
}
