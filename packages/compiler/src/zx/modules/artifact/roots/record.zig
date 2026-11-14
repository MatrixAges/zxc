const std = @import("std");
const Record = @import("../../module_record.zig");
const Binding = @import("../../function_import.zig");
const Error = @import("../model.zig").Error;
const generated = @import("generated_artifact_root_bindings");
const Parameter = @typeInfo(@TypeOf(generated.executeValue)).@"fn".param_types[1].?;
const indirect = @typeInfo(Parameter) == .pointer;
const Input = if (indirect) std.meta.Child(Parameter) else Parameter;
const Row = std.meta.Child(@FieldType(Input, "bindings"));
const Columns = std.meta.Child(@typeInfo(@FieldType(Input, "columns")).optional.child);

pub const References = struct {
    types: []u32,
    functions: []u32,
};

pub fn Projection(comptime Target: type) type {
    return struct {
        record: Target,
        references: References,
    };
}

pub fn project(comptime Target: type, allocator: std.mem.Allocator, record: Record) Error!Projection(Target) {
    const Kind = std.meta.Child(@FieldType(Target, "import_kinds"));
    const bindings = [2][]const Binding{ record.function_imports, record.reexports.functions };
    const ordinary_count = try ports(bindings, null);
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
    const dependency_keys = try allocator.alloc([]const u8, record.imports.len);

    for (record.exports, declarations[0..record.exports.len]) |value, *id| id.* = @backingInt(value.type_id);
    for (record.constant_exports, declarations[record.exports.len..][0..record.constant_exports.len]) |value, *id| id.* = @backingInt(value.type_id);
    for (record.constant_imports, declarations[record.exports.len + record.constant_exports.len ..]) |value, *id| id.* = @backingInt(value.type_id);
    for (record.type_imports, type_imports) |value, *id| id.* = @backingInt(value.type_id);

    _ = try ports(bindings, &.{
        .ids = @ptrCast(&function_ids),
        .inputs = @ptrCast(&function_inputs),
        .outputs = @ptrCast(&function_outputs),
    });

    for (record.imports, import_kinds, import_specifiers, dependency_keys) |*value, *kind, *specifier, *key| {
        kind.* = switch (value.target) {
            .source => .Source,
            .native => .Native,
            .external => .External,
            .compiled => .Compiled,
            .intrinsic => .Intrinsic,
        };

        specifier.* = value.specifier;
        key.* = value.identity orelse value.specifier;
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
        .dependency_keys = dependency_keys,
        .has_body = record.body != .types,
        .body_function = if (record.own_function) |id| @backingInt(id) else if (record.body == .function) @backingInt(record.body.function) else null,
    };

    return .{
        .record = view,
        .references = .{ .types = types, .functions = function_ids },
    };
}

fn ports(groups: [2][]const Binding, columns: ?*const Columns) Error!usize {
    const batch_size = @import("../../package_scope.zig").lookup_batch_size;
    var buffer: [batch_size]Row = undefined;
    var empty = std.heap.FixedBufferAllocator.init(&.{});
    var count: u64 = 0;

    for (groups) |group| {
        var remaining = group;

        while (remaining.len != 0) {
            const size = @min(remaining.len, batch_size);

            for (remaining[0..size], buffer[0..size]) |*binding, *row| {
                row.* = .{
                    .id = if (binding.id) |id| @backingInt(id) else null,
                    .input_type = if (binding.input_type) |id| @backingInt(id) else null,
                    .output_type = if (binding.output_type) |id| @backingInt(id) else null,
                    .intrinsic = if (binding.intrinsic) |value| @intFromEnum(value) else null,
                };
            }

            const input: Input = .{ .bindings = buffer[0..size], .columns = columns, .first = count };

            count = (generated.executeValue(empty.allocator(), if (indirect) &input else input) catch |err| switch (err) {
                error.OutOfMemory => return error.OutOfMemory,
                else => return error.InvalidModule,
            }) orelse return error.InvalidModule;

            remaining = remaining[size..];
        }
    }

    return @intCast(count);
}
