const ir = @import("zx").ir;
const FunctionImport = @import("../function_import.zig");

target: enum { source, compiled, native },
type_only: bool,
types: ir.TypeTable,
exports: []const ir.Export,
members: []const FunctionImport,
