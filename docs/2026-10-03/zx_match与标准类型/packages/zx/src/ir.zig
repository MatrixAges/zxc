const Span = @import("source.zig").Span;
pub const Operator = @import("syntax.zig").Operator;
pub const TypeId = enum(u32) { _ };
pub const SymbolId = enum(u32) { _ };
pub const ExprId = enum(u32) { _ };
pub const FunctionId = enum(u32) { _ };
pub const Ownership = enum { copy, borrowed, owned };
pub const Scalar = enum { void, bool, u8, u16, u32, u64, i32, i64, f32, f64, string };

pub const Type = union(enum) {
    scalar: Scalar,
    object: []const TypeField,
    optional: TypeId,
    list: TypeId,
    tuple: []const TypeId,
    enumeration: struct { name: []const u8, members: []const []const u8 },
};

pub const TypeField = struct { name: []const u8, type_id: TypeId };
pub const Symbol = struct { name: []const u8, type_id: TypeId, span: Span, ownership: Ownership = .copy };
pub const Export = struct { name: []const u8, type_id: TypeId };
pub const ListOperation = enum { push, pop, sort, reverse, splice, concat };
pub const Transform = struct { kind: enum { map, filter, reduce }, target: ExprId, parameters: []const SymbolId, body: ExprId, initial: ?ExprId = null };
pub const Projection = struct { target: ExprId, index: u32 };
pub const Match = struct { subject: ?ExprId, arms: []const MatchArm, fallback: ExprId };
pub const MatchArm = struct { condition: ExprId, result: ExprId };

pub const Expression = struct {
    type_id: TypeId,
    span: Span,
    value: union(enum) {
        integer: u64,
        negative_integer: u64,
        float: f64,
        string: []const u8,
        boolean: bool,
        none,
        unit,
        some: ExprId,
        enum_value: u32,
        reference: SymbolId,
        store_get: u32,
        field: Projection,
        index: struct { target: ExprId, index: ExprId },
        length: ExprId,
        list: []const ExprId,
        tuple: []const ExprId,
        tuple_field: Projection,
        template: []const ExprId,
        clone: ExprId,
        list_operation: struct { kind: ListOperation, target: ExprId, arguments: []const ExprId },
        transform: Transform,
        call: struct { function: FunctionId, argument: ExprId },
        unary: struct { operator: enum { negate, not }, operand: ExprId },
        binary: struct { operator: Operator, left: ExprId, right: ExprId },
        conditional: struct { condition: ExprId, yes: ExprId, no: ExprId },
        match_expr: Match,
        object: struct { fields: []const ObjectField, evaluation: []const ExprId },
    },
};

pub const ObjectField = struct { index: u32, value: ExprId };

pub const Statement = union(enum) {
    constant: struct { symbol: SymbolId, value: ExprId },
    destructure: struct { symbols: []const ?SymbolId, value: ExprId },
    branch: struct { condition: ExprId, yes: []const Statement, no: []const Statement },
    switch_stmt: struct { subject: ExprId, cases: []const SwitchCase, exhaustive: bool },
    store_set: struct { slot: u32, value: ExprId },
    result: ?ExprId,
};

pub const SwitchCase = struct { value: ?ExprId, body: []const Statement };
pub const StoreSlot = struct { path: []const u8, type_id: TypeId, handle: []const u8 = "", readable: bool = true, writable: bool = true };
pub const External = struct { module: []const u8, member: []const u8, allocator_argument: bool = false, expand_tuple: bool = false, fallible: bool = false };

pub const Function = struct {
    external: ?External = null,
    file_name: []const u8,
    input_type: TypeId,
    output_type: TypeId,
    symbols: []const Symbol,
    expressions: []const Expression,
    body: []const Statement,
};

pub const Program = struct {
    version: u32 = 2,
    file_name: []const u8,
    types: []const Type,
    symbols: []const Symbol,
    expressions: []const Expression,
    input_type: TypeId,
    output_type: TypeId,
    body: []const Statement,
    exports: []const Export = &.{},
    functions: []const Function = &.{},
    stores: []const StoreSlot = &.{},
    type_only: bool = false,
    pub fn typeOf(self: Program, id: TypeId) Type {
        return self.types[@intFromEnum(id)];
    }

    pub fn expression(self: Program, id: ExprId) Expression {
        return self.expressions[@intFromEnum(id)];
    }
};

pub fn terminates(statements: []const Statement) bool {
    if (statements.len == 0) return false;

    return switch (statements[statements.len - 1]) {
        .result => true,
        .branch => |branch| terminates(branch.yes) and terminates(branch.no),
        .switch_stmt => |selection| blk: {
            if (!selection.exhaustive) break :blk false;

            for (selection.cases) |case| if (!terminates(case.body)) {
                break :blk false;
            };

            break :blk true;
        },
        else => false,
    };
}
