const ir = @import("zx").ir;

pub fn borrow(comptime Target: type, value: ir.External) Target {
    return .{
        .module_id = @backingInt(value.module),
        .member = value.member,
        .export_name = value.export_name,
        .input = if (value.input) |native_type| native_type.names else null,
        .allocator_argument = value.allocator_argument,
        .io_argument = value.io_argument,
        .process_argument = value.process_argument,
        .expand_tuple = value.expand_tuple,
        .fallible = value.fallible,
    };
}
