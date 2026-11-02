const zx = @import("zx");
const syntax = zx.syntax.borrow;
const ir = zx.ir;
const Analyzer = @import("analyzer.zig");
const Builder = @import("collections/builder.zig");

pub fn analyze(self: *Analyzer, expression: anytype, expected: ?ir.TypeId) zx.Error!ir.ExprId {
    const pipe = syntax.value(expression).pipeline;
    const parent = self.pipeline;
    self.pipeline = null;
    defer self.pipeline = parent;

    const input = try self.expression(pipe.input, null);
    const builder = Builder{ .analyzer = self, .span = expression.span };
    const symbol = try builder.symbol("$pipeline_input", self.node(input).type_id);
    self.pipeline = .{ .symbol = symbol, .depth = self.lambda_depth };

    const result = try self.expression(pipe.stage, expected);

    if (self.pipeline.?.uses == 0) return self.reporter.fail(.name, pipe.stage.span, "a pipeline stage must reference its input with _");

    const bindings = try self.allocator.alloc(ir.ScopeBinding, 1);

    const borrow = switch (self.node(input).value) {
        .reference, .field, .tuple_field, .index, .optional_value => true,
        else => false,
    };

    bindings[0] = .{ .symbol = symbol, .value = input, .borrow = borrow };

    return builder.expression(self.node(result).type_id, .{ .scope = .{ .bindings = bindings, .result = result } });
}
