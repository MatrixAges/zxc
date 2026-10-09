const std = @import("std");
const Record = @import("../../module_record.zig");

pub fn project(comptime Target: type, allocator: std.mem.Allocator, record: Record) std.mem.Allocator.Error!Target {
    const Kind = std.meta.Child(@FieldType(Target, "import_kinds"));
    const exports = try allocator.alloc(u32, record.exports.len);
    const type_imports = try allocator.alloc(u32, record.type_imports.len);
    const function_ids = try allocator.alloc(u32, record.function_imports.len);
    const function_inputs = try allocator.alloc(u32, record.function_imports.len);
    const function_outputs = try allocator.alloc(u32, record.function_imports.len);
    const import_kinds = try allocator.alloc(Kind, record.imports.len);
    const import_specifiers = try allocator.alloc([]const u8, record.imports.len);

    for (record.exports, exports) |value, *id| id.* = @backingInt(value.type_id);
    for (record.type_imports, type_imports) |value, *id| id.* = @backingInt(value.type_id);

    for (record.function_imports, function_ids, function_inputs, function_outputs) |value, *id, *input, *output| {
        id.* = @backingInt(value.id);
        input.* = @backingInt(value.input_type);
        output.* = @backingInt(value.output_type);
    }

    for (record.imports, import_kinds, import_specifiers) |value, *kind, *specifier| {
        kind.* = switch (value.target) {
            .source => .Source,
            .native => .Native,
            .external => .External,
            .compiled => .Compiled,
        };

        specifier.* = value.specifier;
    }

    return .{
        .path = record.path,
        .start = record.type_range.start,
        .end = record.type_range.end,
        .exports = exports,
        .type_imports = type_imports,
        .function_ids = function_ids,
        .function_inputs = function_inputs,
        .function_outputs = function_outputs,
        .import_kinds = import_kinds,
        .import_specifiers = import_specifiers,
        .has_body = record.body != .types,
        .body_function = if (record.body == .function) @backingInt(record.body.function) else null,
    };
}
