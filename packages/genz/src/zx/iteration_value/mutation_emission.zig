const std = @import("std");
const node = @import("../../node.zig");
const rows = @import("../../node/import_rows.zig");
const view = @import("../../node/view.zig");
const Context = @import("root.zig");
const Lower = @import("../lower.zig");
const enabled = @import("genz_options").generated_analysis;
const entry = if (enabled) @import("generated_iteration_mutation") else struct {};
const Input = if (enabled) std.meta.Child(entry.Input) else void;
pub const Mode = if (enabled) @FieldType(Input, "mode") else enum { Push, Pop, Update };
pub const Operand = @import("operand.zig");

pub const Request = struct {
    mode: Mode,
    target: Operand,
    index: Operand,
    value: Operand,
    list_layout: node.ExpressionId,
    result_layout: node.ExpressionId,
};

pub fn lower(context: *Context, args: Request) Lower.Error!node.ExpressionId {
    const self = context.lowering;
    const Binding = std.meta.Child(@FieldType(Input, "target"));
    const Bases = std.meta.Child(@FieldType(Input, "bases"));
    const target: Binding = binding(args.target);
    const index: Binding = binding(args.index);
    const value: Binding = binding(args.value);

    const bases: Bases = .{
        .capture = if (self.capture) |capture| &.{ .name = capture.name, .label = capture.label, .failure = @backingInt(capture.failure) } else null,
        .expression_base = @intCast(self.builder.nodes.expressions.tags.items.len),
        .statement_base = @intCast(self.builder.nodes.statements.tags.items.len),
        .field_base = @intCast(self.builder.nodes.field_columns.count()),
        .serial = self.serial,
    };

    const input: Input = .{
        .mode = args.mode,
        .target = &target,
        .index = &index,
        .value = &value,
        .list_layout = @backingInt(args.list_layout),
        .result_layout = @backingInt(args.result_layout),
        .bases = &bases,
    };

    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var memory = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const temporary = memory.allocator();
    const result = entry.executeIn(temporary, &input) catch |err| return failure(err);

    if (!result.valid) return error.OutOfMemory;

    var expressions = view.join(result.expressions.*, result.forms.*);
    var statements = result.statements.*;
    const block_labels = try temporary.dupe([]const u8, expressions.block_label);
    const break_labels = try temporary.dupe([]const u8, statements.break_value_label);
    const label = try self.allocator.dupe(u8, block_labels[block_labels.len - 1]);
    block_labels[block_labels.len - 1] = label;
    break_labels[break_labels.len - 1] = label;
    expressions.block_label = block_labels;
    statements.break_value_label = break_labels;

    rows.appendBorrowingText(self.allocator, &self.builder.nodes.expressions, &expressions) catch |err| return failure(err);
    rows.appendBorrowed(self.allocator, &self.builder.nodes.statements, &statements) catch |err| return failure(err);

    try self.builder.nodes.field_columns.reserve(self.allocator, result.fields.len);

    for (result.fields) |field| self.builder.nodes.field_columns.append(.{
        .name = field.name,
        .value = @fromBackingInt(field.value),
        .default_value = if (field.default_value) |value_id| @fromBackingInt(value_id) else null,
        .comptime_parameter = field.comptime_parameter,
    });

    self.uses_allocator = self.uses_allocator or result.uses_allocator;
    self.serial = result.serial;

    return @fromBackingInt(result.root);
}

fn binding(value: Operand) std.meta.Child(@FieldType(Input, "target")) {
    return .{ .name = value.name, .value = @backingInt(value.value), .reference = @backingInt(value.reference) };
}

fn failure(err: anyerror) Lower.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => unreachable,
    };
}
