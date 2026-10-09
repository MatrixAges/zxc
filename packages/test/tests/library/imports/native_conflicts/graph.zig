const std = @import("std");
const compiler = @import("compiler");
const f = @import("../fixture.zig");
pub const Change = enum { none, namespace_content, namespace_length, binding_name, binding_type };

pub fn graph(allocator: std.mem.Allocator, library: *const compiler.library.Result, change: Change) !compiler.project.compiled.Library {
    try std.testing.expectEqual(@as(usize, 1), library.program.native_modules.count());

    var module = library.program.native_modules.at(0);

    try std.testing.expectEqual(@as(usize, 1), module.types.names.len);
    try std.testing.expectEqualStrings("Mode", module.types.names[0]);

    module.type_namespace = switch (change) {
        .namespace_content => &.{"Right"},
        .namespace_length => &.{},
        else => &.{"Left"},
    };

    module.types = .{
        .names = try allocator.dupe([]const u8, &.{ "Mode", if (change == .binding_name) "Other" else "Scalar" }),
        .type_ids = try allocator.dupe(u32, &.{ module.types.type_ids[0], @backingInt(if (change == .binding_type) compiler.ir.Scalar.u32 else compiler.ir.Scalar.u64) }),
    };

    var result = f.dependency(library);

    result.program.native_modules = try compiler.ir.NativeModuleTable.fromValues(allocator, &.{module});

    try compiler.project.compiled.validate(allocator, .{
        .program = result.program,
        .exports = result.exports,
        .nominal_types = result.nominal_types,
    });

    return result;
}
