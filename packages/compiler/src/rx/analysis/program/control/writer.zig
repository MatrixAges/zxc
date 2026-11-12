const std = @import("std");
const ir = @import("zx").ir;
const Plan = @import("plan.zig");
const Counts = Plan.Counts;
const Kind = std.meta.Child(@FieldType(ir.ControlTable, "statement_kinds"));
const Error = @import("../builder.zig").Error;
const Self = @This();

pub const Cursor = struct {
    counts: Counts,
    statement: u32,
    pub fn init(first: Counts) Cursor {
        return .{ .counts = first, .statement = @intCast(first.statements()) };
    }
};

columns: ir.ControlStorage = .{},
pub fn init(allocator: std.mem.Allocator, size: Counts, blocks: u32) std.mem.Allocator.Error!Self {
    var writer: Self = .{};

    errdefer writer.columns.deinit(allocator);

    try writer.allocate(allocator, &.{ "statement_kinds", "statement_payloads" }, @intCast(size.statements()));
    try writer.allocate(allocator, &.{"evaluations"}, size.evaluations);
    try writer.allocate(allocator, &.{ "constant_symbols", "constant_values" }, size.constants);
    try writer.allocate(allocator, &.{ "parallel_first", "parallel_count" }, size.parallels);
    try writer.allocate(allocator, &.{ "parallel_symbols", "parallel_values" }, size.invocations);
    try writer.allocate(allocator, &.{ "selection_subjects", "selection_first", "selection_count", "selection_exhaustive" }, size.selections);
    try writer.allocate(allocator, &.{ "case_values", "case_bodies" }, size.cases);
    try writer.allocate(allocator, &.{"results"}, size.results);
    try writer.allocate(allocator, &.{ "block_first", "block_count" }, blocks);

    return writer;
}

pub fn evaluate(self: *Self, cursor: *Cursor, value: ir.ExprId) void {
    const row = cursor.counts.evaluations;
    self.columns.evaluations.items[row] = @backingInt(value);
    cursor.counts.evaluations += 1;

    self.header(cursor, .Evaluate, row);
}

pub fn constant(self: *Self, cursor: *Cursor, symbol: ir.SymbolId, value: ir.ExprId) void {
    const row = cursor.counts.constants;

    self.columns.constant_symbols.items[row] = @backingInt(symbol);
    self.columns.constant_values.items[row] = @backingInt(value);
    cursor.counts.constants += 1;

    self.header(cursor, .Constant, row);
}

pub fn result(self: *Self, cursor: *Cursor, value: ?ir.ExprId) void {
    const row = cursor.counts.results;

    self.columns.results.items[row] = if (value) |id| @backingInt(id) else null;
    cursor.counts.results += 1;

    self.header(cursor, .Result, row);
}

pub fn parallelBranch(self: *Self, position: usize, symbol: ?ir.SymbolId, value: ir.ExprId) void {
    self.columns.parallel_symbols.items[position] = if (symbol) |id| @backingInt(id) else null;
    self.columns.parallel_values.items[position] = @backingInt(value);
}

pub fn parallel(self: *Self, cursor: *Cursor, count: usize) void {
    const row = cursor.counts.parallels;

    self.columns.parallel_first.items[row] = cursor.counts.invocations;
    self.columns.parallel_count.items[row] = @intCast(count);
    cursor.counts.invocations += @intCast(count);
    cursor.counts.parallels += 1;

    self.header(cursor, .Parallel, row);
}

pub fn selectionCase(self: *Self, position: usize, value: ?ir.ExprId, body: ir.BlockId) void {
    self.columns.case_values.items[position] = if (value) |id| @backingInt(id) else null;
    self.columns.case_bodies.items[position] = @backingInt(body);
}

pub fn selection(self: *Self, cursor: *Cursor, subject: ir.ExprId, count: usize, exhaustive: bool) void {
    const row = cursor.counts.selections;

    self.columns.selection_subjects.items[row] = @backingInt(subject);
    self.columns.selection_first.items[row] = cursor.counts.cases;
    self.columns.selection_count.items[row] = @intCast(count);
    self.columns.selection_exhaustive.items[row] = exhaustive;
    cursor.counts.cases += @intCast(count);
    cursor.counts.selections += 1;

    self.header(cursor, .Switch, row);
}

pub fn block(self: *Self, row: Plan.Row, cursor: Cursor, end: Counts) Error!ir.BlockId {
    if (!std.meta.eql(cursor.counts, end) or cursor.statement != end.statements()) return error.InvalidModule;

    const first: u32 = @intCast(row.first.statements());

    self.columns.block_first.items[row.tag] = first;
    self.columns.block_count.items[row.tag] = cursor.statement - first;

    return @fromBackingInt(row.tag);
}

fn header(self: *Self, cursor: *Cursor, kind: Kind, payload: u32) void {
    const statement = cursor.statement;

    self.columns.statement_kinds.items[statement] = kind;
    self.columns.statement_payloads.items[statement] = payload;
    cursor.statement += 1;
}

fn allocate(self: *Self, allocator: std.mem.Allocator, comptime names: []const []const u8, count: usize) std.mem.Allocator.Error!void {
    if (count == 0) return;

    inline for (names) |name| {
        const list = &@field(self.columns, name);

        list.items = try allocator.alloc(std.meta.Child(@TypeOf(list.items)), count);
        list.capacity = count;
    }
}
