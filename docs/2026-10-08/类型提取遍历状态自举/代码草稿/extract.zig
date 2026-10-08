const std = @import("std");
const ir = @import("zx").ir;
const Origins = @import("nominal_data");
const Workspace = @import("extract_workspace_view");
pub const Error = std.mem.Allocator.Error || error{ InvalidModule, MissingNominalOrigin };

pub fn include(workspace: *Workspace, id: ir.TypeId) Error!ir.TypeId {
    const generated = @import("generated_type_extract");
    const Input = @typeInfo(generated.Input).pointer.child;
    const Table = @typeInfo(@FieldType(Input, "table")).pointer.child;
    const Bindings = @typeInfo(@FieldType(Input, "origins")).pointer.child;
    const table = ir.TypeTable.borrow(Table, workspace.source);
    const bindings = Origins.Table.borrow(Bindings, workspace.origins);
    const input: Input = .{ .table = &table, .origins = &bindings, .names = workspace.origins.names, .index = @backingInt(id), .workspace = @ptrCast(workspace), .buffer = @ptrCast(&workspace.references) };
    var arena = std.heap.ArenaAllocator.init(workspace.temporary);

    defer arena.deinit();

    const result = generated.execute(&arena, &input) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => unreachable,
    };

    return switch (result) {
        0 => error.InvalidModule,
        1 => error.MissingNominalOrigin,
        else => @fromBackingInt(@intCast(result - 2)),
    };
}
