const std = @import("std");
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const rows = @import("../../node/import_rows.zig");
const selection = @import("generated_signature_module_select");
const Variants = std.meta.Child(selection.Output);

pub fn select(external: bool, value_function: bool, pointer_variant: bool) Variants {
    const input: std.meta.Child(selection.Input) = .{
        .external = external,
        .value_function = value_function,
        .pointer_variant = pointer_variant,
    };

    var buffer: [std.heap.page_size_min]u8 = undefined;
    var fixed = std.heap.FixedBufferAllocator.init(&buffer);
    const output = selection.executeIn(fixed.allocator(), &input) catch unreachable;

    return output.*;
}

pub const Prototypes = struct {
    name: []const u8,
    parameter_name: []const u8,
    regular: ?node.Function,
    value: ?node.Function,
};

pub fn append(lower: *Lower, output: *std.ArrayList(node.Declaration), prototypes: Prototypes) Lower.Error!void {
    const entry = @import("generated_signature_module_build");
    const Input = std.meta.Child(entry.Input);
    const Prototype = std.meta.Child(@typeInfo(@FieldType(Input, "regular")).optional.child);
    const nodes = lower.builder.nodes;
    var regular: Prototype = undefined;
    var value: Prototype = undefined;

    const input: Input = .{
        .name = prototypes.name,
        .regular = if (prototypes.regular) |function| try prepare(lower, function, prototypes.parameter_name, &regular) else null,
        .value = if (prototypes.value) |function| try prepare(lower, function, prototypes.parameter_name, &value) else null,
        .expression_base = @intCast(nodes.expressions.tags.items.len),
        .declaration_base = @intCast(nodes.declaration_rows.tags.items.len),
        .statement_base = @intCast(nodes.statements.tags.items.len),
    };

    var scratch = std.heap.ArenaAllocator.init(lower.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var memory = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const result = entry.executeIn(memory.allocator(), &input) catch |err| return failure(err);

    if (!result.valid) return error.OutOfMemory;

    try import(lower, &nodes.expressions, result.expressions);
    try import(lower, &nodes.statements, result.statements);
    try import(lower, &nodes.declaration_rows, result.functions);
    try import(lower, &nodes.declaration_rows, result.aliases);
    @import("../../node/import_constants.zig").appendBorrowingText(lower.allocator, output, result.roots) catch |err| return failure(err);
}

fn prepare(lower: *Lower, function: node.Function, name: []const u8, result: anytype) Lower.Error!@TypeOf(result) {
    const fields = &lower.builder.nodes.field_columns;

    if (function.parameters.len > std.math.maxInt(u32) - fields.count()) return error.OutOfMemory;

    const first: u32 = @intCast(fields.count());

    try fields.reserve(lower.allocator, function.parameters.len);

    for (function.parameters) |field| {
        var parameter = field;
        parameter.name = name;

        fields.append(parameter);
    }

    result.* = .{
        .parameters_start = first,
        .parameters_count = @intCast(function.parameters.len),
        .return_type = @backingInt(function.return_type),
        .abi_export = function.abi_export,
        .calling_convention = if (function.calling_convention) |id| @backingInt(id) else null,
    };

    return result;
}

fn import(lower: *Lower, target: anytype, source: anytype) Lower.Error!void {
    rows.appendBorrowingText(lower.allocator, target, source) catch |err| return failure(err);
}

fn failure(err: anyerror) Lower.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => unreachable,
    };
}
