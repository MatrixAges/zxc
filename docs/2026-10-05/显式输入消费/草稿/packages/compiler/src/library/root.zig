const std = @import("std");
const frontend = @import("frontend");
const ir = @import("zx").ir;
pub const codec = @import("codec.zig");
pub const PublicReference = @import("load.zig").Export;
pub const load = @import("load.zig").load;
pub const link = @import("link.zig").link;
pub const Initializer = struct { identity: []const u8, schema_version: u32, program: ir.Program };
pub const Input = struct { name: []const u8, analysis: *const frontend.AnalysisResult, initializers: []const Initializer = &.{} };
pub const Export = frontend.project.compiled.Export;

pub const Result = struct {
    arena: std.heap.ArenaAllocator,
    program: ir.Program,
    exports: []const Export,
    nominal_types: @FieldType(frontend.AnalysisResult, "nominal_types"),
    store_initializers: []const frontend.project.compiled.StoreInitializer = &.{},
    pub fn deinit(self: *Result) void {
        self.arena.deinit();

        self.* = undefined;
    }

    pub fn module(self: *const Result, index: usize) error{InvalidModule}!ir.Program {
        if (index >= self.exports.len) return error.InvalidModule;

        const exported = self.exports[index];
        var result = self.program;
        result.file_name = exported.path;
        result.exports = exported.types;

        if (exported.function) |id| {
            const function = result.functions[@intFromEnum(id)];
            result.type_only = false;
            result.input_type = function.input_type;
            result.output_type = function.output_type;
            result.consumes_input = function.consumes_input;
            result.output_ownership = function.output_ownership;
            result.symbols = function.symbols;
            result.expressions = function.expressions;
            result.body = function.body;
            result.contracts = function.contracts;
            result.stores = function.stores;
            result.store_mode = function.store_mode;
        }

        return result;
    }
};
