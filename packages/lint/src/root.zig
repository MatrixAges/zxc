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

const ExpressionContext = struct {
    kind: enum { zx, rx, zx_style, rx_style },
    source: ?[]const u8 = null,
    condition_item: bool = false,
};

const readability = @import("readability.zig");
const loop_postfix = @import("loop_postfix");
const condition_policy = @import("condition_policy");
pub const checkName = @import("naming").checkName;

pub fn checkNames(program: zx.ast.Program) ?zx.Diagnostic {
    return checkViewNames(header.Native{ .program = program }, program.contracts, program.body);
}

pub fn checkViewNames(view: anytype, contracts: anytype, body: anytype) ?zx.Diagnostic {
    if (checkHeaderNames(view)) |issue| return issue;

    for (0..contracts.len) |index| {
        if (checkExpression(syntax.item(contracts, index).predicate)) |issue| return issue;
    }

    return if (body) |value| checkBlock(value, .{ .kind = .zx }) else null;
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

fn checkBlock(block: anytype, context: ExpressionContext) ?zx.Diagnostic {
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
                if ((context.kind == .zx_style or context.kind == .rx_style) and condition_policy.check(branch.condition.condition_terms, branch.condition.condition_list, true)) return .{ .code = .style, .span = branch.condition.span, .message = "if conditions with more than two terms must use a separate condition binding" };
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
    return checkSourceStyle(null, view, contracts, body);
}

pub fn checkSourceStyle(text: ?[]const u8, view: anytype, contracts: anytype, body: anytype) ?zx.Diagnostic {
    if (checkHeaderNames(view)) |issue| return issue;

    for (0..contracts.len) |index| {
        if (checkReadableExpression(text, syntax.item(contracts, index).predicate)) |issue| return issue;
    }

    return if (body) |value| checkBlock(value, .{ .kind = .zx_style, .source = text }) else null;
}

pub fn checkReadableExpression(text: ?[]const u8, expression: anytype) ?zx.Diagnostic {
    return checkNestedExpression(expression, false, .{ .kind = .zx_style, .source = text });
}

pub fn checkStyleExpression(expression: anytype) ?zx.Diagnostic {
    return checkNestedExpression(expression, false, .{ .kind = .zx_style });
}

pub fn checkExpression(expression: anytype) ?zx.Diagnostic {
    return checkNestedExpression(expression, false, .{ .kind = .zx });
}

pub fn checkRxExpression(expression: anytype) ?zx.Diagnostic {
    return checkNestedExpression(expression, false, .{ .kind = .rx });
}

fn checkNestedExpression(expression: anytype, nested: bool, context: ExpressionContext) ?zx.Diagnostic {
    if (context.kind == .zx_style or context.kind == .rx_style) {
        if (readability.condition(context.source, expression)) {
            if (context.condition_item) return readability.item(context.source.?, expression, true);

            return checkConditionList(expression, expression.span.start, nested, context);
        }

        if (condition_policy.check(expression.condition_terms, expression.condition_list, false)) return .{ .code = .style, .span = expression.span, .message = "boolean expressions with more than three terms must use a condition list" };

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

            const kind: loop_postfix.Kind = switch (value) {
                .field => .Field,
                .index => .Index,
                .call => .Call,
                else => .Other,
            };

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
        .pipeline => {
            if (context.kind == .zx_style or context.kind == .rx_style) {
                if (readability.pipeline(context.source, expression)) |issue| return issue;
            }

            var cursor = expression;

            while (syntax.value(cursor) == .pipeline) {
                const pipe = syntax.value(cursor).pipeline;

                if (checkNestedExpression(pipe.stage, nested, context)) |issue| return issue;

                cursor = pipe.input;
            }

            return checkNestedExpression(cursor, nested, context);
        },
        .conditional => |value| {
            if (context.kind == .zx_style or context.kind == .rx_style) {
                if (readability.ternary(context.source, expression)) |issue| return issue;
            }

            if (nested) return .{ .code = .style, .span = expression.span, .message = if (context.kind == .rx or context.kind == .rx_style) "nested conditional values are not allowed in RX; use If or Switch, or move the decision to ZX and use Call.fn" else "nested conditional expressions are not allowed; use match" };

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

fn checkConditionList(expression: anytype, start: usize, nested: bool, context: ExpressionContext) ?zx.Diagnostic {
    if (expression.condition_list and expression.span.start == start) {
        switch (syntax.value(expression)) {
            .unary => |value| return checkConditionList(value.operand, start, nested, context),
            .binary => |value| {
                if (checkConditionList(value.left, start, nested, context)) |issue| return issue;

                return checkConditionItem(value.right, nested, context);
            },
            else => {},
        }
    }

    return checkConditionItem(expression, nested, context);
}

fn checkConditionItem(expression: anytype, nested: bool, context: ExpressionContext) ?zx.Diagnostic {
    if (readability.item(context.source.?, expression, false)) |issue| return issue;

    var child = context;

    child.condition_item = true;

    return checkNestedExpression(expression, nested, child);
}
