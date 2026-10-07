const std = @import("std");
const ir = @import("../ir.zig");
const Self = @This();
pub const Kind = enum { Requires, Ensures };

expressions: []const *const ir.ExpressionTable = &.{},
kinds: []const Kind = &.{},
predicates: []const u32 = &.{},
span_end: []const u64 = &.{},
span_start: []const u64 = &.{},
symbols: []const *const ir.SymbolTable = &.{},
pub fn count(self: Self) usize {
    return self.kinds.len;
}

pub fn at(self: Self, index: usize) ir.Contract {
    return .{
        .kind = switch (self.kinds[index]) {
            .Requires => .requires,
            .Ensures => .ensures,
        },
        .symbols = self.symbols[index].*,
        .expressions = self.expressions[index].*,
        .predicate = @fromBackingInt(self.predicates[index]),
        .span = .{ .start = @intCast(self.span_start[index]), .end = @intCast(self.span_end[index]) },
    };
}

pub fn validStructure(self: Self) bool {
    if (self.count() > std.math.maxInt(u32)) return false;

    inline for (@typeInfo(Self).@"struct".field_names) |name| {
        if (@field(self, name).len != self.count()) return false;
    }

    for (self.span_start, self.span_end) |start, end| {
        if (start > std.math.maxInt(usize) or end > std.math.maxInt(usize)) return false;
    }

    return true;
}

pub fn fromValues(allocator: std.mem.Allocator, values: []const ir.Contract) std.mem.Allocator.Error!Self {
    var storage: @import("storage.zig") = .{};

    errdefer storage.deinit(allocator);

    for (values) |value| try storage.append(allocator, value);

    return storage.finish(allocator);
}
