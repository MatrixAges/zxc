const std = @import("std");

pub const Values = struct { callees: []const u32, variants: []const []const []const u8 };
pub const Scope = struct { copies: []const u32, stubs: Values };
pub const Plan = struct { scopes: []const Scope, exports: Values };

pub const Input = struct {
    owners: []const u32,
    callees: []const []const u32,
    variants: []const []const []const u8,
    inline_names: []const []const []const u8,
    top_callees: []const []const u32,
    top_variants: []const []const []const u8,
    count: u32,
    seed: bool,
};

pub const Owned = struct {
    arena: std.heap.ArenaAllocator,
    value: Plan,
    pub fn deinit(self: *@This()) void {
        self.arena.deinit();

        self.* = undefined;
    }
};

pub fn createSeed(workspace: std.mem.Allocator, input: Input) std.mem.Allocator.Error!Owned {
    if (comptime @import("parser_options").generated_parser) @compileError("Partition demand seed cannot run in a generated compiler");

    var arena = std.heap.ArenaAllocator.init(workspace);

    errdefer arena.deinit();

    const value = try @import("demand_seed.zig").create(arena.allocator(), input);

    return .{ .arena = arena, .value = value };
}
