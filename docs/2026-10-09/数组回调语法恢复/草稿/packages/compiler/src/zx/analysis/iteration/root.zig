const std = @import("std");
const zx = @import("zx");
const syntax = zx.syntax.borrow;
const ir = zx.ir;
const Analyzer = @import("../analyzer.zig");
const Types = @import("../types.zig");

pub fn analyze(self: *Analyzer, expression: anytype, expected: ?ir.TypeId) zx.Error!ir.ExprId {
    const arguments = syntax.value(expression).call.arguments;

    if (arguments.len != 2) return self.reporter.fail(.type_mismatch, expression.span, "loop requires an initial state and a rule literal");

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

    const initial = try self.expression(syntax.item(arguments, 0), @import("../aggregates.zig").payload(self, expected));
    const type_id = self.node(initial).type_id;

    if (type_id == Types.scalarId(.void)) return self.reporter.fail(.type_mismatch, syntax.item(arguments, 0).span, "loop state cannot be void");

    const predicate = try callback(self, condition.?, type_id, false);
    const next = try callback(self, step.?, type_id, true);

    return self.append(.{ .span = expression.span, .type_id = type_id, .value = .{ .iteration = .{
        .initial = initial,
        .condition_parameter = predicate.parameter,
        .parameter = next.parameter,
        .condition = predicate.body,
        .body = next.body,
        .postcondition = postcondition,
    } } });
}

const Callback = struct { parameter: ir.SymbolId, body: ir.ExprId };

fn callback(self: *Analyzer, source: anytype, type_id: ir.TypeId, updating: bool) zx.Error!Callback {
    if (syntax.value(source) != .lambda or syntax.value(source).lambda.parameters.len != 1) return self.reporter.fail(.type_mismatch, source.span, "loop callbacks require one inline state parameter");

    const lambda = syntax.value(source).lambda;

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

    const body = if (updating)
        try @import("block.zig").analyze(self, syntax.value(lambda.body).state_block, parameter)
    else
        try self.expression(lambda.body, Types.scalarId(.bool));

    return .{ .parameter = parameter, .body = body };
}
