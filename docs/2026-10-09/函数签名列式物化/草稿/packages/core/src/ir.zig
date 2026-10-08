pub const containsNativeReference = @import("native_references.zig").contains;
pub const nativeReferenceOwner = @import("native_references.zig").owner;
const Span = @import("source.zig").Span;
pub const Operator = @import("syntax.zig").Operator;
pub const TypeId = @import("type_table/model.zig").TypeId;
pub const SymbolId = enum(u32) { _ };
pub const ExprId = enum(u32) { _ };
pub const BlockId = enum(u32) { _ };
pub const ControlBody = @import("control_table/root.zig");
pub const ControlTable = @import("control_table/model.zig").Table;
pub const ControlStorage = @import("control_table/storage.zig");
pub const Block = @import("control_table/read.zig").Block;
pub const StatementRow = @import("control_table/read.zig").Statement;
pub const FunctionId = enum(u32) { _ };
pub const Signature = @import("signature_table/model.zig").Signature;
pub const SignatureTable = @import("signature_table/root.zig");
pub const SignatureStorage = @import("signature_table/storage.zig");
pub const FunctionTable = @import("function_table/root.zig");
pub const FunctionStorage = @import("function_table/storage.zig");
pub const NativeModuleId = enum(u32) { _ };
pub const NativeModuleTable = @import("native_module_table/root.zig");
pub const NativeModuleStorage = @import("native_module_table/storage.zig");
pub const NativeBindings = @import("native_module_table/bindings.zig");
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
    branch: struct { condition: ExprId, yes: BlockId, no: BlockId },
    switch_stmt: struct { subject: ExprId, cases: []const SwitchCase, exhaustive: bool },
    store_set: struct { slot: u32, value: ExprId },
    result: ?ExprId,
};

pub const ParallelCall = struct { symbol: ?SymbolId, value: ExprId };
pub const SwitchCase = struct { value: ?ExprId, body: BlockId };
pub const StoreMode = enum { transaction, orchestration };
pub const StoreTable = @import("store_table/root.zig");
pub const StoreStorage = @import("store_table/storage.zig");
pub const StoreSlot = struct { path: []const u8, type_id: TypeId, handle: []const u8 = "", readable: bool = true, writable: bool = true };

pub const NativeModule = struct {
    specifier: []const u8,
    import_name: []const u8,
    identity: ?[]const u8 = null,
    type_namespace: []const []const u8 = &.{},
    types: NativeBindings = .{},
    pub fn key(self: NativeModule) []const u8 {
        return self.identity orelse self.specifier;
    }
};

pub const NativeType = struct { names: []const ?[]const u8 = &.{null} };

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

pub const ContractTable = @import("contract_table/root.zig");
pub const ContractStorage = @import("contract_table/storage.zig");

pub const Contract = struct {
    kind: @import("syntax.zig").ContractKind,
    symbols: SymbolTable,
    expressions: ExpressionTable,
    predicate: ExprId,
    span: Span,
};

pub const Function = struct {
    stores: StoreTable = .{},
    store_mode: StoreMode = .transaction,
    output_ownership: Ownership = .borrowed,
    contracts: ContractTable = .{},
    external: ?External = null,
    file_name: []const u8,
    input_type: TypeId,
    output_type: TypeId,
    symbols: SymbolTable,
    expressions: ExpressionTable,
    body: ControlBody,
};

pub const Program = struct {
    output_ownership: Ownership = .borrowed,
    version: u32 = @import("root.zig").ir_version,
    store_mode: StoreMode = .transaction,
    contracts: ContractTable = .{},
    file_name: []const u8,
    types: TypeTable,
    symbols: SymbolTable,
    expressions: ExpressionTable,
    input_type: TypeId,
    output_type: TypeId,
    body: ControlBody,
    exports: []const Export = &.{},
    functions: FunctionTable = .{},
    native_modules: NativeModuleTable = .{},
    stores: StoreTable = .{},
    type_only: bool = false,
    pub fn typeOf(self: Program, id: TypeId) Type {
        return self.types.get(id);
    }

    pub fn expression(self: Program, id: ExprId) ExpressionRow {
        return self.expressions.get(id);
    }
};

pub fn terminates(statements: Block) bool {
    if (statements.len == 0) return false;

    return switch (statements.at(statements.len - 1)) {
        .result => true,
        .branch => |branch| terminates(branch.yes) and terminates(branch.no),
        .switch_stmt => |selection| blk: {
            if (!selection.exhaustive) break :blk false;

            for (0..selection.cases.len) |index| if (!terminates(selection.cases.at(index).body)) {
                break :blk false;
            };

            break :blk true;
        },
        else => false,
    };
}
