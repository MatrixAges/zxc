const Span = @import("source.zig").Span;
const Operator = @import("syntax.zig").Operator;
pub const Name = struct { text: []const u8, span: Span };

pub const Type = union(enum) {
    named: Name,
    object: []const TypeField,
    optional: *const Type,
    list: *const Type,
    tuple: []const *const Type,
    enumeration: []const Name,
    application: struct { name: Name, argument: *const Type },
};

pub const TypeField = struct { name: Name, value: *const Type };
pub const Declaration = struct { name: Name, value: *const Type, span: Span };
pub const Match = struct { subject: ?*const Expression, arms: []const MatchArm, fallback: *const Expression };
pub const MatchArm = struct { condition: *const Expression, result: *const Expression };

pub const Expression = struct {
    span: Span,
    depth: u16,
    value: union(enum) {
        number: []const u8,
        string: []const u8,
        boolean: bool,
        null_value,
        identifier: Name,
        field: struct { target: *const Expression, name: Name },
        index: struct { target: *const Expression, index: *const Expression },
        list: []const *const Expression,
        call: struct { callee: *const Expression, arguments: []const *const Expression, type_argument: ?*const Type = null },
        lambda: struct { parameters: []const Name, body: *const Expression },
        template: []const TemplatePart,
        unary: struct { operator: enum { negate, not }, operand: *const Expression },
        binary: struct { operator: Operator, left: *const Expression, right: *const Expression },
        conditional: struct { condition: *const Expression, yes: *const Expression, no: *const Expression },
        match_expr: Match,
        object: []const Field,
    },
};

pub const Field = struct { name: Name, value: *const Expression, spread: bool = false };
pub const TemplatePart = union(enum) { text: []const u8, expression: *const Expression };

pub const Statement = struct {
    span: Span,
    value: union(enum) {
        constant: struct { name: Name, annotation: ?*const Type = null, value: *const Expression },
        destructure: struct { names: []const Name, value: *const Expression },
        branch: struct { condition: *const Expression, yes: Block, no: ?Block },
        switch_stmt: struct { subject: *const Expression, cases: []const SwitchCase },
        store_set: struct { target: *const Expression, value: *const Expression },
        result: ?*const Expression,
    },
};

pub const Block = struct { span: Span, statements: []const Statement };
pub const SwitchCase = struct { value: ?*const Expression, body: Block, span: Span };

pub const Import = struct {
    kind: enum { type_only, function, enumeration },
    names: []const Name,
    path: []const u8,
    span: Span,
};

pub const Program = struct {
    declarations: []const Declaration,
    imports: []const Import = &.{},
    has_store: bool = false,
    function_start: usize,
    body: ?Block,
};
