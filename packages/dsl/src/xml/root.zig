const std = @import("std");
const ast = @import("../ast.zig");
const diagnostics = @import("../diagnostic.zig");
const Parser = @import("parser.zig");
pub const ExpressionBoundary = @import("expression.zig").Boundary;
pub const ExpressionReader = @import("expression.zig").Reader;

pub const Result = struct {
    arena: std.heap.ArenaAllocator,
    value: union(enum) { node: ast.Node, diagnostic: diagnostics.Diagnostic },
    pub fn deinit(self: *Result) void {
        self.arena.deinit();

        self.* = undefined;
    }
};

pub fn parse(allocator: std.mem.Allocator, source: []const u8) std.mem.Allocator.Error!Result {
    return parseWith(allocator, source, null);
}

pub fn parseWith(allocator: std.mem.Allocator, source: []const u8, read_expression: ?ExpressionReader) std.mem.Allocator.Error!Result {
    var arena = std.heap.ArenaAllocator.init(allocator);

    errdefer arena.deinit();

    var reporter: diagnostics.Reporter = .{};

    var parser = Parser{
        .allocator = arena.allocator(),
        .source = try arena.allocator().dupe(u8, source),
        .reporter = &reporter,
        .read_expression = read_expression,
    };

    const node = parser.document() catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return .{ .arena = arena, .value = .{ .diagnostic = reporter.diagnostic.? } };
    };

    return .{ .arena = arena, .value = .{ .node = node } };
}
