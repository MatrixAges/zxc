const std = @import("std");
const node = @import("../../node.zig");
const Builder = @import("../../builder.zig");
const Object = @import("../state.zig").Object;
const zx = @import("zx");
const view = @import("../../node/view.zig");

pub fn writable(objects: []const Object) bool {
    if (@import("genz_options").generated_analysis) return policy(objects) != .ReadOnly;
    for (objects) |object| if (object.writable) return true;

    return false;
}

pub fn reclaimable(objects: []const Object) bool {
    if (@import("genz_options").generated_analysis) return policy(objects) == .Independent;
    for (objects) |object| if (object.writable and !object.independent) return false;

    return writable(objects);
}

fn policy(objects: []const Object) @typeInfo(@typeInfo(@TypeOf(@import("generated_store_lifecycle_policy").executeValue)).@"fn".return_type.?).error_union.payload {
    const entry = @import("generated_store_lifecycle_policy");
    const Parameter = @typeInfo(@TypeOf(entry.executeValue)).@"fn".param_types[1].?;
    const indirect = @typeInfo(Parameter) == .pointer;
    const Input = if (indirect) std.meta.Child(Parameter) else Parameter;

    const input: Input = .{
        .objects = @import("zx").columns.slice(@FieldType(Input, "objects"), objects),
    };

    var memory = std.heap.FixedBufferAllocator.init(&.{});

    return entry.executeValue(memory.allocator(), if (indirect) &input else input) catch unreachable;
}

pub fn lower(builder: Builder, declarations: *std.ArrayList(node.Declaration), objects: []const Object) std.mem.Allocator.Error!void {
    if (!@import("genz_options").generated_analysis) return @import("storage_seed.zig").lower(builder, declarations, objects);

    const entry = @import("generated_store_storage");
    const Parameter = @typeInfo(@TypeOf(entry.executeValue)).@"fn".param_types[1].?;
    const indirect = @typeInfo(Parameter) == .pointer;
    const Input = if (indirect) std.meta.Child(Parameter) else Parameter;
    const Bases = std.meta.Child(@FieldType(Input, "bases"));
    const first = builder.nodes.declaration_rows.tags.items.len;

    const bases: Bases = .{
        .capture = null,
        .expression_base = @intCast(builder.nodes.expressions.tags.items.len),
        .statement_base = @intCast(builder.nodes.statements.tags.items.len),
        .field_base = @intCast(builder.nodes.field_columns.count()),
        .serial = 0,
    };

    const input: Input = .{
        .objects = zx.columns.slice(@FieldType(Input, "objects"), objects),
        .bases = &bases,
        .declaration_base = @intCast(first),
    };

    var scratch = std.heap.ArenaAllocator.init(builder.allocator);

    defer scratch.deinit();

    const output = entry.executeValue(scratch.allocator(), if (indirect) &input else input) catch |err| return failure(err);

    if (!output.valid) return error.OutOfMemory;

    const Output = std.meta.Child(entry.Output);
    const Context = std.meta.Child(@FieldType(Output, "context"));
    const context = output.context;
    const expressions = zx.columns.view(std.meta.Child(@FieldType(Context, "expressions")), context.expressions);
    const forms = zx.columns.view(std.meta.Child(@FieldType(Context, "forms")), context.forms);
    const extra = zx.columns.view(std.meta.Child(@FieldType(Output, "extra")), output.extra);
    const columns = zx.columns.view(std.meta.Child(@FieldType(Output, "declarations")), output.declarations);
    const values = view.join(view.join(expressions, forms), extra);
    const rows = @import("../../node/import_rows.zig");

    rows.append(builder.allocator, &builder.nodes.expressions, &values) catch |err| return failure(err);
    rows.append(builder.allocator, &builder.nodes.declaration_rows, &columns) catch |err| return failure(err);
    for (first..builder.nodes.declaration_rows.tags.items.len) |index| try declarations.append(builder.allocator, try builder.nodes.materializeDeclaration(builder.allocator, @intCast(index)));
}

fn failure(err: anyerror) std.mem.Allocator.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => @panic("invalid Store storage AST"),
    };
}
