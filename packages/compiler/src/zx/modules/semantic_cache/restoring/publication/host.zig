const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Artifact = @import("../../../artifact/model.zig");
const Nodes = @import("../../../artifact/nodes.zig");
const remap = @import("../../../artifact/nodes/remap.zig");
const result = @import("../../../link/result/host.zig");
const generated = @import("generated_semantic_restore_publication");
const Input = std.meta.Child(generated.Input);
const Body = std.meta.Child(@typeInfo(@FieldType(Input, "body")).optional.child);
const Mapping = std.meta.Child(@FieldType(Input, "types"));
const Stores = std.meta.Child(@FieldType(Input, "stores"));
const Restored = @import("../../restore.zig").Restored;

pub fn materialize(nodes: *Nodes, module: *const Artifact.Module, tables: result.Tables, candidate: ?ir.FunctionId, structure: Nodes.Structure) Artifact.Error!Restored {
    const source = if (module.function) |*value| value else null;
    var view: remap.FunctionView(Body) = undefined;

    if (source) |value| {
        if (structure == .unchecked and !remap.validFunctionColumns(value)) return error.InvalidModule;

        view.init(nodes, value, candidate);
    }

    const mapping = remap.typeMapping(Mapping, nodes.types);
    const stores = zx.columns.columns(Stores, module.stores);

    const input: Input = .{
        .body = if (source != null) &view.input else null,
        .stores = &stores,
        .reuse_store_types = if (source) |value| sameColumn(module.stores.types, value.stores.types) else false,
        .types = &mapping,
    };

    const prepared = zx.columns.invoke(generated.executeValue, nodes.allocator, &input) catch |err| switch (@as(anyerror, err)) {
        error.OutOfMemory => return error.OutOfMemory,
        else => return error.InvalidModule,
    };

    const plan = prepared orelse return error.InvalidModule;
    const body = if (plan.body) |mapped| try nodes.materializeBody(source.?, mapped, structure) else null;
    const owned = nodes.allocator;
    const store_table = zx.columns.view(ir.StoreTable, plan.stores);
    const surface = @import("../../../artifact/surface.zig");
    const types = remap.typeMapping(surface.Mapping, nodes.types);
    const exported = try surface.copyExports(owned, module.exports, &types);
    const constants = try surface.copyConstants(owned, module.constant_exports, &types);
    const path = try owned.dupe(u8, module.path);

    return .{
        .program = result.program(path, if (body) |*value| value else null, tables, store_table, exported, constants),
        .recursive = if (plan.body) |mapped| if (mapped.recursive) |id| @fromBackingInt(id) else null else null,
    };
}

fn sameColumn(left: []const u32, right: []const u32) bool {
    return left.len == right.len and (left.len == 0 or left.ptr == right.ptr);
}
