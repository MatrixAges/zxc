const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Error = @import("../../artifact/model.zig").Error;

pub fn resolve(
    allocator: std.mem.Allocator,
    modules: ir.NativeModuleTable,
    functions: ir.FunctionTable,
    signature: ir.Signature,
    value: ir.External,
) Error!@typeInfo(@TypeOf(@import("generated_native_link_signature").executeValue(undefined, undefined))).error_union.payload {
    const entry = @import("generated_native_link_signature");
    const Input = std.meta.Child(entry.Input);
    const Ownership = @FieldType(Input, "ownership");
    const natives = zx.columns.columns(std.meta.Child(@FieldType(Input, "modules")), modules);
    const signatures = zx.columns.columns(std.meta.Child(@FieldType(Input, "signatures")), ir.SignatureTable.fromFunctions(functions));
    const external = borrow(std.meta.Child(@FieldType(Input, "value")), value);

    const input: Input = .{
        .modules = &natives,
        .signatures = &signatures,
        .value = &external,
        .input_type = @backingInt(signature.input_type),
        .output_type = @backingInt(signature.output_type),
        .ownership = switch (signature.output_ownership) {
            .copy => Ownership.Copy,
            .borrowed => Ownership.Borrowed,
            .owned => Ownership.Owned,
        },
    };

    return zx.columns.invoke(entry.executeValue, allocator, &input) catch |err| return failure(err);
}

pub fn compatible(allocator: std.mem.Allocator, left: ir.External, right: ir.External) Error!bool {
    const entry = @import("generated_native_signature_compatible");
    const Input = std.meta.Child(entry.Input);
    const External = std.meta.Child(@FieldType(Input, "left"));
    const previous = borrow(External, left);
    const current = borrow(External, right);
    const input: Input = .{ .left = &previous, .right = &current };

    return zx.columns.invoke(entry.executeValue, allocator, &input) catch |err| return failure(err);
}

fn borrow(comptime Target: type, value: ir.External) Target {
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
