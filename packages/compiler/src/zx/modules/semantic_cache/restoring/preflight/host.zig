const std = @import("std");
const zx = @import("zx");
const Artifact = @import("../../../artifact/model.zig");
const Current = @import("../../restore.zig").Current;
const imports = @import("../imports.zig");
const generated = @import("generated_semantic_restore_preflight");
const Input = std.meta.Child(generated.Input);
const Modules = std.meta.Child(@FieldType(Input, "cached_modules"));
const Signatures = std.meta.Child(@FieldType(Input, "signatures"));
const Dependencies = std.meta.Child(@FieldType(Input, "dependencies"));
const Dependency = std.meta.Child(std.meta.Elem(@FieldType(Dependencies, "previous")));
const Control = std.meta.Child(@typeInfo(@FieldType(Input, "control")).optional.child);

pub fn check(temporary: std.mem.Allocator, module: *const Artifact.Module, current: *const Current, decoded: bool) std.mem.Allocator.Error!bool {
    const previous_modules = zx.columns.columns(Modules, module.native_modules);
    const current_modules = zx.columns.columns(Modules, current.native_modules);
    const previous_signatures = zx.columns.columns(Signatures, module.functions);
    var batch: imports.Batch(Dependency) = undefined;
    var control: Control = undefined;
    const unchecked = if (decoded) null else if (module.function) |*body| body else null;

    if (unchecked) |body| {
        control = .{
            .control = zx.columns.pointer(@FieldType(Control, "control"), body.body.control),
            .root = if (body.body.root) |root| @backingInt(root) else null,
        };
    }

    const comparable = module.dependencies.len == current.dependencies.len;
    var offset: usize = 0;

    while (true) {
        const end = if (comparable) offset + @min(imports.batch_size, module.dependencies.len - offset) else 0;
        const finish = end == module.dependencies.len;
        const rows = batch.project(module.dependencies[offset..end], current.dependencies[offset..end], imports.dependency);
        const dependencies: Dependencies = .{ .previous = rows.previous, .current = rows.current };

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
            .members = module.members.len,
            .current_members = current.members.len,
            .decoded = decoded,
            .verified_native = current.verified.native,
            .first = offset == 0,
            .dependency_count = module.dependencies.len,
            .current_dependency_count = current.dependencies.len,
            .dependencies = &dependencies,
            .finish = finish,
            .control = if (unchecked != null) &control else null,
        };

        const valid = zx.columns.invoke(generated.executeValue, temporary, &input) catch |err| switch (@as(anyerror, err)) {
            error.OutOfMemory, error.Overflow => return error.OutOfMemory,
            else => false,
        };

        if (!valid or finish) return valid;

        offset = end;
    }
}
