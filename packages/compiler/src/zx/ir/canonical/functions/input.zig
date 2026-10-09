const ir = @import("zx").ir;
const borrow = @import("../borrow.zig");

pub fn view(comptime T: type, functions: ir.FunctionTable) T {
    var result: T = undefined;

    inline for (@typeInfo(T).@"struct".field_names) |name| {
        @field(result, name) = borrow.slice(@FieldType(T, name), @field(functions, name));
    }

    return result;
}
