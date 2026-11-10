const std = @import("std");
const zx = @import("zx");

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

pub fn create(workspace: std.mem.Allocator, input: Input) std.mem.Allocator.Error!Owned {
    var arena = std.heap.ArenaAllocator.init(workspace);

    errdefer arena.deinit();

    const allocator = arena.allocator();

    if (comptime !@import("parser_options").generated_parser) return .{ .arena = arena, .value = try @import("demand_seed.zig").create(allocator, input) };

    const entry = @import("generated_partition_demand");
    const Fields = std.meta.Child(entry.Input);

    const fields: Fields = .{
        .owners = input.owners,
        .callees = input.callees,
        .variants = input.variants,
        .inline_names = input.inline_names,
        .top_callees = input.top_callees,
        .top_variants = input.top_variants,
        .count = input.count,
        .seed = input.seed,
    };

    const output = zx.columns.invoke(entry.executeValue, allocator, &fields) catch |err| return failure(err);
    const scopes = try allocator.alloc(Scope, output.scopes.len);

    for (output.scopes, scopes) |source, *scope| scope.* = .{
        .copies = source.copies,
        .stubs = .{ .callees = source.stubs.callees, .variants = source.stubs.variants },
    };

    return .{ .arena = arena, .value = .{ .scopes = scopes, .exports = .{ .callees = output.exports.callees, .variants = output.exports.variants } } };
}

fn failure(err: anyerror) std.mem.Allocator.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => @panic("invalid partition demand input"),
    };
}
