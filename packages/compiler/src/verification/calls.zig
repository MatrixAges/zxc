const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const terms = @import("terms.zig");
const Expressions = @import("expressions.zig");
const Conditions = @import("conditions.zig");

pub fn evaluate(self: *Expressions, expression: ir.Expression) zx.Error!terms.Evaluation {
    const invocation = expression.value.call;
    const function = self.program.functions[@intFromEnum(invocation.function)];

    if (function.external != null) return self.reporter.fail(.unsupported, expression.span, "verification requires a ZX body for each executed call; external semantics are not modeled");
    if (self.call_depth >= 128) return self.reporter.fail(.unsupported, expression.span, "verification call depth exceeds 128");

    const argument = try self.evaluate(invocation.argument);
    const argument_key = try std.json.Stringify.valueAlloc(self.allocator, argument.value, .{});
    const key = try std.fmt.allocPrint(self.allocator, "{d}:{s}", .{ @intFromEnum(invocation.function), argument_key });

    if (self.graph.calls.get(key)) |result| return .{ .value = result.value, .safe = try terms.binary(self.allocator, "and", argument.safe, result.safe) };

    var program = self.program;

    program.input_type = function.input_type;
    program.output_type = function.output_type;
    program.symbols = function.symbols;
    program.expressions = function.expressions;
    program.body = function.body;
    program.contracts = function.contracts;
    program.stores = &.{};
    program.file_name = function.file_name;

    var conditions = Conditions{
        .allocator = self.allocator,
        .program = program,
        .reporter = self.reporter,
        .input = argument.value,
        .graph = self.graph,
        .call_depth = self.call_depth + 1,
    };

    const result = try conditions.call();

    try self.graph.calls.put(self.allocator, key, result);

    return .{ .value = result.value, .safe = try terms.binary(self.allocator, "and", argument.safe, result.safe) };
}
