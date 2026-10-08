const zx = @import("zx");
const syntax = zx.syntax.borrow;
const ir = zx.ir;
const Analyzer = @import("analyzer.zig");
const Types = @import("types.zig");
const aggregates = @import("aggregates.zig");

pub fn analyze(self: *Analyzer, expression: anytype, target: ir.ExprId, kind: @FieldType(ir.Transform, "kind"), expected: ?ir.TypeId) zx.Error!ir.ExprId {
    const arguments = syntax.value(expression).call.arguments;
    const reducing = kind == .reduce;

    if (arguments.len < 1 or arguments.len > 2 or (reducing and arguments.len != 2)) return self.reporter.fail(.type_mismatch, expression.span, "collection operations require a callback and optional context; reduce requires a callback and initial value");
    if (syntax.value(syntax.item(arguments, 0)) != .lambda) return self.reporter.fail(.type_mismatch, syntax.item(arguments, 0).span, "collection callback must be an inline, non-capturing lambda");

    const lambda = syntax.value(syntax.item(arguments, 0)).lambda;
    const element_type = self.types.get(self.node(target).type_id).list;
    const initial = if (arguments.len == 2) try self.expression(syntax.item(arguments, 1), if (reducing) expected else null) else null;
    const initial_type = if (initial) |id| self.node(id).type_id else null;
    const parameter_count: usize = if (initial != null) 2 else 1;

    if (!reducing and initial_type != null and self.types.get(initial_type.?) == .task) return self.reporter.fail(.ownership, syntax.item(arguments, 1).span, "collection context cannot share a task handle across callbacks");
    if (lambda.parameters.len != parameter_count) return self.reporter.fail(.type_mismatch, syntax.item(arguments, 0).span, "callback parameter count does not match the collection operation");

    const previous_floor = self.scope_floor;
    const scope_start = self.active.items.len;

    self.scope_floor = scope_start;
    self.lambda_depth += 1;

    defer {
        self.active.shrinkRetainingCapacity(scope_start);

        self.scope_floor = previous_floor;
        self.lambda_depth -= 1;
    }

    const parameters = try self.allocator.alloc(ir.SymbolId, parameter_count);

    for (0..lambda.parameters.len) |index| {
        const parameter = syntax.item(lambda.parameters, index);
        const type_id = if (index == @as(usize, if (reducing) 0 else 1)) initial_type.? else element_type;

        parameters[index] = try self.bind(parameter, type_id, scope_start);

        self.symbols.ownership.items[@backingInt(parameters[index])] = if (try self.types.containsList(type_id)) .Borrowed else .Copy;
    }

    const hint = aggregates.payload(self, expected);

    const body_hint: ?ir.TypeId = switch (kind) {
        .filter, .every, .some => Types.scalarId(.bool),
        .reduce => initial_type,
        .map => if (hint != null and self.types.get(hint.?) == .list) self.types.get(hint.?).list else null,
    };

    const body = try self.expression(lambda.body, body_hint);

    const type_id = switch (kind) {
        .filter => self.node(target).type_id,
        .every, .some => Types.scalarId(.bool),
        .reduce => initial_type.?,
        .map => try self.types.wrap(.list, self.node(body).type_id),
    };

    return self.append(.{ .span = expression.span, .type_id = type_id, .value = .{ .transform = .{
        .kind = kind,
        .target = target,
        .parameters = parameters,
        .body = body,
        .initial = initial,
    } } });
}
