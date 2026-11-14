const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Nodes = @import("../../nodes.zig");
const Error = @import("../../model.zig").Error;
const owned = @import("generated_artifact_owned_stores");
const remapped = @import("generated_artifact_remap_stores");

pub fn own(allocator: std.mem.Allocator, source: *const ir.StoreTable, types: []const u32) Error!ir.StoreTable {
    if (source.count() == 0) return .{};

    const Input = std.meta.Child(owned.Input);
    const Source = @FieldType(Input, "source");
    const input: Input = .{ .source = zx.columns.pointer(Source, source), .types = types };
    const result = zx.columns.invoke(owned.executeValue, allocator, &input) catch |err| return failure(err);

    return zx.columns.view(ir.StoreTable, result);
}

pub fn remap(nodes: *const Nodes, source: *const ir.StoreTable) Error!ir.StoreTable {
    const Input = std.meta.Child(remapped.Input);
    const Source = @FieldType(Input, "source");
    const Mapping = std.meta.Child(@FieldType(Input, "mapping"));
    const mapping = @import("../../nodes/remap.zig").typeMapping(Mapping, nodes.types);
    const input: Input = .{ .source = zx.columns.pointer(Source, source), .mapping = &mapping };
    const result = zx.columns.invoke(remapped.executeValue, nodes.allocator, &input) catch |err| return failure(err);

    return zx.columns.view(ir.StoreTable, result orelse return error.InvalidModule);
}

fn failure(err: anyerror) Error {
    return if (err == error.OutOfMemory) error.OutOfMemory else error.InvalidModule;
}
