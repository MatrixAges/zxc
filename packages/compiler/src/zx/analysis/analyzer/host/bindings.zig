const std = @import("std");
const ir = @import("zx").ir;
const Analyzer = @import("../../analyzer.zig");
const model = @import("model.zig");

pub fn aliases(allocator: std.mem.Allocator, values: []const ir.Export) std.mem.Allocator.Error!model.Aliases {
    const names = try allocator.alloc([]const u8, values.len);
    const ids = try allocator.alloc(u32, values.len);

    for (values, names, ids) |value, *name, *id| {
        name.* = value.name;
        id.* = @backingInt(value.type_id);
    }

    return .{ .names = names, .ids = ids };
}

pub fn imports(allocator: std.mem.Allocator, values: []const Analyzer.FunctionImport) std.mem.Allocator.Error!model.FunctionImports {
    const namespaces = try allocator.alloc(?[]const u8, values.len);
    const names = try allocator.alloc([]const u8, values.len);
    const ids = try allocator.alloc(u32, values.len);
    const input_types = try allocator.alloc(u32, values.len);
    const output_types = try allocator.alloc(u32, values.len);

    for (values, 0..) |value, index| {
        namespaces[index] = value.namespace;
        names[index] = value.name;
        ids[index] = @backingInt(value.id);
        input_types[index] = @backingInt(value.input_type);
        output_types[index] = @backingInt(value.output_type);
    }

    return .{ .namespaces = namespaces, .names = names, .ids = ids, .input_types = input_types, .output_types = output_types };
}

pub fn stores(allocator: std.mem.Allocator, values: @FieldType(Analyzer, "store_bindings")) std.mem.Allocator.Error!model.StoreBindings {
    const handles = try allocator.alloc([]const u8, values.len);
    const paths = try allocator.alloc([]const u8, values.len);
    const type_names = try allocator.alloc(?[]const u8, values.len);
    const type_ids = try allocator.alloc(?u32, values.len);
    const readable = try allocator.alloc(bool, values.len);
    const writable = try allocator.alloc(bool, values.len);

    for (values, 0..) |value, index| {
        handles[index] = value.handle;
        paths[index] = value.path;
        type_names[index] = value.type_name;
        type_ids[index] = if (value.type_id) |id| @backingInt(id) else null;
        readable[index] = value.readable;
        writable[index] = value.writable;
    }

    return .{ .handles = handles, .paths = paths, .type_names = type_names, .type_ids = type_ids, .readable = readable, .writable = writable };
}
