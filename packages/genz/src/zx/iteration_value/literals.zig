const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const rows = @import("../../node/import_rows.zig");
const view = @import("../../node/view.zig");
const Context = @import("root.zig");
const Lower = @import("../lower.zig");
const Operand = @import("operand.zig");
const enabled = @import("genz_options").generated_analysis;
const entry = if (enabled) @import("generated_iteration_literals") else struct {};
const Input = if (enabled) std.meta.Child(entry.Input) else void;
pub const Mode = if (enabled) @FieldType(Input, "mode") else enum { Object, Tuple, List };

pub const Bindings = struct {
    names: [][]const u8,
    values: []u32,
    references: []u32,
    pub fn init(allocator: std.mem.Allocator, count: usize) Lower.Error!Bindings {
        return .{
            .names = try allocator.alloc([]const u8, count),
            .values = try allocator.alloc(u32, count),
            .references = try allocator.alloc(u32, count),
        };
    }

    pub fn set(self: Bindings, index: usize, value: Operand) void {
        self.names[index] = value.name;
        self.values[index] = @backingInt(value.value);
        self.references[index] = @backingInt(value.reference);
    }
};

pub const Request = struct {
    mode: Mode,
    type_id: ir.TypeId,
    layout: node.ExpressionId,
    element: node.ExpressionId = @fromBackingInt(0),
    bindings: Bindings,
    field_indices: []const u32 = &.{},
    field_values: []const u32 = &.{},
    evaluation: []const ir.ExprId = &.{},
    prior: []const u64 = &.{},
};

pub noinline fn lower(context: *Context, args: Request) Lower.Error!node.ExpressionId {
    const self = context.lowering;
    const Prepared = std.meta.Child(@FieldType(Input, "bindings"));
    const Counter = std.meta.Child(@FieldType(Input, "reads"));
    const Index = std.meta.Child(@FieldType(Counter, "index"));
    const Bases = std.meta.Child(@FieldType(Input, "bases"));
    const types = ir.TypeTable.borrow(std.meta.Child(@FieldType(Input, "types")), self.program.types);
    const prepared: Prepared = .{ .names = args.bindings.names, .values = args.bindings.values, .references = args.bindings.references };
    const index: Index = .{ .count = context.reads.state.index.count, .keys = context.reads.state.index.keys.items, .buckets = context.reads.state.index.buckets.items };
    const reads: Counter = .{ .index = &index, .values = context.reads.state.values.items };

    const bases: Bases = .{
        .capture = if (self.capture) |capture| &.{ .name = capture.name, .label = capture.label, .failure = @backingInt(capture.failure) } else null,
        .expression_base = @intCast(self.builder.nodes.expressions.tags.items.len),
        .statement_base = @intCast(self.builder.nodes.statements.tags.items.len),
        .field_base = @intCast(self.builder.nodes.field_columns.count()),
        .serial = self.serial,
    };

    comptime std.debug.assert(@typeInfo(ir.ExprId).@"enum".tag_type == u32);

    const input: Input = .{
        .mode = args.mode,
        .types = &types,
        .type_id = @backingInt(args.type_id),
        .layout = @backingInt(args.layout),
        .element = @backingInt(args.element),
        .bindings = &prepared,
        .field_indices = args.field_indices,
        .field_values = args.field_values,
        .evaluation = @as([*]const u32, @ptrCast(args.evaluation.ptr))[0..args.evaluation.len],
        .prior = args.prior,
        .reads = &reads,
        .bases = &bases,
    };

    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var memory = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const output = entry.executeIn(memory.allocator(), &input) catch |err| return failure(err);
    const block = output.block orelse return error.OutOfMemory;

    if (!block.valid) return error.OutOfMemory;

    const literal = output.literal;
    const expressions = view.join(literal.expressions.*, literal.forms.*);

    rows.appendBorrowingText(self.allocator, &self.builder.nodes.expressions, &expressions) catch |err| return failure(err);

    try @import("../../node/import_fields.zig").appendObject(self.allocator, &self.builder.nodes.field_columns, literal.fields);

    const label = try self.allocator.dupe(u8, block.name);
    const labels = [_][]const u8{label};
    var block_expressions = block.expressions.*;
    var block_statements = block.statements.*;
    block_expressions.block_label = &labels;
    block_statements.break_value_label = &labels;

    rows.appendBorrowed(self.allocator, &self.builder.nodes.statements, literal.statements) catch |err| return failure(err);
    rows.appendBorrowed(self.allocator, &self.builder.nodes.statements, &block_statements) catch |err| return failure(err);
    rows.appendBorrowed(self.allocator, &self.builder.nodes.expressions, &block_expressions) catch |err| return failure(err);

    self.uses_allocator = self.uses_allocator or literal.uses_allocator;
    self.serial = block.serial;

    return @fromBackingInt(block.root);
}

fn failure(err: anyerror) Lower.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => unreachable,
    };
}
