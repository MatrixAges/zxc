const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Artifact = @import("../../../artifact/model.zig");
const FunctionImport = @import("../../../function_import.zig");
const Current = @import("../../restore.zig").Current;
const imports = @import("../imports.zig");
const generated = @import("generated_semantic_restore_rebind");
const Input = std.meta.Child(generated.Input);
const Aliases = std.meta.Child(@FieldType(Input, "aliases"));
const Bindings = std.meta.Child(@FieldType(Input, "bindings"));
const Alias = std.meta.Child(std.meta.Elem(@FieldType(Aliases, "previous")));
const Binding = std.meta.Child(std.meta.Elem(@FieldType(Bindings, "previous")));
const Signatures = std.meta.Child(@FieldType(Input, "signatures"));
const Modules = std.meta.Child(@FieldType(Input, "modules"));
const Entry = std.meta.Child(@FieldType(Input, "entry"));

pub const Maps = struct {
    types: []const ir.TypeId,
    functions: []?ir.FunctionId,
    natives: []?ir.NativeModuleId,
};

pub fn check(temporary: std.mem.Allocator, module: *const Artifact.Module, current: *const Current, maps: Maps) Artifact.Error!?ir.FunctionId {
    const function_count = module.functions.count();
    const linked_count = current.functions.count();
    const linked = ir.SignatureTable.fromFunctions(current.functions.view());
    const types: []const u32 = @ptrCast(maps.types);
    const functions = maps.functions[0..function_count];
    const SignatureTable = std.meta.Child(@FieldType(Signatures, "previous"));
    const NativeTable = std.meta.Child(@FieldType(Modules, "previous"));
    const previous_signatures = zx.columns.columns(SignatureTable, module.functions);
    const current_signatures = zx.columns.columns(SignatureTable, linked);
    const previous_modules = zx.columns.columns(NativeTable, module.native_modules);
    const current_modules = zx.columns.columns(NativeTable, current.native_modules);

    const signatures: Signatures = .{
        .previous = &previous_signatures,
        .current = &current_signatures,
        .types = types,
        .functions = @ptrCast(functions),
        .modules = @ptrCast(maps.natives),
    };

    const modules: Modules = .{
        .previous = &previous_modules,
        .current = &current_modules,
        .types = types,
        .target = @ptrCast(&maps.natives),
    };

    const entry: Entry = .{
        .has_body = module.function != null,
        .local_count = function_count,
        .linked_count = linked_count,
        .target = @ptrCast(&maps.functions),
    };

    var aliases: imports.Batch(Alias) = undefined;
    var bindings: imports.Batch(Binding) = undefined;
    var alias_offset: usize = 0;
    var binding_offset: usize = 0;
    var bind_modules = maps.natives.len != 0;

    while (true) {
        const alias_end = alias_offset + @min(imports.batch_size, current.aliases.len - alias_offset);
        const aliases_complete = alias_end == current.aliases.len;

        const binding_end = if (aliases_complete)
            binding_offset + @min(imports.batch_size, current.imports.len - binding_offset)

        else
            binding_offset;

        const alias_rows = aliases.project(module.type_imports[alias_offset..alias_end], current.aliases[alias_offset..alias_end], alias);
        const binding_rows = bindings.project(module.function_imports[binding_offset..binding_end], current.imports[binding_offset..binding_end], binding);
        const finish = aliases_complete and binding_end == current.imports.len;
        const alias_view: Aliases = .{ .previous = alias_rows.previous, .current = alias_rows.current, .types = types };

        const binding_view: Bindings = .{
            .previous = binding_rows.previous,
            .current = binding_rows.current,
            .mapping = @ptrCast(functions),
            .target = @ptrCast(&functions),
            .types = types,
            .current_count = linked_count,
        };

        const input: Input = .{
            .aliases = &alias_view,
            .modules = &modules,
            .bindings = &binding_view,
            .signatures = &signatures,
            .entry = &entry,
            .bind_modules = bind_modules,
            .aliases_complete = aliases_complete,
            .finish = finish,
        };

        const status = zx.columns.invoke(generated.executeValue, temporary, &input) catch |err| switch (@as(anyerror, err)) {
            error.OutOfMemory, error.IntegerOverflow, error.Overflow => return error.OutOfMemory,
            else => return error.InvalidModule,
        };

        switch (status) {
            .Invalid => return error.InvalidModule,
            .Full => return error.OutOfMemory,
            .Ready => {},
        }

        if (finish) return if (entry.has_body) maps.functions[function_count] else null;

        alias_offset = alias_end;
        binding_offset = binding_end;

        if (aliases_complete) bind_modules = false;
    }
}

fn alias(comptime Row: type, value: *const ir.Export) Row {
    return .{ .name = value.name, .type_id = @backingInt(value.type_id) };
}

fn binding(comptime Row: type, value: *const FunctionImport) Row {
    return value.borrow(Row);
}
