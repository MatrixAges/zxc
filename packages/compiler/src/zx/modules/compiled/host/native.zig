const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;

pub fn copy(allocator: std.mem.Allocator, source: ir.NativeModule) std.mem.Allocator.Error!ir.NativeModule {
    const entry = @import("generated_artifact_native_record");
    const Input = std.meta.Child(entry.Input);
    const Binding = std.meta.Child(@FieldType(Input, "source"));

    const binding: Binding = .{
        .specifier = source.specifier,
        .identity = source.identity,
        .import_name = source.import_name,
        .namespace = source.type_namespace,
        .names = source.types.names,
        .ids = source.types.type_ids,
    };

    const input: Input = .{ .source = &binding, .mapped_ids = null };
    const owned = zx.columns.invoke(entry.executeValue, allocator, &input) catch return error.OutOfMemory;

    return .{
        .specifier = owned.specifier,
        .identity = owned.identity,
        .import_name = owned.import_name,
        .type_namespace = owned.namespace,
        .types = .{ .names = owned.names, .type_ids = owned.ids },
    };
}

pub fn strings(allocator: std.mem.Allocator, source: []const []const u8) std.mem.Allocator.Error![]const []const u8 {
    const result = try allocator.alloc([]const u8, source.len);

    for (source, result) |text, *owned| owned.* = try allocator.dupe(u8, text);

    return result;
}
