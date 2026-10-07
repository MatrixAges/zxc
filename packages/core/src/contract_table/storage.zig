const std = @import("std");
const ir = @import("../ir.zig");
const Table = @import("root.zig");
const Self = @This();

expressions: std.ArrayList(*const ir.ExpressionTable) = .empty,
kinds: std.ArrayList(Table.Kind) = .empty,
predicates: std.ArrayList(u32) = .empty,
span_end: std.ArrayList(u64) = .empty,
span_start: std.ArrayList(u64) = .empty,
symbols: std.ArrayList(*const ir.SymbolTable) = .empty,
pub fn count(self: *const Self) usize {
    return self.kinds.items.len;
}

pub fn append(self: *Self, allocator: std.mem.Allocator, value: ir.Contract) std.mem.Allocator.Error!void {
    if (self.count() == std.math.maxInt(u32)) return error.OutOfMemory;

    inline for (@typeInfo(Self).@"struct".field_names) |name| try @field(self, name).ensureUnusedCapacity(allocator, 1);

    const symbols = try allocator.create(ir.SymbolTable);

    errdefer allocator.destroy(symbols);

    const expressions = try allocator.create(ir.ExpressionTable);

    errdefer allocator.destroy(expressions);

    symbols.* = value.symbols;
    expressions.* = value.expressions;

    self.kinds.appendAssumeCapacity(switch (value.kind) {
        .requires => .Requires,
        .ensures => .Ensures,
    });

    self.predicates.appendAssumeCapacity(@backingInt(value.predicate));
    self.span_start.appendAssumeCapacity(value.span.start);
    self.span_end.appendAssumeCapacity(value.span.end);
    self.symbols.appendAssumeCapacity(symbols);
    self.expressions.appendAssumeCapacity(expressions);
}

pub fn view(self: *const Self) Table {
    var result: Table = .{};

    inline for (@typeInfo(Self).@"struct".field_names) |name| @field(result, name) = @field(self, name).items;

    return result;
}

pub fn finish(self: *Self, allocator: std.mem.Allocator) std.mem.Allocator.Error!Table {
    var result: Table = .{};

    errdefer {
        for (result.symbols) |value| allocator.destroy(value);
        for (result.expressions) |value| allocator.destroy(value);

        inline for (@typeInfo(Table).@"struct".field_names) |name| allocator.free(@field(result, name));
        self.deinit(allocator);
    }

    inline for (@typeInfo(Self).@"struct".field_names) |name| @field(result, name) = try @field(self, name).toOwnedSlice(allocator);

    return result;
}

pub fn deinit(self: *Self, allocator: std.mem.Allocator) void {
    for (self.symbols.items) |value| allocator.destroy(value);
    for (self.expressions.items) |value| allocator.destroy(value);

    inline for (@typeInfo(Self).@"struct".field_names) |name| @field(self, name).deinit(allocator);

    self.* = .{};
}
