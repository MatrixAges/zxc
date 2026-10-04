const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const terms = @import("terms.zig");
const Expressions = @import("expressions.zig");
const Value = terms.Value;
const Self = @This();
const Graph = @import("graph.zig");

allocator: std.mem.Allocator,
program: ir.Program,
reporter: *zx.Reporter,
declarations: std.ArrayList([]const u8) = .empty,
violations: std.ArrayList([]const u8) = .empty,
input: Value = undefined,
next_input: usize = 0,
inputs: std.ArrayList(Input) = .empty,
returns: std.ArrayList(Return) = .empty,
call_depth: usize = 0,

graph: ?*Graph = null,
const Return = struct { path: []const u8, value: Value };

pub const Input = struct { symbol: []const u8, path: []const u8, type_id: ir.TypeId };
pub const Query = struct { feasibility: []const u8, correctness: []const u8, inputs: []const Input };
pub const Model = struct { inputs: []const Input, output: terms.Evaluation, definitions: []const Graph.Definition };

pub fn model(self: *Self) zx.Error!Model {
    if (self.program.type_only or self.program.stores.len != 0) return self.reporter.fail(.unsupported, .{ .start = 0, .end = 0 }, "symbolic execution requires a pure executable function without Store capabilities");

    self.input = try self.parameter(self.program.input_type, "in");

    const output = try self.call();

    return .{ .inputs = self.inputs.items, .output = output, .definitions = self.graph.?.definitions.items };
}

pub fn generate(self: *Self) zx.Error!Query {
    try self.ensureGraph();
    if (self.program.type_only or self.program.stores.len != 0) return self.reporter.fail(.unsupported, .{ .start = 0, .end = 0 }, "verification requires an executable pure function without Store capabilities");

    self.input = try self.parameter(self.program.input_type, "in");

    var precondition: []const u8 = "true";

    for (self.program.contracts) |contract| {
        if (contract.kind != .requires) continue;

        const evaluated = try self.evaluateContract(contract, null);

        try self.require(precondition, evaluated.safe);

        precondition = try self.conjunction(precondition, try self.conjunction(evaluated.safe, evaluated.value.scalar));
    }

    const environment = try self.allocator.alloc(?Value, self.program.symbols.len);

    @memset(environment, null);

    environment[0] = self.input;

    const remaining = try self.block(self.program.body, environment, precondition);

    if (self.program.typeOf(self.program.output_type) == .scalar and self.program.typeOf(self.program.output_type).scalar == .void) {
        try self.postconditions(remaining, .{ .fields = &.{} });
    }

    const declarations = try std.fmt.allocPrint(self.allocator, "{s}\n{s}", .{ try std.mem.join(self.allocator, "\n", self.declarations.items), try self.graph.?.declarations() });
    const failures = if (self.violations.items.len == 0) "false" else try std.fmt.allocPrint(self.allocator, "(or {s})", .{try std.mem.join(self.allocator, " ", self.violations.items)});
    const header = "(set-logic QF_BV)\n(set-option :produce-models true)\n(set-option :timeout 10000)\n";

    return .{
        .feasibility = try std.fmt.allocPrint(self.allocator, "{s}{s}\n(assert {s})\n(check-sat)\n", .{ header, declarations, precondition }),
        .correctness = try std.fmt.allocPrint(self.allocator, "{s}{s}\n(assert {s})\n(check-sat)\n", .{ header, declarations, failures }),
        .inputs = self.inputs.items,
    };
}

fn parameter(self: *Self, type_id: ir.TypeId, path: []const u8) zx.Error!Value {
    const target = self.program.typeOf(type_id);

    if (target == .object or target == .tuple) {
        const count = if (target == .object) target.object.len else target.tuple.len;
        const fields = try self.allocator.alloc(Value, count);

        for (fields, 0..) |*field, index| {
            const child_path = if (target == .object) try std.fmt.allocPrint(self.allocator, "{s}.{s}", .{ path, target.object[index].name }) else try std.fmt.allocPrint(self.allocator, "{s}[{d}]", .{ path, index });

            field.* = try self.parameter(if (target == .object) target.object[index].type_id else target.tuple[index], child_path);
        }

        return .{ .fields = fields };
    }

    if (target == .scalar and target.scalar == .void) return .{ .fields = &.{} };

    const sort = if (terms.integer(target)) |integer| try std.fmt.allocPrint(self.allocator, "(_ BitVec {d})", .{integer.width}) else if (target == .enumeration) try std.fmt.allocPrint(self.allocator, "(_ BitVec {d})", .{terms.enumWidth(target)}) else if (target == .scalar and target.scalar == .bool) "Bool" else return self.reporter.fail(.unsupported, .{ .start = 0, .end = 0 }, "verification currently supports boolean, enum and fixed-width integer inputs with static objects or tuples");
    const name = try std.fmt.allocPrint(self.allocator, "input_{d}", .{self.next_input});

    self.next_input += 1;

    try self.declarations.append(self.allocator, try std.fmt.allocPrint(self.allocator, "(declare-fun {s} () {s})", .{ name, sort }));

    if (target == .enumeration) {
        const maximum = try terms.constant(self.allocator, target.enumeration.members.len - 1, terms.enumWidth(target));

        try self.declarations.append(self.allocator, try std.fmt.allocPrint(self.allocator, "(assert (bvule {s} {s}))", .{ name, maximum }));
    }

    try self.inputs.append(self.allocator, .{ .symbol = name, .path = path, .type_id = type_id });

    return .{ .scalar = name };
}

fn block(self: *Self, statements: []const ir.Statement, environment: []?Value, initial: []const u8) zx.Error![]const u8 {
    var path = initial;
    var evaluator = Expressions{ .allocator = self.allocator, .program = self.program, .environment = environment, .graph = self.graph.?, .reporter = self.reporter, .call_depth = self.call_depth };

    for (statements) |statement| {
        switch (statement) {
            .evaluate => |id| {
                const value = try evaluator.evaluate(id);

                try self.require(path, value.safe);

                path = try self.conjunction(path, value.safe);
            },
            .constant => |binding| {
                const value = try evaluator.evaluate(binding.value);

                try self.require(path, value.safe);

                path = try self.conjunction(path, value.safe);

                environment[@intFromEnum(binding.symbol)] = value.value;
            },
            .destructure => |binding| {
                const value = try evaluator.evaluate(binding.value);

                try self.require(path, value.safe);

                path = try self.conjunction(path, value.safe);

                for (binding.symbols, value.value.fields) |symbol, field| {
                    if (symbol) |id| environment[@intFromEnum(id)] = field;
                }
            },
            .result => |result| {
                const value = if (result) |id| try evaluator.evaluate(id) else terms.Evaluation{ .value = .{ .fields = &.{} } };

                try self.require(path, value.safe);
                try self.postconditions(try self.conjunction(path, value.safe), value.value);
                try self.returns.append(self.allocator, .{ .path = try self.conjunction(path, value.safe), .value = value.value });

                return "false";
            },
            .branch => |branch| {
                const condition = try evaluator.evaluate(branch.condition);

                try self.require(path, condition.safe);

                path = try self.conjunction(path, condition.safe);
                const yes = try self.block(branch.yes, try self.allocator.dupe(?Value, environment), try self.conjunction(path, condition.value.scalar));
                const no = try self.block(branch.no, try self.allocator.dupe(?Value, environment), try self.conjunction(path, try terms.unary(self.allocator, "not", condition.value.scalar)));

                path = try self.disjunction(yes, no);
            },
            .switch_stmt => |selection| {
                const subject = try evaluator.evaluate(selection.subject);

                try self.require(path, subject.safe);

                path = try self.conjunction(path, subject.safe);
                var unmatched: []const u8 = "true";
                var continuation: []const u8 = "false";
                var fallback: ?[]const ir.Statement = null;

                for (selection.cases) |case| {
                    if (case.value) |id| {
                        const label = try evaluator.evaluate(id);
                        const matches = try terms.binary(self.allocator, "=", subject.value.scalar, label.value.scalar);
                        const remaining = try self.block(case.body, try self.allocator.dupe(?Value, environment), try self.conjunction(path, matches));

                        continuation = try self.disjunction(continuation, remaining);
                        unmatched = try self.conjunction(unmatched, try terms.unary(self.allocator, "not", matches));
                    } else fallback = case.body;
                }

                const default_path = try self.conjunction(path, unmatched);
                const remaining = if (fallback) |body| try self.block(body, try self.allocator.dupe(?Value, environment), default_path) else default_path;

                path = try self.disjunction(continuation, remaining);
            },
            .parallel => |invocations| path = try self.parallel(&evaluator, invocations, path),
            else => return self.reporter.fail(.unsupported, .{ .start = 0, .end = 0 }, "verification does not yet model this statement"),
        }
    }

    return path;
}

fn parallel(self: *Self, evaluator: *Expressions, invocations: []const ir.ParallelCall, initial: []const u8) zx.Error![]const u8 {
    var parameter_path = initial;

    for (invocations) |invocation| {
        const argument = self.program.expression(invocation.value).value.call.argument;
        const value = try evaluator.evaluate(argument);

        try self.require(parameter_path, value.safe);

        parameter_path = try self.conjunction(parameter_path, value.safe);
    }

    const launch_path = parameter_path;
    var joined_path = launch_path;
    const values = try self.allocator.alloc(terms.Evaluation, invocations.len);

    defer self.allocator.free(values);

    for (invocations, values) |invocation, *value| {
        value.* = try evaluator.evaluate(invocation.value);

        try self.require(launch_path, value.safe);

        joined_path = try self.conjunction(joined_path, value.safe);
    }

    for (invocations, values) |invocation, value| {
        if (invocation.symbol) |symbol| evaluator.environment[@intFromEnum(symbol)] = value.value;
    }

    return joined_path;
}

fn evaluateContract(self: *Self, clause: ir.Contract, output: ?Value) zx.Error!terms.Evaluation {
    const environment = try self.allocator.alloc(?Value, clause.symbols.len);

    environment[0] = self.input;

    if (clause.kind == .ensures) environment[1] = output;

    var view = self.program;

    view.symbols = clause.symbols;
    view.expressions = clause.expressions;

    var evaluator = Expressions{ .allocator = self.allocator, .program = view, .environment = environment, .graph = self.graph.?, .reporter = self.reporter };

    return evaluator.evaluate(clause.predicate);
}

fn postconditions(self: *Self, path: []const u8, value: Value) zx.Error!void {
    var remaining = path;

    for (self.program.contracts) |clause| {
        if (clause.kind != .ensures) continue;

        const evaluated = try self.evaluateContract(clause, value);
        const valid = try self.conjunction(evaluated.safe, evaluated.value.scalar);

        try self.require(remaining, valid);

        remaining = try self.conjunction(remaining, valid);
    }
}

fn require(self: *Self, path: []const u8, predicate: []const u8) zx.Error!void {
    const condition = try self.conjunction(path, try terms.unary(self.allocator, "not", predicate));

    try self.violations.append(self.allocator, condition);
}

fn conjunction(self: *Self, left: []const u8, right: []const u8) zx.Error![]const u8 {
    return self.boolean(try terms.binary(self.allocator, "and", left, right));
}

fn disjunction(self: *Self, left: []const u8, right: []const u8) zx.Error![]const u8 {
    return self.boolean(try terms.binary(self.allocator, "or", left, right));
}

fn boolean(self: *Self, value: []const u8) zx.Error![]const u8 {
    return self.graph.?.bind(value, 0, .{ .file_name = self.program.file_name, .span = .{ .start = 0, .end = 0 } });
}

fn ensureGraph(self: *Self) zx.Error!void {
    if (self.graph != null) return;

    const graph = try self.allocator.create(Graph);
    graph.* = .{ .allocator = self.allocator, .reporter = self.reporter };
    self.graph = graph;
}

pub fn call(self: *Self) zx.Error!terms.Evaluation {
    try self.ensureGraph();

    var path: []const u8 = "true";

    for (self.program.contracts) |contract| {
        if (contract.kind != .requires) continue;

        const evaluated = try self.evaluateContract(contract, null);
        const valid = try self.conjunction(evaluated.safe, evaluated.value.scalar);

        try self.require(path, valid);

        path = try self.conjunction(path, valid);
    }

    const environment = try self.allocator.alloc(?Value, self.program.symbols.len);

    @memset(environment, null);

    environment[0] = self.input;

    const remaining = try self.block(self.program.body, environment, path);

    if (self.program.typeOf(self.program.output_type) == .scalar and self.program.typeOf(self.program.output_type).scalar == .void) {
        const unit = Value{ .fields = &.{} };

        try self.postconditions(remaining, unit);
        try self.returns.append(self.allocator, .{ .path = remaining, .value = unit });
    }

    if (self.returns.items.len == 0) return self.reporter.fail(.contract, .{ .start = 0, .end = 0 }, "verified call has no return value");

    var value = self.returns.items[0].value;
    var returned: []const u8 = "false";
    var safe: []const u8 = "true";

    for (self.returns.items) |result| {
        value = try self.graph.?.value(self.program, self.program.output_type, try terms.select(self.allocator, result.path, result.value, value), .{ .start = 0, .end = 0 });
        returned = try self.disjunction(returned, result.path);
    }

    for (self.violations.items) |violation| safe = try self.conjunction(safe, try terms.unary(self.allocator, "not", violation));

    return .{ .value = value, .safe = try self.conjunction(safe, returned) };
}
