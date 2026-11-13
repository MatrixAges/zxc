const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Artifact = @import("../../../artifact/model.zig");

pub fn check(temporary: std.mem.Allocator, module: *const Artifact.Module, current: []const ir.Constant, mapping: []const ir.TypeId) std.mem.Allocator.Error!bool {
    if (module.constant_exports.len == 0 and module.constant_imports.len == 0) return true;

    const entry = @import("generated_semantic_restore_constants");
    const Input = std.meta.Child(entry.Input);
    const Tables = std.meta.Child(@FieldType(Input, "types"));
    const Values = std.meta.Child(@typeInfo(@FieldType(Input, "imports")).optional.child);
    const marshal = @import("../../../../analysis/constants/input.zig").marshal;
    var arena = zx.Arena.init(temporary);

    defer arena.deinit();

    const scratch = arena.allocator();
    const base = ir.TypeTable.borrow(std.meta.Child(@FieldType(Tables, "base")), module.types);
    const delta = ir.TypeTable.borrow(std.meta.Child(@FieldType(Tables, "delta")), .{});
    const types: Tables = .{ .base = &base, .delta = &delta };

    const input: Input = .{
        .types = &types,
        .exports = try marshal(Values, scratch, module.constant_exports),
        .imports = try marshal(Values, scratch, module.constant_imports),
        .current = try marshal(Values, scratch, current),
        .mapping = @ptrCast(mapping),
    };

    return entry.executeIn(scratch, &input) catch |err| switch (err) {
        error.OutOfMemory => error.OutOfMemory,
        else => false,
    };
}
