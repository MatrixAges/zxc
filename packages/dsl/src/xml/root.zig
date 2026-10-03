const std = @import("std");
const ast = @import("../ast.zig");
const diagnostics = @import("../diagnostic.zig");
const Parser = @import("parser.zig");

pub const Result = struct {
    arena: std.heap.ArenaAllocator,
    value: union(enum) { node: ast.Node, diagnostic: diagnostics.Diagnostic },
    pub fn deinit(self: *Result) void {
        self.arena.deinit();

        self.* = undefined;
    }
};

pub fn parse(allocator: std.mem.Allocator, source: []const u8) std.mem.Allocator.Error!Result {
    var arena = std.heap.ArenaAllocator.init(allocator);

    errdefer arena.deinit();

    var reporter: diagnostics.Reporter = .{};

    var parser = Parser{
        .allocator = arena.allocator(),
        .source = try arena.allocator().dupe(u8, source),
        .reporter = &reporter,
    };

    const node = parser.document() catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return .{ .arena = arena, .value = .{ .diagnostic = reporter.diagnostic.? } };
    };

    return .{ .arena = arena, .value = .{ .node = node } };
}
