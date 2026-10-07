const ir = @import("zx").ir;
const borrow = @import("../borrow.zig");

pub fn view(comptime T: type, functions: ir.FunctionTable) T {
    return .{
        .native_modules = functions.native_modules,
        .native_concurrent = functions.native_concurrent,
        .stores = borrow.slice(@FieldType(T, "stores"), functions.stores),
        .expressions = borrow.slice(@FieldType(T, "expressions"), functions.expressions),
    };
}
