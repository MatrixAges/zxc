const zx = @import("zx");
const Context = @import("context.zig");

pub const Symbols = struct {
    target: @FieldType(Context, "target"),
    types: zx.ir.TypeTable,
    exports: []const zx.ir.Export,
    constants: []const zx.ir.Constant,
    functions: []const []const u8,
};

pub const Bindings = struct {
    names: []const []const u8,
    indices: []const u64,
};

pub const Selection = struct {
    aliases: Bindings,
    constants: Bindings,
    functions: Bindings,
    namespace: ?[]const u8,
};
