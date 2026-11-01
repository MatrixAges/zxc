const zx = @import("zx");

pub const Input = struct {
    aliases: []const zx.ir.Export,
    imports: []const @import("function_import.zig"),
    constant_imports: []const zx.ir.Constant = &.{},
    functions: zx.ir.FunctionTable,
    verified_functions: zx.ir.FunctionTable = .{},
    store_initializers: []const @import("compiled.zig").StoreInitializer = &.{},
};

pub const valid = @import("resolved/bindings.zig").valid;
