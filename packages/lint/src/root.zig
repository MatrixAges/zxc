const std = @import("std");
const zx = @import("zx");
const syntax = zx.syntax.borrow;
pub const attribute_required = @import("attribute_required").check;
pub const layout = @import("layout/root.zig");
pub const spacing = @import("spacing.zig");
pub const indentation = @import("indentation/root.zig");
pub const header = zx.syntax.header;
pub const source = @import("source.zig");
pub const length = @import("length");
pub const rx = @import("rx/root.zig");
pub const configuration = @import("configuration/root.zig");
pub const NameKind = @import("naming").NameKind;
const ExpressionContext = enum { zx, rx, zx_style, rx_style };
const loop_postfix = @import("loop_postfix");
pub const checkName = @import("naming").checkName;

pub fn checkNames(program: zx.ast.Program) ?zx.Diagnostic {
    return checkViewNames(header.Native{ .program = program }, program.contracts, program.body);
}

pub fn checkViewNames(view: anytype, contracts: anytype, body: anytype) ?zx.Diagnostic {
    if (checkHeaderNames(view)) |issue| return issue;

    for (0..contracts.len) |index| {
        if (checkExpression(syntax.item(contracts, index).predicate)) |issue| return issue;
    }

    return if (body) |value| checkBlock(value, .zx) else null;
}

pub fn checkHeaderNames(view: anytype) ?zx.Diagnostic {
    if (view.functionName()) |name| {
        if (checkBinding(name, .callable)) |issue| return issue;
    }

    for (0..view.importCount()) |index| {
        const item = view.importAt(index);

        for (0..view.importNameCount(index)) |name| {
            if (checkBinding(view.importNameAt(index, name), switch (item.kind) {
                .function => .callable,
                .enumeration => .imported_value,
                .type_only => .type_decl,
            })) |issue| return issue;
        }
    }

    for (0..view.declarationCount()) |index| {
        if (checkBinding(view.declarationAt(index).name, .type_decl)) |issue| return issue;
    }

    for (0..view.constantCount()) |index| {
        if (checkBinding(view.constantAt(index).name, .value)) |issue| return issue;
    }

    return null;
}

fn checkBinding(name: zx.ast.Name, kind: NameKind) ?zx.Diagnostic {
    if (checkName(name.text, kind)) return null;

    return .{ .code = .naming, .span = name.span, .message = switch (kind) {
        .value => "value names must use snake_case",
        .callable => "function names must use camelCase",
        .type_decl => "type names must use PascalCase",
        .imported_value => "named imports must use camelCase functions, snake_case constants or PascalCase types",
    } };
}

fn checkBlock(block: anytype, comptime context: ExpressionContext) ?zx.Diagnostic {
    for (0..block.statements.len) |statement_index| {
        const statement = syntax.item(block.statements, statement_index);

        switch (statement.value) {
            .state_update => |value| if (checkNestedExpression(value.target, false, context) orelse checkNestedExpression(value.value, false, context)) |issue| return issue,
            .evaluate => |value| if (checkNestedExpression(value, false, context)) |issue| return issue,
            .constant => |binding| {
                if (checkBinding(binding.name, .value)) |issue| return issue;
                if (checkNestedExpression(binding.value, false, context)) |issue| return issue;
            },
            .destructure => |binding| {
                for (0..binding.names.len) |name_index| {
                    const name = syntax.item(binding.names, name_index);

                    if (!std.mem.eql(u8, name.text, "_")) {
                        if (checkBinding(name, .value)) |issue| return issue;
                    }
                }

                if (checkNestedExpression(binding.value, false, context)) |issue| return issue;
            },
            .branch => |branch| {
                if (checkNestedExpression(branch.condition, false, context)) |issue| return issue;
                if (checkBlock(branch.yes, context)) |issue| return issue;

                if (branch.no) |no| {
                    if (checkBlock(no, context)) |issue| return issue;
                }
            },
            .switch_stmt => |selection| {
                if (checkNestedExpression(selection.subject, false, context)) |issue| return issue;

                for (0..selection.cases.len) |case_index| {
                    const case = syntax.item(selection.cases, case_index);

                    if (case.value) |value| {
                        if (checkNestedExpression(value, false, context)) |issue| return issue;
                    }

                    if (checkBlock(case.body, context)) |issue| return issue;
                }
            },
            .store_set => |setter| {
                if (checkNestedExpression(setter.target, false, context) orelse checkNestedExpression(setter.value, false, context)) |issue| return issue;
            },
            .result => |value| if (value) |item| {
                if (checkNestedExpression(item, false, context)) |issue| return issue;
            },
        }
    }

    return null;
}

pub fn checkViewStyle(view: anytype, contracts: anytype, body: anytype) ?zx.Diagnostic {
    if (checkHeaderNames(view)) |issue| return issue;

    for (0..contracts.len) |index| {
        if (checkStyleExpression(syntax.item(contracts, index).predicate)) |issue| return issue;
    }

    return if (body) |value| checkBlock(value, .zx_style) else null;
}

pub fn checkStyleExpression(expression: anytype) ?zx.Diagnostic {
    return checkNestedExpression(expression, false, .zx_style);
}

pub fn checkExpression(expression: anytype) ?zx.Diagnostic {
    return checkNestedExpression(expression, false, .zx);
}

pub fn checkRxExpression(expression: anytype) ?zx.Diagnostic {
    return checkNestedExpression(expression, false, .rx);
}

fn checkNestedExpression(expression: anytype, nested: bool, comptime context: ExpressionContext) ?zx.Diagnostic {
    if (context == .zx_style or context == .rx_style) {
        const value = syntax.value(expression);

        const receiver: ?@TypeOf(expression) = switch (value) {
            .field => |field| field.target,
            .index => |index| index.target,
            .call => |call| call.callee,
            else => null,
        };

        if (receiver) |target| {
            const target_value = syntax.value(target);
            const callee = if (target_value == .call) syntax.value(target_value.call.callee) else target_value;
            const kind: loop_postfix.Kind = switch (value) { .field => .Field, .index => .Index, .call => .Call, else => .Other };

            if (loop_postfix.check(kind, if (target_value == .call) .Call else .Other, if (callee == .identifier) .Identifier else .Other, if (callee == .identifier) callee.identifier.text else "")) {
                return .{ .code = .style, .span = .{ .start = target.span.end, .end = expression.span.end }, .message = "move loop result processing into its return callback" };
            }
        }
    }

    switch (syntax.value(expression)) {
        .state_block => |body| return checkBlock(body, context),
        .lambda => |lambda| {
            for (0..lambda.parameters.len) |name_index| {
                const name = syntax.item(lambda.parameters, name_index);

                if (checkBinding(name, .value)) |issue| return issue;
            }

            return checkNestedExpression(lambda.body, false, context);
        },
        .field => |field| return checkNestedExpression(field.target, nested, context),
        .index => |item| return checkNestedExpression(item.target, nested, context) orelse checkNestedExpression(item.index, nested, context),
        .capture, .task, .await_task, .cancel_task => |child| return checkNestedExpression(child, nested, context),
        .unary => |unary| return checkNestedExpression(unary.operand, nested, context),
        .binary => |binary| return checkNestedExpression(binary.left, nested, context) orelse checkNestedExpression(binary.right, nested, context),
        .pipeline => |pipe| return checkNestedExpression(pipe.input, nested, context) orelse checkNestedExpression(pipe.stage, nested, context),
        .conditional => |value| {
            if (nested) return .{ .code = .style, .span = expression.span, .message = if (context == .rx or context == .rx_style) "nested conditional values are not allowed in RX; use If or Switch, or move the decision to ZX and use Call.fn" else "nested conditional expressions are not allowed; use match" };

            return checkNestedExpression(value.condition, true, context) orelse checkNestedExpression(value.yes, true, context) orelse checkNestedExpression(value.no, true, context);
        },
        .match_expr => |selection| {
            if (selection.subject) |subject| {
                if (checkNestedExpression(subject, nested, context)) |issue| return issue;
            }

            for (0..selection.arms.len) |arm_index| {
                const arm = syntax.item(selection.arms, arm_index);

                if (checkNestedExpression(arm.condition, nested, context) orelse checkNestedExpression(arm.result, nested, context)) |issue| return issue;
            }

            return checkNestedExpression(selection.fallback, nested, context);
        },
        .object => |fields| for (0..fields.len) |field_index| {
            const field = syntax.item(fields, field_index);

            if (checkNestedExpression(field.value, nested, context)) |issue| return issue;
        },
        .list => |items| for (0..items.len) |item_index| {
            const item = syntax.item(items, item_index);

            if (checkNestedExpression(item, nested, context)) |issue| return issue;
        },
        .call => |call| {
            if (checkNestedExpression(call.callee, nested, context)) |issue| return issue;

            for (0..call.arguments.len) |argument_index| {
                const argument = syntax.item(call.arguments, argument_index);

                if (checkNestedExpression(argument, nested, context)) |issue| return issue;
            }
        },
        .template => |parts| for (0..parts.len) |part_index| {
            const part = syntax.item(parts, part_index);

            if (part == .expression) {
                if (checkNestedExpression(part.expression, nested, context)) |issue| return issue;
            }
        },
        else => {},
    }

    return null;
}
