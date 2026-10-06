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
                conditional: struct { condition: Expression, yes: Expression, no: Expression },
                match_expr: struct { subject: ?Expression, arms: Sequence(.arms), fallback: Expression },
                object: Sequence(.fields),
            };
            pub fn read(self: Expression) Value {
                return @import("expressions.zig").read(self);
            }
        };

        pub const Block = struct { span: zx.Span, statements: Sequence(.statements) };

        pub const Statement = struct {
            span: zx.Span,
            value: union(enum) {
                evaluate: Expression,
                state_update: struct { target: Expression, value: Expression, operator: ?zx.syntax.Operator },
                constant: struct { name: zx.ast.Name, annotation: ?Type, value: Expression },
                destructure: struct { names: Sequence(.names), value: Expression },
                branch: struct { condition: Expression, yes: Block, no: ?Block },
                switch_stmt: struct { subject: Expression, cases: Sequence(.cases) },
                store_set: struct { target: Expression, value: Expression },
                result: ?Expression,
            },
        };
        pub const Program = struct {
            body: ?Block,
            contracts: Sequence(.contracts),
            consumes_input: bool,
            has_store: bool,
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
