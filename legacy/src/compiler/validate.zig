const std = @import("std");
const ast = @import("ast.zig");
const diagnostic = @import("diagnostic.zig");
const Allocator = std.mem.Allocator;
const Error = diagnostic.Error;
const Reporter = diagnostic.Reporter;

pub fn validate(
    allocator: Allocator,
    program: ast.Program,
    reporter: *Reporter,
) Error!void {
    var validator = Validator{
        .allocator = allocator,
        .program = program,
        .reporter = reporter,
    };

    try validator.run();
}

const Validator = struct {
    allocator: Allocator,
    program: ast.Program,
    reporter: *Reporter,
    declarations: std.StringHashMap(ast.Declaration) = undefined,
    fn run(self: *Validator) Error!void {
        self.declarations = std.StringHashMap(ast.Declaration).init(self.allocator);

        defer self.declarations.deinit();

        for (self.program.declarations) |declaration| {
            if (self.declarations.contains(declaration.name())) {
                return self.reporter.fail(declaration.location(), "duplicate top-level declaration");
            }

            try self.declarations.put(declaration.name(), declaration);
        }

        for (self.program.declarations) |declaration| {
            switch (declaration) {
                .type_decl => |value| try self.validateType(value.value_type),
                .enum_decl => |value| try self.validateEnum(value),
            }
        }

        const output_decl = self.declarations.get("Output").?.type_decl;

        try self.validateBlock(self.program.function_declaration.body, output_decl.value_type);

        if (!isVoid(output_decl.value_type) and
            !blockAlwaysReturns(self.program.function_declaration.body))
        {
            return self.reporter.fail(
                self.program.function_declaration.location,
                "every reachable path of a non-void function must return Output",
            );
        }
    }
    fn validateType(self: *Validator, value_type: *const ast.TypeNode) Error!void {
        switch (value_type.*) {
            .named => |value| {
                if (!isPrimitive(value.name) and !self.declarations.contains(value.name)) {
                    return self.reporter.fail(value.location, "unknown type name");
                }
            },
            .optional => |inner| try self.validateType(inner),
            .list => |item| try self.validateType(item),
            .object => |object| {
                var fields = std.StringHashMap(void).init(self.allocator);

                defer fields.deinit();

                for (object.fields) |field| {
                    if (fields.contains(field.name)) {
                        return self.reporter.fail(field.location, "duplicate object field");
                    }

                    try fields.put(field.name, {});
                    try self.validateType(field.value_type);
                }
            },
        }
    }
    fn validateEnum(self: *Validator, declaration: ast.EnumDeclaration) Error!void {
        var members = std.StringHashMap(void).init(self.allocator);

        defer members.deinit();

        for (declaration.members) |member| {
            if (members.contains(member.name)) {
                return self.reporter.fail(member.location, "duplicate enum member");
            }

            try members.put(member.name, {});
        }
    }
    fn validateBlock(
        self: *Validator,
        statements: []const ast.Statement,
        output_type: *const ast.TypeNode,
    ) Error!void {
        var local_names = std.StringHashMap(void).init(self.allocator);

        defer local_names.deinit();

        for (statements) |statement| {
            switch (statement) {
                .constant => |value| {
                    if (std.mem.eql(u8, value.name, "in") or local_names.contains(value.name)) {
                        return self.reporter.fail(value.location, "duplicate local binding");
                    }

                    try self.validateExpression(value.initializer);
                    try local_names.put(value.name, {});
                },
                .if_stmt => |value| {
                    try self.validateExpression(value.condition);
                    try self.validateBlock(value.then_body, output_type);

                    if (value.else_body) |else_body| {
                        try self.validateBlock(else_body, output_type);
                    }
                },
                .switch_stmt => |value| {
                    try self.validateExpression(value.subject);

                    for (value.cases) |switch_case| {
                        if (switch_case.value) |case_value| try self.validateExpression(case_value);
                        try self.validateBlock(switch_case.body, output_type);
                    }
                },
                .return_stmt => |value| try self.validateReturn(value, output_type),
            }
        }
    }

    fn validateReturn(
        self: *Validator,
        statement: ast.ReturnStatement,
        output_type: *const ast.TypeNode,
    ) Error!void {
        if (isVoid(output_type)) {
            if (statement.value != null) {
                return self.reporter.fail(statement.location, "a void function must use `return;`");
            }

            return;
        }

        const value = statement.value orelse {
            return self.reporter.fail(statement.location, "a non-void function must return Output");
        };

        try self.validateExpression(value);

        const output_object = resolveObject(output_type, &self.declarations) orelse return;

        const object = switch (value.*) {
            .object => |result| result,
            else => return,
        };

        var returned_fields = std.StringHashMap(void).init(self.allocator);

        defer returned_fields.deinit();

        for (object.fields) |field| {
            if (returned_fields.contains(field.name)) {
                return self.reporter.fail(field.location, "duplicate returned object field");
            }

            if (!hasTypeField(output_object, field.name)) {
                return self.reporter.fail(field.location, "Output has no such field");
            }

            try returned_fields.put(field.name, {});
        }

        for (output_object.fields) |field| {
            if (!returned_fields.contains(field.name) and !isOptional(field.value_type)) {
                return self.reporter.fail(object.location, "returned object is missing a required Output field");
            }
        }
    }

    fn validateExpression(self: *Validator, expression: *const ast.Expression) Error!void {
        switch (expression.*) {
            .literal, .identifier => {},
            .member => |value| try self.validateExpression(value.target),
            .index => |value| {
                try self.validateExpression(value.target);
                try self.validateExpression(value.index);
            },
            .unary => |value| try self.validateExpression(value.operand),
            .binary => |value| {
                try self.validateExpression(value.left);
                try self.validateExpression(value.right);
            },
            .ternary => |value| {
                try self.validateExpression(value.condition);
                try self.validateExpression(value.when_true);
                try self.validateExpression(value.when_false);
            },
            .object => |value| {
                var fields = std.StringHashMap(void).init(self.allocator);

                defer fields.deinit();

                for (value.fields) |field| {
                    if (fields.contains(field.name)) {
                        return self.reporter.fail(field.location, "duplicate object field");
                    }

                    try fields.put(field.name, {});
                    try self.validateExpression(field.value);
                }
            },
            .list => |value| {
                for (value.items) |item| try self.validateExpression(item);
            },
            .call => |value| {
                return self.reporter.fail(
                    value.location,
                    "function calls are not implemented in the pure-function MVP",
                );
            },
        }
    }
};

fn isPrimitive(name: []const u8) bool {
    const names = [_][]const u8{
        "bool",  "string", "void", "u8",  "u16",  "u32", "u64", "u128",
        "i8",    "i16",    "i32",  "i64", "i128", "f16", "f32", "f64",
        "usize", "isize",
    };

    for (names) |primitive| {
        if (std.mem.eql(u8, primitive, name)) return true;
    }

    return false;
}

fn isVoid(value_type: *const ast.TypeNode) bool {
    return switch (value_type.*) {
        .named => |value| std.mem.eql(u8, value.name, "void"),
        else => false,
    };
}

fn isOptional(value_type: *const ast.TypeNode) bool {
    return switch (value_type.*) {
        .optional => true,
        else => false,
    };
}

fn resolveObject(
    value_type: *const ast.TypeNode,
    declarations: *const std.StringHashMap(ast.Declaration),
) ?ast.ObjectType {
    return switch (value_type.*) {
        .object => |value| value,
        .named => |value| {
            const declaration = declarations.get(value.name) orelse return null;

            return switch (declaration) {
                .type_decl => |type_decl| resolveObject(type_decl.value_type, declarations),
                .enum_decl => null,
            };
        },
        else => null,
    };
}

fn hasTypeField(object: ast.ObjectType, name: []const u8) bool {
    for (object.fields) |field| {
        if (std.mem.eql(u8, field.name, name)) return true;
    }

    return false;
}

fn blockAlwaysReturns(statements: []const ast.Statement) bool {
    for (statements) |statement| {
        switch (statement) {
            .return_stmt => return true,
            .if_stmt => |value| {
                if (value.else_body) |else_body| {
                    if (blockAlwaysReturns(value.then_body) and blockAlwaysReturns(else_body)) return true;
                }
            },
            .switch_stmt => |value| {
                var has_default = false;
                var all_return = value.cases.len > 0;

                for (value.cases) |switch_case| {
                    if (switch_case.value == null) has_default = true;

                    all_return = all_return and blockAlwaysReturns(switch_case.body);
                }

                if (has_default and all_return) return true;
            },
            .constant => {},
        }
    }

    return false;
}
