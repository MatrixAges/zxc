const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Artifact = @import("../../../artifact/model.zig");

pub fn check(temporary: std.mem.Allocator, module: *const Artifact.Module, current: []const ir.Constant, mapping: []const ir.TypeId, decoded: bool) std.mem.Allocator.Error!bool {
    if (module.constant_imports.len == 0 and (decoded or module.constant_exports.len == 0)) return true;

    const entry = @import("generated_semantic_restore_constants");
    const Input = std.meta.Child(entry.Input);
    const Constants = std.meta.Child(@typeInfo(@FieldType(Input, "unchecked")).optional.child);
    const Tables = std.meta.Child(@FieldType(Constants, "types"));
    const Values = std.meta.Child(@typeInfo(@FieldType(Input, "imports")).optional.child);
    const marshal = @import("../../../../analysis/constants/input.zig").marshal;
    var arena = zx.Arena.init(temporary);

    defer arena.deinit();

    const scratch = arena.allocator();
    const base = ir.TypeTable.borrow(std.meta.Child(@FieldType(Tables, "base")), module.types);
    const delta = ir.TypeTable.borrow(std.meta.Child(@FieldType(Tables, "delta")), .{});
    const types: Tables = .{ .base = &base, .delta = &delta };
    const imports = try marshal(Values, scratch, module.constant_imports);

    const unchecked: Constants = .{
        .types = &types,
        .exports = if (decoded) null else try marshal(Values, scratch, module.constant_exports),
        .imports = imports,
    };

    const input: Input = .{
        .unchecked = if (decoded) null else &unchecked,
        .imports = imports,
        .current = try marshal(Values, scratch, current),
        .mapping = @ptrCast(mapping),
    };

    return entry.executeIn(scratch, &input) catch |err| switch (err) {
        error.OutOfMemory => error.OutOfMemory,
        else => false,
    };
}
