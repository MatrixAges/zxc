const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Origins = @import("../../nominal_origins.zig");
const Error = @import("../model.zig").Error;
const borrow = @import("../../../ir/canonical/borrow.zig");
const generated = @import("generated_artifact_materialize");
const Nodes = @import("../nodes.zig");
const remap = @import("../nodes/remap.zig");
const Input = std.meta.Child(generated.Input);
const Content = std.meta.Child(@FieldType(Input, "content"));
const Source = std.meta.Child(@typeInfo(@FieldType(Content, "source")).optional.child);
const Output = @typeInfo(@TypeOf(generated.executeValue(undefined, undefined))).error_union.payload;

pub fn materialize(nodes: *const Nodes, program: *const ir.Program, nominal_types: Origins.Table, prepared: @import("run.zig").Prepared, source: ?*const ir.Function) Error!Output {
    const table = ir.TypeTable.borrow(std.meta.Child(@FieldType(Input, "table")), program.types);
    const origins = Origins.Table.borrow(std.meta.Child(@FieldType(Input, "origins")), nominal_types);
    const declarations = borrow.columns(std.meta.Child(@FieldType(Input, "declarations")), ir.SignatureTable.fromFunctions(program.functions));
    const stores = borrow.pointer(@FieldType(Content, "entry_stores"), &program.stores);
    const BodyStores = @typeInfo(@FieldType(Content, "body_stores")).optional.child;
    const mapping = remap.typeMapping(std.meta.Child(@FieldType(Content, "type_mapping")), nodes.types);
    var view: remap.FunctionView(Source) = undefined;

    if (source) |value| view.init(nodes, value, null);

    const content: Content = .{
        .source = if (source != null) &view.input else null,
        .body_stores = if (source) |value| borrow.pointer(BodyStores, &value.stores) else null,
        .entry_stores = stores,
        .type_mapping = &mapping,
        .copy_entry_stores = prepared.body.copy_entry_stores,
    };

    const input: Input = .{
        .table = &table,
        .origins = &origins,
        .declarations = &declarations,
        .modules = borrow.pointer(@FieldType(Input, "modules"), &program.native_modules),
        .plan = prepared.plan,
        .content = &content,
    };

    return zx.columns.invoke(generated.executeValue, nodes.allocator, &input) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => return error.InvalidModule,
    };
}
