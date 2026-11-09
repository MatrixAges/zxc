const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../../node.zig");
const Lower = @import("../../lower.zig");
const Context = @import("root.zig");
const Mode = if (@import("genz_options").generated_analysis) @FieldType(std.meta.Child(@import("generated_loop_fields_projection").Input), "mode") else enum { Initial, Restore, Minimum };

pub fn initial(context: *const Context, lowering: *Lower) Lower.Error!node.ExpressionId {
    return (try build(context, lowering, .Initial, context.seed, context.layout, @fromBackingInt(0))).?;
}

pub fn restore(context: *const Context, lowering: *Lower, state: node.ExpressionId) Lower.Error!node.ExpressionId {
    const layout = try lowering.layoutExpr(context.type_id);

    return (try build(context, lowering, .Restore, state, layout, @fromBackingInt(0))).?;
}

pub fn minimum(context: *const Context, lowering: *Lower, operation: ir.ExprId) Lower.Error!?node.ExpressionId {
    return build(context, lowering, .Minimum, context.seed, @fromBackingInt(0), operation);
}

fn build(context: *const Context, lowering: *Lower, mode: Mode, value: node.ExpressionId, layout: node.ExpressionId, operation: ir.ExprId) Lower.Error!?node.ExpressionId {
    const entry = @import("generated_loop_fields_projection");
    const Input = std.meta.Child(entry.Input);
    const types = ir.TypeTable.borrow(std.meta.Child(@FieldType(Input, "types")), lowering.program.types);

    const input: Input = .{
        .types = &types,
        .type_id = @backingInt(context.type_id),
        .borrowed = context.borrowed,
        .value = @backingInt(value),
        .layout = @backingInt(layout),
        .mode = mode,
        .capacity = if (context.capacity) |capacity| &.{ .operation = @backingInt(capacity.operation), .source = capacity.source } else null,
        .operation = @backingInt(operation),
        .active = lowering.state_active,
        .selected = lowering.state_plan.selected,
        .expression_base = @intCast(lowering.builder.nodes.expressions.tags.items.len),
        .field_base = @intCast(lowering.builder.nodes.field_columns.count()),
    };

    var scratch = std.heap.ArenaAllocator.init(lowering.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var memory = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const result = (entry.executeIn(memory.allocator(), &input) catch |err| return failure(err)) orelse return null;

    if (!result.valid) return error.OutOfMemory;

    var expressions = result.expressions.*;
    var fields = result.fields.*;

    if (result.origin_owned) {
        const names = try memory.allocator().dupe([]const u8, expressions.field_name);
        const field_names = try memory.allocator().dupe([]const u8, fields.name);
        const name = try lowering.allocator.dupe(u8, names[names.len - 1]);

        names[names.len - 1] = name;
        field_names[field_names.len - 1] = name;
        expressions.field_name = names;
        fields.name = field_names;
    }

    @import("../../../node/import_rows.zig").appendBorrowed(lowering.allocator, &lowering.builder.nodes.expressions, &expressions) catch |err| return failure(err);
    _ = @import("../../../node/import_fields.zig").appendBorrowingText(lowering.allocator, &lowering.builder.nodes.field_columns, &fields) catch |err| return failure(err);

    return @fromBackingInt(result.root);
}

fn failure(err: anyerror) Lower.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => unreachable,
    };
}
