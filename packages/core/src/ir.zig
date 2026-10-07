pub const containsNativeReference = @import("native_references.zig").contains;
pub const nativeReferenceOwner = @import("native_references.zig").owner;
const Span = @import("source.zig").Span;
pub const Operator = @import("syntax.zig").Operator;
pub const TypeId = @import("type_table/model.zig").TypeId;
pub const SymbolId = enum(u32) { _ };
pub const ExprId = enum(u32) { _ };
pub const FunctionId = enum(u32) { _ };
pub const NativeModuleId = enum(u32) { _ };
pub const Ownership = enum { copy, borrowed, owned };
pub const Scalar = @import("type_table/model.zig").Scalar;
pub const Type = @import("type_table/model.zig").Type;
pub const TypeValue = @import("type_table/value.zig").Value;
pub const TypeTable = @import("type_table/root.zig");
pub const TypeStorage = @import("type_table/storage.zig");
pub const TypeIds = @import("type_table/model.zig").Ids;
pub const TypeFields = @import("type_table/model.zig").Fields;
pub const TypeField = @import("type_table/model.zig").Field;
pub const ExpressionTable = @import("expression_table/model.zig").Table;
pub const ExpressionStorage = @import("expression_table/storage.zig");
pub const ExpressionRow = @import("expression_table/row.zig").Expression;
pub const ScopeRow = @FieldType(@FieldType(ExpressionRow, "value"), "scope");
pub const MatchRow = @FieldType(@FieldType(ExpressionRow, "value"), "match_expr");
pub const SymbolTable = @import("symbol_table/root.zig");
pub const SymbolStorage = @import("symbol_table/storage.zig");
pub const Symbol = struct { name: []const u8, type_id: TypeId, span: Span, ownership: Ownership = .copy };
pub const Export = struct { name: []const u8, type_id: TypeId };
pub const ListOperation = enum { push, pop, sort, reverse, splice, concat };
pub const Transform = struct { kind: enum { map, filter, reduce, every, some }, target: ExprId, parameters: []const SymbolId, body: ExprId, initial: ?ExprId = null };
pub const Projection = struct { target: ExprId, index: u32 };
pub const Match = struct { subject: ?ExprId, arms: []const MatchArm, fallback: ExprId };
pub const MatchArm = struct { condition: ExprId, result: ExprId };
pub const ScopeBinding = struct { symbol: ?SymbolId, value: ExprId, borrow: bool = false };
pub const Scope = struct { bindings: []const ScopeBinding, result: ExprId };
pub const ListUpdate = struct { target: ExprId, index: ExprId, value: ExprId };
pub const Task = struct { body: ExprId, captures: []const SymbolId };
pub const ParallelBranch = struct { task: ExprId, field: ?u32 };

pub const Iteration = struct {
    initial: ExprId,
    condition_parameter: SymbolId,
    parameter: SymbolId,
    condition: ExprId,
    body: ExprId,
    postcondition: bool,
};

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
        capture: ExprId,
        task: Task,
        await_task: ExprId,
        cancel_task: ExprId,
        parallel: []const ParallelBranch,
        optional_value: ExprId,
        enum_value: u32,
        error_value: u32,
        reference: SymbolId,
        store_get: u32,
        field: Projection,
        index: struct { target: ExprId, index: ExprId },
        length: ExprId,
        list: []const ExprId,
        tuple: []const ExprId,
        tuple_field: Projection,
        template: []const ExprId,
        list_operation: struct { kind: ListOperation, target: ExprId, arguments: []const ExprId },
        transform: Transform,
        scope: Scope,
        iteration: Iteration,
        list_update: ListUpdate,
        call: struct { function: FunctionId, argument: ExprId, stores: []const u32 = &.{} },
        unary: struct { operator: enum { negate, not }, operand: ExprId },
        binary: struct { operator: Operator, left: ExprId, right: ExprId },
        conditional: struct { condition: ExprId, yes: ExprId, no: ExprId },
        match_expr: Match,
        object: struct { fields: []const ObjectField, evaluation: []const ExprId },
    },
};

pub const ObjectField = struct { index: u32, value: ExprId };

pub const Statement = union(enum) {
    evaluate: ExprId,
    constant: struct { symbol: SymbolId, value: ExprId },
    parallel: []const ParallelCall,
    destructure: struct { symbols: []const ?SymbolId, value: ExprId },
    branch: struct { condition: ExprId, yes: []const Statement, no: []const Statement },
    switch_stmt: struct { subject: ExprId, cases: []const SwitchCase, exhaustive: bool },
    store_set: struct { slot: u32, value: ExprId },
    result: ?ExprId,
};

pub const ParallelCall = struct { symbol: ?SymbolId, value: ExprId };
pub const SwitchCase = struct { value: ?ExprId, body: []const Statement };
pub const StoreMode = enum { transaction, orchestration };
pub const StoreSlot = struct { path: []const u8, type_id: TypeId, handle: []const u8 = "", readable: bool = true, writable: bool = true };

pub const NativeModule = struct {
    specifier: []const u8,
    import_name: []const u8,
    identity: ?[]const u8 = null,
    type_namespace: []const []const u8 = &.{},
    types: []const Export = &.{},
    pub fn key(self: NativeModule) []const u8 {
        return self.identity orelse self.specifier;
    }
};

pub const NativeType = struct { name: ?[]const u8 = null, children: []const NativeType = &.{} };

pub const External = struct {
    input: ?NativeType = null,
    module: NativeModuleId,
    member: []const []const u8,
    export_name: ?[]const u8 = null,
    allocator_argument: bool = false,
    io_argument: bool = false,
    process_argument: bool = false,
    expand_tuple: bool = false,
    fallible: bool = false,
    errors: ?[]const []const u8 = null,
    concurrent: bool = false,
    pub fn exportName(self: External) []const u8 {
        return self.export_name orelse self.member[self.member.len - 1];
    }
};

pub const Contract = struct {
    kind: @import("syntax.zig").ContractKind,
    symbols: SymbolTable,
    expressions: ExpressionTable,
    predicate: ExprId,
    span: Span,
};

pub const Function = struct {
    stores: []const StoreSlot = &.{},
    store_mode: StoreMode = .transaction,
    output_ownership: Ownership = .borrowed,
    contracts: []const Contract = &.{},
    external: ?External = null,
    file_name: []const u8,
    input_type: TypeId,
    output_type: TypeId,
    symbols: SymbolTable,
    expressions: ExpressionTable,
    body: []const Statement,
};

pub const Program = struct {
    output_ownership: Ownership = .borrowed,
    version: u32 = 27,
    store_mode: StoreMode = .transaction,
    contracts: []const Contract = &.{},
    file_name: []const u8,
    types: TypeTable,
    symbols: SymbolTable,
    expressions: ExpressionTable,
    input_type: TypeId,
    output_type: TypeId,
    body: []const Statement,
    exports: []const Export = &.{},
    functions: []const Function = &.{},
    native_modules: []const NativeModule = &.{},
    stores: []const StoreSlot = &.{},
    type_only: bool = false,
    pub fn typeOf(self: Program, id: TypeId) Type {
        return self.types.get(id);
    }

    pub fn expression(self: Program, id: ExprId) ExpressionRow {
        return self.expressions.get(id);
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
