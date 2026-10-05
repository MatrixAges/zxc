const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Analyzer = @import("../analyzer.zig");
const Types = @import("../types.zig");

pub fn analyze(self: *Analyzer, expression: *const zx.ast.Expression, expected: ?ir.TypeId) zx.Error!ir.ExprId {
    const arguments = expression.value.call.arguments;

    if (arguments.len != 2) return self.reporter.fail(.type_mismatch, expression.span, "loop requires an initial state and a rule literal");
    if (arguments[1].value != .object) return self.reporter.fail(.type_mismatch, arguments[1].span, "loop rules must be an inline literal");

    var condition: ?*const zx.ast.Expression = null;
    var step: ?*const zx.ast.Expression = null;
    var postcondition = false;

    for (arguments[1].value.object) |field| {
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

    if (condition == null or step == null) return self.reporter.fail(.type_mismatch, arguments[1].span, "loop requires while and exactly one next or do step");

    const initial = try self.expression(arguments[0], @import("../aggregates.zig").payload(self, expected));
    const type_id = self.node(initial).type_id;

    if (type_id == Types.scalarId(.void)) return self.reporter.fail(.type_mismatch, arguments[0].span, "loop state cannot be void");

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

fn callback(self: *Analyzer, source: *const zx.ast.Expression, type_id: ir.TypeId, updating: bool) zx.Error!Callback {
    if (source.value != .lambda or source.value.lambda.parameters.len != 1) return self.reporter.fail(.type_mismatch, source.span, "loop callbacks require one inline state parameter");

    const lambda = source.value.lambda;

    if (updating and lambda.body.value != .state_block) return self.reporter.fail(.type_mismatch, lambda.body.span, "loop next and do require a state update block");

    const start = self.active.items.len;
    const floor = self.scope_floor;

    self.scope_floor = start;
    self.lambda_depth += 1;

    defer {
        self.active.shrinkRetainingCapacity(start);

        self.scope_floor = floor;
        self.lambda_depth -= 1;
    }

    const parameter = try self.bind(lambda.parameters[0], type_id, start);

    self.symbols.items[@backingInt(parameter)].ownership = .borrowed;

    const body = if (updating)
        try @import("block.zig").analyze(self, lambda.body.value.state_block, parameter)
    else
        try self.expression(lambda.body, Types.scalarId(.bool));

    return .{ .parameter = parameter, .body = body };
}
