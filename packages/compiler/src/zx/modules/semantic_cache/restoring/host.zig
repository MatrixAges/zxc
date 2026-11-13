const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Artifact = @import("../../artifact/model.zig");
const Current = @import("../restore.zig").Current;
pub const constants = @import("constants/host.zig").check;
const imports = @import("imports.zig");
pub const dependencies = imports.dependencies;
pub const aliases = imports.aliases;
pub const bindings = imports.bindings;

pub fn preflight(module: *const Artifact.Module, current: *const Current, decoded: bool) bool {
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
        .decoded = decoded,
    };

    return check(generated, &input);
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

pub fn bindModules(temporary: std.mem.Allocator, previous: ir.NativeModuleTable, current: ir.NativeModuleTable, types: []const ir.TypeId, mapping: []?ir.NativeModuleId) Artifact.Error!bool {
    if (mapping.len == 0) return true;

    const entry = @import("generated_semantic_restore_modules");
    const Input = std.meta.Child(entry.Input);
    const Table = std.meta.Child(@FieldType(Input, "previous"));
    const left = zx.columns.columns(Table, previous);
    const right = zx.columns.columns(Table, current);

    const input: Input = .{
        .previous = &left,
        .current = &right,
        .types = @ptrCast(types),
        .target = @ptrCast(&mapping),
    };

    return zx.columns.invoke(entry.executeValue, temporary, &input) catch |err| switch (@as(anyerror, err)) {
        error.OutOfMemory, error.Overflow, error.IntegerOverflow => return error.OutOfMemory,
        else => return error.InvalidModule,
    };
}

pub fn own(mapping: []?ir.FunctionId, local_count: usize, linked_count: usize, has_body: bool) Artifact.Error!?ir.FunctionId {
    const entry = @import("generated_semantic_restore_own");

    const input: std.meta.Child(entry.Input) = .{
        .has_body = has_body,
        .local_count = local_count,
        .linked_count = linked_count,
        .target = @ptrCast(&mapping),
    };

    var empty = std.heap.FixedBufferAllocator.init(&.{});

    const id = zx.columns.invoke(entry.executeValue, empty.allocator(), &input) catch |err| switch (@as(anyerror, err)) {
        error.OutOfMemory, error.IntegerOverflow => return error.OutOfMemory,
        else => return error.InvalidModule,
    };

    const value = id orelse return null;

    if (value == std.math.maxInt(u32)) return error.OutOfMemory;

    return @fromBackingInt(value);
}

fn check(comptime generated: type, input: anytype) bool {
    var empty = std.heap.FixedBufferAllocator.init(&.{});

    return zx.columns.invoke(generated.executeValue, empty.allocator(), input) catch unreachable;
}
