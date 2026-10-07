const std = @import("std");
const ir = @import("zx").ir;
pub const Error = std.mem.Allocator.Error || error{ InvalidAnalysis, InvalidModule, InvalidIr, MissingNominalOrigin };

pub const Signature = struct {
    file_name: []const u8,
    input_type: ir.TypeId,
    output_type: ir.TypeId,
    output_ownership: ir.Ownership,
    external: ?ir.External,
};

pub const Module = struct {
    path: []const u8,
    source_digest: [32]u8,
    dependencies: []const @import("../module_record.zig").Import,
    types: ir.TypeTable,
    nominal_types: @import("../nominal_origins.zig").Table,
    exports: []const ir.Export,
    type_imports: []const ir.Export,
    function_imports: []const @import("../function_import.zig"),
    functions: []const Signature,
    native_modules: ir.NativeModuleTable,
    function: ?ir.Function,
    stores: ir.StoreTable,
};

pub const Result = struct {
    arena: std.heap.ArenaAllocator,
    value: Module,
    pub fn deinit(self: *Result) void {
        self.arena.deinit();

        self.* = undefined;
    }
};
