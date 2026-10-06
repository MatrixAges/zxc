const std = @import("std");
const node = @import("node.zig");
const Self = @This();
const Error = std.mem.Allocator.Error;

allocator: std.mem.Allocator,
output: std.ArrayList(u8) = .empty,
depth: usize = 0,
pub fn write(self: *Self, text: []const u8) Error!void {
    try self.output.appendSlice(self.allocator, text);
}

fn indent(self: *Self) Error!void {
    for (0..self.depth) |_| try self.write("    ");
}

fn quoted(self: *Self, text: []const u8) Error!void {
    try self.write("\"");

    for (text) |byte| {
        switch (byte) {
            '"' => try self.write("\\\""),
            '\\' => try self.write("\\\\"),
            '\n' => try self.write("\\n"),
            '\r' => try self.write("\\r"),
            '\t' => try self.write("\\t"),
            32...33, 35...91, 93...126 => try self.output.append(self.allocator, byte),
            else => try self.output.print(self.allocator, "\\x{x:0>2}", .{byte}),
        }
    }

    try self.write("\"");
}

fn identifier(self: *Self, name: []const u8) Error!void {
    if (plainIdentifier(name)) return self.write(name);
    try self.write("@");
    try self.quoted(name);
}

fn plainIdentifier(name: []const u8) bool {
    if (name.len == 0 or std.mem.eql(u8, name, "_") or std.zig.Token.getKeyword(name) != null) return false;
    if (!std.ascii.isAlphabetic(name[0]) and name[0] != '_') return false;

    for (name[1..]) |byte| {
        if (!std.ascii.isAlphanumeric(byte) and byte != '_') return false;
    }

    return true;
}

fn errorSet(self: *Self, members: []const []const u8) Error!void {
    try self.write("error{ ");

    for (members) |member| {
        try self.identifier(member);
        try self.write(", ");
    }

    try self.write("}");
}

pub fn expression(self: *Self, value: *const node.Expression) Error!void {
    switch (value.*) {
        .unreachable_value => try self.write("unreachable"),
        .unit => try self.write("{}"),
        .return_value => |result| {
            try self.write("return");

            if (result) |item| {
                try self.write(" ");
                try self.expression(item);
            }
        },
        .catch_scope => |item| {
            try self.write("(");
            try self.expression(item.value);
            try self.write(" catch ");

            if (item.capture) |name| {
                try self.write("|");
                try self.identifier(name);
                try self.write("| ");
            }

            try self.block(item.body);
            try self.write(")");
        },
        .fixed_array_type => |array| {
            try self.write("[");
            try self.expression(array.length);
            try self.write("]");
            try self.expression(array.element);
        },
        .null_value => try self.write("null"),
        .undefined_value => try self.write("undefined"),
        .optional_type => |child| {
            try self.write("?");
            try self.expression(child);
        },
        .error_set => |members| try self.errorSet(members),
        .error_union => |error_union| {
            if (error_union.errors) |members| try self.errorSet(members) else if (!error_union.inferred) try self.write("anyerror");
            try self.write("!");
            try self.expression(error_union.payload);
        },
        .catch_value => |item| {
            try self.write("(");
            try self.expression(item.value);
            try self.write(" catch |");
            try self.identifier(item.capture);
            try self.write("| break :");
            try self.identifier(item.label);
            try self.write(" ");
            try self.expression(item.result);
            try self.write(")");
        },
        .try_value => |child| {
            try self.write("(try ");
            try self.expression(child);
            try self.write(")");
        },
        .comptime_value => |child| {
            try self.write("(comptime ");
            try self.expression(child);
            try self.write(")");
        },
        .enum_literal => |name| {
            try self.write(".");
            try self.identifier(name);
        },
        .tuple_type => |items| {
            try self.write("struct { ");

            for (items) |item| {
                try self.expression(item);
                try self.write(", ");
            }

            try self.write("}");
        },
        .enum_type => |members| {
            try self.write("enum { ");

            for (members) |member| {
                try self.identifier(member);
                try self.write(", ");
            }

            try self.write("}");
        },
        .array => |array| {
            try self.write("[_]");
            try self.expression(array.element_type);
            try self.write("{");

            for (array.values) |item| {
                try self.expression(item);
                try self.write(", ");
            }

            try self.write("}");
        },
        .tuple => |items| {
            try self.write(".{ ");

            for (items) |item| {
                try self.expression(item);
                try self.write(", ");
            }

            try self.write("}");
        },
        .index => |item| {
            try self.write("(");
            try self.expression(item.target);
            try self.write(")[");
            try self.expression(item.index);
            try self.write("]");
        },
        .slice => |item| {
            try self.write("(");
            try self.expression(item.target);
            try self.write(")[");
            if (item.start) |start| try self.expression(start) else try self.write("0");
            try self.write("..");
            if (item.end) |end| try self.expression(end);
            try self.write("]");
        },
        .address_of => |operand| {
            try self.write("(&");
            try self.expression(operand);
            try self.write(")");
        },
        .error_value => |name| {
            try self.write("error.");
            try self.identifier(name);
        },
        .block => |item| {
            try self.identifier(item.label);
            try self.write(": ");
            try self.block(item.statements);
        },
        .identifier => |name| try self.identifier(name),
        .integer => |number| try self.output.print(self.allocator, "{d}", .{number}),
        .float => |number| try self.output.print(self.allocator, "@as(f64, @bitCast(@as(u64, {d})))", .{@as(u64, @bitCast(number))}),
        .string => |text| try self.quoted(text),
        .boolean => |boolean| try self.write(if (boolean) "true" else "false"),
        .primitive => |primitive| try self.write(@tagName(primitive)),
        .dereference => |value_expr| {
            try self.write("(");
            try self.expression(value_expr);
            try self.write(").*");
        },
        .pointer => |element| {
            try self.write("*");
            try self.expression(element);
        },
        .const_pointer => |element| {
            try self.write("*const ");
            try self.expression(element);
        },
        .const_slice => |element| {
            try self.write("[]const ");
            try self.expression(element);
        },
        .mutable_slice => |element| {
            try self.write("[]");
            try self.expression(element);
        },
        .many_pointer => |element| {
            try self.write("[*]");
            try self.expression(element);
        },
        .namespace_type => |declarations| {
            try self.write("struct {\n");

            self.depth += 1;

            for (declarations) |item| {
                try self.indent();
                try self.declaration(item);
            }

            self.depth -= 1;

            try self.indent();
            try self.write("}");
        },
        .container_type => |container| {
            try self.write("struct {\n");

            self.depth += 1;

            for (container.fields) |field| {
                try self.indent();
                try self.identifier(field.name);
                try self.write(": ");
                try self.expression(field.value);

                if (field.default_value) |initial| {
                    try self.write(" = ");
                    try self.expression(initial);
                }

                try self.write(",\n");
            }

            for (container.declarations) |item| {
                try self.indent();
                try self.declaration(item);
            }

            self.depth -= 1;

            try self.indent();
            try self.write("}");
        },
        .opaque_type => try self.write("opaque {}"),
        .struct_type => |fields| {
            try self.write("struct {\n");

            self.depth += 1;

            for (fields) |field| {
                try self.indent();
                try self.identifier(field.name);
                try self.write(": ");
                try self.expression(field.value);

                if (field.default_value) |initial| {
                    try self.write(" = ");
                    try self.expression(initial);
                }

                try self.write(",\n");
            }

            self.depth -= 1;

            try self.indent();
            try self.write("}");
        },
        .range => |range| {
            try self.expression(range.start);
            try self.write("..");
            try self.expression(range.end);
        },
        .field => |field| {
            try self.write("(");
            try self.expression(field.target);
            try self.write(").");
            try self.identifier(field.name);
        },
        .unary => |unary| {
            try self.write(if (unary.operator == .negate) "(-" else "(!");
            try self.expression(unary.operand);
            try self.write(")");
        },
        .binary => |binary| {
            try self.write("(");
            try self.expression(binary.left);
            try self.write(" ");
            try self.write(binary.operator.spelling());
            try self.write(" ");
            try self.expression(binary.right);
            try self.write(")");
        },
        .builtin => |call| {
            try self.write("@");
            try self.write(@tagName(call.name));
            try self.arguments(call.arguments);
        },
        .call => |call| {
            try self.expression(call.callee);
            try self.arguments(call.arguments);
        },
        .conditional => |conditional| {
            try self.write("(if (");
            try self.expression(conditional.condition);
            try self.write(") ");

            if (conditional.capture) |name| {
                try self.write("|");
                try self.identifier(name);
                try self.write("| ");
            }

            try self.expression(conditional.yes);
            try self.write(" else ");

            if (conditional.error_capture) |name| {
                try self.write("|");
                try self.identifier(name);
                try self.write("| ");
            }

            try self.expression(conditional.no);
            try self.write(")");
        },
        .optional_unwrap => |operand| {
            try self.expression(operand);
            try self.write(".?");
        },
        .selection => |selection| {
            try self.write("switch (");
            try self.expression(selection.subject);
            try self.write(") { ");

            for (selection.arms) |arm| {
                if (arm.value) |tag| try self.expression(tag) else try self.write("else");
                try self.write(" => ");

                if (arm.capture) |name| {
                    try self.write("|");
                    try self.identifier(name);
                    try self.write("| ");
                }

                try self.expression(arm.result);
                try self.write(", ");
            }

            try self.write("}");
        },
        .object => |object| {
            if (object.type_expr) |type_expr| try self.expression(type_expr) else try self.write(".");
            try self.write("{");

            for (object.fields) |field| {
                try self.write(" .");
                try self.identifier(field.name);
                try self.write(" = ");
                try self.expression(field.value);
                try self.write(",");
            }

            try self.write(" }");
        },
    }
}

fn arguments(self: *Self, values: []const *const node.Expression) Error!void {
    try self.write("(");

    for (values, 0..) |value, index| {
        if (index != 0) try self.write(", ");
        try self.expression(value);
    }

    try self.write(")");
}

fn constant(self: *Self, value: node.Constant) Error!void {
    if (value.exported) try self.write("pub ");
    try self.write("const ");
    try self.identifier(value.name);

    if (value.type_expr) |type_expr| {
        try self.write(": ");
        try self.expression(type_expr);
    }

    try self.write(" = ");
    try self.expression(value.value);
    try self.write(";\n");
}

fn variable(self: *Self, value: node.Constant) Error!void {
    try self.write("var ");
    try self.identifier(value.name);

    if (value.type_expr) |type_expr| {
        try self.write(": ");
        try self.expression(type_expr);
    }

    try self.write(" = ");
    try self.expression(value.value);
    try self.write(";\n");
}

fn block(self: *Self, statements: []const node.Statement) Error!void {
    try self.write("{\n");

    self.depth += 1;

    for (statements, 0..) |statement, index| {
        if (index > 0 and (statements[index - 1] != .constant or statement != .constant)) try self.write("\n");
        try self.indent();

        switch (statement) {
            .scope => |body| {
                try self.block(body);
                try self.write("\n");
            },
            .defer_expression, .errdefer_expression => |value| {
                try self.write(if (statement == .errdefer_expression) "errdefer " else "defer ");
                try self.expression(value);
                try self.write(";\n");
            },
            .defer_scope => |body| {
                try self.write("defer ");
                try self.block(body);
                try self.write("\n");
            },
            .discard_error => |value| {
                try self.write("if (");
                try self.expression(value);
                try self.write(") |_| {} else |_| {}\n");
            },
            .constant => |value| try self.constant(value),
            .variable => |value| try self.variable(value),
            .assignment => |value| {
                try self.expression(value.target);
                try self.write(" = ");
                try self.expression(value.value);
                try self.write(";\n");
            },
            .for_loop => |loop| {
                try self.write("for (");
                try self.expression(loop.iterable);
                if (loop.index_capture != null) try self.write(", 0..");
                try self.write(") |");
                if (loop.capture_reference) try self.write("*");
                if (std.mem.eql(u8, loop.capture, "_")) try self.write("_") else try self.identifier(loop.capture);

                if (loop.index_capture) |index_name| {
                    try self.write(", ");
                    try self.identifier(index_name);
                }

                try self.write("| ");
                try self.block(loop.body);
                try self.write("\n");
            },
            .while_loop => |loop| {
                try self.write("while (");
                try self.expression(loop.condition);
                try self.write(") ");

                if (loop.capture) |name| {
                    try self.write("|");
                    try self.identifier(name);
                    try self.write("| ");
                }

                try self.block(loop.body);
                try self.write("\n");
            },
            .break_loop => try self.write("break;\n"),
            .continue_loop => try self.write("continue;\n"),
            .break_value => |value| {
                try self.write("break :");
                try self.identifier(value.label);
                try self.write(" ");
                try self.expression(value.value);
                try self.write(";\n");
            },
            .unreachable_stmt => try self.write("unreachable;\n"),
            .result => |value| {
                try self.write("return");

                if (value) |expression_value| {
                    try self.write(" ");
                    try self.expression(expression_value);
                }

                try self.write(";\n");
            },
            .branch => |branch| {
                try self.write("if (");
                try self.expression(branch.condition);
                try self.write(") ");

                if (branch.capture) |name| {
                    try self.write("|");
                    if (branch.capture_reference) try self.write("*");
                    try self.identifier(name);
                    try self.write("| ");
                }

                try self.block(branch.yes);

                if (branch.no.len != 0 or branch.error_capture != null) {
                    try self.write(" else ");

                    if (branch.error_capture) |name| {
                        try self.write("|");
                        try self.identifier(name);
                        try self.write("| ");
                    }

                    try self.block(branch.no);
                }

                try self.write("\n");
            },
            .discard, .expression => |value| {
                if (statement == .discard) try self.write("_ = ");
                try self.expression(value);
                try self.write(";\n");
            },
        }
    }

    self.depth -= 1;

    try self.indent();
    try self.write("}");
}

pub fn declaration(self: *Self, value: node.Declaration) Error!void {
    switch (value) {
        .constant => |item| try self.constant(item),
        .variable => |item| {
            if (item.exported) try self.write("pub ");
            try self.variable(item);
        },
        .comptime_scope => |body| {
            try self.write("comptime ");
            try self.block(body);
            try self.write("\n");
        },
        .field => |item| {
            try self.identifier(item.name);
            try self.write(": ");
            try self.expression(item.value);

            if (item.default_value) |initial| {
                try self.write(" = ");
                try self.expression(initial);
            }

            try self.write(",\n");
        },
        .function => |function| {
            if (function.exported) try self.write("pub ");
            if (function.abi_export) try self.write("export ");
            try self.write("fn ");
            try self.identifier(function.name);
            try self.write("(");

            for (function.parameters, 0..) |parameter, index| {
                if (index != 0) try self.write(", ");
                if (parameter.comptime_parameter) try self.write("comptime ");
                if (std.mem.eql(u8, parameter.name, "_")) try self.write("_") else try self.identifier(parameter.name);
                try self.write(": ");
                try self.expression(parameter.value);
            }

            try self.write(") ");

            if (function.calling_convention) |convention| {
                try self.write("callconv(");
                try self.expression(convention);
                try self.write(") ");
            }

            try self.expression(function.return_type);
            try self.write(" ");
            try self.block(function.body);
            try self.write("\n");
        },
    }
}
