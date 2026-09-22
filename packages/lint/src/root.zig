const std = @import("std");
const zx = @import("zx");
pub const spacing = @import("spacing.zig");
pub const NameKind = enum { value, callable, type_decl };

pub fn checkName(name: []const u8, kind: NameKind) bool {
    if (name.len == 0) return false;

    if (kind == .type_decl) {
        if (!std.ascii.isUpper(name[0])) return false;
    } else if (!std.ascii.isLower(name[0])) return false;

    var after_underscore = false;

    for (name) |byte| {
        if (kind == .value and byte == '_') {
            if (after_underscore) return false;

            after_underscore = true;

            continue;
        }

        if (!std.ascii.isAlphanumeric(byte)) return false;
        if (kind == .value and std.ascii.isUpper(byte)) return false;

        after_underscore = false;
    }

    return !after_underscore;
}

pub fn checkNames(program: zx.ast.Program) ?zx.Diagnostic {
    for (program.imports) |item| {
        for (item.names) |name| {
            if (checkBinding(name, if (item.kind == .function) .callable else .type_decl)) |issue| return issue;
        }
    }

    for (program.declarations) |declaration| {
        if (checkBinding(declaration.name, .type_decl)) |issue| return issue;
    }

    return if (program.body) |body| checkBlock(body) else null;
}

fn checkBinding(name: zx.ast.Name, kind: NameKind) ?zx.Diagnostic {
    if (checkName(name.text, kind)) return null;

    return .{ .code = .naming, .span = name.span, .message = switch (kind) {
        .value => "value names must use snake_case",
        .callable => "function names must use camelCase",
        .type_decl => "type names must use PascalCase",
    } };
}

fn checkBlock(block: zx.ast.Block) ?zx.Diagnostic {
    for (block.statements) |statement| {
        switch (statement.value) {
            .constant => |binding| {
                if (checkBinding(binding.name, .value)) |issue| return issue;
                if (checkExpression(binding.value)) |issue| return issue;
            },
            .destructure => |binding| {
                for (binding.names) |name| {
                    if (!std.mem.eql(u8, name.text, "_")) {
                        if (checkBinding(name, .value)) |issue| return issue;
                    }
                }

                if (checkExpression(binding.value)) |issue| return issue;
            },
            .branch => |branch| {
                if (checkExpression(branch.condition)) |issue| return issue;
                if (checkBlock(branch.yes)) |issue| return issue;

                if (branch.no) |no| {
                    if (checkBlock(no)) |issue| return issue;
                }
            },
            .switch_stmt => |selection| {
                if (checkExpression(selection.subject)) |issue| return issue;

                for (selection.cases) |case| {
                    if (case.value) |value| {
                        if (checkExpression(value)) |issue| return issue;
                    }

                    if (checkBlock(case.body)) |issue| return issue;
                }
            },
            .store_set => |setter| {
                if (checkExpression(setter.value)) |issue| return issue;
            },
            .result => |value| if (value) |item| {
                if (checkExpression(item)) |issue| return issue;
            },
        }
    }

    return null;
}

fn checkExpression(expression: *const zx.ast.Expression) ?zx.Diagnostic {
    switch (expression.value) {
        .lambda => |lambda| {
            for (lambda.parameters) |name| {
                if (checkBinding(name, .value)) |issue| return issue;
            }

            return checkExpression(lambda.body);
        },
        .field => |field| return checkExpression(field.target),
        .index => |item| return checkExpression(item.target) orelse checkExpression(item.index),
        .unary => |unary| return checkExpression(unary.operand),
        .binary => |binary| return checkExpression(binary.left) orelse checkExpression(binary.right),
        .conditional => |value| return checkExpression(value.condition) orelse checkExpression(value.yes) orelse checkExpression(value.no),
        .object => |fields| for (fields) |field| {
            if (checkExpression(field.value)) |issue| return issue;
        },
        .list => |items| for (items) |item| {
            if (checkExpression(item)) |issue| return issue;
        },
        .call => |call| {
            if (checkExpression(call.callee)) |issue| return issue;

            for (call.arguments) |argument| {
                if (checkExpression(argument)) |issue| return issue;
            }
        },
        .template => |parts| for (parts) |part| {
            if (part == .expression) {
                if (checkExpression(part.expression)) |issue| return issue;
            }
        },
        else => {},
    }

    return null;
}
