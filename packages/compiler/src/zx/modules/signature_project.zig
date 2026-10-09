const std = @import("std");
const zx = @import("zx");
const Origins = @import("nominal_origins.zig");
pub const Ports = @import("source_signature.zig").Ports;

pub const Module = struct {
    path: []const u8,
    signature: @import("source_signature.zig").Result,
    type_imports: []const zx.ir.Export,
    function_imports: []const @import("function_import.zig"),
};

pub const Library = struct { index: usize, exports: []const @import("compiled.zig").Export };

pub const Data = struct {
    types: zx.ir.TypeTable,
    nominal_types: Origins.Table,
    native_modules: zx.ir.NativeModuleTable,
    functions: zx.ir.FunctionTable,
    store_initializers: []const @import("compiled.zig").StoreInitializer,
    modules: []const Module,
    libraries: []const Library,
};

pub const Result = struct {
    arena: std.heap.ArenaAllocator,
    value: union(enum) { data: Data, diagnostic: zx.Diagnostic },
    pub fn deinit(self: *Result) void {
        self.arena.deinit();

        self.* = undefined;
    }
};
