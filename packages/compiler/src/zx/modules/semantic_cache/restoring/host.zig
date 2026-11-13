const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Record = @import("../../module_record.zig");
const FunctionImport = @import("../../function_import.zig");
const Artifact = @import("../../artifact/model.zig");
const Current = @import("../restore.zig").Current;

pub fn preflight(module: *const Artifact.Module, current: *const Current) bool {
    const generated = @import("generated_semantic_restore_preflight");
    const Input = std.meta.Child(generated.Input);
    const Modules = std.meta.Child(@FieldType(Input, "cached_modules"));
    const Signatures = std.meta.Child(@FieldType(Input, "signatures"));
    const previous_modules = zx.columns.columns(Modules, module.native_modules);
    const current_modules = zx.columns.columns(Modules, current.native_modules);
    const previous_signatures = zx.columns.columns(Signatures, module.functions);

    const input: Input = .{
        .signatures = &previous_signatures,
        .cached_modules = &previous_modules,
        .current_modules = &current_modules,
        .types = module.type_imports.len,
        .current_types = current.aliases.len,
        .functions = module.function_imports.len,
        .current_functions = current.imports.len,
        .constants = module.constant_imports.len,
        .current_constants = current.constant_imports.len,
    };

    return check(generated, &input);
}

pub fn dependencies(previous: []const Record.Import, current: []const Record.Import) bool {
    if (previous.len != current.len) return false;

    const generated = @import("generated_semantic_restore_dependency");
    const Input = std.meta.Child(generated.Input);
    const Row = std.meta.Child(@FieldType(Input, "previous"));

    for (previous, current) |*left, *right| {
        const a = dependency(Row, left);
        const b = dependency(Row, right);
        const input: Input = .{ .previous = &a, .current = &b };

        if (!check(generated, &input)) return false;
    }

    return true;
}

fn dependency(comptime Row: type, value: *const Record.Import) Row {
    const target = &value.target;
    const compiled = if (target.* == .compiled) &target.compiled else null;

    return .{
        .specifier = value.specifier,
        .identity = value.identity orelse value.specifier,
        .names = value.names,
        .source_names = if (value.source_names.len == 0) value.names else value.source_names,
        .kind = @intFromEnum(value.kind),
        .exported = value.exported,
        .wildcard = value.wildcard,
        .target = @intFromEnum(std.meta.activeTag(target.*)),
        .path = switch (target.*) {
            .source => |path| path,
            .compiled => |artifact| artifact.artifact,
            else => "",
        },
        .instance = if (compiled) |artifact| artifact.instance else "",
        .member = if (compiled) |artifact| artifact.name else "",
    };
}

pub fn alias(previous: *const ir.Export, current: *const ir.Export, types: []const ir.TypeId) bool {
    const generated = @import("generated_semantic_restore_alias");

    const input: std.meta.Child(generated.Input) = .{
        .previous_name = previous.name,
        .current_name = current.name,
        .previous_type = @backingInt(previous.type_id),
        .current_type = @backingInt(current.type_id),
        .types = @ptrCast(types),
    };

    return check(generated, &input);
}

pub fn bind(previous: *const FunctionImport, current: *const FunctionImport, mapping: []?ir.FunctionId, types: []const ir.TypeId, current_count: usize) bool {
    const generated = @import("generated_semantic_restore_binding");
    const Input = std.meta.Child(generated.Input);
    const Binding = std.meta.Child(@FieldType(Input, "previous"));
    const left = binding(Binding, previous);
    const right = binding(Binding, current);

    const input: Input = .{
        .previous = &left,
        .current = &right,
        .mapping = @ptrCast(mapping),
        .target = @ptrCast(&mapping),
        .types = @ptrCast(types),
        .current_count = current_count,
    };

    return check(generated, &input);
}

fn binding(comptime Binding: type, value: *const FunctionImport) Binding {
    return .{
        .namespace = value.namespace,
        .name = value.name,
        .id = if (value.id) |id| @backingInt(id) else null,
        .input_type = if (value.input_type) |id| @backingInt(id) else null,
        .output_type = if (value.output_type) |id| @backingInt(id) else null,
        .intrinsic = if (value.intrinsic) |operation| @intFromEnum(operation) else null,
    };
}

pub fn signatures(temporary: std.mem.Allocator, previous: ir.SignatureTable, current: ir.SignatureTable, types: []const ir.TypeId, functions: []const ?ir.FunctionId, modules: []const ?ir.NativeModuleId) Artifact.Error!bool {
    const generated = @import("generated_semantic_restore_signatures");
    const Input = std.meta.Child(generated.Input);
    const Table = std.meta.Child(@FieldType(Input, "previous"));
    const left = zx.columns.columns(Table, previous);
    const right = zx.columns.columns(Table, current);

    const input: Input = .{
        .previous = &left,
        .current = &right,
        .types = @ptrCast(types),
        .functions = @ptrCast(functions),
        .modules = @ptrCast(modules),
    };

    return zx.columns.invoke(generated.executeValue, temporary, &input) catch |err| switch (@as(anyerror, err)) {
        error.OutOfMemory => return error.OutOfMemory,
        else => return error.InvalidModule,
    };
}

fn check(comptime generated: type, input: anytype) bool {
    var empty = std.heap.FixedBufferAllocator.init(&.{});

    return zx.columns.invoke(generated.executeValue, empty.allocator(), input) catch unreachable;
}
