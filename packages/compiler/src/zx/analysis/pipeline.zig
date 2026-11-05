const std = @import("std");
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

    if (self.node(input).type_id == @import("types.zig").scalarId(.bool)) try self.refinement.alias(self.allocator, self.nodes.view(), symbol, input);

    self.pipeline = .{ .symbol = symbol, .depth = self.lambda_depth, .owner = self.collection_captures, .scope_start = self.active.items.len };

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

pub fn probeSymbol(self: *const Analyzer, expression: anytype) ?ir.SymbolId {
    if (@import("expression_binding.zig").unit(self, expression)) return null;
    if (@import("expression_binding.zig").lookup(self, expression)) |binding| return binding;

    const value = syntax.value(expression);

    if (value != .identifier) return null;

    if (std.mem.eql(u8, value.identifier.text, "_")) {
        if (self.pipeline) |pipe| {
            var index = self.active.items.len;

            while (index > pipe.scope_start and index > self.scope_floor) {
                index -= 1;
                const binding = self.active.items[index];

                if (std.mem.eql(u8, self.symbols.at(@backingInt(binding)).name, "_")) return binding;
            }

            if (self.collection_captures == pipe.owner) return if (self.lambda_depth == pipe.depth) pipe.symbol else null;
            if (self.collection_captures) |captures| return captures.cachedSymbol(pipe.owner, pipe.symbol) orelse pipe.symbol;

            return null;
        }
    }

    return self.lookup(value.identifier.text);
}
