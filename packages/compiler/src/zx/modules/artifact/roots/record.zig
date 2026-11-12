const std = @import("std");
const Record = @import("../../module_record.zig");
const Error = @import("../model.zig").Error;

pub const References = struct {
    types: []const u32,
    functions: []const u32,
};

pub fn Projection(comptime Target: type) type {
    return struct {
        record: Target,
        references: References,
    };
}

pub fn project(comptime Target: type, allocator: std.mem.Allocator, record: Record) Error!Projection(Target) {
    const Kind = std.meta.Child(@FieldType(Target, "import_kinds"));
    var ordinary_count: usize = 0;

    for ([_][]const @import("../../function_import.zig"){ record.function_imports, record.reexports.functions }) |bindings| for (bindings) |binding| {
        if (!binding.valid()) return error.InvalidModule;
        if (binding.intrinsic == null) ordinary_count += 1;
    };

    const declaration_count = record.exports.len + record.constant_exports.len + record.constant_imports.len;
    const alias_count = declaration_count + record.type_imports.len;
    const port_count = 2 * ordinary_count;
    const types = try allocator.alloc(u32, alias_count + port_count);
    const declarations = types[0..declaration_count];
    const type_imports = types[declaration_count..alias_count];
    const function_inputs = types[alias_count..][0..ordinary_count];
    const function_outputs = types[alias_count + ordinary_count ..];
    const function_ids = try allocator.alloc(u32, ordinary_count);
    const import_kinds = try allocator.alloc(Kind, record.imports.len);
    const import_specifiers = try allocator.alloc([]const u8, record.imports.len);

    for (record.exports, declarations[0..record.exports.len]) |value, *id| id.* = @backingInt(value.type_id);
    for (record.constant_exports, declarations[record.exports.len..][0..record.constant_exports.len]) |value, *id| id.* = @backingInt(value.type_id);
    for (record.constant_imports, declarations[record.exports.len + record.constant_exports.len ..]) |value, *id| id.* = @backingInt(value.type_id);
    for (record.type_imports, type_imports) |value, *id| id.* = @backingInt(value.type_id);

    var function_index: usize = 0;

    for ([_][]const @import("../../function_import.zig"){ record.function_imports, record.reexports.functions }) |bindings| for (bindings) |value| {
        if (value.intrinsic != null) continue;

        function_ids[function_index] = @backingInt(value.id.?);
        function_inputs[function_index] = @backingInt(value.input_type.?);
        function_outputs[function_index] = @backingInt(value.output_type.?);
        function_index += 1;
    };

    for (record.imports, import_kinds, import_specifiers) |value, *kind, *specifier| {
        kind.* = switch (value.target) {
            .source => .Source,
            .native => .Native,
            .external => .External,
            .compiled => .Compiled,
            .intrinsic => .Intrinsic,
        };

        specifier.* = value.specifier;
    }

    const view: Target = .{
        .path = record.path,
        .start = record.type_range.start,
        .end = record.type_range.end,
        .declaration_types = declarations,
        .type_imports = type_imports,
        .function_ids = function_ids,
        .function_inputs = function_inputs,
        .function_outputs = function_outputs,
        .import_kinds = import_kinds,
        .import_specifiers = import_specifiers,
        .has_body = record.body != .types,
        .body_function = if (record.own_function) |id| @backingInt(id) else if (record.body == .function) @backingInt(record.body.function) else null,
    };

    return .{ .record = view, .references = .{ .types = types, .functions = function_ids } };
}
