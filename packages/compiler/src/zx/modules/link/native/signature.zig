const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Error = @import("../../artifact/model.zig").Error;

pub fn compatible(allocator: std.mem.Allocator, left: ir.External, right: ir.External) Error!bool {
    const entry = @import("generated_native_signature_compatible");
    const Input = std.meta.Child(entry.Input);
    const External = std.meta.Child(@FieldType(Input, "left"));
    const previous = borrow(External, left);
    const current = borrow(External, right);
    const input: Input = .{ .left = &previous, .right = &current };

    return zx.columns.invoke(entry.executeValue, allocator, &input) catch |err| return failure(err);
}

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

fn failure(err: anyerror) Error {
    return if (err == error.OutOfMemory) error.OutOfMemory else error.InvalidModule;
}
