const std = @import("std");
const zx = @import("zx");
const Conditions = @import("conditions.zig");
pub const check = @import("solver.zig").check;

pub const Result = struct {
    arena: std.heap.ArenaAllocator,
    value: union(enum) { query: Conditions.Query, diagnostic: zx.Diagnostic },
    pub fn deinit(self: *Result) void {
        self.arena.deinit();

        self.* = undefined;
    }
};

pub fn generate(allocator: std.mem.Allocator, program: zx.ir.Program) std.mem.Allocator.Error!Result {
    var arena = std.heap.ArenaAllocator.init(allocator);

    errdefer arena.deinit();

    if (try @import("frontend").validateIr(allocator, program)) |issue| return .{ .arena = arena, .value = .{ .diagnostic = issue } };

    var reporter: zx.Reporter = .{};
    var conditions = Conditions{ .allocator = arena.allocator(), .program = program, .reporter = &reporter };

    const query = conditions.generate() catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return .{ .arena = arena, .value = .{ .diagnostic = reporter.diagnostic orelse .{ .code = .contract, .span = .{ .start = 0, .end = 0 }, .message = "invalid symbolic value shape" } } };
    };

    return .{ .arena = arena, .value = .{ .query = query } };
}
