const zx = @import("zx");
const ir = zx.ir;
const Analyzer = @import("analyzer.zig");
const Types = @import("types.zig");
const aggregates = @import("aggregates.zig");

pub fn analyze(self: *Analyzer, expression: *const zx.ast.Expression, target: ir.ExprId, kind: @FieldType(ir.Transform, "kind"), expected: ?ir.TypeId) zx.Error!ir.ExprId {
    const arguments = expression.value.call.arguments;
    const reducing = kind == .reduce;

    if (arguments.len != @as(usize, if (reducing) 2 else 1)) return self.reporter.fail(.type_mismatch, expression.span, "map/filter/forEach require a callback; reduce requires a callback and initial value");
    if (arguments[0].value != .lambda) return self.reporter.fail(.type_mismatch, arguments[0].span, "collection callback must be an inline, non-capturing lambda");

    const lambda = arguments[0].value.lambda;
    const element_type = self.types.get(self.node(target).type_id).list;
    const initial = if (reducing) try self.expression(arguments[1], expected) else null;
    const initial_type = if (initial) |id| self.node(id).type_id else null;
    const parameter_count: usize = if (reducing) 2 else 1;

    if (lambda.parameters.len != parameter_count) return self.reporter.fail(.type_mismatch, arguments[0].span, "callback parameter count does not match the collection operation");

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

    for (lambda.parameters, 0..) |parameter, index| {
        const type_id = if (reducing and index == 0) initial_type.? else element_type;

        parameters[index] = try self.bind(parameter, type_id, scope_start);

        self.symbols.items[@intFromEnum(parameters[index])].ownership = if (self.types.containsList(type_id)) .borrowed else .copy;
    }

    const hint = aggregates.payload(self, expected);

    const body_hint: ?ir.TypeId = switch (kind) {
        .filter => Types.scalarId(.bool),
        .reduce => initial_type,
        .forEach => null,
        .map => if (hint != null and self.types.get(hint.?) == .list) self.types.get(hint.?).list else null,
    };

    const body = try self.expression(lambda.body, body_hint);

    const type_id = switch (kind) {
        .filter => self.node(target).type_id,
        .reduce => initial_type.?,
        .forEach => Types.scalarId(.void),
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
