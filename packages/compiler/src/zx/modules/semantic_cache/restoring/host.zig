const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Artifact = @import("../../artifact/model.zig");
const Current = @import("../restore.zig").Current;
pub const constants = @import("constants/host.zig").check;
const imports = @import("imports.zig");
pub const dependencies = imports.dependencies;
pub const rebind = @import("rebind/host.zig").check;

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

fn check(comptime generated: type, input: anytype) bool {
    var empty = std.heap.FixedBufferAllocator.init(&.{});

    return zx.columns.invoke(generated.executeValue, empty.allocator(), input) catch unreachable;
}
