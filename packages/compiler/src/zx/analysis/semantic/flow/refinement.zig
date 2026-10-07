const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const options = @import("parser_options");
const Workspace = @import("flow_workspace");
const borrow = @import("../../../ir/canonical/borrow.zig");
const Self = @This();

state: zx.Refinement = .{},
events: std.ArrayList(Workspace.Event) = .empty,
pub const Mark = zx.Refinement.Mark;

pub fn mark(self: Self) Mark {
    return self.state.mark();
}

pub fn restore(self: *Self, saved: Mark) void {
    self.state.restore(saved);
}

pub fn deinit(self: *Self, allocator: std.mem.Allocator) void {
    self.state.deinit(allocator);
    self.events.deinit(allocator);

    self.* = .{};
}

pub fn bind(self: *Self, allocator: std.mem.Allocator, expressions: ir.ExpressionTable, value: ir.ExprId, symbols: []const ?ir.SymbolId) std.mem.Allocator.Error!void {
    if (comptime !options.generated_parser) return self.state.bind(allocator, expressions.get(value), symbols);

    const generated = @import("generated_refinement_bind");
    const Input = std.meta.Child(generated.Input);

    const input: Input = .{
        .writer = undefined,
        .expressions = borrow.pointer(@FieldType(Input, "expressions"), &expressions),
        .value = @backingInt(value),
        .count = symbols.len,
        .err = if (symbols.len > 0 and symbols[0] != null) @backingInt(symbols[0].?) else null,
        .result = if (symbols.len > 1 and symbols[1] != null) @backingInt(symbols[1].?) else null,
    };

    return self.execute(allocator, generated, input);
}

pub fn assume(self: *Self, allocator: std.mem.Allocator, expressions: ir.ExpressionTable, condition: ir.ExprId, truth: bool) std.mem.Allocator.Error!void {
    if (comptime !options.generated_parser) return self.state.assume(allocator, expressions, condition, truth);

    const generated = @import("generated_refinement_assume");
    const Input = std.meta.Child(generated.Input);

    const input: Input = .{
        .writer = undefined,
        .expressions = borrow.pointer(@FieldType(Input, "expressions"), &expressions),
        .condition = @backingInt(condition),
        .truth = truth,
    };

    return self.execute(allocator, generated, input);
}

pub fn typeOf(self: *const Self, types: ir.TypeTable, id: ir.TypeId, symbol: ir.SymbolId) ir.TypeId {
    if (comptime !options.generated_parser) {
        const target = types.at(@backingInt(id));

        return if (target == .optional and self.state.contains(symbol)) target.optional else id;
    }

    const generated = @import("generated_refinement_type");
    const Input = std.meta.Child(generated.Input);
    const Table = std.meta.Child(@FieldType(Input, "table"));
    const table = ir.TypeTable.borrow(Table, types);
    var storage: [0]u8 = undefined;
    var fixed = std.heap.FixedBufferAllocator.init(&storage);
    var arena = std.heap.ArenaAllocator.init(fixed.allocator());
    var workspace = Workspace{ .allocator = fixed.allocator(), .facts = @constCast(&self.state) };

    defer arena.deinit();

    const input: Input = .{ .writer = @ptrCast(&workspace), .table = &table, .type_id = @backingInt(id), .symbol = @backingInt(symbol) };

    return @fromBackingInt(generated.execute(&arena, &input) catch unreachable);
}

fn execute(self: *Self, allocator: std.mem.Allocator, comptime generated: type, input: std.meta.Child(generated.Input)) std.mem.Allocator.Error!void {
    var workspace = Workspace{ .allocator = allocator, .facts = &self.state, .events = self.events };

    defer {
        self.events = workspace.events;
        workspace.events = .empty;

        workspace.deinit();
    }

    var value = input;

    value.writer = @ptrCast(&workspace);

    var storage: [0]u8 = undefined;
    var fixed = std.heap.FixedBufferAllocator.init(&storage);
    var arena = std.heap.ArenaAllocator.init(fixed.allocator());

    defer arena.deinit();

    generated.execute(&arena, &value) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => unreachable,
    };
}
