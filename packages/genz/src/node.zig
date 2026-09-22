pub const Expression = union(enum) {
    identifier: []const u8,
    null_value,
    unit,
    undefined_value,
    optional_type: *const Expression,
    tuple_type: []const *const Expression,
    enum_type: []const []const u8,
    enum_literal: []const u8,
    array: struct { element_type: *const Expression, values: []const *const Expression },
    tuple: []const *const Expression,
    index: struct { target: *const Expression, index: *const Expression },
    block: struct { label: []const u8, statements: []const Statement },
    try_value: *const Expression,
    error_union: *const Expression,
    integer: u64,
    float: f64,
    string: []const u8,
    boolean: bool,
    primitive: enum { @"anytype", void, bool, u8, u16, u32, u64, i32, i64, f32, f64 },
    dereference: *const Expression,
    pointer: *const Expression,
    const_pointer: *const Expression,
    const_slice: *const Expression,
    struct_type: []const Field,
    field: struct { target: *const Expression, name: []const u8 },
    unary: struct { operator: enum { negate, not }, operand: *const Expression },
    binary: struct { operator: BinaryOperator, left: *const Expression, right: *const Expression },
    builtin: struct { name: enum { divTrunc, rem, as, setRuntimeSafety, import, intCast, floatCast, enumFromInt, intFromEnum, TypeOf }, arguments: []const *const Expression },
    call: struct { callee: *const Expression, arguments: []const *const Expression },
    conditional: struct { condition: *const Expression, yes: *const Expression, no: *const Expression },
    object: struct { type_expr: *const Expression, fields: []const Field },
};

pub const BinaryOperator = enum {
    add,
    subtract,
    multiply,
    divide,
    equal,
    not_equal,
    less,
    less_equal,
    greater,
    greater_equal,
    logical_and,
    logical_or,
    coalesce,
    pub fn spelling(self: BinaryOperator) []const u8 {
        return switch (self) {
            .add => "+",
            .subtract => "-",
            .multiply => "*",
            .divide => "/",
            .equal => "==",
            .not_equal => "!=",
            .less => "<",
            .less_equal => "<=",
            .greater => ">",
            .greater_equal => ">=",
            .logical_and => "and",
            .logical_or => "or",
            .coalesce => "orelse",
        };
    }
};

pub const Field = struct { name: []const u8, value: *const Expression };
pub const Constant = struct { name: []const u8, type_expr: ?*const Expression = null, value: *const Expression, exported: bool = false };

pub const Statement = union(enum) {
    constant: Constant,
    variable: Constant,
    assignment: struct { target: *const Expression, value: *const Expression },
    for_loop: struct { iterable: *const Expression, capture: []const u8, body: []const Statement },
    break_value: struct { label: []const u8, value: *const Expression },
    unreachable_stmt,
    result: ?*const Expression,
    branch: struct { condition: *const Expression, yes: []const Statement, no: []const Statement },
    discard: *const Expression,
    expression: *const Expression,
};

pub const Function = struct {
    name: []const u8,
    parameters: []const Field,
    return_type: *const Expression,
    body: []const Statement,
    exported: bool = false,
};

pub const Declaration = union(enum) { constant: Constant, function: Function };
