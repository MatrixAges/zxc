const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Error = @import("../model.zig").Error;
const materialize = @import("generated_artifact_external_record");

pub fn own(allocator: std.mem.Allocator, value: ir.External, module: ir.NativeModuleId) Error!ir.External {
    const input: std.meta.Child(materialize.Input) = .{
        .members = value.member,
        .errors = value.errors,
        .export_name = value.export_name,
        .parameters = if (value.input) |native| native.names else null,
    };

    const owned = zx.columns.invoke(materialize.executeValue, allocator, &input) catch |err| switch (@as(anyerror, err)) {
        error.OutOfMemory, error.Overflow, error.IntegerOverflow => return error.OutOfMemory,
        else => return error.InvalidModule,
    };

    var result = value;

    result.module = module;
    result.member = owned.members;
    result.errors = owned.errors;
    result.export_name = owned.export_name;
    result.input = if (owned.parameters) |parameters| .{ .names = parameters } else null;

    return result;
}
