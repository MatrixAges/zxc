const std = @import("std");
const zx = @import("zx");

pub const Kind = enum { arguments, fields, parameters, parts, arms, statements, names, cases, contracts };

pub fn Model(comptime Context: type) type {
    return struct {
        pub const Type = struct { view: *const Context.TypeView, ref: Context.TypeView.Ref };

        pub const Expression = struct {
            context: *const Context,
            index: usize,
            span: zx.Span,
            condition_list: bool,
            condition_terms: u16,
            pub const Value = union(enum) {
                number: []const u8,
                string: []const u8,
                boolean: bool,
                null_value,
                capture: Expression,
                task: Expression,
                await_task: Expression,
                cancel_task: Expression,
                identifier: zx.ast.Name,
                field: struct { target: Expression, name: zx.ast.Name },
                index: struct { target: Expression, index: Expression },
                list: Sequence(.arguments),
                call: struct { callee: Expression, arguments: Sequence(.arguments), type_argument: ?Type },
                lambda: struct { parameters: Sequence(.parameters), body: Expression },
                state_block: Block,
                template: Sequence(.parts),
                unary: struct { operator: enum { negate, not }, operand: Expression },
                binary: struct { operator: zx.syntax.Operator, left: Expression, right: Expression },
                pipeline: struct { input: Expression, stage: Expression },
                conditional: struct { condition: Expression, yes: Expression, no: Expression },
                match_expr: struct { subject: ?Expression, arms: Sequence(.arms), fallback: Expression },
                object: Sequence(.fields),
            };
            pub fn read(self: Expression) Value {
                return @import("expressions.zig").read(self);
            }
        };
        pub const BindingPattern = struct {
            context: *const Context,
            index: usize,
            span: zx.Span,
            pub fn kind(self: @This()) std.meta.Tag(@FieldType(zx.ast.BindingPattern, "value")) {
                return switch (self.context.storage.blocks.names[self.index].kind) {
                    .Name => .name,
                    .Object => .object,
                    .Sequence => .sequence,
                    .Hole => unreachable,
                };
            }
            pub fn name(self: @This()) zx.ast.Name {
                return self.context.name(self.context.storage.blocks.names[self.index].span);
            }
            pub fn count(self: @This()) usize {
                return @intCast(self.context.storage.blocks.names[self.index].count);
            }
            pub fn child(self: @This(), position: usize) ?@This() {
                const index = self.childIndex(position);
                const node = self.context.storage.blocks.names[index];

                if (node.kind == .Hole) return null;

                return .{ .context = self.context, .index = index, .span = zx.syntax.header.span(node.span) };
            }
            pub fn key(self: @This(), position: usize) zx.ast.Name {
                return self.context.name(self.context.storage.blocks.names[self.childIndex(position)].key);
            }
            fn childIndex(self: @This(), position: usize) usize {
                std.debug.assert(position < self.count());

                return self.context.order.edges[self.context.order.patterns[self.index] + position];
            }
        };

        pub const Block = struct { span: zx.Span, statements: Sequence(.statements) };

        pub const Statement = struct {
            span: zx.Span,
            value: union(enum) {
                evaluate: Expression,
                state_update: struct { target: Expression, value: Expression, operator: ?zx.syntax.Operator },
                constant: struct { name: zx.ast.Name, annotation: ?Type, value: Expression },
                destructure: struct { names: Sequence(.names), pattern: ?BindingPattern, value: Expression },
                branch: struct { condition: Expression, yes: Block, no: ?Block },
                switch_stmt: struct { subject: Expression, cases: Sequence(.cases) },
                store_set: struct { target: Expression, value: Expression },
                result: ?Expression,
            },
        };
        pub const Program = struct {
            body: ?Block,
            contracts: Sequence(.contracts),
            has_store: bool,
            function_name: ?zx.ast.Name = null,
        };
        pub fn Sequence(comptime kind: Kind) type {
            return struct {
                const Self = @This();
                context: *const Context,
                first: usize,
                len: usize,
                pub const Item = switch (kind) {
                    .arguments => Expression,
                    .parameters, .names => zx.ast.Name,
                    .fields => struct { name: zx.ast.Name, value: Expression, spread: bool },
                    .parts => union(enum) { text: []const u8, expression: Expression },
                    .arms => struct { condition: Expression, result: Expression },
                    .statements => Statement,
                    .cases => struct { value: ?Expression, body: Block, span: zx.Span },
                    .contracts => struct { kind: zx.syntax.ContractKind, predicate: Expression, span: zx.Span },
                };
                pub fn at(self: Self, index: usize) Item {
                    std.debug.assert(index < self.len);

                    return @import("collections.zig").item(kind, self, index);
                }
            };
        }
    };
}
