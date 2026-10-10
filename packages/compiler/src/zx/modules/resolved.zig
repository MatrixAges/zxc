const zx = @import("zx");

pub const Input = struct {
    aliases: []const zx.ir.Export,
    imports: []const @import("function_import.zig"),
    functions: zx.ir.FunctionTable,
    verified_functions: zx.ir.FunctionTable = .{},
    store_initializers: []const @import("compiled.zig").StoreInitializer = &.{},
};

pub const valid = @import("resolved/bindings.zig").valid;
