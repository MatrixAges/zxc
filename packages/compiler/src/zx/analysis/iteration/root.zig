const std = @import("std");
const zx = @import("zx");
const syntax = zx.syntax.borrow;
const ir = zx.ir;
const Analyzer = @import("../analyzer.zig");
const Types = @import("../types.zig");
const Captures = @import("../collections/captures.zig");
const Builder = @import("../collections/builder.zig");

pub fn analyze(self: *Analyzer, expression: anytype, expected: ?ir.TypeId) zx.Error!ir.ExprId {
    const arguments = syntax.value(expression).call.arguments;

    if (arguments.len != 2) return self.reporter.fail(.type_mismatch, expression.span, "loop requires an initial state and a rule literal");

    const rules = syntax.item(arguments, 1);
    const rule_value = syntax.value(rules);

    if (rule_value != .object) return self.reporter.fail(.type_mismatch, rules.span, "loop rules must be an inline literal");

    const fields = rule_value.object;
    var condition: ?@TypeOf(expression) = null;
    var step: ?@TypeOf(expression) = null;
    var output: ?@TypeOf(expression) = null;
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
        } else if (std.mem.eql(u8, field.name.text, "return")) {
            if (output != null) return self.reporter.fail(.name, field.name.span, "duplicate loop return");
            if (step == null) return self.reporter.fail(.name, field.name.span, "loop return must follow next or do");

            output = field.value;
        } else return self.reporter.fail(.name, field.name.span, "unknown loop rule; expected while, next or do, and optional return");
    }

    if (condition == null or step == null) return self.reporter.fail(.type_mismatch, rules.span, "loop requires while and exactly one next or do step");

    const initial_value = try self.expression(syntax.item(arguments, 0), if (output != null) null else @import("../aggregates.zig").payload(self, expected));
    const type_id = self.node(initial_value).type_id;

    if (type_id == Types.scalarId(.void)) return self.reporter.fail(.type_mismatch, syntax.item(arguments, 0).span, "loop state cannot be void");

    var predicate = try callback(self, condition.?, type_id, false, Types.scalarId(.bool));
    var next = try callback(self, step.?, type_id, true, null);
    var selected = if (output) |source| try callback(self, source, type_id, false, expected) else null;
    const builder = Builder{ .analyzer = self, .span = expression.span };
    var shared: std.ArrayList(Captures.Binding) = .empty;

    for ([_][]const Captures.Binding{ predicate.captures, next.captures, if (selected) |item| item.captures else &.{} }) |bindings| {
        for (bindings) |binding| {
            for (shared.items) |present| {
                if (present.source == binding.source and self.node(present.value).type_id == self.node(binding.value).type_id) break;
            } else try shared.append(self.allocator, binding);
        }
    }

    const lexical = if (shared.items.len != 0) lexical: {
        const values = try self.allocator.alloc(ir.ExprId, shared.items.len);

        for (values, shared.items) |*value, binding| value.* = binding.value;

        const environment = if (values.len == 1) values[0] else try builder.tuple(values);

        break :lexical .{ .value = environment, .saved = try save(self, environment, "loop_scope") };
    } else null;

    const saved_initial = if (lexical != null) try save(self, initial_value, "loop_initial") else null;

    if (lexical) |scope| {
        predicate.body = try bindScope(self, builder, predicate, shared.items, scope.saved.reference);
        next.body = try bindScope(self, builder, next, shared.items, scope.saved.reference);

        if (selected) |*item| item.body = try bindScope(self, builder, item.*, shared.items, scope.saved.reference);
    }

    const result = try self.append(.{ .span = expression.span, .type_id = type_id, .value = .{ .iteration = .{
        .initial = if (saved_initial) |saved| saved.reference else initial_value,
        .condition_parameter = predicate.parameter,
        .parameter = next.parameter,
        .environment_symbol = if (lexical) |scope| scope.saved.symbol else null,
        .condition = predicate.body,
        .body = next.body,
        .postcondition = postcondition,
    } } });

    const projected = if (selected) |projection| try self.append(.{
        .span = expression.span,
        .type_id = self.node(projection.body).type_id,
        .value = .{ .scope = .{
            .bindings = try self.allocator.dupe(ir.ScopeBinding, &.{.{ .symbol = projection.parameter, .value = result }}),
            .result = projection.body,
        } },
    }) else result;

    if (lexical) |scope| return builder.expression(self.node(projected).type_id, .{ .scope = .{
        .bindings = try self.allocator.dupe(ir.ScopeBinding, &.{ .{ .symbol = saved_initial.?.symbol, .value = initial_value }, .{ .symbol = scope.saved.symbol, .value = scope.value, .borrow = true } }),
        .result = projected,
    } });

    return projected;
}

const Callback = struct { parameter: ir.SymbolId, body: ir.ExprId, captures: []const Captures.Binding };
const Saved = struct { symbol: ir.SymbolId, reference: ir.ExprId };

fn save(self: *Analyzer, value: ir.ExprId, name: []const u8) zx.Error!Saved {
    const node = self.node(value);
    const symbol: ir.SymbolId = @fromBackingInt(@intCast(self.symbols.count()));

    try self.symbols.append(self.allocator, .{ .name = name, .type_id = node.type_id, .span = node.span });

    return .{ .symbol = symbol, .reference = try self.append(.{ .span = node.span, .type_id = node.type_id, .value = .{ .reference = symbol } }) };
}

fn callback(self: *Analyzer, source: anytype, type_id: ir.TypeId, updating: bool, expected: ?ir.TypeId) zx.Error!Callback {
    const message = "loop callbacks require one inline state parameter";

    if (syntax.value(source) != .lambda) return self.reporter.fail(.type_mismatch, source.span, message);

    const lambda = syntax.value(source).lambda;

    if (lambda.parameters.len != 1) return self.reporter.fail(.type_mismatch, source.span, message);
    if (updating and syntax.value(lambda.body) != .state_block) return self.reporter.fail(.type_mismatch, lambda.body.span, "loop next and do require a state update block");

    const start = self.active.items.len;
    const floor = self.scope_floor;
    const captures = self.collection_captures;
    var lexical = Captures{ .start = start, .floor = floor, .parent = captures };

    self.collection_captures = &lexical;
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
        try self.expression(lambda.body, expected);

    return .{ .parameter = parameter, .captures = lexical.bindings.items, .body = body };
}

fn bindScope(self: *Analyzer, builder: Builder, callback_value: Callback, shared: []const Captures.Binding, context: ir.ExprId) zx.Error!ir.ExprId {
    if (callback_value.captures.len == 0) return callback_value.body;

    const bindings = try self.allocator.alloc(ir.ScopeBinding, callback_value.captures.len);

    for (bindings, callback_value.captures) |*binding, capture| {
        for (shared, 0..) |source, index| {
            if (source.source != capture.source or self.node(source.value).type_id != self.node(capture.value).type_id) continue;

            binding.* = .{
                .symbol = capture.target,
                .value = if (shared.len == 1) context else try builder.expression(self.node(capture.value).type_id, .{ .tuple_field = .{ .target = context, .index = @intCast(index) } }),
                .borrow = true,
            };

            break;
        } else unreachable;
    }

    return builder.expression(self.node(callback_value.body).type_id, .{ .scope = .{ .bindings = bindings, .result = callback_value.body } });
}
